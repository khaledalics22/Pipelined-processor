quit -sim
vsim -gui work.writeback_stage_tb
add wave -position end  sim:/writeback_stage_tb/push
add wave -position end  sim:/writeback_stage_tb/memRead
add wave -position end  sim:/writeback_stage_tb/SP_address
add wave -position end  sim:/writeback_stage_tb/mem_out
add wave -position end  sim:/writeback_stage_tb/ALU_result
add wave -position end  sim:/writeback_stage_tb/WB_data
add wave -position end  sim:/writeback_stage_tb/SP_data
run 1000