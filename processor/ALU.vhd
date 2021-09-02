library ieee; 
use ieee.std_logic_1164.all;

entity ALU is
    port (	A, B : in std_logic_vector(31 downto 0);
		CCR_IN : in std_logic_vector(2 downto 0); 	-- (2) carry, (1) negative, (0) zero 
            	OPERATION: in std_logic_vector(4 downto 0); 
            	CCR_OUT: out std_logic_vector(2 downto 0);
		ALU_OUT: out std_logic_vector(31 downto 0));
end ALU;

architecture arch of AlU IS

component add_operations IS 
    	Port(
        	A, B : in std_logic_vector(31 downto 0);  
        	operation:in std_logic_vector(4 downto 0);
        	S: out std_logic_vector(31 downto 0);
        	cout: out std_logic);
END component;
  
component shift_rot IS 
	PORT( 	A, B : in std_logic_vector(31 downto 0);  
        operation:in std_logic_vector(4 downto 0);
	cin: in std_logic;
        S: out std_logic_vector(31 downto 0);
        cout: out std_logic);
END component;

signal add_operations_s, shift_rot_s: std_logic_vector(31 downto 0);
signal add_operations_cout, shift_rot_cout: std_logic;
signal temp: std_logic_vector(31 downto 0);
begin
	c0 : add_operations port map (A , B , OPERATION , add_operations_s, add_operations_cout);
	c1 : shift_rot port map (A , B , OPERATION , CCR_IN(2), shift_rot_s, shift_rot_cout);

	temp <= A when OPERATION = "00000"
	else B when OPERATION = "00001"
	else A AND B when OPERATION = "00100"
	else A OR B when OPERATION = "00101"
	else (others => '0') when OPERATION = "01000"
	else NOT A when OPERATION = "01001"
	else add_operations_s when OPERATION = "00010" or OPERATION = "00011" or OPERATION = "01010" or OPERATION = "01011" or OPERATION = "01100"
	else shift_rot_s when OPERATION = "00110" or OPERATION = "00111" or OPERATION = "01101" or OPERATION = "01110";
	
	CCR_OUT(2) <= '1' when OPERATION = "01111"
	else add_operations_cout when OPERATION = "00010" or OPERATION = "00011" or OPERATION = "01010" or OPERATION = "01011"
	else shift_rot_cout when OPERATION = "00110" or OPERATION = "00111" or OPERATION = "01101" or OPERATION = "01110"
	else '0' when OPERATION = "10000"
	else CCR_IN(2);
	
	CCR_OUT(1) <= '1' when( (temp(31) = '1') AND ( OPERATION = "01001" or  OPERATION = "00010"
	 	or OPERATION = "00011" or OPERATION = "01010" or OPERATION = "01011" or OPERATION = "01100"
		or OPERATION = "00100" or OPERATION = "00101"))
	else '0';

	CCR_OUT(0) <= '1' when ((temp = x"00000000") AND ( OPERATION = "01001" or  OPERATION = "00010"
	 	or OPERATION = "00011" or OPERATION = "01010" or OPERATION = "01011" or OPERATION = "01100"
		or OPERATION = "00100" or OPERATION = "00101" or OPERATION = "01000"))
	else '0';

	ALU_OUT <= temp;

end arch; 
