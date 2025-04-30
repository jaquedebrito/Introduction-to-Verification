// Enhanced timing check task
task automatic enhanced_timing_check(
    input time start_time,
    input int test_num,
    input logic [3:0] op
);
    time end_time, delta;
    end_time = $time;
    delta = end_time - start_time;
    
    // Basic timing check
    if (delta != 10) begin
        $error("Test %0d: Timing violation - Expected 10ns, got %0t ns", test_num, delta);
        errors.timing_violations++;
    end
    
    // Setup time verification
    if (delta < 5) begin
        $error("Test %0d: Setup time violation - Operation started too early", test_num);
        errors.setup_hold_violations++;
    end
    
    // Operation-specific timing checks
    case (op)
        4'b0000: begin // ADD
            if (delta > 12) begin // ADD should complete within 12ns
                $error("Test %0d: ADD operation exceeded maximum allowed time", test_num);
                errors.performance_violations++;
            end
        end
        4'b0011: begin // DIV
            if (delta > 15) begin // DIV allowed more time
                $error("Test %0d: DIV operation exceeded maximum allowed time", test_num);
                errors.performance_violations++;
            end
        end
    endcase
endtask