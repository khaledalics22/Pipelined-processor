LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


entity is_two_word is Port(
    opcode: in std_logic_vector(6 downto 0);
    is2word: out std_logic
);
end entity is_two_word; 


architecture is_two_word_arch of is_two_word is 
begin

    --  (IADD, LDM, LDD, STD)
	is2word <= '1' when opcode = "1000101" or opcode = "0010010" 
    or opcode = "0010011" or opcode = "0010100"
	else '0';

    end is_two_word_arch;