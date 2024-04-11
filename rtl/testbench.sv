module testbench;

   wire move_is_legal;

   fpga_chess dut(
      .move_is_legal(move_is_legal)
   );

   // Stimulus
   initial begin
      // Wait for some time to observe the result
      #10;

      // Display the result
      $display("move_is_legal = %b", move_is_legal);
      
      // Finish simulation
      $finish;
   end

endmodule
