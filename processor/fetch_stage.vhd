LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY fetch_stage IS
	PORT(
		clk, reset, pc_disable: IN std_logic;
		instruction: OUT std_logic_vector(31 downto 0)
	);

END ENTITY fetch_stage;

ARCHITECTURE fetch_stage_Arch OF fetch_stage IS

component Instruction_Memory IS
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(19 DOWNTO 0); 
		dataout : OUT std_logic_vector(31 DOWNTO 0);
		resetAddr : OUT std_logic_vector(31 DOWNTO 0));
END component; 


component reg is 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
END component; 

component is_two_word is Port(
    opcode: in std_logic_vector(6 downto 0);
    is2word: out std_logic
);
end component;

signal pc_out: std_logic_vector(31 downto 0);
signal memory_out: std_logic_vector(31 downto 0);
signal memoryOfZero: std_logic_vector(31 downto 0);
signal isTwoWords: std_logic;

signal pc_inc: std_logic_vector(31 downto 0);
signal pc_in: std_logic_vector(31 downto 0);

signal pc_enable: std_logic;

BEGIN
	im : Instruction_Memory port map (clk, pc_out(19 downto 0), memory_out, memoryOfZero);
	istwo: is_two_word port map(memory_out(31 downto 25), isTwoWords);
	
	pc_enable <= not pc_disable;

	PC: reg GENERIC MAP (32) port map(clk, '0', pc_enable, '0', pc_in, pc_out);
	
	pc_inc <= std_logic_vector(to_unsigned(to_integer(unsigned(pc_out)) + 1, 32)) when isTwoWords = '0'
	else std_logic_vector(to_unsigned(to_integer(unsigned(pc_out)) + 2, 32));

	pc_in <= pc_inc when reset = '0'
	else memoryOfZero;
	
	instruction <= memory_out;

END fetch_stage_Arch;
