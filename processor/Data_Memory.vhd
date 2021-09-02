LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Data_Memory IS
	PORT(
		clk : IN std_logic;
		writeEnable  : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0); 
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));

END ENTITY Data_Memory;

ARCHITECTURE Data_Memory_Arch OF Data_Memory IS

	TYPE ram_type IS ARRAY(0 TO 1048575) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	SIGNAL temp_addr : std_logic_vector(19 downto 0) := "11111111111111111110";	
	BEGIN
		temp_addr <= address when to_integer(unsigned(address)) < 1048575  else  "11111111111111111110" ;

		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					IF writeEnable = '1' THEN
						ram(to_integer(unsigned(address))) <= datain(31 downto 16);
						ram(to_integer(unsigned(address))+1) <= datain(15 downto 0);
					END IF;
				END IF;
		END PROCESS;
		
		dataout(31 DOWNTO 16)  <= ram(to_integer(unsigned(temp_addr)));
		dataout(15 DOWNTO 0)  <= ram(to_integer(unsigned(temp_addr)) + 1);
		
END Data_Memory_Arch;
