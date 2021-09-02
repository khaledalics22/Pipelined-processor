LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity processor_tb is 
end entity processor_tb; 

architecture processor_tb_arch of processor_tb is 
component processor is 
	PORT(
		clk, reset: IN std_logic
	);
end component;

    signal clk: std_logic;
    signal reset: std_logic;

begin

   	pr: processor port map (clk, reset);
        

end processor_tb_arch;
