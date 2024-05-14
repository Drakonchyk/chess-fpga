// Code your design here
module score_board(
    input reg [1:0] checkmate,
    input reg stalemate,
    input reg white_to_move,
    output reg [15:0] score
);

localparam CHECKMATE_WHITE = 2'b10;
localparam CHECKMATE_BLACK = 2'b01;
localparam STALEMATE = 1;

localparam COLOR_WHITE = 0;
localparam COLOR_BLACK = 1;

bit [3:0] piece_score [5:0] = '{4'b0000, 4'b1010, 4'b0101, 4'b0011, 4'b0011, 4'b0001};

reg [3:0] board[63:0];

always @* begin
//     if (checkmate == 2'b01 || checkmate == 2'b10) begin
//         if (white_to_move) begin
//             checkmate <= CHECKMATE_BLACK;
//         end
//         else begin
//             checkmate <= CHECKMATE_WHITE;
//         end
//     end
//     else if (stalemate) begin
//         stalemate = STALEMATE;
//     end
//     else begin
        reg [15:0] score_c = 0;
        for (int i = 0; i < 64; i = i + 1) begin
            if (board[i][3:2] == 2'b00) continue;
            if (board[i][3:2] == COLOR_WHITE) score_c += piece_score[board[i][1:0]];
            else if (board[i][3:2] == COLOR_BLACK) score_c -= piece_score[board[i][1:0]];
        end
        score = score_c;
//     end
end

endmodule
