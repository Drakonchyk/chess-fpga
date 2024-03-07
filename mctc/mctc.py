import chess
import random
from math import log, sqrt, e, inf

class Node:
    def __init__(self):
        self.state = chess.Board()
        self.action = ''
        self.children = set()
        self.parent = None
        self.N = 0
        self.n = 0
        self.v = 0

def ucb1(curr_node):
    ans = curr_node.v + 2 * (sqrt(log(curr_node.N + e + (10 ** -6)) / (curr_node.n + (10 ** -10))))
    return ans

def rollout(curr_node):
    if curr_node.state.is_game_over():
        board = curr_node.state
        if board.result() == '1-0':
            return 1, curr_node
        elif board.result() == '0-1':
            return -1, curr_node
        else:
            return 0.5, curr_node

    all_moves = [curr_node.state.san(i) for i in list(curr_node.state.legal_moves)]

    for move in all_moves:
        tmp_state = chess.Board(curr_node.state.fen())
        tmp_state.push_san(move)
        child = Node()
        child.state = tmp_state
        child.action = move
        child.parent = curr_node
        curr_node.children.add(child)

    rnd_state = random.choice(list(curr_node.children))
    return rollout(rnd_state)

def expand(curr_node, white):
    if len(curr_node.children) == 0:
        return curr_node

    if white:
        max_ucb = -inf
        sel_child = None
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp > max_ucb:
                max_ucb = tmp
                sel_child = child
        return expand(sel_child, False)

    else:
        min_ucb = inf
        sel_child = None
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp < min_ucb:
                min_ucb = tmp
                sel_child = child
        return expand(sel_child, True)



def rollback(curr_node, reward):
    curr_node.n += 1
    curr_node.v += reward
    while curr_node.parent is not None:
        curr_node.N += 1
        curr_node = curr_node.parent
    return curr_node

def generate_state_id(board_state, move):
    return str(board_state) + '_' + move

def mcts_pred(curr_node, over, white, board, iterations=10):
    if over:
        return None, curr_node

    while iterations > 0:
        # Fetch the list of legal moves from the current state of the board
        all_moves = [curr_node.state.san(i) for i in list(curr_node.state.legal_moves)]
        map_state_move = dict()

        for move in all_moves:
            tmp_state = chess.Board(curr_node.state.fen())
            tmp_state.push_san(move)

            # Check for game end
            if tmp_state.is_game_over():
                continue

            child = Node()
            child.state = tmp_state
            child.action = move
            child.parent = curr_node
            curr_node.children.add(child)
            state_id = generate_state_id(tmp_state, move)
            map_state_move[state_id] = move

        if white:
            max_ucb = -inf
            sel_child = None
            for child in curr_node.children:
                tmp = ucb1(child)
                if tmp > max_ucb:
                    max_ucb = tmp
                    sel_child = child
            ex_child = expand(sel_child, False)
            reward, state = rollout(ex_child)
            curr_node = rollback(state, reward)
            iterations -= 1
        else:
            min_ucb = inf
            sel_child = None
            for child in curr_node.children:
                tmp = ucb1(child)
                if tmp < min_ucb:
                    min_ucb = tmp
                    sel_child = child
            ex_child = expand(sel_child, True)
            reward, state = rollout(ex_child)
            curr_node = rollback(state, reward)
            iterations -= 1

        # Update available moves after each move
        all_moves = [curr_node.state.san(i) for i in list(curr_node.state.legal_moves)]

    if white:
        mx = -inf
        selected_move = ''
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp > mx:
                mx = tmp
                selected_move = child.action

        return selected_move, curr_node
    else:
        mn = inf
        selected_move = ''
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp < mn:
                mn = tmp
                selected_move = child.action
        return selected_move, curr_node

def main():
    root = Node()
    board = chess.Board()
    print(board)
    print()

    while not board.is_game_over():
        if board.turn == chess.WHITE:
            if board.is_checkmate():
                print("Black wins by checkmate!")
                break
            elif board.is_stalemate() or board.is_insufficient_material() or board.is_seventyfive_moves():
                print("It's a draw!")
                break

            print("Bot's move:")
            bot_move, root = mcts_pred(root, board.is_game_over(), True, board, iterations=100)  # Update the root node
            try:
                move = board.parse_san(bot_move)
                if move in board.legal_moves:
                    board.push(move)
                    print(board)
                    print()
                else:
                    print("Invalid move by bot. Please check the bot logic.")
                    print("Bot attempted to move:", bot_move)
                    break
            except ValueError:
                print("Invalid move by bot. Please check the bot logic.")
                print("Bot attempted to move:", bot_move)
                break
            except Exception as e:
                print("An error occurred in bot's move:", e)
                break

        else:
            if board.is_checkmate():
                print("White wins by checkmate!")
                break
            elif board.is_stalemate() or board.is_insufficient_material() or board.is_seventyfive_moves():
                print("It's a draw!")
                break

            while True:
                move_san = input("Black's move (in SAN notation, e.g., e7e5): ")
                try:
                    move = board.parse_san(move_san)
                    if move in board.legal_moves:
                        board.push(move)
                        print("Black's move:", move_san)
                        print(board)
                        print()
                        break
                    else:
                        print("Invalid move. Please try again.")
                except ValueError:
                    print("Invalid move. Please try again.")

    print("Game over.")

if __name__ == "__main__":
    main()
