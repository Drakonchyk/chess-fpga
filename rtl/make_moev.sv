module make_move(move_start, move_end, board);
	inout wire[3:0] board[63:0];
	input wire[5:0] move_start;
	input wire[5:0] move_end;
	localparam PIECE_NONE = 3'b000;

	
	reg[3:0] piece_to_move;
	
	always @* begin
		piece_to_move = board[move_start];

		board[move_start] = PIECE_NONE; 
		board[move_end] = piece_to_move;
	end
endmodule