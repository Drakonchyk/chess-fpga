module undo_move(board, move_start, move_end, piece_captured);

	inout wire[3:0] board[63:0];
	input wire[5:0] move_start;
	input wire[5:0] move_end;
	input wire[3:0] piece_captured;
	
	reg[3:0] piece_to_undo = 0;
	always @* begin
		piece_to_undo = board[move_end];
		
		assign board[move_start] = piece_to_undo;
		assign board[move_end] = piece_captured;
	end
endmodule
	


//function automatic undo_move(reg[5:0] move_start, reg[5:0] move_end, reg [3:0] board[63:0], reg[3:0] piece_captured);
//	reg[3:0] piece_to_undo;
//	piece_to_undo = board[move_end];

//	board[move_start] = piece_to_undo; 
//	board[move_end] = piece_captured;
	
//	return board;
// endfunction