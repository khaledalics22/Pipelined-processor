LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity decode_stage_tb is 
end entity decode_stage_tb; 

architecture decode_stage_tb_arch of decode_stage_tb is 
component decode_stage IS
PORT(
    clk, reset, writeBackNow: IN std_logic;
    instruction, in_port: IN std_logic_vector(31 downto 0);
    writeReg : IN std_logic_vector(2 downto 0);
    writeData : IN std_logic_vector (31 downto 0);
    RdstRead, hasRsrc, Push, Pop, outPortEnable, writeBackNext, hasImm, SrcAndImm, memWrite,
    memRead, stdEnable: OUT std_logic;
    ALU_operation : OUT std_logic_vector (4 downto 0);
    imm, src, dst : OUT std_logic_vector (31 downto 0);
    SrcRead, DstRead : OUT std_logic_vector (2 downto 0)
	);
    end component; 
    signal clk: std_logic := '1';
    signal reset, writeBackNow ,RdstRead, 
    hasRsrc, Push, Pop, outPortEnable, writeBackNext, 
    hasImm, SrcAndImm, memWrite,memRead, stdEnable: std_logic;
    signal instruction, in_port , imm, src, dst,writeData:  std_logic_vector(31 downto 0);
    signal writeReg , SrcRead, DstRead :  std_logic_vector(2 downto 0);
    signal ALU_operation : std_logic_vector (4 downto 0);
    begin

    d: decode_stage port map (clk, reset, writeBackNow,instruction, in_port,
    writeReg,writeData,RdstRead, hasRsrc, Push, Pop, outPortEnable, writeBackNext, hasImm, SrcAndImm, memWrite,
    memRead, stdEnable, ALU_operation, imm, src, dst, SrcRead, DstRead);
        

    clk <= not clk after 50 ps;
   
    process begin
        reset <= '1'; 
        
        wait for 100 ps; 

        reset <= '0'; 
        in_port <= "11111111111111111111111111111111";

        writeBackNow <= '0';
        
        -- inc reg 2; 
        instruction <= "01000100000100000000000000000000"; 
        wait for 100 ps; 
        -- mov instruction from reg 1 to reg 2
        instruction <= "10000000010100000000000000000000"; 
        wait for 100 ps; 
        -- mov instruction from reg 2 to reg 3
        instruction <= "10000000100110000000000000000000"; 
        wait for 100 ps; 
        -- write back now in reg  4 
        writeBackNow <= '1'; 
        writeReg <= "100"; 
        writeData <= "11111111111111111000000000000000";
        wait for 100 ps; 
    end process; 


end decode_stage_tb_arch;