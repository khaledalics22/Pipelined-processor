library ieee; 
use ieee.std_logic_1164.all; 

entity stack_pointer is 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
end stack_pointer; 

architecture stack_pointer_Arch of stack_pointer is
begin 

    process (clk,rst)
    begin 
    if rst = '1' then 
        q(31 downto 20) <= (others=>'0');
        q(19 downto 1) <= (others=>'1');
        q(0) <= '0'; 
    elsif clk'event and clk = edge and en = '1' then 
        q <= d; 
    end if;  
    end process; 
end stack_pointer_Arch; 
