
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_adder IS
PORT (a, b : IN std_logic_vector(31 DOWNTO 0) ;
        cin : IN std_logic;
        s : OUT std_logic_vector(31 DOWNTO 0);
        cout : OUT std_logic);
END my_adder;

ARCHITECTURE a_my_adder OF my_adder IS
COMPONENT halfAdder IS
PORT( a,b,cin : IN std_logic;
        s,cout : OUT std_logic); 
END COMPONENT;
SIGNAL temp : std_logic_vector(31 DOWNTO 0);
BEGIN

    f0: halfAdder PORT MAP(a(0),b(0),cin,s(0),temp(0));
    loop1: FOR i IN 1 TO 31 GENERATE
        fx: halfAdder PORT MAP(a(i),b(i),temp(i-1),s(i),temp(i));
    END GENERATE;

    Cout <= temp(31);

END a_my_adder;
