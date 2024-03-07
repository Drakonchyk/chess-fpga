import chess
import random
import chess.pgn
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
        child.parent = curr_node
        curr_node.children.add(child)

    rnd_state = random.choice(list(curr_node.children))
    return rollout(rnd_state)

def expand(curr_node, white):
    if len(curr_node.children) == 0:
        return curr_node

    if white:
        idx = -1
        max_ucb = -inf
        sel_child = None
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp > max_ucb:
                idx = child
                max_ucb = tmp
                sel_child = child
        return expand(sel_child, False)

    else:
        idx = -1
        min_ucb = inf
        sel_child = None
        for child in curr_node.children:
            tmp = ucb1(child)
            if tmp < min_ucb:
                idx = child
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


def mcts_pred(curr_node, over, white, iterations=1000):
    if over:
        return None, curr_node
    all_moves = [curr_node.state.san(i) for i in list(curr_node.state.legal_moves)]
    map_state_move = dict()
    for i in all_moves:
        tmp_state = chess.Board(curr_node.state.fen())
        tmp_state.push_san(i)
        child = Node()
        child.state = tmp_state
        child.parent = curr_node
        curr_node.children.add(child)
        map_state_move[child] = i
    while (iterations > 0):
        if (white):
            idx = -1
            max_ucb = -inf
            sel_child = None
            for i in curr_node.children:
                tmp = ucb1(i)
                if (tmp > max_ucb):
                    idx = i
                    max_ucb = tmp
                    sel_child = i
            ex_child = expand(sel_child, 0)
            reward, state = rollout(ex_child)
            curr_node = rollback(state, reward)
            iterations -= 1
        else:
            idx = -1
            min_ucb = inf
            sel_child = None
            for i in curr_node.children:
                tmp = ucb1(i)
                if (tmp < min_ucb):
                    idx = i
                    min_ucb = tmp
                    sel_child = i

            ex_child = expand(sel_child, 1)

            reward, state = rollout(ex_child)

            curr_node = rollback(state, reward)
            iterations -= 1
    if (white):

        mx = -inf
        idx = -1
        selected_move = ''
        for i in (curr_node.children):
            tmp = ucb1(i)
            if (tmp > mx):
                mx = tmp
                selected_move = map_state_move[i]
        return selected_move
    else:
        mn = inf
        idx = -1
        selected_move = ''
        for i in (curr_node.children):
            tmp = ucb1(i)
            if (tmp < mn):
                mn = tmp
                selected_move = map_state_move[i]
        return selected_move



def main():
    board = chess.Board()
    print(board)
    print()
    white = 1
    moves = 0
    evaluations = []
    sm = 0
    cnt = 0
    pgn = []
    while not board.is_game_over():

        if board.turn == chess.WHITE:
            if board.is_checkmate():
                print("Black wins by checkmate!")
                break
            elif board.is_stalemate() or board.is_insufficient_material() or board.is_seventyfive_moves():
                print("It's a draw!")
                break

            print("Bot's move:")

            try:
                all_moves = [board.san(i) for i in list(board.legal_moves)]
                root = Node()
                root.state = board
                result = mcts_pred(root, board.is_game_over(), white)
                board.push_san(result)
                pgn.append(result)
                white ^= 1
                print(board)
                print()
                moves += 1
                print(pgn[moves-1])
                print()

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
