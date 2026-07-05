# Input delays
set_input_delay 0 [all_inputs]

# Output delays
set_output_delay 0 [all_outputs]

# Driving cell
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_1 [all_inputs]

# Output load
set_load 0.05 [all_outputs]
