module scoreMaterial(score);

output wire[15:0] score;

reg [3:0] board[63:0];

localparam COLOR_WHITE = 0;
localparam COLOR_BLACK = 1;

bit [3:0] pieceScore [5:0] = '{4'b0000, 4'b1010, 4'b0101, 4'b0011, 4'b0011, 4'b0001};

score_c = 0;
for (reg[2:0] i = 3'b000; i <= 3'b111; i = i + 1) begin
	for(reg[2:0] j = 3'b000; j <= 3'b111; j = j + 1) begin
		if (board[{i,j}][3] == COLOR_WHITE) begin
			score_c += pieceScore[board[{i,j}][2:0] - 1];
		end
		else if (board[{i,j}][3] == COLOR_BLACK) begin
			score_c -= pieceScore[board[{i,j}][2:0] - 1];
		end
	end
end
	 
endmodule