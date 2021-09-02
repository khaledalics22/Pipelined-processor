LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
Use work.MyPackage.ALL;

ENTITY add_operations_tb IS
END add_operations_tb;

ARCHITECTURE testbench_b OF add_operations_tb IS
	
	COMPONENT add_operations is 
	Port(
        A, B : in std_logic_vector(31 downto 0);  
        operation:in std_logic_vector(4 downto 0);
        S: out std_logic_vector(31 downto 0);
        cout: out std_logic);
	END COMPONENT;
	
	SIGNAL A, B : std_logic_vector(31 downto 0);
	SIGNAL operation: std_logic_vector(4 downto 0);
	SIGNAL S: std_logic_vector(31 downto 0);
	SIGNAL cout: std_logic;

	-- new array type
	Type inputtypes is array (0 TO 7) of std_logic_vector(31 downto 0);
	Type operations is array (0 TO 7) of std_logic_vector(4 downto 0);
	Type couts is array (0 TO 7) of std_logic;

	-- create test cases
	CONSTANT As : inputtypes :=
        ("10000000001100000000000000000000",
	"10000000000000000000000000000000",
	"00000000000000000000000000100011",
	"00000000000000000000000000000001",
	"10000000000000000000000000000000",
	"00010000000000000000000001000001",
	"00000000000000000000000000000100",
	"00000000000000000000000000000001");

	CONSTANT Bs : inputtypes :=
        ("00000100101100001000000000000010",
	"10000000000000000000000000000001",
	"00000000000000000000000000000101",
	"00000000000000000000000000000010",
	"01000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000",
	"00000000000000000000000000000000");

	CONSTANT ops : operations :=
        ("00010",
		"00010",
		"00011",
		"00011",
		"00011",
		"01010",
		"01011",
		"01100");

	CONSTANT Ss : inputtypes :=
        ("10000100111000001000000000000010",
	"00000000000000000000000000000001",
	"00000000000000000000000000011110",
	"11111111111111111111111111111111",
	"01000000000000000000000000000000",
	"00010000000000000000000001000010",
	"00000000000000000000000000000011",
	"11111111111111111111111111111111");
	
	CONSTANT Cs : couts :=
        ('0','1','1','0','1','0','1','0');


	BEGIN
		PROCESS
			BEGIN
				for i in As'range Loop
				A <= As(i);
				B <= Bs(i);
				operation <= ops(i);
				WAIT FOR 100 ps;
				ASSERT(S = Ss(i) and cout = Cs(i))
				REPORT  "Error"
				SEVERITY ERROR;
				
				end loop;
				-- Stop Simulation
				WAIT;
		END PROCESS;

		A_S: add_operations PORT MAP (A => A, B => B, operation => operation, S => S, cout => cout);
		
END testbench_b;
