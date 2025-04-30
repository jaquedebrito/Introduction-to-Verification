
Exercicio 1


module sillyfunction_tb();
	logic a, b , c;
	logic y;

	// instanciar o “device under test dut”
	sillyfunction dut (a, b , c , y);
	

	// estimular o dispositivo (aplicar as entradas) uma de cada vez
	initial // podemos utilizar o bloco procedural initial
	begin
	a = 0; b = 0; c = 0; #10;
	c = 1; #10;
	b = 1; c = 0; #10;
	c = 1; #10;
	a = 1; b = 0; c = 0; #10;
	c = 1; #10;
	b = 1; c = 0; #10;
	c = 1; #10;
	end
endmodule