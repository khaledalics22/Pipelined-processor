vsim work.processor

add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/in_port
add wave -position end  sim:/processor/out_port

add wave -position end  sim:/processor/fs/instruction
add wave -position end  sim:/processor/fs/pc_out
add wave -position end  sim:/processor/fs/isTwoWords

add wave -position end  sim:/processor/IFID_disable
add wave -position end  sim:/processor/ds/src
add wave -position end  sim:/processor/ds/dst
add wave -position end  sim:/processor/ds/ALU_operation
add wave -position end  sim:/processor/ds/imm
add wave -position end  sim:/processor/ds/writeBackNow
add wave -position end  sim:/processor/ds/writeReg
add wave -position end  sim:/processor/ds/writeData

add wave -position end  sim:/processor/es/ALU_Operation
add wave -position end  sim:/processor/es/A
add wave -position end  sim:/processor/es/B
add wave -position end sim:/processor/es/Immediate_in
add wave -position end  sim:/processor/es/ALU_Result
add wave -position end  sim:/processor/es/CCR_OUT

add wave -position end  sim:/processor/FORWARDING_WBdst
add wave -position end  sim:/processor/FORWARDING_MEMdst
add wave -position end  sim:/processor/FORWARDING_WBsrc
add wave -position end  sim:/processor/FORWARDING_MEMsrc

add wave -position end  sim:/processor/ms/ALU_Result

add wave -position end  sim:/processor/wb/WB_data

add wave -position end  sim:/processor/ds/regFile/reg0_data
add wave -position end  sim:/processor/ds/regFile/reg1_data
add wave -position end  sim:/processor/ds/regFile/reg2_data
add wave -position end  sim:/processor/ds/regFile/reg3_data
add wave -position end  sim:/processor/ds/regFile/reg4_data
add wave -position end  sim:/processor/ds/regFile/reg5_data
add wave -position end  sim:/processor/ds/regFile/reg6_data
add wave -position end  sim:/processor/ds/regFile/reg7_data


mem load -i assembler/TwoOperand.mem /processor/fs/im/ram


force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
force -freeze sim:/processor/in_port 16#5 0
run
force -freeze sim:/processor/in_port 16#19 0
run
force -freeze sim:/processor/in_port 16#FFFFFFFF 0
run
force -freeze sim:/processor/in_port 16#FFFFF320 0
run 1400