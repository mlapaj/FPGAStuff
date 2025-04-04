module simple_apb_module #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_WIDTH = 32
) (
    input  wire                 PCLK,       // Clock
    input  wire                 PRESETn,    // Reset (active low)
    input  wire                 PSEL,       // Select signal
    input  wire                 PENABLE,    // Enable signal
    input  wire                 PWRITE,     // Write control signal (1 for write, 0 for read)
    input  wire [ADDR_WIDTH-1:0] PADDR,      // Address bus
    input  wire [DATA_WIDTH-1:0] PWDATA,     // Write data bus
    output reg  [DATA_WIDTH-1:0] PRDATA,     // Read data bus
    output reg                  PREADY,     // Ready signal
    output reg                  PSLVERR     // Slave error signal
);

    // Internal memory (simple array as an example storage)
    reg [DATA_WIDTH-1:0] memory [0:(1 << ADDR_WIDTH)-1];

    // Reset logic
    always @(negedge PRESETn or posedge PCLK) begin
        if (!PRESETn) begin
            PREADY  <= 1'b0;
            PSLVERR <= 1'b0;
            PRDATA  <= {DATA_WIDTH{1'b0}};
        end else begin
            if (PSEL && PENABLE) begin
                PREADY  <= 1'b1; // Indicate the operation is complete
                PSLVERR <= 1'b0; // No error for now

                if (PWRITE) begin
                    // Write operation
                    memory[0] <= PWDATA;
                end else begin
                    // Read operation
                    PRDATA <= memory[0];
                end
            end else begin
                PREADY <= 1'b0; // Not ready when not enabled
            end
        end
    end

endmodule
