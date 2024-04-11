module fpga_chess(
	move_is_legal
);

output reg move_is_legal;
move_verification ver(.move_is_legal(move_is_legal));	

endmodule