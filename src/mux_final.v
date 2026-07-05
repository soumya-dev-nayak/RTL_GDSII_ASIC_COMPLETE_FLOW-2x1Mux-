module Mux_2x1 (out,
    i0,
    i1,
    sel);
 output out;
 input i0;
 input i1;
 input sel;

 wire _2_;

 sky130_fd_sc_hd__mux2_1 _4_ (.A0(i0),
    .A1(i1),
    .S(sel),
    .X(_2_));
 assign out = _2_;
endmodule
