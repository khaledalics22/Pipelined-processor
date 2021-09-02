
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY forwarding_unit IS
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

END ENTITY forwarding_unit;

ARCHITECTURE forwarding_unit_arch OF forwarding_unit IS
BEGIN
	MEMdst <= '1' when (ID_EX_RdstRead = '1' AND EX_MEM_WB = '1' AND (ID_EX_Rdst xnor EX_MEM_DstReg) = "111")  
		else '0';
	
	WBdst <= '1' when (ID_EX_RdstRead = '1' and MEM_WB_WB = '1' and (ID_EX_Rdst xnor MEM_WB_DstReg) = "111")
			else '0';

	MEMsrc <= '1' when (ID_EX_HasRsrc = '1' and EX_MEM_WB = '1' and (ID_EX_Rsrc xnor EX_MEM_DstReg) = "111")
		else '0';

	WBsrc <= '1' when (ID_EX_HasRsrc = '1' and MEM_WB_WB = '1' and (ID_EX_Rsrc xnor MEM_WB_DstReg) = "111")
		else '0';
END forwarding_unit_arch;
