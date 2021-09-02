LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY execution_stage IS
	PORT(
		clk, reset: IN std_logic;
		ALU_Operation: IN std_logic_vector(4 downto 0);
		SrcAndImm_in, HasImmediate_in: IN std_logic;
		RsrcData_in, RdstData_in, Immediate_in: IN std_logic_vector(31 downto 0);
		MEMdst, WBdst: IN std_logic;
		MEMsrc, WBsrc: IN std_logic;
		MEMWBData, WBWBData: IN std_logic_vector(31 downto 0);

		ALU_Result: OUT std_logic_vector(31 downto 0);
		RdstData_out: OUT std_logic_vector(31 downto 0)
		
	);

END ENTITY execution_stage;

ARCHITECTURE execution_stage_Arch OF execution_stage IS

component ALU is
    	port (A, B : in std_logic_vector(31 downto 0);
		CCR_IN : in std_logic_vector(2 downto 0); 	-- (2) carry, (1) negative, (0) zero 
            	OPERATION: in std_logic_vector(4 downto 0); 
            	CCR_OUT: out std_logic_vector(2 downto 0);
		ALU_OUT: out std_logic_vector(31 downto 0));
END component; 


component reg is 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
END component; 

signal ALU_CCR_OUT: std_logic_vector(2 downto 0);
signal CCR_OUT: std_logic_vector(2 downto 0);

signal A, B: std_logic_vector(31 downto 0);

signal RdstData_Forwarded: std_logic_vector(31 downto 0);
signal RsrcData_Forwarded: std_logic_vector(31 downto 0);

BEGIN
	alu_com : ALU port map (A, B, CCR_OUT, ALU_Operation, ALU_CCR_OUT, ALU_Result);
	CCR: reg GENERIC MAP (3) port map(clk, reset, '1', '1', ALU_CCR_OUT, CCR_OUT);
	

	RdstData_Forwarded <= RdstData_in when MEMdst = '0' and WBdst = '0'
	else WBWBData when MEMdst = '0' and WBdst = '1'
	else MEMWBData when MEMdst = '1';

	RsrcData_Forwarded <= RsrcData_in when MEMsrc = '0' and WBsrc = '0'
	else WBWBData when MEMsrc = '0' and WBsrc = '1'
	else MEMWBData when MEMsrc = '1';


	A <= RdstData_Forwarded when SrcAndImm_in = '0'
	else RsrcData_Forwarded;

	B <= RsrcData_Forwarded when HasImmediate_in = '0'
	else Immediate_in;

	RdstData_out <= RdstData_Forwarded;

END execution_stage_Arch;
