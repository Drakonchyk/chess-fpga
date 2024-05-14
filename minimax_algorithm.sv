module minimax_algorithm(board, white_to_move, next_move);
 
	input wire[3:0] board[63:0];
	input wire white_to_move;
	output wire[11:0] next_move;

	localparam CHECKMATE_WHITE = 2'b10;
	localparam CHECKMATE_BLACK = 2'b01;

	localparam PIECE_NONE = 4'b0000;

	localparam STALEMATE = 0;
	localparam DEPTH = 5;

	reg[15:0] score = 0;
	reg valid_move = 0;
	integer move_amount = 0;
	reg[11:0] valid_moves[9:0];
// wire [255:0] passable_board;

// genvar i;
// generate for (i=0; i<64; i=i+1) begin: BOARD
//  	assign passable_board[i*4+3 : i*4] = board[i];
// end
// endgenerate
	get_valid_moves move_getter(
			board, 
			valid_moves
	);
	find_move_minimax finder(
			.valid_moves(valid_moves), 
			.depth(DEPTH), 
			.white_to_move(white_move), 
			.score(score)
	);

endmodule