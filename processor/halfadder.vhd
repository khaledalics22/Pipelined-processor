library ieee; 
use ieee.std_logic_1164.all;

ENTITY halfAdder IS    
        PORT( a,b,cin : IN std_logic;
             s,cout : OUT std_logic); 
END halfAdder;

ARCHITECTURE a_my_adder OF halfAdder IS
BEGIN
             s <= a XOR b XOR cin;
             cout <= (a AND b) or (cin AND (a XOR b));
END a_my_adder;
