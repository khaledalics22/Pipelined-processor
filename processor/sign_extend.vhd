LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity sign_extend is Port (
    is_shift: in std_logic; 
    shift_value: in std_logic_vector(4 downto 0); 
    immediate : in std_logic_vector(15 downto 0); 
    extended: out std_logic_vector(31 downto 0) 
);
end entity sign_extend; 

architecture sign_extend_arch of sign_extend is
    begin
   
        extended <= std_logic_vector(resize(unsigned(shift_value), extended'length))when is_shift = '1' 
        else std_logic_vector(resize(unsigned(immediate), extended'length));  

    end sign_extend_arch;