// blink.v — LED blinker for the Arty A7
// Toggles LED0 at ~1 Hz given a 100 MHz system clock.
//
// Top-level ports match the Arty A7 XDC constraints.

module blink #(
    parameter CLK_HZ  = 100_000_000,
    parameter BLINK_HZ = 1
) (
    input  wire clk,
    input  wire rst_n,   // active-low reset (tied to BTN0 via XDC)
    output reg  led0
);

    localparam COUNT_MAX = (CLK_HZ / (2 * BLINK_HZ)) - 1;

    reg [$clog2(COUNT_MAX+1)-1:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            led0    <= 0;
        end else begin
            if (counter == COUNT_MAX) begin
                counter <= 0;
                led0    <= ~led0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
