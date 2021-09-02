mem load -i assembler/Memory.mem /memory_stage/dm/ram
force -freeze sim:/memory_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/memory_stage/Rsrc_Data 10#100 0
force -freeze sim:/memory_stage/Rdst_Data 10#50 0
force -freeze sim:/memory_stage/ALU_Result 10#150 0
force -freeze sim:/memory_stage/SP_Addr_In 10#16 0
force -freeze sim:/memory_stage/Memory_Write 0 0
force -freeze sim:/memory_stage/STD_Enable 0 0
force -freeze sim:/memory_stage/pop 1 0
force -freeze sim:/memory_stage/push 0 0
force -freeze sim:/memory_stage/Memory_Read 1 0
run
force -freeze sim:/memory_stage/Memory_Write 1 0
force -freeze sim:/memory_stage/Memory_Read 0 0
force -freeze sim:/memory_stage/Memory_Write 1 0
force -freeze sim:/memory_stage/push 1 0
force -freeze sim:/memory_stage/pop 0 0
run
run -continue
run
