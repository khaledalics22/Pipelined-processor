LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity writeback_stage_tb Is 

end entity writeback_stage_tb; 

architecture writeback_stage_tb_arch of writeback_stage_tb is
    component writeback_stage is Port(
        push , memRead : in std_logic; 
        SP_address, mem_out, ALU_result : in std_logic_vector(31 downto 0 ); 
        WB_data , SP_data: out std_logic_vector(31 downto 0)  
    ); end component; 

    signal push, memRead: std_logic; 
    signal  SP_address, mem_out, ALU_result ,
    WB_data , SP_data : std_logic_vector(31 downto 0 );

    begin

    
    wb: writeback_stage port map ( push => push, memRead => memRead, SP_address=> SP_address,
	mem_out => mem_out, ALU_result => ALU_result,  WB_data => WB_data, SP_data => SP_data); 
    process begin
        SP_address <= (others => '1');

        mem_out( 3 downto 0) <= (others => '1');
        mem_out(31 downto 4) <= (others => '0');

        ALU_result(5 downto 0) <= (others => '1');
        ALU_result(31 downto 6) <= (others => '0');

        push <= '0'; 
        memRead <= '0'; 

        wait for 100 ps; 

        push <= '1'; 

        wait for 100 ps; 

        memRead <= '1'; 

        wait for 100 ps; 
    end process; 


    end writeback_stage_tb_arch; 

