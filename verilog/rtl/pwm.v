module ThreePhasePWM(
    input wire clk,
    input wire rst,
    input wire en,  // Added enable input
    input wire [7:0] duty_cycle,
    output wire pwm1_out,
    output wire pwm1_comp_out,
    output wire pwm2_out,
    output wire pwm2_comp_out,
    output wire pwm3_out,
    output wire pwm3_comp_out
);

    wire [7:0] corrected_duty_cycle;
    wire cmp1_out, cmp2_out;
    wire latch1_q, latch2_q;
    wire [7:0] count1, count2;

    wire pwm1_raw, pwm2_raw, pwm3_raw;


    // Dead Time Generation for each PWM signal
    DeadTimeGenerator dtg1(
        .clk(clk),
        .pwm_in(pwm1_raw),
        .pwm_out(pwm1_out),  // Connect to ThreePhasePWM module's output ports
        .comp_pwm_out(pwm1_comp_out)
    );

    DeadTimeGenerator dtg2(
        .clk(clk),
        .pwm_in(pwm2_raw),
        .pwm_out(pwm2_out),  // Connect to ThreePhasePWM module's output ports
        .comp_pwm_out(pwm2_comp_out)
    );

    DeadTimeGenerator dtg3(
        .clk(clk),
        .pwm_in(pwm3_raw),
        .pwm_out(pwm3_out),  // Connect to ThreePhasePWM module's output ports
        .comp_pwm_out(pwm3_comp_out)
    );

    DutyCycleCorrector dcc (
        .duty_cycle_in(duty_cycle),
        .duty_cycle_out(corrected_duty_cycle)
    );

    // Instantiate Single PWM Modules
    PWM PWM1(
        .clk(clk),
        .rst(rst),
        .en(en),  // Connected enable signal
        .duty_cycle(corrected_duty_cycle),  // Updated to use corrected_duty_cycle
        .pwm_out(pwm1_raw),  // Updated to match PWM module definition
        .count(count1)  // Connected count output to ThreePhasePWM module's count1 wire
    );
    
    PWM PWM2(
        .clk(clk),
        .rst(rst),
        .en(latch1_q & en),  // Updated enable condition
        .duty_cycle(corrected_duty_cycle),  // Updated to use corrected_duty_cycle
        .pwm_out(pwm2_raw),  // Updated to match PWM module definition
        .count(count2)  // Connected count output to ThreePhasePWM module's count2 wire
    );
    
    PWM PWM3(
        .clk(clk),
        .rst(rst),
        .en(latch2_q & en),  // Updated enable condition
        .duty_cycle(corrected_duty_cycle),  // Updated to use corrected_duty_cycle        
        .pwm_out(pwm3_raw)  // Updated to match PWM module definition
    );

    // Comparator Modules
    OneThirdComparator cmp1(
        .count(count1),
        .cmp_out(cmp1_out)
    );
    
    OneThirdComparator cmp2(
        .count(count2),
        .cmp_out(cmp2_out)
    );

    // S-R Latch Modules
    SR_latch latch1(
        .en(en),
        .rst(rst),
        .S(cmp1_out),
        .R(1'b0),
        .Q(latch1_q)
    );
    
    SR_latch latch2(
        .en(en),
        .rst(rst),
        .S(cmp2_out),
        .R(1'b0),
        .Q(latch2_q)
    );

endmodule

module DutyCycleCorrector(
    input wire [7:0] duty_cycle_in,
    output wire [7:0] duty_cycle_out
);
    assign duty_cycle_out = 8'hFF - duty_cycle_in;
endmodule

module OneThirdComparator(
    input wire [7:0] count,
    output wire cmp_out
);
    assign cmp_out = (count >= 8'd85) ? 1 : 0;  // 256/3 ≈ 85
endmodule

module SR_latch(
    input en, rst, S, R, 
    output reg Q
    ); 
    
    always@(*)
        begin 
            if(rst) Q <= 1'b0;
            else if(en) begin
                case({S,R})
                    2'b00 : Q <= Q;
                    2'b01 : Q <= 1'b0;
                    2'b10 : Q <= 1'b1;
                    default : Q <= 1'bx;
                endcase
            end    
        end
endmodule


// Single PWM module, Comparator, UpCounter, DFlipFlop modules remain unchanged
module PWM(
    input wire clk,
    input wire rst,
    input wire en,  // Added enable input
    input wire [7:0] duty_cycle,
    output wire pwm_out,
    output wire [7:0] count  // Added count output
);

    wire cmp_out;
    
    UpCounter u1(
        .clk(clk),
        .rst(rst),
        .en(en),  // Connected enable signal
        .count(count)  // Connected count output to PWM module's count output
    );
    
    Comparator c1(
        .duty_cycle(duty_cycle),
        .count(count),
        .cmp_out(cmp_out)
    );
    
    DFlipFlop d1(
        .clk(clk),
        .rst(rst),
        .d(cmp_out),
        .q(pwm_out)
    );
    
endmodule

module Comparator(
    input wire [7:0] duty_cycle,
    input wire [7:0] count,
    output wire cmp_out
);
    assign cmp_out = (count > duty_cycle) ? 1 : 0;  // Changed from count < duty_cycle to count > duty_cycle
endmodule

module UpCounter(
    input wire clk,
    input wire rst,
    input wire en,  // Added enable input
    output wire [7:0] count
);
    reg [7:0] count_reg;
    assign count = count_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            count_reg <= 8'b0;
        else if (en)  // Check enable signal
            if (count_reg == 8'b11111111)
                count_reg <= 8'b0;
            else
                count_reg <= count_reg + 1;
    end
endmodule

module DFlipFlop(
    input wire clk,
    input wire rst,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 0;
        else
            q <= d;
    end
endmodule

module DeadTimeGenerator(
    input wire clk,
    input wire pwm_in,
    output wire pwm_out,
    output wire comp_pwm_out
);
    wire dff1_out, dff2_out, dff3_out, dff4_out;

    // Chain of four D Flip-Flops
    DFlipFlop dff1(
        .clk(clk),
        .rst(1'b0),  // No reset
        .d(pwm_in),
        .q(dff1_out)
    );

    DFlipFlop dff2(
        .clk(clk),
        .rst(1'b0),
        .d(dff1_out),
        .q(dff2_out)
    );

    DFlipFlop dff3(
        .clk(clk),
        .rst(1'b0),
        .d(dff2_out),
        .q(dff3_out)
    );

    DFlipFlop dff4(
        .clk(clk),
        .rst(1'b0),
        .d(dff3_out),
        .q(dff4_out)
    );

    // Logic Gates
    assign pwm_out = pwm_in & dff4_out;
    assign comp_pwm_out = ~(pwm_in | dff4_out);

endmodule
