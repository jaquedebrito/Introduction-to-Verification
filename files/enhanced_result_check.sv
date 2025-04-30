task automatic enhanced_result_check(
    input logic [7:0] a,
    input logic [7:0] b,
    input logic [3:0] op,
    input logic [7:0] expected_result,
    input logic expected_carry,
    input int test_num
);
    logic [15:0] full_result;
    logic [7:0] truncated_result;
    logic overflow_detected;
    
    // Calculate full result for verification
    case (op)
        4'b0000: begin // ADD
            full_result = {8'b0, a} + {8'b0, b};
            overflow_detected = (full_result > 16'hFF);
            if (overflow_detected && !CarryOut) begin
                $error("Test %0d: Overflow not detected in ADD operation", test_num);
                errors.overflow_errors++;
            end
        end
        4'b0010: begin // MUL
            full_result = a * b;
            if (full_result > 16'hFF) begin
                $error("Test %0d: Multiplication overflow detected", test_num);
                errors.overflow_errors++;
            end
        end
    endcase
    
    // Data stability check
    fork
        begin
            @(posedge clock);
            if ($isunknown(ULA_Out)) begin
                $error("Test %0d: Unstable output detected", test_num);
                errors.data_stability_errors++;
            end
        end
    join_none
    
    // Result matching with detailed reporting
    if (ULA_Out !== expected_result) begin
        $error("Test %0d: Result mismatch", test_num);
        $display("  Operation: %s", op_to_string(op));
        $display("  Inputs: A=%h, B=%h", a, b);
        $display("  Expected: %h", expected_result);
        $display("  Received: %h", ULA_Out);
        $display("  Full Result: %h", full_result);
        errors.result_mismatch++;
    end
endtask