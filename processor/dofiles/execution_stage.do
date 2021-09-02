restart -f
force -freeze sim:/execution_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/execution_stage/reset 1 0
run
force -freeze sim:/execution_stage/reset 0 0
force -freeze sim:/execution_stage/ALU_Operation 00001 0
force -freeze sim:/execution_stage/SrcAndImm_in 0 0
force -freeze sim:/execution_stage/HasImmediate_in 0 0
force -freeze sim:/execution_stage/RsrcData_in 10#35 0
force -freeze sim:/execution_stage/RdstData_in 10#2 0
force -freeze sim:/execution_stage/Immediate_in 10#1 0
force -freeze sim:/execution_stage/MEMdstA 0 0
force -freeze sim:/execution_stage/WBdstA 0 0
force -freeze sim:/execution_stage/MEMdstB 0 0
force -freeze sim:/execution_stage/WBdstB 0 0
force -freeze sim:/execution_stage/MEMWBData 10#0 0
force -freeze sim:/execution_stage/WBWBData 10#0 0
run

force -freeze sim:/execution_stage/ALU_Operation 00110 0
force -freeze sim:/execution_stage/SrcAndImm_in 1 0
force -freeze sim:/execution_stage/HasImmediate_in 1 0
force -freeze sim:/execution_stage/RsrcData_in 10#2 0
force -freeze sim:/execution_stage/RdstData_in 10#10 0
force -freeze sim:/execution_stage/Immediate_in 10#3 0
force -freeze sim:/execution_stage/MEMdstA 0 0
force -freeze sim:/execution_stage/WBdstA 0 0
force -freeze sim:/execution_stage/MEMdstB 0 0
force -freeze sim:/execution_stage/WBdstB 0 0
force -freeze sim:/execution_stage/MEMWBData 10#0 0
force -freeze sim:/execution_stage/WBWBData 10#0 0
run

force -freeze sim:/execution_stage/ALU_Operation 00010 0
force -freeze sim:/execution_stage/SrcAndImm_in 1 0
force -freeze sim:/execution_stage/HasImmediate_in 1 0
force -freeze sim:/execution_stage/RsrcData_in 10#35 0
force -freeze sim:/execution_stage/RdstData_in 10#2 0
force -freeze sim:/execution_stage/Immediate_in 10#3 0
force -freeze sim:/execution_stage/MEMdstA 0 0
force -freeze sim:/execution_stage/WBdstA 0 0
force -freeze sim:/execution_stage/MEMdstB 0 0
force -freeze sim:/execution_stage/WBdstB 0 0
force -freeze sim:/execution_stage/MEMWBData 10#0 0
force -freeze sim:/execution_stage/WBWBData 10#0 0
run