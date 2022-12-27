
localparam int fpclass_int_width  = 32                                       ;
localparam int fpclass_fra_width  = 32                                       ;
localparam int fpclass_full_width = fpclass_int_width + fpclass_fra_width - 1;

class fixed_point;

    real real_value;

    int integer_length   ;
    int fractional_length;

    bit [fpclass_full_width:0] fp_number; //fixedpoint value storage


    function new(real number, int int_length, int fract_length);
        this.real_value = number;
        this.integer_length = int_length;
        this.fractional_length = fract_length;

        this.fp_number = (($rtoi(number))<<(fract_length)) + ((number - $rtoi(number)) * 2**fract_length);//
    endfunction : new


    function logic[fpclass_int_width-1:0] get_integer();
        return this.fp_number[fractional_length +: fpclass_int_width] + this.fp_number[fpclass_full_width];
    endfunction : get_integer

    function real get_real();
        return $itor(this.fp_number)/2**this.fractional_length;
    endfunction : get_real

    function void display();
        $display("Value is = %0f",this.get_real());
    endfunction : display


    function void widths_check(fixed_point second_fp);
        if(this.fractional_length != second_fp.fractional_length)
            $fatal("Fractional widths don't match! first = %0d ; second = %0d",this.fractional_length,second_fp.fractional_length);
    endfunction : widths_check




    function logic[fpclass_full_width:0] get_sum(fixed_point second_fp);
        this.widths_check(second_fp);
        return this.fp_number + second_fp.fp_number;
    endfunction : get_sum

    function logic[fpclass_full_width:0] get_sub(fixed_point second_fp);
        this.widths_check(second_fp);
        return this.fp_number - second_fp.fp_number;
    endfunction : get_sub

    function logic[fpclass_full_width:0] get_mult(fixed_point second_fp);
        this.widths_check(second_fp);
        return (this.fp_number * second_fp.fp_number)>>fractional_length;
    endfunction : get_mult

    function logic[fpclass_full_width:0] get_shift_right(int shift);
        return this.fp_number >> shift;
    endfunction : get_shift_right

    function logic[fpclass_full_width:0] get_shift_left(int shift);
        return this.fp_number << shift;
    endfunction : get_shift_left


    function void add( fixed_point second_fp );
        this.fp_number = this.get_sum(second_fp);
    endfunction : add

    function void sub( fixed_point second_fp );
        this.fp_number = this.get_sub(second_fp);
    endfunction : sub

    function void mult( fixed_point second_fp );
        this.fp_number = this.get_mult(second_fp);
    endfunction : mult

    function void shift_right(int shift);
        this.fp_number = this.get_shift_right(shift);
    endfunction : shift_right

    function void shift_left(int shift);
        this.fp_number = this.get_shift_right(shift);
    endfunction : shift_left

endclass : fixed_point