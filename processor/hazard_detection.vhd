LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

-- Only for load use hazard; others ==> Handled by forwarding
ENTITY hazard_detection IS
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

END ENTITY hazard_detection;

ARCHITECTURE hazard_detection_arch OF hazard_detection IS
	signal stall: std_logic;
BEGIN

	stall <= '1' when (ID_EX_MemRead = '1' and 
		((IF_ID_Rsrc xnor ID_EX_Rdst) = "111" or (IF_ID_RdstRead = '1' and (IF_ID_Rdst xnor ID_EX_Rdst) = "111")))
		else '0';

	PC_Disable <= stall;
	IF_ID_Disable <= stall;
	clear_IDEX_signals <= stall;
END hazard_detection_arch;