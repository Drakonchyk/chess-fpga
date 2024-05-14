// Code your design here
module score_material(
    output wire [15:0] score
);

reg [3:0] board[63:0];

localparam COLOR_WHITE = 0;
localparam COLOR_BLACK = 1;

bit [3:0] piece_score [5:0] = '{4'b0000, 4'b1010, 4'b0101, 4'b0011, 4'b0011, 4'b0001};

reg [15:0] score_c;

always @* begin
    score_c = 0;
    for (int i = 0; i < 64; i = i + 1) begin
        for (int j = 0; j < 64; j = j + 1) begin
            if (board[{i,j}][3] == COLOR_WHITE) begin
                score_c += piece_score[board[{i,j}][2:0] - 1];
            end
            else if (board[{i,j}][3] == COLOR_BLACK) begin
                score_c -= piece_score[board[{i,j}][2:0] - 1];
            end
        end
    end
end

assign score = score_c;

endmodule