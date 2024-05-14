// function for getting an array of valid moves
// queen - 28, king - 8, bishop - 14, rook - 14, pawn - 4, knight - 8
// maximum valid moves - 140 
module get_valid_moves(board, valid_moves);

	input wire[3:0] board[63:0];
   output wire[11:0] valid_moves[9:0];
	
	reg move_valid = 0;
	integer move_amount = 0;
	integer i;
	integer j;
	integer check_v;
	integer check_h;
	reg[5:0] m_start = 0;
	reg[5:0] m_end = 0;
	localparam PIECE_NONE = 3'b000;
	localparam CHECKMATE_WHITE = 2'b10;
	localparam CHECKMATE_BLACK = 2'b01;

	
	move_verification verify(
							.board(board), 
							.move_start(m_start), 
							.move_end(m_end), 
							.move_piece(board[m_start]), 
							.move_is_legal(move_valid)
						);
	
	always @* begin
		for(i = 0; i <= 8; i = i + 1) begin : outer_start
			for(j = 3'b000; j <= 3'b111; j = j + 1) begin : inner_start
				m_start = {i, j};
				if(board[m_start] == PIECE_NONE) begin : skip_empty
					continue;
				end : skip_empty
				
				for(check_v = 3'b000; check_v <= 3'b111; check_v = check_v + 1) begin : outer_end
					for(check_h = 3'b000; check_h <= 3'b111; check_h = check_h + 1) begin : inner_end
						if(i == check_v && j == check_h) begin : skip_current
							continue; 
						end : skip_current
						m_end = {check_v, check_h};
						
						//verify(
							//.board(board), 
							//.move_start(m_start), 
							//.move_end(m_end), 
							//.move_piece(board[m_start]), 
							//.move_is_legal(move_valid)
						//);
						
						reg leg = verify.move_is_legal
						
						if(move_valid == 1) begin : write_valid_move
							valid_moves[move_amount] = {i, j, check_v, check_h};
							move_amount = move_amount + 1;
						end : write_valid_move
					end : inner_end
				end : outer_end	
				
			end : inner_start
		end : outer_start
	endgenerate
endmodule


//function automatic get_valid_moves();
	// 140 cells of valid start and end of moves
//  reg[11:0] valid_moves[139:0];

//	for(reg[2:0] i = 3'b000; i <= 3'b111; i = i + 1) begin : outer_start
//		for(reg[2:0] j = 3'b000; j <= 3'b111; j = j + 1) begin : inner_start
//			if(board[{i, j}] == PIECE_NONE) begin : skip_empty
//				continue;
//			end : skip_empty
			
//			for(reg[2:0] check_v = 3'b000; check_v <= 3'b111; check_v = check_v + 1) begin : outer_end
//				for(reg[2:0] check_h = 3'b000; check_h <= 3'b111; check_h = check_h + 1) begin : inner_end
//					if(i == check_v && j == check_h) begin : skip_current
//						continue; 
//					end : skip_current

					// move_verification m(.move_start({i, j}), .move_end({check_v, check_h}), .move_piece(board[{i, j}]), .move_is_legal(valid_move));
					
//					if(valid_move) begin : write_valid_move
//						valid_moves[move_amount] = {i, j, check_v, check_h};
//						move_amount = move_amount + 1;
//					end : write_valid_move
//				end : inner_end
//			end : outer_end
			
//		end : inner_start
//	end : outer_start
	
// return valid_moves;

// endfunction