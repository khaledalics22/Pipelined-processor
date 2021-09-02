
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY forwarding_unit_tb IS
END forwarding_unit_tb;

ARCHITECTURE forwarding_unit_tb_arch OF forwarding_unit_tb IS
	
	COMPONENT forwarding_unit is 
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

		WBdstA : out std_logic;
		MEMdstA : out std_logic;
		WBdstB : out std_logic;
		MEMdstB : out std_logic
	);
	END COMPONENT;
	
	signal ID_EX_RdstRead : std_logic;
	signal ID_EX_HasRsrc : std_logic;
	signal ID_EX_SrcImm : std_logic;
	signal ID_EX_Rdst : std_logic_vector(2 downto 0);
	signal ID_EX_Rsrc : std_logic_vector(2 downto 0);

	signal EX_MEM_WB : std_logic;
	signal EX_MEM_DstReg : std_logic_vector(2 downto 0);

	signal MEM_WB_WB : std_logic;
	signal MEM_WB_DstReg : std_logic_vector(2 downto 0);

	signal WBdstA : std_logic;
	signal MEMdstA : std_logic;
	signal WBdstB : std_logic;
	signal MEMdstB : std_logic;

	BEGIN
		PROCESS
			BEGIN
				ID_EX_RdstRead<='0';
				ID_EX_HasRsrc<='0';
				ID_EX_SrcImm<='1';
				ID_EX_Rdst<="000";
				ID_EX_Rsrc<="001";
			
				EX_MEM_WB<='0';
				EX_MEM_DstReg<="101";
			
				MEM_WB_WB<='1';
				MEM_WB_DstReg<="001";
				WAIT FOR 10 ns;
		END PROCESS;

		fu: forwarding_unit PORT MAP (
			ID_EX_RdstRead=>ID_EX_RdstRead,
			ID_EX_HasRsrc=>ID_EX_HasRsrc,
			ID_EX_SrcImm=>ID_EX_SrcImm,
			ID_EX_Rdst=>ID_EX_Rdst,
			ID_EX_Rsrc=>ID_EX_Rsrc,
		
			EX_MEM_WB=>EX_MEM_WB,
			EX_MEM_DstReg=>EX_MEM_DstReg,
		
			MEM_WB_WB=>MEM_WB_WB,
			MEM_WB_DstReg=>MEM_WB_DstReg,
		
			WBdstA=>WBdstA,
			MEMdstA=>MEMdstA,
			WBdstB=>WBdstB,
			MEMdstB=>MEMdstB
		);
		
END forwarding_unit_tb_arch;
