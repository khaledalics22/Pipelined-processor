
library ieee; 
use ieee.std_logic_1164.all; 

entity register_file is 
port (clk, rst ,writeBack :IN std_logic; 
        writeData :IN std_logic_vector(31 downto 0); 
        readReg1, readReg2, writeReg :IN std_logic_vector(2 downto 0 );
        src, dst :OUT std_logic_vector(31 downto 0)); 
end register_file; 

architecture register_file_Arch of register_file is
component reg IS 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
END component;

SIGNAL enable0, enable1, enable2, enable3, enable4, enable5, enable6, enable7 : std_logic;
SIGNAL reg0_data, reg1_data, reg2_data, reg3_data, reg4_data, reg5_data, reg6_data, reg7_data : std_logic_vector(31 downto 0);
begin 

	R0 : reg PORT MAP (clk, rst, enable0, '0', writeData, reg0_data);
	R1 : reg PORT MAP (clk, rst, enable1, '0', writeData, reg1_data);
	R2 : reg PORT MAP (clk, rst, enable2, '0', writeData, reg2_data);
	R3 : reg PORT MAP (clk, rst, enable3, '0', writeData, reg3_data);
	R4 : reg PORT MAP (clk, rst, enable4, '0', writeData, reg4_data);
	R5 : reg PORT MAP (clk, rst, enable5, '0', writeData, reg5_data);
	R6 : reg PORT MAP (clk, rst, enable6, '0', writeData, reg6_data);
	R7 : reg PORT MAP (clk, rst, enable7, '0', writeData, reg7_data);
  	
	enable0 <= '1' when writeBack = '1' and writeReg = "000"	else '0';
	enable1 <= '1' when writeBack = '1' and writeReg = "001"	else '0';
	enable2 <= '1' when writeBack = '1' and writeReg = "010"	else '0';
	enable3 <= '1' when writeBack = '1' and writeReg = "011"	else '0';
	enable4 <= '1' when writeBack = '1' and writeReg = "100"	else '0';
	enable5 <= '1' when writeBack = '1' and writeReg = "101"	else '0';
	enable6 <= '1' when writeBack = '1' and writeReg = "110"	else '0';
	enable7 <= '1' when writeBack = '1' and writeReg = "111"	else '0';

	src <= reg0_data when readReg1 = "000"
	else reg1_data when readReg1 = "001"
	else reg2_data when readReg1 = "010"
	else reg3_data when readReg1 = "011"
	else reg4_data when readReg1 = "100"
	else reg5_data when readReg1 = "101"
	else reg6_data when readReg1 = "110"
	else reg7_data when readReg1 = "111" ;

	dst <= reg0_data when readReg2 = "000"
	else reg1_data when readReg2 = "001"
	else reg2_data when readReg2 = "010"
	else reg3_data when readReg2 = "011"
	else reg4_data when readReg2 = "100"
	else reg5_data when readReg2 = "101"
	else reg6_data when readReg2 = "110" 
	else reg7_data when readReg2 = "111" ;

end register_file_Arch;