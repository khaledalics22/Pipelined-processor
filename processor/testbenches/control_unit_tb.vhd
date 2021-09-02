LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
Use work.MyPackage.ALL;

ENTITY control_unit_tb IS
END control_unit_tb;

ARCHITECTURE testbench_b OF control_unit_tb IS
	
	COMPONENT control_unit is 
	port (	opcode: In std_logic_vector(6 downto 0);
		signals: out std_logic_vector(17 downto 0)	-- same order as in doc
    	);
	END COMPONENT;
	
	SIGNAL opcode : std_logic_vector(6 downto 0);
	SIGNAL signals: std_logic_vector(17 downto 0);

	-- new array type
	Type inputtypes is array (0 TO 24) of std_logic_vector(6 downto 0);
	Type outputtypes is array (0 TO 24) of std_logic_vector(17 downto 0);

	-- create test cases
	CONSTANT inputcases : inputtypes :=
        ("1000000","1000001","1000010","1000011", "1000100",
	"1000101","1000110","1000111","0010000", "0010001",
	"0010010","0010011","0010100","0100000", "0100001",
	"0100010","0100011","0100100","0100101", "0100110",
	"0100111","0101000","0000000","0000001", "0000010");

	CONSTANT outputcases : outputtypes :=
	("000011000100000000","000101000110000000","000111000110000000","001001000110000000", "001011000110000000",
	"000101100010000000","001101110101000000","001111110101000000","000000000010011000", "000001000000100100",
	"000011100000100000","000101110100100000","000100111110010000","010001000000000000", "010011000010000000",
	"010101000010000000","010111000010000000","011001000010000000","000000000010000010", "000001000000000001",
	"011011000010000000","011101000010000000","000000000000000000","011110000000000000", "100000000000000000");

	BEGIN
		PROCESS
			BEGIN
				for i in inputcases'range Loop
				opcode <= inputcases(i);
				WAIT FOR 10 ns;
				ASSERT(signals = outputcases(i))
				REPORT  " Error in opcode: "&to_string(inputcases(i))&" output is: "&to_string(signals)&" and should be: "&to_string(outputcases(i))
				SEVERITY ERROR;
				
				end loop;
				-- Stop Simulation
				WAIT;
		END PROCESS;

		cu: control_unit PORT MAP (opcode => opcode, signals => signals);
		
END testbench_b;

