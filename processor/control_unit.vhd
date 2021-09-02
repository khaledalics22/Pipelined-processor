library ieee; 
use ieee.std_logic_1164.all; 
USE IEEE.numeric_std.all;

entity control_unit is 
port (	opcode: In std_logic_vector(6 downto 0);
	signals: out std_logic_vector(17 downto 0)	-- same order as in doc
    );
end control_unit; 

architecture control_unit_arc of control_unit is
begin
	-- InPortEnable
	signals(0) <= '1' when opcode = "0100110"
	else '0';
	
	-- OutPortEnable
	signals(1) <= '1' when opcode = "0100101"
	else '0';

	-- Pop
	signals(2) <= '1' when opcode = "0010001"
	else '0';

	-- Push
	signals(3) <= '1' when opcode = "0010000"
	else '0';

	-- MemWrite (PUSH, STD)
	signals(4) <= '1' when opcode = "0010000" or opcode = "0010100"
	else '0';

	-- MemRead (POP, LDD)
	signals(5) <= '1' when opcode = "0010001" or opcode = "0010011"
	else '0';
	
	-- IsShift (SHL, SHR)
	signals(6) <= '1' when opcode = "1000110" or opcode = "1000111"
	else '0';

	-- RdstRead (except No operand, IN, CLR, POP, LDM, LDD, MOV, SHL, SHR)
	signals(7) <= '0' when opcode(6 downto 4) = "000" or opcode = "0100110" or opcode = "0100000" 
	or opcode = "0010001" or opcode = "0010010" or opcode = "0010011" or opcode = "1000000"
	or opcode = "1000110" or opcode = "1000111"
	else '1';

	-- HasSrc (all 2 operand except IADD, LDD, STD)
	signals(8) <= '1' when (opcode(6 downto 4) = "100" or opcode = "0010011" or opcode = "0010100")
	and (not(opcode = "1000101"))
	else '0';

	-- STDEnable
	signals(9) <= '1' when opcode = "0010100"
	else '0';

	-- Src&Imm (SHL, SHR, LDD, STD)
	signals(10) <= '1' when opcode = "1000110" or opcode = "1000111" or opcode = "0010011" or opcode = "0010100"
	else '0';

	-- HasImmediate (IADD, SHL, SHR, LDM, LDD, STD)
	signals(11) <= '1' when opcode = "1000101" or opcode = "1000110" or opcode = "1000111" 
	or opcode = "0010010" or opcode = "0010011" or opcode = "0010100"
	else '0';

	-- WB (except No operand, PUSH, STD, OUT 
	signals(12) <= '0' when opcode(6 downto 4) = "000" or opcode = "0010000" or opcode = "0010100" or opcode = "0100101"
	else '1';

	-- ALU Operation
	signals(17 downto 13) <= "00000" when opcode = "0100101" 						-- OUT
	else "00001" when opcode = "1000000" or opcode = "0010010" or opcode = "0100110"		-- MOV, LDM, IN 
	else "00010" when opcode = "1000001" or opcode = "1000101" or opcode = "0010011" or opcode = "0010100"	-- ADD, IADD, LDD, STD
	else "00011" when opcode = "1000010"									-- SUB
	else "00100" when opcode = "1000011"									-- AND
	else "00101" when opcode = "1000100"									-- OR
	else "00110" when opcode = "1000110"									-- SHL
	else "00111" when opcode = "1000111"									-- SHR
	else "01000" when opcode = "0100000"									-- CLR
	else "01001" when opcode = "0100001"									-- NOT
	else "01010" when opcode = "0100010"									-- INC
	else "01011" when opcode = "0100011"									-- DEC
	else "01100" when opcode = "0100100"									-- NEG
	else "01101" when opcode = "0100111"									-- RLC
	else "01110" when opcode = "0101000"									-- RRC
	else "01111" when opcode = "0000001"									-- SETC
	else "10000" when opcode = "0000010"									-- CLRC
	else "00000";									

end control_unit_arc; 
