covergroup Enhanced_ULA_cov @(posedge clock);
    option.per_instance = 1;
    option.comment = "Enhanced ULA Coverage Model";
    
    // Operation Coverage
    cp_op: coverpoint ULA_Sel {
        bins ops[] = {[0:3]};
        illegal_bins invalid = {[4:$]};
        option.weight = 2;
    }
    
    // Input Data Ranges
    cp_input_a: coverpoint A {
        bins zero = {0};
        bins small = {[1:16]};
        bins medium = {[17:128]};
        bins large = {[129:254]};
        bins max = {255};
    }
    
    cp_input_b: coverpoint B {
        bins zero = {0};
        bins small = {[1:16]};
        bins medium = {[17:128]};
        bins large = {[129:254]};
        bins max = {255};
    }
    
    // Result Categories
    cp_result: coverpoint ULA_Out {
        bins zero_result = {0};
        bins small_result = {[1:16]};
        bins medium_result = {[17:128]};
        bins large_result = {[129:254]};
        bins max_result = {255};
    }
    
    // Cross Coverage
    cx_op_inputs: cross cp_op, cp_input_a, cp_input_b {
        option.weight = 3;
    }
    
    // Special Cases Coverage
    cp_special_cases: coverpoint {A, B, ULA_Sel} {
        bins overflow_case = (8'hFF, 8'h01, 4'b0000);  // ADD overflow
        bins max_sub = (8'hFF, 8'hFF, 4'b0001);        // SUB max
        bins max_mul = (8'hFF, 8'hFF, 4'b0010);        // MUL max
        bins div_by_one = (8'hFF, 8'h01, 4'b0011);     // DIV by 1
    }
endgroup