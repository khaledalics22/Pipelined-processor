vsim -gui work.fetch_stage
add wave sim:/fetch_stage/*
mem load -i assembler/Memory.mem /fetch_stage/im/ram
force -freeze sim:/fetch_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/fetch_stage/reset 1 0
force -freeze sim:/fetch_stage/pc_disable 0 0
run
force -freeze sim:/fetch_stage/reset 0 0
run 1500