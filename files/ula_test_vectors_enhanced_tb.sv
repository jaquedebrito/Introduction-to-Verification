`include "ula_tb_pkg.sv"
import ula_tb_pkg::*;

module ULA_test_vectors_enhanced_tb;
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
    
    // Arquivo de vetores
    integer file;
    string line;
    
    // Instanciação do DUT
    ULA dut (.*);
    
    // Geração de clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end
    
    // Vector processing task
    task automatic process_vector(string vector_line);
        logic [3:0] op;
        logic [7:0] a, b, expected_result;
        logic expected_carry;
        string op_comment;
        time start_time;
        logic operation_success;
        
        if ($sscanf(vector_line, "%h %h %h %h %b // %s", 
                 op, a, b, expected_result, expected_carry, op_comment) != 6) begin
            errors.vector_format_errors++;
            return;
        end
        
        start_time = $time;
        
        @(posedge clock);
        A = a;
        B = b;
        ULA_Sel = op;
        
        @(posedge clock);
        #1;
        
        // Result checking
        if (ULA_Out !== expected_result) begin
            errors.result_mismatch++;
            $error("Vector mismatch: %s", vector_line);
            $display("  Received: %h", ULA_Out);
        end
        
        operation_success = (ULA_Out === expected_result);
        state_monitor.update_statistics($time - start_time, 
                                     operation_success, 
                                     op_t'(op));
                                     
        enhanced_timing_check(start_time, state_monitor.num_tests, op_t'(op));
    endtask

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

    // Main test process
    initial begin
        // Initialize
        state_monitor = new();
        cov = new("ULA_Vector_Coverage");
        errors = '{default: 0};
        
        // Print header
        $display("//----------------------------------------");
        $display("// Enhanced ULA Test Vectors Testbench");
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

        // Process test vectors
        file = $fopen("ULA_vectors.txt", "r");
        if (file == 0) begin
            $fatal(1, "Could not open vector file");
        end

        while ($fgets(line, file)) begin
            // Skip comments and empty lines
            line = trim(line);
            if (line == "" || line.substr(0, 2) == "//")
                