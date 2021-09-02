library ieee; 
use ieee.std_logic_1164.all; 

entity reg is 
generic (n:INTEGER:= 32); 
port (clk, rst ,en, edge :IN std_logic; 
        d:In std_logic_vector(n-1 downto 0); 
        q:out std_logic_vector(n-1 downto 0 )); 
end reg; 

architecture Reg_Arch of reg is
begin 
    process (clk,rst)
    begin 
    if rst = '1' then 
        q <= (others=>'0'); 
    elsif clk'event and clk = edge and en = '1' then 
        q <= d; 
    end if;  
    end process; 
end Reg_Arch; 
