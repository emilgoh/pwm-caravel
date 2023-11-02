// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */

module user_proj_pwm(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,

    // IOs
    input  [14:0] io_in,
    output [14:0] io_out,
    output [14:0] io_oeb
);

    //Output
    wire pwm1_out;
    wire pwm1_comp_out;
    wire pwm2_out;
    wire pwm2_comp_out;
    wire pwm3_out;
    wire pwm3_comp_out;

    ThreePhasePWM pwm(
        .clk(wb_clk_i),
        .rst(wb_rst_i),
        .en(io_in[0]),
        .duty_cycle(io_in[8:1]),
        .pwm1_out(pwm1_out),
        .pwm1_comp_out(pwm1_comp_out),
        .pwm2_out(pwm2_out),
        .pwm2_comp_out(pwm2_comp_out),
        .pwm3_out(pwm3_out),
        .pwm3_comp_out(pwm3_comp_out)
    );
    
    // Output
    assign io_out[8:0] = 9'd0;
    assign io_out[9] = pwm1_out;
    assign io_out[10] = pwm1_comp_out;
    assign io_out[11] = pwm2_out;
    assign io_out[12] = pwm2_comp_out;
    assign io_out[13] = pwm3_out;
    assign io_out[14] = pwm3_comp_out;

    assign io_oeb[14:0] = 15'd0;


endmodule


`default_nettype wire
