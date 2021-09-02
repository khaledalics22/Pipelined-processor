force -freeze sim:/shift_rot/A 00000000000000000000000000010000 0
force -freeze sim:/shift_rot/B 10#5 0
force -freeze sim:/shift_rot/cin 0 0
force -freeze sim:/shift_rot/operation 00111 0
run
force -freeze sim:/shift_rot/A 00001000000000000000000000000000 0
force -freeze sim:/shift_rot/B 10#5 0
force -freeze sim:/shift_rot/cin 0 0
force -freeze sim:/shift_rot/operation 00110 0
run