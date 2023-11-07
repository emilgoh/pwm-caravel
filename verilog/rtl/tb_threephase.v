`timescale 1ns/10ps

module tb_ThreePhasePWM();
    reg clk;
    reg rst;
    reg en;  // Added enable signal
    reg [7:0] duty_cycle;
    wire pwm1_out, pwm1_comp_out, pwm2_out, pwm2_comp_out, pwm3_out, pwm3_comp_out;

    // Instantiate the ThreePhasePWM module
    ThreePhasePWM uut (
        .clk(clk),
        .rst(rst),
        .en(en),  // Connected enable signal
        .duty_cycle(duty_cycle),
        .pwm1_out(pwm1_out),
        .pwm1_comp_out(pwm1_comp_out),
        .pwm2_out(pwm2_out),
        .pwm2_comp_out(pwm2_comp_out),
        .pwm3_out(pwm3_out),
        .pwm3_comp_out(pwm3_comp_out)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #20 clk = ~clk;  // Slowed down the clock by 2 times
    end

    // Stimulus
    initial begin
        // Open VCD file
        $dumpfile("output.vcd");
        $dumpvars(0, tb_ThreePhasePWM);

        // Reset
        rst = 1;
        en = 0;  // Disable PWM initially
        duty_cycle = 8'b0;
        #20 rst = 0;

        // Enable PWM and reset = 0, duty cycle = 0%
        en = 1;
        #5120;  // 512 cycles * 10 time units per clock cycle

        // Test Case 1: 25% Duty Cycle
        duty_cycle = 8'd64;  // 64/256 for 25% duty cycle
        #76800;  // 768 cycles * 100 time units per clock cycle

        // Test Case 2: 50% Duty Cycle
        duty_cycle = 8'd128;  // 128/256 for 50% duty cycle
        #76800;  // 768 cycles * 100 time units per clock cycle
        
        // Test Case 3: 75% Duty Cycle
        duty_cycle = 8'd192;  // 192/256 for 75% duty cycle
        #76800;  // 768 cycles * 100 time units per clock cycle

        // Simulation Complete
        $stop;
    end

endmodule
