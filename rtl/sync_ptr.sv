`timescale 1ns/1ps
module sync_ptr #(
    parameter int WIDTH = 4
) (
    input  logic             clk,
    input  logic             rst_n,
    input  logic [WIDTH-1:0] d_in,
    output logic [WIDTH-1:0] d_out
);

    // Two-stage shift register for synchronization
    logic [WIDTH-1:0] sync_reg [1:0];

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_reg[0] <= '0;
            sync_reg[1] <= '0;
        end else begin
            sync_reg[0] <= d_in;
            sync_reg[1] <= sync_reg[0];
        end
    end

    // Output synchronized pointer
    assign d_out = sync_reg[1];

endmodule