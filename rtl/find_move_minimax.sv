module find_move_minimax(board, valid_moves, depth, white_to_move, score);
	inout wire[3:0] board[63:0];
	input wire[11:0] valid_moves[139:0];
	input wire[2:0] depth;
	input wire white_to_move;
	
	output wire[15:0] score;
	
   reg[7:0] next_move = 0;
	localparam DEPTH = 5;	
	localparam CHECKMATE_WHITE = 2'b10;
	localparam CHECKMATE_BLACK = 2'b01;

	
	score_material s_material();
	make_move move_maker();
	get_valid_moves move_validator();
	find_move_minmax move_finder();
	undo_move move_undoer();
	
	always @* begin
		if (depth == 0) begin : init_step
			s_material(.score(score));
		end : init_step
		 
		 // if checkmate black is 10(or 01), it cant be more than a 16 bit number
		else if (white_to_move) begin : white_move
			bit [15:0] max_score;
			max_score = CHECKMATE_BLACK;
			for (int i = 0; i < 10; i++) begin : foreach_loop
				reg[11:0] next_moves[9:0];
				reg[3:0] captured_piece;
				captured_piece = board[valid_moves[i][11:6]];
				
				move_maker(valid_moves[i][5:0], valid_moves[i][11:6], board);
				move_validator(board, next_moves);
				move_finder(board, next_moves, depth - 1, 0, score);
					
				if (score > max_score) begin : maxscore_if
					max_score = score;
					if (depth == DEPTH) 
						next_move = valid_moves[i];
				end : maxscore_if
				
				move_undoer(board, valid_moves[i][5:0], valid_moves[i][11:6], captured_piece);
					
			end : foreach_loop
			assign score = max_score;
		end : white_move

		else begin
			bit [15:0] min_score;;
			min_score = CHECKMATE_WHITE;
			for (int i = 0; i < 10; i++) begin : foreach_black
				reg[11:0] next_moves[9:0];
				reg[3:0] captured_piece;
				captured_piece = board[valid_moves[i][11:6]];
				
				move_maker(valid_moves[i][5:0], valid_moves[i][11:6], board);
				move_validator(board, next_moves);
				move_finder(next_moves, depth - 1, 1, board, score);
				
				if (score < min_score) begin : minscore_if
					min_score = score;
					if (depth == DEPTH) 
						next_move = valid_moves[i];
				end : minscore_if
				
				move_undoer(board, valid_moves[i][5:0], valid_moves[i][11:6], captured_piece);
			end : foreach_black
			score = min_score;
		end
	end
	
endmodule