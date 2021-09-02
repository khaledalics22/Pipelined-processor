quit -sim
vsim -gui work.decode_stage_tb
add wave -position end  sim:/decode_stage_tb/clk
add wave -position end  sim:/decode_stage_tb/reset
add wave -position end  sim:/decode_stage_tb/writeBackNow
add wave -position end  sim:/decode_stage_tb/RdstRead
add wave -position end  sim:/decode_stage_tb/hasRsrc
add wave -position end  sim:/decode_stage_tb/Push
add wave -position end  sim:/decode_stage_tb/Pop
add wave -position end  sim:/decode_stage_tb/outPortEnable
add wave -position end  sim:/decode_stage_tb/writeBackNext
add wave -position end  sim:/decode_stage_tb/hasImm
add wave -position end  sim:/decode_stage_tb/SrcAndImm
add wave -position end  sim:/decode_stage_tb/memWrite
add wave -position end  sim:/decode_stage_tb/memRead
add wave -position end  sim:/decode_stage_tb/stdEnable
add wave -position end  sim:/decode_stage_tb/instruction
add wave -position end  sim:/decode_stage_tb/in_port
add wave -position end  sim:/decode_stage_tb/imm
add wave -position end  sim:/decode_stage_tb/src
add wave -position end  sim:/decode_stage_tb/dst
add wave -position end  sim:/decode_stage_tb/writeData
add wave -position end  sim:/decode_stage_tb/writeReg
add wave -position end  sim:/decode_stage_tb/SrcRead
add wave -position end  sim:/decode_stage_tb/DstRead
add wave -position end  sim:/decode_stage_tb/ALU_operation
run 10000