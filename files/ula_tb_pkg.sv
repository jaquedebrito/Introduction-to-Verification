package ula_tb_pkg;
    timeunit 1ns;
    timeprecision 1ps;

    // Enhanced Error Statistics Structure
    typedef struct {
        int invalid_ops;
        int timing_violations;
        int overflow_errors;
        int a_less_than_b;
        int div_by_zero;
        int result_mismatch;
        int carry_mismatch;
        int unknown_values;
        int vector_format_errors;
        int setup_hold_violations;
        int reset_timing_errors;
        int clock_glitch_errors;
        int invalid_state_transitions;
        int boundary_condition_errors;
        int performance_violations;
        int data_stability_errors;
        int protocol_violations;
    } enhanced_error_stats_t;

    // Operation type enumeration
    typedef enum logic [3:0] {
        ADD = 4'b0000,
        SUB = 4'b0001,
        MUL = 4'b0010,
        DIV = 4'b0011
    } op_t;

    // State Monitor Class
    class UlaStateMonitor;
        // State tracking
        logic [7:0] last_result;
        logic [3:0] last_op;
        int consecutive_errors;
        time last_operation_time;
        
        // Performance monitoring
        time max_operation_time;
        time min_operation_time;
        real avg_operation_time;
        int total_operations;
        
        // Test statistics
        int num_adds;
        int num_subs;
        int num_muls;
        int num_divs;
        int num_invalids;
        int num_tests;
        
        function new();
            last_result = 8'h00;
            last_op = 4'h0;
            consecutive_errors = 0;
            last_operation_time = 0;
            max_operation_time = 0;
            min_operation_time = '1;
            avg_operation_time = 0;
            total_operations = 0;
            num_adds = 0;
            num_subs = 0;
            num_muls = 0;
            num_divs = 0;
            num_invalids = 0;
            num_tests = 0;
        endfunction
        
        function void update_statistics(
            input time operation_time,
            input logic operation_success,
            input op_t operation
        );
            total_operations++;
            
            if (operation_time > max_operation_time)
                max_operation_time = operation_time;
            if (operation_time < min_operation_time)
                min_operation_time = operation_time;
                
            avg_operation_time = (avg_operation_time * (total_operations-1) + 
                                real'(operation_time)) / total_operations;
                                
            if (!operation_success)
                consecutive_errors++;
            else
                consecutive_errors = 0;
                
            if (consecutive_errors >= 3)
                $fatal(1, "Three consecutive operations failed!");
                
            case (operation)
                ADD: num_adds++;
                SUB: num_subs++;
                MUL: num_muls++;
                DIV: num_divs++;
                default: num_invalids++;
            endcase
            
            num_tests++;
        endfunction
        
        function void print_statistics();
            string timestamp;
            timestamp = $sformatf("%0d-%0d-%0d %0d:%0d:%0d", 
                                2025, 02, 23, 18, 10, 54);
            
            $display("\n=== ULA Operation Statistics ===");
            $display("Timestamp: %s", timestamp);
            $display("User: jaquedebrito");
            $display("\nOperation Counts:");
            $display("  Additions: %0d", num_adds);
            $display("  Subtractions: %0d", num_subs);
            $display("  Multiplications: %0d", num_muls);
            $display("  Divisions: %0d", num_divs);
            $display("  Invalid Operations: %0d", num_invalids);
            $display("\nTiming Statistics:");
            $display("  Total Operations: %0d", total_operations);
            $display("  Maximum Operation Time: %0t", max_operation_time);
            $display("  Minimum Operation Time: %0t", min_operation_time);
            $display("  Average Operation Time: %0.2f", avg_operation_time);
            $display("  Consecutive Errors: %0d", consecutive_errors);
        endfunction
    endclass

    // Enhanced Coverage Group
    covergroup Enhanced_ULA_cov(string name) @(posedge clock);
        option.per_instance = 1;
        option.name = name;
        
        cp_op: coverpoint ULA_Sel {
            bins ops[] = {[0:3]};
            illegal_bins invalid = {[4:$]};
            option.weight = 2;
        }
        
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
        
        cp_result: coverpoint ULA_Out {
            bins zero_result = {0};
            bins small_result = {[1:16]};
            bins medium_result = {[17:128]};
            bins large_result = {[129:254]};
            bins max_result = {255};
        }
        
        cx_op_inputs: cross cp_op, cp_input_a, cp_input_b;
        
        cp_special_cases: coverpoint {A, B, ULA_Sel} {
            bins overflow_case = (8'hFF, 8'h01, 4'b0000);
            bins max_sub = (8'hFF, 8'hFF, 4'b0001);
            bins max_mul = (8'hFF, 8'hFF, 4'b0010);
            bins div_by_one = (8'hFF, 8'h01, 4'b0011);
        }
    endgroup

endpackage