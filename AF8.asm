.data
    	zaehler_prompt:    	.asciiz "Zaehler>"
    	nenner_prompt:    	.asciiz "Nenner>"
    	result_output:		.asciiz "Reduzierte Darstellung "
    	div_out:		.asciiz "/"
    	newline:			.asciiz "\n"
    	ggt_out:		.asciiz " ggt "
    	error_out:		.asciiz "Fehler: Nenner=0"
    	repeat_prompt:		.asciiz "Weitere Berechnung (0 exit)>"
    	zaehler:    		.word 0
    	nenner:        		.word 0
	z1:			.word 0
	n1:			.word 0
.text

main:
    	# Zaehler
    	li $v0, 4        # Print String
    	la $a0, zaehler_prompt
    	syscall

    	# Take Input
    	li $v0, 5
    	syscall
    	sw $v0, zaehler

    	# Nenner
    	li $v0, 4        # Print String
    	la $a0, nenner_prompt
	syscall

    	# Take Input
    	li $v0, 5
    	syscall
    	sw $v0, nenner

    	# Call programm
    	lw $a0, zaehler
    	lw $a1, nenner
    	jal reduce_fraction
    	
    	move $t0, $v0

    	# Print all values
	li $v0, 4		
	la $a0, result_output
	syscall
	
	li $v0, 1
	lw $a0, z1
	syscall
	
	li $v0, 4		
	la $a0, div_out
	syscall
	
	li $v0, 1
	lw $a0, n1
	syscall
	
	li $v0, 4
	la $a0, ggt_out
	syscall
	
	# Print ggt
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall

    	j ask_for_repeat

    	li $v0, 10    # Exit programm
    	syscall
    	
ask_for_repeat:
	li $v0, 4
	la $a0, repeat_prompt
	syscall
	
	# Read int
	li $v0, 5
	syscall
	bne $v0, $zero, main
	
	li $v0, 10    # Exit programm
    	syscall


# int reduce_fraction(int z $a0, int n $a1, int *z1 $a2, int *n1 $a3)
reduce_fraction:
	beq $a1, 0, reduce_end_zero
    	move $t0, $zero            # int t = 0

    	# Save return adress on stack
    	addi $sp, $sp, -16
    	sw $ra, 0($sp)
    	sw $a0, 4($sp)
    	sw $a1, 8($sp)
    	sw $a2, 12($sp)
    	sw $a3, 16($sp)

    	jal gcd
    	move $t0, $v0            # Save return value

    	# Stack
    	lw $ra, 0($sp)            # restore old return adress
    	lw $a0, 4($sp)
    	lw $a1, 8($sp)
    	lw $a2, 12($sp)
    	lw $a3, 16($sp)
    	addi $sp, $sp, 16

    	div $a0, $t0
    	mflo $a2
    	div $a1, $t0
    	mflo $a3
    	
    	la $t1, z1
    	la $t2, n1
    	sw $a2, 0($t1)            # store reduced nenner into *z1
    	sw $a3, 0($t2)            # store reduced zaehler into *n1

    	move $v0, $t0
    	jr $ra

reduce_end_zero:	# ERROR
	move $v0, $zero
	li $v0, 4
	la $a0, error_out
	syscall
	
	j ask_for_repeat

#------------------------
# gcd(x, y) if y == 0 return x else return gcd(y, x % y)
gcd:
    addi $sp, $sp, -12        # Make space for return adress, x and y
    sw $ra, 0($sp)            # Save return adress on stack
    sw $s0, 4($sp)            # Save x parameter on stack
    sw $s1, 8($sp)            # Save y parameter on stack

    move $s0, $a0            # Save x local
    move $s1, $a1            # Save y local

    beq $s1, 0, gcd_end        # y == 0

    move $a0, $s1
    div $s0, $s1
    mfhi $a1

    jal gcd

gcd_exit:
    lw $ra, 0($sp)            # Read previously saved register
    lw $s0, 4($sp)            # Read previous a0
    lw $s1, 8($sp)
    addi $sp, $sp, 12        # Reset stack pointer
    jr $ra                # Return

gcd_end:
    move $v0, $s0        # Return x
    j gcd_exit