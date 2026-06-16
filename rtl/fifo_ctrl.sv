`timescale 1ns/1ps
module fifo_ctrl #(
    parameter int DEPTH            = 16,
    parameter int ALMOST_FULL_VAL  = 14,
    parameter int ALMOST_EMPTY_VAL = 2,
    parameter int ADDR_WIDTH       = 4
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    wr_en,
    input  logic                    rd_en,
    output logic [ADDR_WIDTH-1:0]   wr_addr,
    output logic [ADDR_WIDTH-1:0]   rd_addr,
    output logic                    full,
    output logic                    empty,
    output logic                    almost_full,
    output logic                    almost_empty,
    output logic [ADDR_WIDTH:0]     word_count
);

    // Pointers with an extra bit for wrap-around detection
    logic [ADDR_WIDTH:0] wr_ptr_reg;
    logic [ADDR_WIDTH:0] rd_ptr_reg;

    // Map internal pointers to memory addresses
    assign wr_addr = wr_ptr_reg[ADDR_WIDTH-1:0];
    assign rd_addr = rd_ptr_reg[ADDR_WIDTH-1:0];

    // Pointer update logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_reg <= '0;
            rd_ptr_reg <= '0;
        end else begin
            if (wr_en && !full) begin
                wr_ptr_reg <= wr_ptr_reg + 1'b1;
            end
            if (rd_en && !empty) begin
                rd_ptr_reg <= rd_ptr_reg + 1'b1;
            end
        end
    end

    // Word count calculation using binary pointer subtraction
    assign word_count = wr_ptr_reg - rd_ptr_reg;

    // Status flag generation
    assign empty        = (word_count == 0);
    assign full         = (word_count == DEPTH);
    assign almost_full  = (word_count >= ALMOST_FULL_VAL);
    assign almost_empty = (word_count <= ALMOST_EMPTY_VAL);

endmodule