
func1:
	addi $8, $0, 0xffff			# Pseudo instruction? No idea how to combine codes
	sllv $t0, $t0, $a1
	and $v0, $a0, $t0
	jr $ra					# Rest correct
	
func2:
	addi $t0, $zero, 1
	addi $v0, $zero, -1
	and $t1, $a0, $t0
	addi $zero, $zero, 1
	sll $t0, $t0, 1
	bnez $t1, -4
	jr $ra
