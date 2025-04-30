module ULA_enhanced_tb;
    // ... existing declarations ...
    
    Enhanced_ULA_cov enhanced_cov;
    UlaStateMonitor state_monitor;
    enhanced_error_stats_t errors;
    
    initial begin
        enhanced_cov = new();
        state_monitor = new();
        
        // ... rest of the test ...
    end
    
    // Example of enhanced test execution
    task run_enhanced_test(
        input logic [7:0] a,
        input logic [7:0] b,
        input logic [3:0] op,
        input logic [7:0] expected_result,
        input logic expected_carry,
        input int test_num
    );
        time start_time;
        logic operation_success;
        
        start_time = $time;
        
        // Apply inputs
        @(posedge clock);
        A = a;
        B = b;
        ULA_Sel = op;
        
        // Wait for result
        @(posedge clock);
        
        // Enhanced checks
        enhanced_timing_check(start_time, test_num, op);
        enhanced_result_check(a, b, op, expected_result, expected_carry, test_num);
        
        // Update statistics
        operation_success = (ULA_Out === expected_result);
        state_monitor.update_statistics($time - start_time, operation_success);
    endtask
    
    final begin
        state_monitor.print_statistics();
        $display("\nTestbench completed at %t", $time);
    end
endmodule