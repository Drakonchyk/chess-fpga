module move_verification(
move_is_legal);

reg [3:0] board[63:0];
reg[5:0] move_start;
reg[5:0] move_end;
reg[3:0] move_piece;

initial
begin

board[6'b000_000] <= { COLOR_WHITE, PIECE_ROOK };
board[6'b000_001] <= { COLOR_WHITE, PIECE_KNIGHT };
board[6'b000_010] <= { COLOR_WHITE, PIECE_BISHOP };
board[6'b000_011] <= { COLOR_WHITE, PIECE_QUEEN };
board[6'b000_100] <= { COLOR_WHITE, PIECE_KING };
board[6'b000_101] <= { COLOR_WHITE, PIECE_BISHOP };
board[6'b000_110] <= { COLOR_WHITE, PIECE_KNIGHT };
board[6'b000_111] <= { COLOR_WHITE, PIECE_ROOK };

board[6'b001_000] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_001] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_010] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_011] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_100] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_101] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_110] <= { COLOR_WHITE, PIECE_PAWN };
board[6'b001_111] <= { COLOR_WHITE, PIECE_PAWN };

board[6'b010_000] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_001] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_010] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_011] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_100] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_101] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_110] <= { COLOR_WHITE, PIECE_NONE };
board[6'b010_111] <= { COLOR_WHITE, PIECE_NONE };

board[6'b011_000] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_001] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_010] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_011] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_100] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_101] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_110] <= { COLOR_WHITE, PIECE_NONE };
board[6'b011_111] <= { COLOR_WHITE, PIECE_NONE };


board[6'b100_000] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_001] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_010] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_011] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_100] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_101] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_110] <= { COLOR_WHITE, PIECE_NONE };
board[6'b100_111] <= { COLOR_WHITE, PIECE_NONE };


board[6'b101_000] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_001] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_010] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_011] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_100] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_101] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_110] <= { COLOR_WHITE, PIECE_NONE };
board[6'b101_111] <= { COLOR_WHITE, PIECE_NONE };

board[6'b110_000] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_001] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_010] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_011] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_100] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_101] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_110] <= { COLOR_BLACK, PIECE_PAWN };
board[6'b110_111] <= { COLOR_BLACK, PIECE_PAWN };

board[6'b111_000] <= { COLOR_BLACK, PIECE_ROOK };
board[6'b111_001] <= { COLOR_BLACK, PIECE_KNIGHT };
board[6'b111_010] <= { COLOR_BLACK, PIECE_BISHOP };
board[6'b111_100] <= { COLOR_BLACK, PIECE_QUEEN };
board[6'b111_011] <= { COLOR_BLACK, PIECE_KING };
board[6'b111_101] <= { COLOR_BLACK, PIECE_BISHOP };
board[6'b111_110] <= { COLOR_BLACK, PIECE_KNIGHT };
board[6'b111_111] <= { COLOR_BLACK, PIECE_ROOK };

move_start <= 6'b110_000;
move_end <= 6'b101_000;

// 3 - color, 2:0 - piece code
move_piece <= 4'b1_001;
end

//genvar i;
//generate for (i=0; i<64; i=i+1) begin: BOARD
	//assign board[i] = board_input[i*4+3 : i*4];
//end
//endgenerate

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