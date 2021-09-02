LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity processor is 
	PORT(
		clk, reset: IN std_logic;
		in_port: IN std_logic_vector(31 downto 0);
		out_port: OUT std_logic_vector(31 downto 0)
	);
end entity processor; 

architecture processor_arch of processor is 

component fetch_stage IS
	PORT(
		clk, reset, pc_disable: IN std_logic;
		instruction: OUT std_logic_vector(31 downto 0)
	);
end component;
 
component reg is 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
END component; 


component decode_stage IS
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
end component;

component execution_stage IS
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
end component;

component memory_stage IS
	PORT(
		clk, reset, pop, push, Memory_Write, Memory_Read, STD_Enable: IN std_logic;
		Rsrc_Data: in std_logic_vector(31 DOWNTO 0);
		Rdst_Data: in std_logic_vector(31 DOWNTO 0);
		ALU_Result: in std_logic_vector(31 DOWNTO 0);
		dataout : out std_logic_vector(31 DOWNTO 0)
	);
end component;

component writeback_stage is Port(
    memRead : in std_logic; 
    mem_out, ALU_result : in std_logic_vector(31 downto 0 ); 
    WB_data: out std_logic_vector(31 downto 0)  
);
end component; 

component forwarding_unit IS
	PORT(
		ID_EX_RdstRead : in std_logic;
		ID_EX_HasRsrc : in std_logic;
		ID_EX_SrcImm : in std_logic;
		ID_EX_Rdst : in std_logic_vector(2 downto 0);
		ID_EX_Rsrc : in std_logic_vector(2 downto 0);

		EX_MEM_WB : in std_logic;
		EX_MEM_DstReg : in std_logic_vector(2 downto 0);

		MEM_WB_WB : in std_logic;
		MEM_WB_DstReg : in std_logic_vector(2 downto 0);

		WBdst : out std_logic;
		MEMdst : out std_logic;
		WBsrc : out std_logic;
		MEMsrc : out std_logic
	);
END component;

component hazard_detection IS
	PORT(
		IF_ID_RdstRead : in std_logic;
		IF_ID_Rsrc : in std_logic_vector(2 downto 0);
		IF_ID_Rdst : in std_logic_vector(2 downto 0);

		ID_EX_MemRead: in std_logic;
		ID_EX_Rdst : in std_logic_vector(2 downto 0);

		PC_Disable : out std_logic;
		IF_ID_Disable : out std_logic;
		clear_IDEX_signals : out std_logic
	);

END component;

-- Fetch Stage
signal fetch_instruction_out: std_logic_vector(31 downto 0);

signal IFID_INPUT: std_logic_vector(63 downto 0);
signal IFID_OUT: std_logic_vector(63 downto 0);
Signal IFID_enable : std_logic ;


-- Decode Stage
signal IFID_RdstRead, IFID_hasRsrc, IFID_Push, IFID_Pop, IFID_outPortEnable, 
	IFID_writeBackNext, IFID_hasImm, IFID_SrcAndImm, IFID_memWrite, IFID_memRead, IFID_stdEnable : std_logic;

signal IFID_ALU_operation : std_logic_vector (4 downto 0);
signal IFID_imm, IFID_src, IFID_dst : std_logic_vector (31 downto 0);
signal IFID_SrcNum, IFID_DstNum :std_logic_vector (2 downto 0);

signal IDEX_INPUT: std_logic_vector(117 downto 0);
signal IDEX_OUT: std_logic_vector(117 downto 0);

constant IFID_RdstRead_IDX 					: integer := 0;
constant IFID_hasRsrc_IDX 					: integer := 1;
constant IFID_Push_IDX 						: integer := 2;
constant IFID_Pop_IDX 						: integer := 3;
constant IFID_outPortEnable_IDX 			: integer := 4;
constant IFID_writeBackNext_IDX 			: integer := 5;
constant IFID_hasImm_IDX 					: integer := 6;
constant IFID_SrcAndImm_IDX 				: integer := 7;
constant IFID_memWrite_IDX 					: integer := 8;
constant IFID_memRead_IDX 					: integer := 9;
constant IFID_stdEnable_IDX 				: integer := 10;
constant IFID_ALU_operation_ST_IDX 			: integer := 11; 
constant IFID_ALU_operation_END_IDX 		: integer := 15;
constant IFID_imm_ST_IDX 					: integer := 16; 
constant IFID_imm_END_IDX 					: integer := 47;
constant IFID_src_ST_IDX 					: integer := 48; 
constant IFID_src_END_IDX 					: integer := 79;
constant IFID_dst_ST_IDX 					: integer := 80; 
constant IFID_dst_END_IDX 					: integer := 111;
constant IFID_SrcNum_ST_IDX 				: integer := 112; 
constant IFID_SrcNum_END_IDX 				: integer := 114;
constant IFID_DstNum_ST_IDX 				: integer := 115; 
constant IFID_DstNum_END_IDX 				: integer := 117;

signal IDEX_ALU_RESULT: std_logic_vector(31 downto 0);
signal IDEX_RdstData_out: std_logic_vector(31 downto 0);

signal EXMEM_INPUT: std_logic_vector(105 downto 0);
signal EXMEM_OUT: std_logic_vector(105 downto 0);

constant EXMEM_Push_IDX 					: integer := 0;
constant EXMEM_outPortEnable_IDX 			: integer := 1;
constant EXMEM_Pop_IDX 						: integer := 2;
constant EXMEM_writeBackNext_IDX 			: integer := 3;
constant EXMEM_memWrite_IDX 				: integer := 4;
constant EXMEM_memRead_IDX 					: integer := 5;
constant EXMEM_stdEnable_IDX 				: integer := 6;
constant EXMEM_Src_ST_IDX 					: integer := 7; 
constant EXMEM_Src_END_IDX 					: integer := 38;
constant EXMEM_ALU_Result_ST_IDX 			: integer := 39; 
constant EXMEM_ALU_Result_END_IDX 			: integer := 70;
constant EXMEM_Dst_ST_IDX 					: integer := 71; 
constant EXMEM_Dst_END_IDX 					: integer := 102;
constant EXMEM_DstNum_ST_IDX 				: integer := 103; 
constant EXMEM_DstNum_END_IDX 				: integer := 105;

-- memory


signal EXMEM_MEM_OUT: std_logic_vector(31 downto 0);

signal MEMWB_INPUT: std_logic_vector(102 downto 0);
signal MEMWB_OUT: std_logic_vector(102 downto 0);

constant MEMWB_outPortEnable_IDX 					: integer := 0;
constant MEMWB_memRead_IDX 							: integer := 1;
constant MEMWB_writeBackNext_IDX 					: integer := 2;
constant MEMWB_MEM_OUT_ST_IDX 						: integer := 36;
constant MEMWB_MEM_OUT_END_IDX 						: integer := 67;
constant MEMWB_ALU_Result_ST_IDX 					: integer := 68; 
constant MEMWB_ALU_Result_END_IDX 					: integer := 99;
constant MEMWB_DstNum_ST_IDX 						: integer := 100; 
constant MEMWB_DstNum_END_IDX 						: integer := 102;

-- write back 
signal WRITE_BACK_DATA: std_logic_vector(31 downto 0); 

-- forwarding unit

SIGNAL FORWARDING_WBdst, FORWARDING_MEMdst, FORWARDING_WBsrc, FORWARDING_MEMsrc : std_logic;

-- data hazrd 
SIGNAL PC_disable, clear_IDEX_Signals, IFID_disable : std_logic ;
begin
	-- fetch
	fs: fetch_stage PORT MAP(clk, reset, PC_disable, fetch_instruction_out);
	IFID: reg GENERIC MAP (64) port map(clk, reset, IFID_enable, '1', IFID_INPUT, IFID_OUT);
	
	IFID_enable <= not IFID_disable;
	IFID_INPUT(63 downto 32) <= fetch_instruction_out;
	IFID_INPUT(31 downto 0) <= in_port;
	
	-- decode
	ds: decode_stage PORT MAP(clk, reset, MEMWB_OUT(MEMWB_writeBackNext_IDX), clear_IDEX_Signals, IFID_OUT(63 downto 32), IFID_OUT(31 downto 0),
	MEMWB_OUT(MEMWB_DstNum_END_IDX downto MEMWB_DstNum_ST_IDX), WRITE_BACK_DATA, IFID_RdstRead, 
	IFID_hasRsrc, IFID_Push, IFID_Pop, IFID_outPortEnable, IFID_writeBackNext, IFID_hasImm, 
	IFID_SrcAndImm, IFID_memWrite, IFID_memRead, IFID_stdEnable, IFID_ALU_operation, IFID_imm,
	IFID_src, IFID_dst, IFID_SrcNum, IFID_DstNum);

	IDEX: reg GENERIC MAP (118) port map(clk, reset, '1', '1', IDEX_INPUT, IDEX_OUT);



	IDEX_INPUT(IFID_RdstRead_IDX) <= IFID_RdstRead;		
	IDEX_INPUT(IFID_hasRsrc_IDX) <= IFID_hasRsrc;			
	IDEX_INPUT(IFID_Push_IDX) <= IFID_Push;			
	IDEX_INPUT(IFID_Pop_IDX) <= IFID_Pop;				
	IDEX_INPUT(IFID_outPortEnable_IDX) <= IFID_outPortEnable; 	
	IDEX_INPUT(IFID_writeBackNext_IDX) <= IFID_writeBackNext;	
	IDEX_INPUT(IFID_hasImm_IDX) <= IFID_hasImm;	
	IDEX_INPUT(IFID_SrcAndImm_IDX) <= IFID_SrcAndImm; 		
	IDEX_INPUT(IFID_memWrite_IDX) <= IFID_memWrite;			
	IDEX_INPUT(IFID_memRead_IDX) <= IFID_memRead;			
	IDEX_INPUT(IFID_stdEnable_IDX) <= IFID_stdEnable; 		
	IDEX_INPUT(IFID_ALU_operation_END_IDX downto IFID_ALU_operation_ST_IDX) <= IFID_ALU_operation; 	
	IDEX_INPUT(IFID_imm_END_IDX downto IFID_imm_ST_IDX) <= IFID_imm;			
	IDEX_INPUT(IFID_src_END_IDX downto IFID_src_ST_IDX) <= IFID_src; 			
	IDEX_INPUT(IFID_dst_END_IDX downto IFID_dst_ST_IDX) <= IFID_dst;			
	IDEX_INPUT(IFID_SrcNum_END_IDX downto IFID_SrcNum_ST_IDX) <= IFID_SrcNum; 		
	IDEX_INPUT(IFID_DstNum_END_IDX downto IFID_DstNum_ST_IDX) <= IFID_DstNum;


	-- execute
	es: execution_stage PORT MAP(clk, reset, IDEX_OUT(IFID_ALU_operation_END_IDX downto IFID_ALU_operation_ST_IDX),
	IDEX_OUT(IFID_SrcAndImm_IDX), IDEX_OUT(IFID_hasImm_IDX), IDEX_OUT(IFID_src_END_IDX downto IFID_src_ST_IDX),
	IDEX_OUT(IFID_dst_END_IDX downto IFID_dst_ST_IDX), IDEX_OUT(IFID_imm_END_IDX downto IFID_imm_ST_IDX),
	FORWARDING_MEMdst, FORWARDING_WBdst, FORWARDING_MEMsrc, FORWARDING_WBsrc,
	EXMEM_OUT(EXMEM_ALU_Result_END_IDX downto EXMEM_ALU_Result_ST_IDX), WRITE_BACK_DATA,
	IDEX_ALU_RESULT, IDEX_RdstData_out);


	EXMEM: reg GENERIC MAP (106) port map(clk, reset, '1', '1', EXMEM_INPUT, EXMEM_OUT);

	EXMEM_INPUT(EXMEM_Push_IDX) <= IDEX_OUT(IFID_Push_IDX);
	EXMEM_INPUT(EXMEM_outPortEnable_IDX) <= IDEX_OUT(IFID_outPortEnable_IDX);
	EXMEM_INPUT(EXMEM_Pop_IDX) <= IDEX_OUT(IFID_Pop_IDX);
	EXMEM_INPUT(EXMEM_writeBackNext_IDX) <= IDEX_OUT(IFID_writeBackNext_IDX);
	EXMEM_INPUT(EXMEM_memWrite_IDX) <= IDEX_OUT(IFID_memWrite_IDX);
	EXMEM_INPUT(EXMEM_memRead_IDX) <= IDEX_OUT(IFID_memRead_IDX);
	EXMEM_INPUT(EXMEM_stdEnable_IDX) <= IDEX_OUT(IFID_stdEnable_IDX);
	EXMEM_INPUT(EXMEM_Src_END_IDX downto EXMEM_Src_ST_IDX) <= IDEX_OUT(IFID_src_END_IDX downto IFID_src_ST_IDX);
	EXMEM_INPUT(EXMEM_ALU_Result_END_IDX downto EXMEM_ALU_Result_ST_IDX) <=  IDEX_ALU_RESULT;
	EXMEM_INPUT(EXMEM_Dst_END_IDX downto EXMEM_Dst_ST_IDX) <= IDEX_RdstData_out;
	EXMEM_INPUT(EXMEM_DstNum_END_IDX downto EXMEM_DstNum_ST_IDX) <= IDEX_OUT(IFID_DstNum_END_IDX downto IFID_DstNum_ST_IDX);

	-- memory
	ms: memory_stage PORT MAP(clk, reset, EXMEM_OUT(EXMEM_Pop_IDX), EXMEM_OUT(EXMEM_Push_IDX), EXMEM_OUT(EXMEM_memWrite_IDX),
	EXMEM_OUT(EXMEM_memRead_IDX), EXMEM_OUT(EXMEM_stdEnable_IDX), EXMEM_OUT(EXMEM_Src_END_IDX downto EXMEM_Src_ST_IDX),
	EXMEM_OUT(EXMEM_Dst_END_IDX downto EXMEM_Dst_ST_IDX), EXMEM_OUT(EXMEM_ALU_Result_END_IDX downto EXMEM_ALU_Result_ST_IDX), EXMEM_MEM_OUT);

	
	
	MEMWB: reg GENERIC MAP (103) port map(clk, reset, '1', '1', MEMWB_INPUT, MEMWB_OUT);

	MEMWB_INPUT(MEMWB_outPortEnable_IDX) <= EXMEM_OUT(EXMEM_outPortEnable_IDX);
	MEMWB_INPUT(MEMWB_memRead_IDX) <= EXMEM_OUT(EXMEM_memRead_IDX);
	MEMWB_INPUT(MEMWB_writeBackNext_IDX) <= EXMEM_OUT(EXMEM_writeBackNext_IDX);
	MEMWB_INPUT(MEMWB_MEM_OUT_END_IDX downto MEMWB_MEM_OUT_ST_IDX) <= EXMEM_MEM_OUT;
	MEMWB_INPUT(MEMWB_ALU_Result_END_IDX downto MEMWB_ALU_Result_ST_IDX) <= EXMEM_OUT(EXMEM_ALU_Result_END_IDX downto EXMEM_ALU_Result_ST_IDX);
	MEMWB_INPUT(MEMWB_DstNum_END_IDX downto MEMWB_DstNum_ST_IDX) <= EXMEM_OUT(EXMEM_DstNum_END_IDX downto EXMEM_DstNum_ST_IDX);

	-- write back 
	wb: writeback_stage port map (MEMWB_OUT(MEMWB_memRead_IDX),
	MEMWB_OUT(MEMWB_MEM_OUT_END_IDX downto MEMWB_MEM_OUT_ST_IDX),
	MEMWB_OUT(MEMWB_ALU_Result_END_IDX downto MEMWB_ALU_Result_ST_IDX), WRITE_BACK_DATA);
	

	-- data forwarding
	df : forwarding_unit PORT MAP (IDEX_OUT(IFID_RdstRead_IDX), IDEX_OUT(IFID_hasRsrc_IDX), IDEX_OUT(IFID_SrcAndImm_IDX),
		IDEX_OUT(IFID_DstNum_END_IDX downto IFID_DstNum_ST_IDX), IDEX_OUT(IFID_SrcNum_END_IDX downto IFID_SrcNum_ST_IDX),
		EXMEM_OUT(EXMEM_writeBackNext_IDX), EXMEM_OUT(EXMEM_DstNum_END_IDX downto EXMEM_DstNum_ST_IDX),
		 MEMWB_OUT(MEMWB_writeBackNext_IDX), MEMWB_OUT(MEMWB_DstNum_END_IDX downto MEMWB_DstNum_ST_IDX),
		 FORWARDING_WBdst, FORWARDING_MEMdst, FORWARDING_WBsrc, FORWARDING_MEMsrc);

	-- hazard detection 		
	hd : hazard_detection PORT MAP (IFID_RdstRead, IFID_SrcNum, IFID_DstNum, IDEX_OUT(IFID_memRead_IDX),
		IDEX_OUT(IFID_DstNum_END_IDX downto IFID_DstNum_ST_IDX), PC_disable, IFID_disable, clear_IDEX_Signals );

	
	outport: reg GENERIC MAP (32) port map(clk, reset, MEMWB_OUT(MEMWB_outPortEnable_IDX),
	 	'0', WRITE_BACK_DATA, out_port);




end processor_arch;
