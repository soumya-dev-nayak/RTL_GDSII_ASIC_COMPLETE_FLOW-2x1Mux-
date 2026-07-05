% path search . /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag
Usage: path [search|cell|sys] [[+]path]
% path search
. /foss/pdks/sky130A/libs.ref/sky130_fd_pr/mag /foss/pdks/sky130A/libs.ref/sky130_fd_io/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hdll/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hs/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hvl/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_lp/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_ls/mag /foss/pdks/sky130A/libs.ref/sky130_fd_sc_ms/mag /foss/pdks/sky130A/libs.ref/sky130_osu_sc/mag /foss/pdks/sky130A/libs.ref/sky130_osu_sc_t18/mag /foss/pdks/sky130A/libs.ref/sky130_ml_xx_hd/mag /foss/pdks/sky130A/libs.ref/sky130_fd_bd_sram/mag /foss/pdks/sky130A/libs.ref/sky130_sram_macros/mag
% lef read /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef
Reading LEF data from file /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd__nom.tlef.
This action cannot be undone.
LEF read, Line 82 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 83 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read, Line 116 (Message): Unknown keyword "MINENCLOSEDAREA" in LEF file; ignoring.
LEF read, Line 118 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 119 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read, Line 125 (Message): Unknown keyword "MAXIMUMDENSITY" in LEF file; ignoring.
LEF read, Line 126 (Message): Unknown keyword "DENSITYCHECKWINDOW" in LEF file; ignoring.
LEF read, Line 127 (Message): Unknown keyword "DENSITYCHECKSTEP" in LEF file; ignoring.
LEF read, Line 160 (Message): Unknown keyword "MINENCLOSEDAREA" in LEF file; ignoring.
LEF read, Line 168 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 169 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read, Line 171 (Message): Unknown keyword "MAXIMUMDENSITY" in LEF file; ignoring.
LEF read, Line 172 (Message): Unknown keyword "DENSITYCHECKWINDOW" in LEF file; ignoring.
LEF read, Line 173 (Message): Unknown keyword "DENSITYCHECKSTEP" in LEF file; ignoring.
LEF read, Line 210 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 211 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read, Line 213 (Message): Unknown keyword "MAXIMUMDENSITY" in LEF file; ignoring.
LEF read, Line 214 (Message): Unknown keyword "DENSITYCHECKWINDOW" in LEF file; ignoring.
LEF read, Line 215 (Message): Unknown keyword "DENSITYCHECKSTEP" in LEF file; ignoring.
LEF read, Line 252 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 253 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read, Line 255 (Message): Unknown keyword "MAXIMUMDENSITY" in LEF file; ignoring.
LEF read, Line 256 (Message): Unknown keyword "DENSITYCHECKWINDOW" in LEF file; ignoring.
LEF read, Line 257 (Message): Unknown keyword "DENSITYCHECKSTEP" in LEF file; ignoring.
LEF read, Line 294 (Message): Unknown keyword "ANTENNAMODEL" in LEF file; ignoring.
LEF read, Line 295 (Message): Unknown keyword "ANTENNADIFFSIDEAREARATIO" in LEF file; ignoring.
LEF read: Processed 801 lines.
% lef read /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef
Reading LEF data from file /foss/pdks/sky130A/libs.ref/sky130_fd_sc_hd/lef/sky130_fd_sc_hd.lef.
This action cannot be undone.
LEF read: Processed 56536 lines.
% def read /foss/designs/MUX_2x1_RTL_to_GDS/mux_final.def
Reading DEF data from file /foss/designs/MUX_2x1_RTL_to_GDS/mux_final.def.
This action cannot be undone.
  Processed 1 subcell instances total.
  Processed 4 pins total.
  Processed 4 nets total.
DEF read: Processed 65 lines.
% save mux_final
% select top cell
Topmost cell in the window
% expand all
% what
Selected subcell(s):
    Instance "Topmost cell in the window" of cell "mux_final"
% quit
0
% 