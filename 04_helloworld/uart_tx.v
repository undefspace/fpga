// Generic UART transmitter module
//
// UART is a very simple protocol. It transmits data in frames, each carrying
// from 5 to 8 bits of useful data with optional parity checking.
//
// The line rests at a logic 1. Each frame consists of:
//   - a start bit (logic 0)
//   - the data transmitted from the least to the most significant bit
//   - an optional parity bit
//   - a stop bit (logic 1)
//
// Here's a frame transmitting the ASCII-encoded letter 'H' (0x48) with 8 data
// bits, even parity and 1 stop bit:
//
//    idle   S  [0] [1] [2] [3] [4] [5] [6] [7]  P   S    idle
// 1 ------+               +---+       +---+       +---+----------
//         |               |   |       |   |       |
// 0       +---+---+---+---+   +---+---+   +---+---+
//
// Because the transmitter is configured with even parity, it will ensure that
// the number of '1' bits is always even. It can do that with the help of a
// parity bit which it can set to a '1' if the number of '1' bits in the
// payload is odd. In the frame above, the data contains 2 '1' bits, and thus
// the parity bit is at 0.
// The receiver can use the parity bit for some rudimentary data integrity
// checking. If it sees that the parity bit that it received does not match
// the expected value, it knows that what it received is not what the sender
// intended to transmit. On the other hand, if it receives the value that it
// expected, it has a
//   $$f(\{0\}) / f(\{0,2,4,6,8\}),$$ where
//       $$f(S) = \sum\limits_{n \in S} \binom{9}{n} p^n (1-p)^{9-n}$$
// confidence that it received the correct data, where $p$ is the probability
// of a single bit flip (since we are living in the world where the parity is
// correct, we are only interested in the cases where the number of bit flips
// is even; the received value is correct if and only if this number is zero).
// See also: https://math.stackexchange.com/questions/4398331/probability-of-an-error-going-undetected-with-a-single-parity-bit
//
// This transmitter module is always configered for 8 data bits, even parity and
// 1 stop bit. The baudrate matches the input clock rate.
module uart_tx(
    // Simple memory interface. The UART sets an address and expects the data
    // to stabilize before the next edge of the clock signal.
    output reg [7:0] address = 0,
    input [7:0] data,
    
    // Clock input; must match the intended baud rate
    input clk,

    // When `start` is pulsed up and down, the module will start transmitting
    // and stop when it encounters a 0 byte in the input data. The beginning
    // of the strobe must not occur at the falling edge of the clock.
    input start,
    output idle, // 1 while idle, 0 while transmitting

    // Data transmission output
    output reg tx = 1
);

// Simple state machine
`define STATE_IDLE   0
`define STATE_START  1
`define STATE_BIT(x) 2 + x
`define STATE_PARITY 10
`define STATE_STOP   11
reg [3:0] state = `STATE_IDLE;
assign idle = state == `STATE_IDLE;

wire cur_bit;
assign cur_bit = data[state - 2];

reg parity;

always @(posedge (clk | start)) begin
    if(start) begin
        address <= 0;
        state <= `STATE_START;
    end else begin
        case(state)
            `STATE_IDLE: ;
            `STATE_START: begin
                parity <= 0;
                tx <= 0;
            end
            `STATE_PARITY: begin
                tx <= parity;
                address <= address + 1;
            end
            `STATE_STOP: begin
                tx <= 1;
            end
            default: begin
                tx <= cur_bit;
                parity <= parity ^ cur_bit;
            end
        endcase

        if(state == `STATE_IDLE) begin
            ;
        end else if(state == `STATE_STOP) begin
            if(data == 0) begin
                address <= 0;
                state <= `STATE_IDLE;
            end else begin
                state <= `STATE_START;
            end
        end else begin
            state <= state + 1;
        end
    end
end

endmodule
