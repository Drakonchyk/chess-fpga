module move_verification(board, move_start, move_end, move_piece, move_is_legal);

inout wire[3:0] board[63:0];
input wire[5:0] move_start;
input wire[5:0] move_end;

input wire[3:0] move_piece;

output reg move_is_legal;

localparam PIECE_NONE   = 3'b000;
localparam PIECE_PAWN   = 3'b001;
localparam PIECE_KNIGHT = 3'b010;
localparam PIECE_BISHOP = 3'b011;
localparam PIECE_ROOK   = 3'b100;
localparam PIECE_QUEEN  = 3'b101;
localparam PIECE_KING   = 3'b110;

localparam MAX_ITERATIONS = 3'b100;

localparam COLOR_WHITE  = 0;
localparam COLOR_BLACK  = 1;

reg[2:0] h_delta;
reg[2:0] v_delta;

always @(*) begin
	if (move_start[2:0] >= move_end[2:0]) 
		begin
			h_delta = move_start[2:0] - move_end[2:0];
		end
	else	
		begin
			h_delta = move_end[2:0] - move_start[2:0];
		end
		
	if (move_start[5:3] >= move_end[5:3]) 
		begin
			v_delta = move_start[5:3] - move_end[5:3];
		end
	else	
		begin
			v_delta = move_end[5:3] - move_start[5:3];
		end
end

always @(*) begin
	 // check out of bounds; probably redundant
	 // check pieces moves 
    if(move_piece[2:0] == PIECE_PAWN)
        begin
            if (move_piece[3] == COLOR_BLACK) begin // pawn moves forward (decreasing MSB)
                if (v_delta == 2 && h_delta == 0 // moving 2 steps forward
                    && move_start[5:3] == 3'b110 // moving from home row
                    && board[move_end][2:0] == PIECE_NONE && board[move_end + 6'b001_000][2:0] == PIECE_NONE // no piece in way?
						  && move_start[5:3] > move_end[5:3] )
                    move_is_legal = 1;
                else if(v_delta == 1 && h_delta == 0 // move 1 step forward
                    && board[move_end][2:0] == PIECE_NONE
						  && move_start[5:3] > move_end[5:3] )
                    move_is_legal = 1;
                else if(v_delta == 1
                    && (h_delta == 1) // moving diagonally by 1?
                    && board[move_end][3] == COLOR_WHITE && board[move_end][2:0] != PIECE_NONE // capturing 
						  && move_end[5:3] < move_start[5:3] )
                    move_is_legal = 1;
						  
                else move_is_legal = 0;
            end
				
            else if (move_piece[3] == COLOR_WHITE) begin // pawn moves forward
                if (v_delta == 2 && h_delta == 0 // moving 2 steps forward
                    && move_start[5:3] == 3'b001 // moving from home row
                    && board[move_end][2:0] == PIECE_NONE && board[move_end - 6'b001_000][2:0] == PIECE_NONE // no piece in way?
						  && move_start[5:3] < move_end[5:3] )
                    move_is_legal = 1;
                else if(v_delta == 1 && h_delta == 0 // move 1 step forward
                    && board[move_end][2:0] == PIECE_NONE
						  && move_start[5:3] < move_end[5:3] )
                    move_is_legal = 1;
                else if(v_delta == 1
                    && (h_delta == 1) // moving diagonally by 1?
                    && board[move_end][3] == COLOR_BLACK && board[move_end][2:0] != PIECE_NONE // capturing opponent
						  && move_end[5:3] > move_start[5:3] )
                    move_is_legal = 1;
						  
                else move_is_legal = 0;
            end
        end

    else if(move_piece[2:0] == PIECE_ROOK)
        begin
            move_is_legal = 1;
				if(h_delta == 0 && v_delta != 0)
				begin
					for (reg [2:0] cell_shift = 3'b001; cell_shift < v_delta; cell_shift = cell_shift + 1)
						begin
							reg[2:0] cell_address_x;
                     cell_address_x = move_start[5:3];
							
							if(move_start[5:3] < move_end[5:3]) cell_address_x = cell_address_x + cell_shift;
							else cell_address_x = cell_address_x - cell_shift;
							
							if(board[{cell_address_x, move_start[2:0]}][2:0] != PIECE_NONE) move_is_legal = 0; 
						end
				end
				else if(h_delta != 0 && v_delta == 0)
				begin
					for (reg [2:0] cell_shift = 3'b001; cell_shift < h_delta && cell_shift < MAX_ITERATIONS; cell_shift = cell_shift + 1)
						begin
							reg[2:0] cell_address_y;
                     cell_address_y = move_start[2:0];
							
							if(move_start[2:0] < move_end[2:0]) cell_address_y = cell_address_y + cell_shift;
							else cell_address_y = cell_address_y - cell_shift;
							
							if(board[{move_start[5:3], cell_address_y}][2:0] != PIECE_NONE) move_is_legal = 0; 
						end
				end
				else move_is_legal = 0;
        end
	else if(move_piece[2:0] == PIECE_BISHOP)
        begin
           move_is_legal = 1;
				if(h_delta == v_delta)
					begin
						for (reg [2:0] cell_shift = 3'b000; cell_shift < v_delta && cell_shift < MAX_ITERATIONS; cell_shift = cell_shift + 1)
							begin
								reg[2:0] cell_x;
								reg[2:0] cell_y;
								cell_x = move_start[5:3];
								cell_y = move_start[2:0];
								
								
								if(move_start[5:3] < move_end[5:3]) cell_x = cell_x + cell_shift;
								else cell_x = cell_x - cell_shift;
								
								if(move_start[2:0] < move_end[2:0]) cell_y = cell_y + cell_shift;
								else cell_y = cell_y - cell_shift;
								
								if(board[{cell_x, cell_y}][2:0] != PIECE_NONE) move_is_legal = 0; 
							end
					end
			
				else move_is_legal = 0;
        end


	else if(move_piece[2:0] == PIECE_QUEEN)
		begin
			move_is_legal = 1;
			// check bishop move
			if(h_delta == v_delta)
				begin
					for (reg [2:0] cell_shift = 3'b000; cell_shift < v_delta && cell_shift < MAX_ITERATIONS; cell_shift = cell_shift + 1)
						begin
							reg[2:0] cell_x;
							reg[2:0] cell_y;
							
							if(move_start[5:3] < move_end[5:3]) cell_x = cell_x + cell_shift;
							else cell_x = cell_x - cell_shift;
							
							if(move_start[2:0] < move_end[2:0]) cell_y = cell_y + cell_shift;
							else cell_y = cell_y - cell_shift;
							
							if(board[{cell_x, cell_y}][2:0] != PIECE_NONE) move_is_legal = 0; 
						end
				end
				
			// check rook move
			else if(h_delta == 0 && v_delta != 0)
				begin
					for (reg [2:0] cell_shift = 3'b000; cell_shift < v_delta && cell_shift < MAX_ITERATIONS; cell_shift = cell_shift + 1)
						begin
							reg[2:0] cell_address_x;
							
							if(move_start[5:3] < move_end[5:3]) cell_address_x = cell_address_x + cell_shift;
							else cell_address_x = cell_address_x - cell_shift;
							
							if(board[{cell_address_x, move_start[2:0]}][2:0] != PIECE_NONE) move_is_legal = 0; 
						end
				end
				
			else if(h_delta != 0 && v_delta == 0)
				begin
					for (reg [2:0] cell_shift = 3'b000; cell_shift < h_delta && cell_shift < MAX_ITERATIONS; cell_shift = cell_shift + 1)
						begin
							reg[2:0] cell_address_y;
							
							if(move_start[2:0] < move_end[2:0]) cell_address_y = cell_address_y + cell_shift;
							else cell_address_y = cell_address_y - cell_shift;
							
							if(board[{move_start[5:3], cell_address_y}][2:0] != PIECE_NONE) move_is_legal = 0; 
						end
				end
		  
		  else move_is_legal = 0;
		  end

    else if(move_piece[2:0] == PIECE_KING)
        begin
				if ((h_delta == 0 || h_delta == 1) && (v_delta == 0 || v_delta == 1)) move_is_legal = 1;
					// begin
						// reg[2:0] cell_x = move_start[5:3];
						// reg[2:0] cell_y;
						
						// if(move_start[5:3] < move_end[5:3]) cell_x = cell_x + v_delta;
						// else cell_x = cell_x - v_delta;
						
						// if(move_start[2:0] < move_end[2:0]) cell_y = cell_y + h_delta;
						// else cell_y = cell_y - h_delta;
						
						// if(board[{cell_x, cell_y}][2:0] != PIECE_NONE) move_is_legal = 0;
					// end
				else move_is_legal = 0;
        end

    else if(move_piece[2:0] == PIECE_KNIGHT)
        begin
            move_is_legal = (h_delta == 2 && v_delta == 1) || (v_delta == 2 && h_delta == 1);
        end
     
		  else move_is_legal = 0;
end 

endmodule