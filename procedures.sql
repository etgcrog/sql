DROP PROCEDURE fatorial;
DELIMITER $
		CREATE PROCEDURE fatorial(in x int)
			begin 
				declare resultado int default 1;
                declare i int default 1;
                
                while i <= x do
					set resultado = resultado * i;
					set i = i + 1;
				select x as valor, resultado as fatorial;
				end while;
			end;
            
call fatorial(5);