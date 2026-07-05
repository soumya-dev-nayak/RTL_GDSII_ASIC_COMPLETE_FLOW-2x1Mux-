module Mux_2x1 (
    input logic i0,
    input logic i1,
    input logic sel,
    output logic out
);
    assign out = (sel) ? i1 : i0;

endmodule
