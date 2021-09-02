library ieee; 
use ieee.std_logic_1164.all; 
--------------------------------------ADDer, SUBtractor, incrementer, decrementer, negate -----------
ENTITY add_operations IS 
    Port(
        A, B : in std_logic_vector(31 downto 0);  
        operation:in std_logic_vector(4 downto 0);
        S: out std_logic_vector(31 downto 0);
        cout: out std_logic);
end add_operations; 
architecture arch of add_operations is
    component my_adder is
        PORT (a, b : IN std_logic_vector(31 DOWNTO 0) ;
	cin : IN std_logic;
        s : OUT std_logic_vector(31 DOWNTO 0);
        cout : OUT std_logic);
    end component;

    signal Btemp: std_logic_vector(31 downto 0);
    signal Atemp: std_logic_vector(31 downto 0);
    signal cin :std_logic; 
begin   
	u0: my_adder port map(Atemp , Btemp , cin , s , cout);
	
	Atemp <= not A when operation = "01100"		-- neg
	else B when operation = "00011"
	else A;

    	Btemp <= B when operation = "00010"		-- add
	else not A when operation = "00011"		-- sub
	else (others => '1') when operation = "01011"	-- dec
    	else (others => '0');				-- inc, neg
    	cin <= '1' when operation = "00011" or operation = "01010" or operation = "01100" 	-- sub, inc, neg
	else '0';

end arch; 

