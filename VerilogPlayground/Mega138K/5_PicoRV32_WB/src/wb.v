module wb (
    input wire clk_i,            // Clock signal
    input wire rst_i,            // Reset signal (active high)
    input wire [31:0] adr_i,   // Address input
    input wire [31:0] dat_i,   // Data input
    output reg [31:0] dat_o,   // Data output
    input wire we_i,           // Write enable
    input wire stb_i,          // Strobe signal
    input wire cyc_i,          // Cycle signal
    output reg ack_o           // Acknowledge signal
);

// Internal 32-bit register
reg [31:0] register;

// Wishbone operation
always @(posedge clk_i or posedge rst_i) begin
    if (rst_i) begin
        // Reset logic
        register <= 32'b0;
        dat_o <= 32'b0;
        ack_o <= 1'b0;
    end else begin
        if (cyc_i && stb_i) begin
            ack_o <= 1'b1; // Acknowledge the transaction
            if (we_i) begin
                // Write operation
                register <= dat_i;
            end else begin
                // Read operation
                dat_o <= register;
            end
        end else begin
            ack_o <= 1'b0; // Deassert acknowledge
        end
    end
end

endmodule

