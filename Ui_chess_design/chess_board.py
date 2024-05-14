import pygame
import chess

pygame.init()
WIDTH = 800
HEIGHT = 800
screen = pygame.display.set_mode([WIDTH, HEIGHT])
pygame.display.set_caption('Two-Player Pygame Chess!')
font = pygame.font.Font('freesansbold.ttf', 20)
medium_font = pygame.font.Font('freesansbold.ttf', 40)
big_font = pygame.font.Font('freesansbold.ttf', 50)
timer = pygame.time.Clock()
fps = 60
# game variables and images
white_pieces = ['rook', 'knight', 'bishop', 'king', 'queen', 'bishop', 'knight', 'rook',
                'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn']
white_locations = [(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0),
                   (0, 1), (1, 1), (2, 1), (3, 1), (4, 1), (5, 1), (6, 1), (7, 1)]
black_pieces = ['rook', 'knight', 'bishop', 'king', 'queen', 'bishop', 'knight', 'rook',
                'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn', 'pawn']
black_locations = [(0, 7), (1, 7), (2, 7), (3, 7), (4, 7), (5, 7), (6, 7), (7, 7),
                   (0, 6), (1, 6), (2, 6), (3, 6), (4, 6), (5, 6), (6, 6), (7, 6)]
captured_pieces_white = []
captured_pieces_black = []
# 0 - whites turn no selection: 1-whites turn piece selected: 2- black turn no selection, 3 - black turn piece selected
turn_step = 0
selection = 100
valid_moves = []
# load in game piece images (queen, king, rook, bishop, knight, pawn) x 2
black_queen = pygame.image.load('assets/images/black queen.png')
black_queen = pygame.transform.scale(black_queen, (80, 80))
black_queen_small = pygame.transform.scale(black_queen, (45, 45))
black_king = pygame.image.load('assets/images/black king.png')
black_king = pygame.transform.scale(black_king, (80, 80))
black_king_small = pygame.transform.scale(black_king, (45, 45))
black_rook = pygame.image.load('assets/images/black rook.png')
black_rook = pygame.transform.scale(black_rook, (80, 80))
black_rook_small = pygame.transform.scale(black_rook, (45, 45))
black_bishop = pygame.image.load('assets/images/black bishop.png')
black_bishop = pygame.transform.scale(black_bishop, (80, 80))
black_bishop_small = pygame.transform.scale(black_bishop, (45, 45))
black_knight = pygame.image.load('assets/images/black knight.png')
black_knight = pygame.transform.scale(black_knight, (80, 80))
black_knight_small = pygame.transform.scale(black_knight, (45, 45))
black_pawn = pygame.image.load('assets/images/black pawn.png')
black_pawn = pygame.transform.scale(black_pawn, (65, 65))
black_pawn_small = pygame.transform.scale(black_pawn, (45, 45))
white_queen = pygame.image.load('assets/images/white queen.png')
white_queen = pygame.transform.scale(white_queen, (80, 80))
white_queen_small = pygame.transform.scale(white_queen, (45, 45))
white_king = pygame.image.load('assets/images/white king.png')
white_king = pygame.transform.scale(white_king, (80, 80))
white_king_small = pygame.transform.scale(white_king, (45, 45))
white_rook = pygame.image.load('assets/images/white rook.png')
white_rook = pygame.transform.scale(white_rook, (80, 80))
white_rook_small = pygame.transform.scale(white_rook, (45, 45))
white_bishop = pygame.image.load('assets/images/white bishop.png')
white_bishop = pygame.transform.scale(white_bishop, (80, 80))
white_bishop_small = pygame.transform.scale(white_bishop, (45, 45))
white_knight = pygame.image.load('assets/images/white knight.png')
white_knight = pygame.transform.scale(white_knight, (80, 80))
white_knight_small = pygame.transform.scale(white_knight, (45, 45))
white_pawn = pygame.image.load('assets/images/white pawn.png')
white_pawn = pygame.transform.scale(white_pawn, (65, 65))
white_pawn_small = pygame.transform.scale(white_pawn, (45, 45))
white_images = [white_pawn, white_queen, white_king, white_knight, white_rook, white_bishop]
small_white_images = [white_pawn_small, white_queen_small, white_king_small, white_knight_small,
                      white_rook_small, white_bishop_small]
black_images = [black_pawn, black_queen, black_king, black_knight, black_rook, black_bishop]
small_black_images = [black_pawn_small, black_queen_small, black_king_small, black_knight_small,
                      black_rook_small, black_bishop_small]
piece_list = ['pawn', 'queen', 'king', 'knight', 'rook', 'bishop']
# check variables/ flashing counter
counter = 0
winner = ''
game_over = False
white_view = True  # Змінна для визначення сторони огляду дошки

# draw main game board
def draw_board():

    for i in range(32):
        column = i % 4
        row = i // 4
        if row % 2 == 0:
            pygame.draw.rect(screen, 'green', [600 - (column * 200), row * 100, 100, 100])
        else:
            pygame.draw.rect(screen, 'green', [600- (column * 200) + 100, row * 100, 100, 100])

    for i in range(32):
        column = i % 4
        row = i // 4
        if row % 2 != 0:
            pygame.draw.rect(screen, 'red', [(column * 200), row * 100, 100, 100])
        else:
            pygame.draw.rect(screen, 'red', [(column * 200) + 100,  row * 100, 100, 100])

def draw_pieces():
    global white_view

    for i in range(len(white_pieces)):
        index = piece_list.index(white_pieces[i])
        piece_x = white_locations[i][0] * 100 + 20
        piece_y = white_locations[i][1] * 100 + 20

        if not white_view:  # Якщо обрано вид з боку чорних, інвертуємо координати
            piece_x = (7 - white_locations[i][0]) * 100 + 20
            piece_y = (7 - white_locations[i][1]) * 100 + 20

        if white_pieces[i] == 'pawn':
            screen.blit(white_pawn, (piece_x, piece_y))
        else:
            screen.blit(white_images[index], (piece_x - 10, piece_y - 10))


    for i in range(len(black_pieces)):
        index = piece_list.index(black_pieces[i])
        piece_x = black_locations[i][0] * 100 + 20
        piece_y = black_locations[i][1] * 100 + 20

        if not white_view:  # Якщо обрано вид з боку чорних, інвертуємо координати
            piece_x = (7 - black_locations[i][0]) * 100 + 20
            piece_y = (7 - black_locations[i][1]) * 100 + 20

        if black_pieces[i] == 'pawn':
            screen.blit(black_pawn, (piece_x, piece_y))
        else:
            screen.blit(black_images[index], (piece_x - 10, piece_y - 10))


def drag_and_drop():
    global white_pieces, black_pieces, white_locations, black_locations, turn_step, captured_pieces_white, captured_pieces_black

    def is_move_valid(piece, new_position):
        return True

    def get_piece_at_position(x, y):
        for i in range(len(white_locations)):
            if white_locations[i] == (x, y):
                return 'white', white_pieces[i], i

        for i in range(len(black_locations)):
            if black_locations[i] == (x, y):
                return 'black', black_pieces[i], i

        return None, None, None

    selected_piece_color = None
    selected_piece = None
    selected_piece_index = None

    # Збережемо попередні позиції фігур для перевірки, чи була фігура переміщена
    prev_white_locations = white_locations[:]
    prev_black_locations = black_locations[:]

    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                quit()
            elif event.type == pygame.MOUSEBUTTONDOWN:
                mouse_pos = pygame.mouse.get_pos()
                clicked_x = (mouse_pos[0]) // 100
                clicked_y = (mouse_pos[1]) // 100

                if selected_piece_color is None:
                    # Вибір фігури
                    if turn_step == 0 or turn_step == 1:  # Хід білих
                        selected_piece_color, selected_piece, selected_piece_index = get_piece_at_position(clicked_x, clicked_y)
                        if selected_piece_color != 'white':
                            selected_piece_color = None
                            selected_piece = None
                            selected_piece_index = None
                    else:  # Хід чорних
                        selected_piece_color, selected_piece, selected_piece_index = get_piece_at_position(clicked_x, clicked_y)
                        if selected_piece_color != 'black':
                            selected_piece_color = None
                            selected_piece = None
                            selected_piece_index = None
                else:
                    # Переміщення фігури
                    new_position = (clicked_x, clicked_y)

                    if 0 <= new_position[0] < 8 and 0 <= new_position[1] < 8:
                        if selected_piece_color == 'white':
                            if new_position in black_locations:  # Захоплення чорної фігури
                                captured_index = black_locations.index(new_position)
                                captured_pieces_black.append(black_pieces.pop(captured_index))
                                black_locations.pop(captured_index)
                                if is_move_valid(selected_piece, new_position):
                                    white_locations[selected_piece_index] = new_position
                            elif new_position not in white_locations:
                                if is_move_valid(selected_piece, new_position):
                                    white_locations[selected_piece_index] = new_position
                        else:
                            if new_position in white_locations:  # Захоплення білої фігури
                                captured_index = white_locations.index(new_position)
                                captured_pieces_white.append(white_pieces.pop(captured_index))
                                white_locations.pop(captured_index)
                                if is_move_valid(selected_piece, new_position):
                                    black_locations[selected_piece_index] = new_position
                            elif new_position not in black_locations:
                                if is_move_valid(selected_piece, new_position):
                                    black_locations[selected_piece_index] = new_position

                    selected_piece_color = None
                    selected_piece = None
                    selected_piece_index = None

                    # Перевірка, чи була фігура переміщена
                    if turn_step == 0 or turn_step == 1:
                        if white_locations != prev_white_locations:
                            # Якщо фігура біла, і її позиція змінилась, змінюємо хід
                            if turn_step == 0:
                                turn_step = 2
                            else:
                                turn_step = 3
                    else:
                        if black_locations != prev_black_locations:
                            # Якщо фігура чорна, і її позиція змінилась, змінюємо хід
                            if turn_step == 2:
                                turn_step = 0
                            else:
                                turn_step = 1

                    # Оновлюємо попередні позиції фігур
                    prev_white_locations = white_locations[:]
                    prev_black_locations = black_locations[:]

        # Заповнення фону
        screen.fill((255, 255, 255))

        # Відображення дошки та фігур
        draw_board()
        draw_pieces()

        # Оновлення вікна
        pygame.display.flip()

        # Обмеження кадрів в секунду
        timer.tick(fps)

# Головний цикл гри
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # Обробка подій перетягування фігур
        drag_and_drop()

    # Заповнення фону
    screen.fill((255, 255, 255))

    # Відображення дошки та фігур
    draw_board()
    draw_pieces()

    # Оновлення вікна
    pygame.display.flip()

    # Обмеження кадрів в секунду
    timer.tick(fps)

# Закриття вікна
pygame.quit()
