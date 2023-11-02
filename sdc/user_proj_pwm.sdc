###############################################################################
# Created by write_sdc
# Thu Nov  2 14:51:35 2023
###############################################################################
current_design user_proj_pwm
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 25.0000 [get_ports {wb_clk_i}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
set_input_delay 12.5000 -clock [get_clocks {clk}] -add_delay [get_ports {wb_rst_i}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {io_oeb[14]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[13]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[12]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[11]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[10]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[9]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[8]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[7]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[6]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[5]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[4]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[3]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[2]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[1]}]
set_load -pin_load 0.1900 [get_ports {io_oeb[0]}]
set_load -pin_load 0.1900 [get_ports {io_out[14]}]
set_load -pin_load 0.1900 [get_ports {io_out[13]}]
set_load -pin_load 0.1900 [get_ports {io_out[12]}]
set_load -pin_load 0.1900 [get_ports {io_out[11]}]
set_load -pin_load 0.1900 [get_ports {io_out[10]}]
set_load -pin_load 0.1900 [get_ports {io_out[9]}]
set_load -pin_load 0.1900 [get_ports {io_out[8]}]
set_load -pin_load 0.1900 [get_ports {io_out[7]}]
set_load -pin_load 0.1900 [get_ports {io_out[6]}]
set_load -pin_load 0.1900 [get_ports {io_out[5]}]
set_load -pin_load 0.1900 [get_ports {io_out[4]}]
set_load -pin_load 0.1900 [get_ports {io_out[3]}]
set_load -pin_load 0.1900 [get_ports {io_out[2]}]
set_load -pin_load 0.1900 [get_ports {io_out[1]}]
set_load -pin_load 0.1900 [get_ports {io_out[0]}]
set_input_transition 0.6100 [get_ports {wb_clk_i}]
set_input_transition -min 0.0500 [get_ports {io_in[14]}]
set_input_transition -max 0.3800 [get_ports {io_in[14]}]
set_input_transition -min 0.0500 [get_ports {io_in[13]}]
set_input_transition -max 0.3800 [get_ports {io_in[13]}]
set_input_transition -min 0.0500 [get_ports {io_in[12]}]
set_input_transition -max 0.3800 [get_ports {io_in[12]}]
set_input_transition -min 0.0500 [get_ports {io_in[11]}]
set_input_transition -max 0.3800 [get_ports {io_in[11]}]
set_input_transition -min 0.0500 [get_ports {io_in[10]}]
set_input_transition -max 0.3800 [get_ports {io_in[10]}]
set_input_transition -min 0.0500 [get_ports {io_in[9]}]
set_input_transition -max 0.3800 [get_ports {io_in[9]}]
set_input_transition -min 0.0500 [get_ports {io_in[8]}]
set_input_transition -max 0.3800 [get_ports {io_in[8]}]
set_input_transition -min 0.0500 [get_ports {io_in[7]}]
set_input_transition -max 0.3800 [get_ports {io_in[7]}]
set_input_transition -min 0.0500 [get_ports {io_in[6]}]
set_input_transition -max 0.3800 [get_ports {io_in[6]}]
set_input_transition -min 0.0500 [get_ports {io_in[5]}]
set_input_transition -max 0.3800 [get_ports {io_in[5]}]
set_input_transition -min 0.0500 [get_ports {io_in[4]}]
set_input_transition -max 0.3800 [get_ports {io_in[4]}]
set_input_transition -min 0.0500 [get_ports {io_in[3]}]
set_input_transition -max 0.3800 [get_ports {io_in[3]}]
set_input_transition -min 0.0500 [get_ports {io_in[2]}]
set_input_transition -max 0.3800 [get_ports {io_in[2]}]
set_input_transition -min 0.0500 [get_ports {io_in[1]}]
set_input_transition -max 0.3800 [get_ports {io_in[1]}]
set_input_transition -min 0.0500 [get_ports {io_in[0]}]
set_input_transition -max 0.3800 [get_ports {io_in[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 1.0000 [current_design]
set_max_fanout 16.0000 [current_design]
