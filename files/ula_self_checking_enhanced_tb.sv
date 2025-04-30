`include "ula_tb_pkg.sv"
import ula_tb_pkg::*;

module ULA_self_checking_enhanced_tb;
    timeunit 1ns;
    timeprecision 1ps;

    // Sinais do testbench
    logic        clock;
    logic        reset;
    logic [7:0]  A;
    logic [7:0]  B;
    logic [3:0]  ULA_Sel;
    logic [7:0]  ULA_Out;
    logic        CarryOut;
    
    // Enhanced error tracking
    enhanced_error_stats_t errors;
    
    // State monitoring
    UlaStateMonitor state_monitor;
    
    // Coverage
    Enhanced_ULA_cov cov;
    
    // Instanciação do DUT
    ULA dut (.*);
    
    // Geração de clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Enhanced timing check task
    task automatic enhanced_timing_check(
        input time start_time,
        input int test_num,
        input op_t op
    );
        time end_time, delta;
        end_time = $time;
        delta = end_time - start_time;
        
        if (delta != 10) begin
            $error("Test %0d: Timing violation - Expected 10ns, got %0t ns", test_num, delta);
            errors.timing_violations++;
        end
        
        if (delta < 5) begin
            $error("Test %0d: Setup time violation", test_num);
            errors.setup_hold_violations++;
        end
        
        case (op)
            ADD: if (delta > 12) errors.performance_violations++;
            DIV: if (delta > 15) errors.performance_violations++;
        endcase
    endtask

    // Enhanced result check task
    task automatic enhanced_check_result(
        input logic [7:0] a,
        input logic [7:0] b,
        input op_t op,
        input int test_num
    );
        time start_time;
        logic [15:0] full_result;
        logic operation_success;
        
        if ($isunknown({a, b, op})) begin
            errors.unknown_values++;
            return;
        end

        start_time = $time;
        
        @(posedge clock);
        A = a;
        B = b;
        ULA_Sel = op;
        
        @(posedge clock);
        #1;

        case (op)
            ADD: begin
                full_result = {8'b0, a} + {8'b0, b};
                if (full_result > 16'hFF && !CarryOut) 
                    errors.overflow_errors++;
            end
            MUL: begin
                full_result = a * b;
                if (full_result > 16'hFF) 
                    errors.overflow_errors++;
            end
        endcase

        operation_success = !errors.overflow_errors && 
                          !errors.timing_violations && 
                          !errors.unknown_values;
                          
        state_monitor.update_statistics($time - start_time, 
                                     operation_success, 
                                     op);
                                     
        enhanced_timing_check(start_time, test_num, op);
    endtask

    // Main test process
    initial begin
        // Initialize
        state_monitor = new();
        cov = new("ULA_Coverage");
        errors = '{default: 0};
        
        // Print header
        $display("//----------------------------------------");
        $display("// Enhanced ULA Self-Checking Testbench");
        $display("// Date: 2025-02-23 18:10:54");
        $display("// User: jaquedebrito");
        $display("//----------------------------------------");
        
        // Reset sequence
        reset = 1;
        A = 0;
        B = 0;
        ULA_Sel = 0;
        repeat(2) @(posedge clock);
        reset = 0;
        @(posedge clock);

        // Run tests
        run_deterministic_tests();
        run_random_tests(20);
        
        // Final reports
        state_monitor.print_statistics();
        print_error_report();
        
        $display("\nTestbench completed at %t", $time);
        $finish;
    end

    // ... (rest of the existing tasks and functions)
endmodule