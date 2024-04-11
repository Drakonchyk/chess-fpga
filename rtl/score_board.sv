module score_board(checkmate, stalemate, white_to_move, score)

input wire[1:0] checkmate;
input wire stalemate;
input wire white_to_move;
output wire[15:0] score;

localparam CHECKMATE_WHITE = 2'b10;
localparam CHECKMATE_BLACK = 2'b01;
localparam STALEMATE = 1;

localparam COLOR_WHITE = 0;
localparam COLOR_BLACK = 1;

bit [3:0] pieceScore [5:0] = '{4'b0000, 4'b1010, 4'b0101, 4'b0011, 4'b0011, 4'b0001};

reg [3:0] board[63:0];

if (checkmate) begin
  if (white_to_move) begin
		checkmate <= CHECKMATE_BLACK;
		break;
  end
  else begin
		checkmate <= CHECKMATE_WHITE;
		break;
  end
end

else if (stalemate) begin
  stalemate <= STALEMATE;
  break;
end

else begin
	bit [15:0] score_c;
   score_c = 0;
   for (reg[2:0] i = 3'b000; i <= 3'b111; i = i + 1) begin
		for(reg[2:0] j = 3'b000; j <= 3'b111; j = j + 1) begin
			if(board[{i, j}[2:0] == 3'b000]) continue;
			if (board[{i,j}][3] == COLOR_WHITE) score_c += pieceScore[board[{i,j}][2:0] - 1];
			else if (board[{i,j}][3] == COLOR_BLACK) score_c -= pieceScore[board[{i,j}][2:0] - 1];
		end
   end
   score <= score_c;
end

endmodule