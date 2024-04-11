module minimax_algorithm(valid_moves, depth, white_to_move, next_move);

  // Define pieceScore

// Define constants
localparam CHECKMATE_WHITE = 2'b10;
localparam CHECKMATE_BLACK = 2'b01;

localparam STALEMATE = 0;
localparam DEPTH = 5;

initial begin
	bit [7:0] nextMove;
   nextMove = 0;
   findMoveMinMax(gs, validMoves, DEPTH, gs.whiteToMove);
end


// Recursive Minimax
function automatic findMoveMinMax(gs, validMoves, depth, whiteToMove);
    bit [7:0] nextMove;
    nextMove = 0;
    if (depth == 0) begin
        return scoreMaterial(gs.board);
    end
    if (whiteToMove) begin : white_move
		 bit [15:0] maxScore;
		 maxScore = -CHECKMATE;
		 fork
			begin: isolating_thread
			 foreach (validMoves[i]) begin : foreach_loop
				fork
				  gs.makeMove();
				  nextMove = gs.getValidMoves();
				  bit [15:0] score = findMoveMinMax(gs, nextMove, depth-1, 0);
				  if (score > maxScore) begin : maxscore_if
						maxScore = score;
						if (depth == DEPTH) nextMove = validMoves[i];
				  end : maxscore_if
				  gs.undoMove();
				join_none;
			 end : foreach_loop
			wait fork;
			end : isolating_thread
			join
		 return maxScore;
	 end : white_move

    else begin
        bit [15:0] minScore;
        minScore = CHECKMATE;
		  fork
			begin: isolating_thread_black
			  foreach (validMoves[i]) begin : foreach_black
				fork
					gs.makeMove();
					nextMove = gs.getValidMoves();
					bit [15:0] score = findMoveMinMax(gs, nextMove, depth-1, 1);
					if (score < minScore) begin : minscore_if
						 minScore = score;
						 if (depth == DEPTH) nextMove = validMoves[i];
					end : minscore_if
					gs.undoMove();
				join_none;
			  end : foreach_black
			  wait fork;
			end : isolating_thread_black
			join
        return minScore;
    end
endfunction






endmodule