`timescale 1ns / 1ns    


`include "./fixed_point.svh"

localparam int  integer_width_first  = 14                                            ;
localparam int  fraction_width_first = 12                                            ;
localparam int  full_width_first     = integer_width_first + fraction_width_first - 1;
localparam real number_first         = 3.25                                          ;

localparam int  integer_width_second  = 10                                              ;
localparam int  fraction_width_second = 12                                              ;
localparam int  full_width_second     = integer_width_second + fraction_width_second - 1;
localparam real number_second         = 1.5                                             ;

module fp_TB
();


//////Clock
reg clk;initial  clk = 1'b0;
always #10 clk = !clk;
// --------------------------------------------------
reg reset_n = 1'b0;


fixed_point fp_first  = new(number_first, integer_width_first, fraction_width_first)   ;
fixed_point fp_second = new(number_second, integer_width_second, fraction_width_second);

logic [integer_width_first-1:0] integer_part;

logic [  full_width_first:0] sum_of_two ;
logic [  full_width_first:0] sub_of_two ;
logic [full_width_first*2:0] mult_of_two;
logic [  full_width_first:0] shifted    ;

logic[3:0]cntr=0;

always_ff @(posedge clk) begin
    integer_part <= fp_first.get_integer();

    sum_of_two  <= fp_first.get_sum(fp_second);
    sub_of_two  <= fp_first.get_sub(fp_second);
    mult_of_two <= fp_first.get_mult(fp_second);

    shifted     <= fp_first.get_shift_right(2);

    if(cntr [3])
        fp_first.display();

    if(cntr [3])
        fp_first.sub(fp_second);



    cntr <= cntr[3]? '0 : (cntr + 'd1);
end

endmodule

