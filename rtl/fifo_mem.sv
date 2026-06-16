`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// Company: VLSI Design Industry Standard
// Engineer: Principal VLSI Design Engineer
// 
// Module Name: fifo_mem
// Description: Dual-port synchronous write, combinational read memory array.
////////////////////////////////////////////////////////////////////////////////
module fifo_mem #(
    parameter int DATA_WIDTH = 8,
    parameter int ADDR_WIDTH = 4
)(
    input  logic                  clk,
    input  logic                  w_en,
    input  logic [ADDR_WIDTH-1:0] w_addr,
    input  logic [DATA_WIDTH-1:0] w_data,
    input  logic                  r_en, // Included for protocol completeness
    input  logic [ADDR_WIDTH-1:0] r_addr,
    output logic [DATA_WIDTH-1:0] r_data
);

    localparam int DEPTH = 1 << ADDR_WIDTH;
    
    // Memory Array Declaration
    logic [DATA_WIDTH-1:0] mem [DEPTH];

    // Synchronous Write Port
    always_ff @(posedge clk) begin
        if (w_en) begin
            mem[w_addr] <= w_data;
        end
    end

    // Combinational Read Port for low-latency output
    assign r_data = mem[r_addr];

endmodule