module clock_divider #(parameter DIV_FACTOR = 2) // Division factor (must be greater than 1)

(
    input wire clk_in,       // Input clock
    input wire reset,        // Active-high reset signal
    output reg clk_out       // Output divided clock
);

    // Counter for division
    reg [$clog2(DIV_FACTOR)-1:0] counter = 0;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter == DIV_FACTOR - 1) begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle output clock
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

