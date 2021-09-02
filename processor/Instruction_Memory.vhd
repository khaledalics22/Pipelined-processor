LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Instruction_Memory IS
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0); 
		dataout : OUT std_logic_vector(31 DOWNTO 0);
		resetAddr : OUT std_logic_vector(31 DOWNTO 0));

END ENTITY Instruction_Memory;

ARCHITECTURE Instruction_Memory_Arch OF Instruction_Memory IS

	TYPE ram_type IS ARRAY(0 TO 1048575) OF std_logic_vector(15 DOWNTO 0);

	SIGNAL ram : ram_type ;
	
BEGIN
		dataout(31 DOWNTO 16)  <= ram(to_integer(unsigned(address)));
		dataout(15 DOWNTO 0)  <= ram(to_integer(unsigned(address)) + 1);
		
		resetAddr(31 DOWNTO 16)  <= ram(0);
		resetAddr(15 DOWNTO 0)  <= ram(1);

END Instruction_Memory_Arch;
