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
    
    function new();
        last_result = 8'h00;
        last_op = 4'h0;
        consecutive_errors = 0;
        last_operation_time = 0;
        max_operation_time = 0;
        min_operation_time = '1;
        avg_operation_time = 0;
        total_operations = 0;
    endfunction
    
    function void update_statistics(
        input time operation_time,
        input logic operation_success
    );
        total_operations++;
        
        if (operation_time > max_operation_time)
            max_operation_time = operation_time;
        if (operation_time < min_operation_time)
            min_operation_time = operation_time;
            
        avg_operation_time = (avg_operation_time * (total_operations-1) + 
                            operation_time) / total_operations;
                            
        if (!operation_success)
            consecutive_errors++;
        else
            consecutive_errors = 0;
            
        if (consecutive_errors >= 3)
            $fatal(1, "Three consecutive operations failed!");
    endfunction
    
    function void print_statistics();
        $display("\n=== ULA Operation Statistics ===");
        $display("Total Operations: %0d", total_operations);
        $display("Maximum Operation Time: %0t", max_operation_time);
        $display("Minimum Operation Time: %0t", min_operation_time);
        $display("Average Operation Time: %0.2f", avg_operation_time);
        $display("Consecutive Errors: %0d", consecutive_errors);
    endfunction
endclass