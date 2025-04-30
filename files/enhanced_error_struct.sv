typedef struct {
    // Existing error types
    int invalid_ops;
    int timing_violations;
    int overflow_errors;
    int a_less_than_b;
    int div_by_zero;
    int result_mismatch;
    int carry_mismatch;
    int unknown_values;
    int vector_format_errors;
    
    // New error types
    int setup_hold_violations;
    int reset_timing_errors;
    int clock_glitch_errors;
    int invalid_state_transitions;
    int boundary_condition_errors;
    int performance_violations;
    int data_stability_errors;
    int protocol_violations;
} enhanced_error_stats_t;