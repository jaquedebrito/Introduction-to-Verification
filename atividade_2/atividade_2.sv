// Aluna: JAQUELINE FERREIRA DE BRITO

//Atividade_1

module fork_join_example;
	initial begin
		fork
			begin // process A
				$display("Process A started at time = %0t", $time);
				#10;
				$display("Process A completed at time = %0t", $time);
			end
			begin // process B
				$display("Process B started at time = %0t", $time);
				#15;
				$display("Process B completed at time = %0t", $time);
			end
			begin // process C
				$display("Process C started at time = %0t", $time);
				#20;
				$display("Process C completed at time = %0t", $time);
			end
		join
		$display("fork-join completed at time = %0t", $time);
	end
endmodule

//a)
//Saída no EDA

//xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
//xcelium> run
//Process A started at time = 0
//Process B started at time = 0
//Process C started at time = 0
//Process A completed at time = 10
//Process B completed at time = 15
//Process C completed at time = 20
//fork-join completed at time = 20
//xmsim: *W,RNQUIE: Simulation is complete.
//xcelium> exit
//TOOL:	xrun	23.09-s001: Exiting on Jan 09, 2025 at 07:36:54 EST  (total: 00:00:02)
//Done

//b) A funcionalidade do código usando fork-join é que aguarda até que todos os processos dentro do bloco
//   fork-join sejam concluídos antes de continuar, e sempre a execução com menor tempo estará sobre
//	 as de maiores tempo. Na atividade-1 os displays nomeando cada processo tem tempo zero, logo elas serão apresentadas
//	 primeiro em relação as que tem tempo.

//Atividade_2

module fork_join_any_example;
	initial begin
		fork
			begin // process A
				$display("Process A started at time = %0t", $time);
				#10;
				$display("Process A completed at time = %0t", $time);
			end
			begin // process B
				$display("Process B started at time = %0t", $time);
				#15;
				$display("Process B completed at time = %0t", $time);
			end
			begin // process C
				$display("Process C started at time = %0t", $time);
				#20;
				$display("Process C completed at time = %0t", $time);
			end
		join_any
	$display("fork-join_any completed at time = %0t", $time);
	end
endmodule

// a) Resultado da execução 
// xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
// xcelium> run
// Process A started at time = 0
// Process B started at time = 0
// Process C started at time = 0
// Process A completed at time = 10
// fork-join_any completed at time = 10
// Process B completed at time = 15
// Process C completed at time = 20
// xmsim: *W,RNQUIE: Simulation is complete.
// xcelium> exit
// TOOL:	xrun	23.09-s001: Exiting on Jan 09, 2025 at 07:46:35 EST  (total: 00:00:01)
// Done

// b) A funcionalidade do código usando fork join_any aguarda até que pelo menos um processo dentro
//    do bloco fork join_any seja concluído antes de continuar, e sempre a execução com menor tempo estará sobre
//	  as de maiores tempo, por isso os displays com tempo 0 ocorrem de forma instantanea e o pprimeirp processo 
//    com menor tempo é 10 ele conclui o processo de fork join_any e depois continua.

//Atividade_3

module fork_join_none_example;
	initial begin
		fork
			begin // process A
				$display("Process A started at time = %0t", $time);
				#10;
				$display("Process A completed at time = %0t", $time);
			end
			begin // process B
				$display("Process B started at time = %0t", $time);
				#15;
				$display("Process B completed at time = %0t", $time);
			end
			begin // process C
				$display("Process C started at time = %0t", $time);
				#20;
				$display("Process C completed at time = %0t", $time);
			end
		join_none
		$display("fork-join_none completed at time = %0t", $time);
	end
endmodule

// a) Resultado da execução 

// xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
// xcelium> run
// fork-join_none completed at time = 0
// Process A started at time = 0
// Process B started at time = 0
// Process C started at time = 0
// Process A completed at time = 10
// Process B completed at time = 15
// Process C completed at time = 20
// xmsim: *W,RNQUIE: Simulation is complete.
// xcelium> exit
// TOOL:	xrun	23.09-s001: Exiting on Jan 09, 2025 at 07:58:13 EST  (total: 00:00:02)
// Done// 

// b) Diferente dos outros o fork join_none não espera nenhum dos processo dentro do bloco
//    fork join_none seja concluído ou mesmo iniciado; ele sai imediatamente. Mas a preferencia
//    de execução pelo processo de menor duração continua, em seguida os processos continuarão nessa
//    precedência.

// Atividade-4

module disable_fork_example;
	initial begin
		fork
			begin // process A
				$display("Process A started at time = %0t", $time);
				#10;
				$display("Process A completed at time = %0t", $time);
			end
			begin // process B
				$display("Process B started at time = %0t", $time);
				#15;
				$display("Process B completed at time = %0t", $time);
			end
			begin // process C
				$display("Process C started at time = %0t", $time);
				#20;
				$display("Process C completed at time = %0t", $time);
			end
		join_any
			disable fork;
			$display("fork-join_any completed at time = %0t", $time);
	end
endmodule

// a) Resultado da execução 

// TOOL:	xrun	23.09-s001: Started on Jan 09, 2025 at 08:03:25 
// xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
// xcelium> run
// Process A started at time = 0
// Process B started at time = 0
// Process C started at time = 0
// Process A completed at time = 10
// fork-join_any completed at time = 10
// xmsim: *W,RNQUIE: Simulation is complete.
// xcelium> exit
// TOOL:	xrun	23.09-s001: Exiting on Jan 09, 2025 at 08:03:26 EST  (total: 00:00:01)
// Done

// b)   Nessa atividade o fork join_any executa qualquer processo e continua sem precisar que os outros processos ocorram,
//	    como o disable fork permite que todos os threads ativos que foram iniciados a partir de bloco fork join_any possam
//      ser eliminados ele finaliza a tarefa, pois não tem mais processo a ser executado.


// Atividade_5

module wait_fork_example;
	initial begin
		fork
			begin // process A
				$display("Process A started at time = %0t", $time);
				#10;
				$display("Process A completed at time = %0t", $time);
			end
			begin // process B
				$display("Process B started at time = %0t", $time);
				#15;
				$display("Process B completed at time = %0t", $time);
			end
			begin // process C
				$display("Process C started at time = %0t", $time);
				#20;
				$display("Process C completed at time = %0t", $time);
			end
		join_any
		wait fork;
		$display("fork-join_any completed at time = %0t", $time);
	end
endmodule

// a) Resultado da execução 

// xcelium> source /xcelium23.09/tools/xcelium/files/xmsimrc
// xcelium> run
// Process A started at time = 0
// Process B started at time = 0
// Process C started at time = 0
// Process A completed at time = 10
// Process B completed at time = 15
// Process C completed at time = 20
// fork-join_any completed at time = 20
// xmsim: *W,RNQUIE: Simulation is complete.
// xcelium> exit
// TOOL:	xrun	23.09-s001: Exiting on Jan 09, 2025 at 08:12:12 EST  (total: 00:00:02)
// Done


// b) Nessa atividade ao adicionar o wait-fork ao final do fork join_any, o processo principal espere até que todos
//    os processos “forked” acabem, então a função do fork join_any mesmo que precise apenas de 1 processo para continuar
//    com wait-fork terá que esperar que todos os processos termine para assim continuar.

