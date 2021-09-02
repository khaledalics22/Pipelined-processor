library ieee; 
use ieee.std_logic_1164.all; 
USE IEEE.numeric_std.all;

ENTITY shift_rot IS 
	PORT( 	A, B : in std_logic_vector(31 downto 0);  
        operation:in std_logic_vector(4 downto 0);
	cin: in std_logic;
        S: out std_logic_vector(31 downto 0);
        cout: out std_logic);
END shift_rot; 

architecture arch of shift_rot is
signal tempB:std_logic_vector(31 downto 0) := "00000000000000000000000000000001";
begin
	tempB <= B when to_integer(unsigned(B)) < 32
	else "00000000000000000000000000000001";

	S <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B)))) when operation = "00110"	-- SHL
	else std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B)))) when operation = "00111"	-- SHR
	else A(30 downto 0) & cin when operation = "01101"	-- RLC
	else cin & A(31 downto 1) when operation = "01110";	-- RRC

	cout <=  A(32 - to_integer(unsigned(tempB))) when operation = "00110"
	else A(to_integer(unsigned(tempB)) - 1) when operation = "00111"
	else A(31) when operation = "01101"
	else A(0) when operation = "01110";

end arch;
