
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY decode_stage IS
	PORT(
		clk, reset, writeBackNow, clearSignals: IN std_logic;
		instruction, in_port: IN std_logic_vector(31 downto 0);
		writeReg : IN std_logic_vector(2 downto 0);
		writeData : IN std_logic_vector (31 downto 0);
		RdstRead, hasRsrc, Push, Pop, outPortEnable, writeBackNext, hasImm, SrcAndImm, memWrite,
		memRead, stdEnable: OUT std_logic;
		ALU_operation : OUT std_logic_vector (4 downto 0);
		imm, src, dst : OUT std_logic_vector (31 downto 0);
		SrcRead, DstRead : OUT std_logic_vector (2 downto 0)
	);

END ENTITY decode_stage;

ARCHITECTURE decode_stage_Arch OF decode_stage IS


component control_unit is 
port (	opcode: In std_logic_vector(6 downto 0);
	signals: out std_logic_vector(17 downto 0)	-- same order as in doc
    );
end component;


component register_file is 
port (clk, rst ,writeBack :IN std_logic; 
        writeData :IN std_logic_vector(31 downto 0); 
        readReg1, readReg2, writeReg :IN std_logic_vector(2 downto 0 );
        src, dst :OUT std_logic_vector(31 downto 0)); 
end component; 

component sign_extend is Port (
    is_shift: in std_logic; 
    shift_value: in std_logic_vector(4 downto 0); 
    immediate : in std_logic_vector(15 downto 0); 
    extended: out std_logic_vector(31 downto 0) 
);
end component; 

	SIGNAL srcDataReg : std_logic_vector (31 downto 0);
	SIGNAL signals : std_logic_vector (17 downto 0);

BEGIN

	cn : control_unit PORT MAP (instruction(31 downto 25),signals);

	RdstRead <= signals(7) when clearSignals = '0' else '0' ;
	hasRsrc <= signals(8) when clearSignals = '0' else '0' ;
	Push <= signals(3) when clearSignals = '0' else '0' ;
	Pop <= signals(2) when clearSignals = '0' else '0' ;
	outPortEnable <= signals(1) when clearSignals = '0' else '0' ;
	writeBackNext <= signals(12) when clearSignals = '0' else '0';
	hasImm <= signals(11) when clearSignals = '0' else '0';
	SrcAndImm <= signals(10) when clearSignals = '0' else '0';
	memWrite <= signals(4) when clearSignals = '0' else '0';
	memRead <= signals(5) when clearSignals = '0' else '0';
 	stdEnable <= signals(9) when clearSignals = '0' else '0';
	ALU_operation <= signals(17 downto 13) when clearSignals = '0' else (others => '0');

	regFile : register_file PORT MAP (clk, reset, writeBackNow, writeData, instruction(24 downto 22),
 	instruction(21 downto 19), writeReg, srcDataReg, dst);
	src <= srcDataReg when signals(0) = '0'		else in_port ;
	
	SE : sign_extend PORT MAP (signals(6),instruction(21 downto 17) ,instruction(18 downto 3) , imm);

	SrcRead <= instruction(24 downto 22);
	DstRead <= instruction(21 downto 19) when signals(6) = '0'
	else instruction(24 downto 22);

	

END decode_stage_Arch;