
//  Xilinx Single Port No Change RAM
//  This code implements a parameterizable single-port no-change memory where when data is written
//  to the memory, the output remains unchanged.  This is the most power efficient write mode.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.


module DATA_MEM #(
  parameter len_data = 32,                       // Specify RAM data width
  parameter ram_depth = 256,                    // Specify RAM depth (number of entries)
  parameter RAM_PERFORMANCE = "LOW_LATENCY",     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter init_file = "test2.hex"              // Specify name/location of RAM initialization file if using one (leave blank if not)
) (
  input [clogb2(ram_depth-1)-1:0] Addr,  // Address bus, width determined from ram_depth
  input [len_data-1:0] In_Data,           // RAM input data
  input clk,                           // Clock
  input Wr,                            // Write enable
  input Rd,                            // RAM Enable, for additional power savings, disable port when not in use
  output [len_data-1:0] Out_Data         // RAM output data
 // output [len_data-1:0] douta_wire     // RAM output data wire
);
  wire regcea = 1;                         // Output register enable
  wire rsta = 0; // Output reset (does not affect memory contents)

  reg [len_data-1:0] BRAM [ram_depth-1:0];
  reg [len_data-1:0] ram_data = {len_data{1'b0}};


  //assign douta_wire = ram_data[0];

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
  generate
    if (init_file != "") begin: use_init_file
      initial
        $readmemh(init_file, BRAM, 0, ram_depth-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      integer valor = 0;//128;
      initial
        for (ram_index = 0; ram_index < ram_depth; ram_index = ram_index + 1)
          BRAM[ram_index] = {len_data{1'b0}}+(ram_index)+valor;
    end
  endgenerate

  always @(negedge clk)
  begin
    if (Wr)
      BRAM[Addr] <= In_Data;
  end

  always @(posedge clk)
  begin
    if (Rd)
      ram_data <= BRAM[Addr];
  end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign Out_Data = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [len_data-1:0] douta_reg = {len_data{1'b0}};

      always @(negedge clk)
        if (rsta)
          douta_reg <= {len_data{1'b0}};
        else if (regcea)
          douta_reg <= ram_data;

      assign Out_Data = douta_reg;

    end
  endgenerate

  //  The following function calculates the address width based on specified RAM depth
  function integer clogb2;
    input integer depth;
      for (clogb2=0; depth>0; clogb2=clogb2+1)
        depth = depth >> 1;
  endfunction

endmodule

// The following is an instantiation template for xilinx_single_port_ram_no_change
/*
  //  Xilinx Single Port No Change RAM
  xilinx_single_port_ram_no_change #(
    .len_data(18),                       // Specify RAM data width
    .ram_depth(1024),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .init_file("")                        // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) your_instance_name (
    .Addr(Addr),    // Address bus, width determined from ram_depth
    .In_Data(In_Data),      // RAM input data, width determined from len_data
    .clk(clk),      // Clock
    .Wr(Wr),        // Write enable
    .Rd(Rd),        // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rsta),      // Output reset (does not affect memory contents)
    .regcea(regcea),  // Output register enable
    .Out_Data(Out_Data)     // RAM output data, width determined from len_data
  );

*/
						
						
