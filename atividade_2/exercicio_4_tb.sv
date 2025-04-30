//Exercicio 4 tb

module sillyfunction_tb();
	logic a, b;
	logic y;
	
	sillyfunction dut(a, b, y);
	
	initial
	begin
		a = 0; b = 0; #10;
		if (y !== 1) $display("00 failed.");
		b = 1; #10;
		if (y !== 0) $display("01 failed.");
		a = 1; b = 0; #10;
		if (y !== 0) $display("10 failed.");
		b = 1; #10;
		if (y !== 1) $display("11 failed.");
	end
endmodule