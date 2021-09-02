LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
package MyPackage is
function to_string ( a: std_logic_vector) return string ;

end package MyPackage;


-- Package Body Section
package body MyPackage is

function to_string ( a: std_logic_vector) return string is
	variable b : string (1 to a'length) := (others => NUL);
	variable stri : integer := 1; 
	begin
 	   for i in a'range loop
	    b(stri) := std_logic'image(a((i)))(2);
	    stri := stri+1;
 	   end loop;
	return b;
end function;

end package body MyPackage;
