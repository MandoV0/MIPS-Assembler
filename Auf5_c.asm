# Aufgabe c
.text

main:
	# Init Input
	addi $4, $0, 17
	addi $5, $0, 51
	
	# Call Subroutine/Function
	jal gcd_subroutine
	
	j end
	
gcd_subroutine:
	# sp = Stack Pointer
	addi $sp, $sp, -4			# -4 to create space on Stack because Stack moves down in Mips?
	# ra = return adress
	sw $ra, 0($sp)				# Save return adress
	# Continures execution at next instruction which is gcd?
	
gcd:
    beq $4, $0, r4_eq_zero			# r4 == 0
    beq $5, $0, r5_eq_zero			# r5 == 0

    slt $10, $4, $5              		# $10 = r5 < r4
    bne $10, $zero, r4_gt_then_r5 		# r4 > r5
    beq $10, $zero, r4_less_then_r5

r4_eq_zero:
	lw $ra, 0($sp)			# Load return adress
	addi $sp, $sp, 4		# Deallocate Space on Stack
	add $2, $0, $5			# Return value is in $2 (should be $5)
	jr $ra                    	# Go to ra - return adress (Jumps back to gcd)

r5_eq_zero:
    lw $ra, 0($sp)
    addi $sp, $sp, 4		# Deallocate Space on Stack
    add $2, $0, $4	    	# Return value is in $2 (should be $4 since r5 == 0)
    jr $ra                   	# Return from subroutine (Jumps back to gcd)

r4_gt_then_r5:
    subu $5, $5, $4
    j gcd

r4_less_then_r5:
    subu $4, $4, $5
    j gcd

end:
    j end                    # Infinite loop to end the program
