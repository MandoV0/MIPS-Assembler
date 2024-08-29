.data
	p:		.float -5
	q:		.float 6
	const_four:	.float 4.0
	const_two:	.float 2.0
	const_one:	.float 1.0
	const_zero:	.float 0.0
	sol_out:		.asciiz " solution(s)\n"
	sol_one:	.asciiz "solution: "
	
	# Nullstellen 0.53, -2.53
.text
main:
	# Pass trough f12, f13
	lwc1 $f12, p
	lwc1 $f13, q
	jal quadsolve
	
	move $t0, $v0
	
	# Print Number of solutions
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4
	la $a0, sol_out
	syscall
	
	li $v0, 4
	la $a0, sol_one
	syscall
	
	li $v0, 2
	mov.s $f12, $f0
	syscall
	
	li $v0, 4
	la $a0, sol_one
	syscall
	
	li $v0, 2
	mov.s $f12, $f1
	syscall
	
	li $v0, 10
	syscall

# unsigned int quadsolve(double p, double q)
# Gibt anzahl realler Lösungen in $v0 zurück
# Die Lösungen selbst werden in den paaren f1, f0 zurückgegeben,
quadsolve:
	# Berechne D = p^2 / 4 - q
	mul.s $f0, $f12, $f12
	
	lwc1 $f1, const_four
	
	div.s $f0, $f0, $f1
	sub.s $f0, $f0, $f13
	# D calculated in $f0 -> CALC CORRECT
	
	lwc1 $f2, const_zero
	
	c.lt.s $f0, $f2
	bc1t quadsolve_d_smaller_zero
	
	c.eq.s $f0, $f2
	bc1t quadsolve_d_equal_zero
	
	bc1f quadsolve_d_bigger_zero
	
quadsolve_d_smaller_zero:
	li $v0, 0
	jr $ra
	
quadsolve_d_equal_zero:
	li $v0, 1
	
	lwc1 $f0, p
	lwc1 $f1, const_two
	div.s $f2, $f0, $f1
	lwc1 $f0, const_zero
	sub.s $f2, $f0, $f2
	
	mov.s $f0, $f2
	jr $ra

quadsolve_d_bigger_zero:
	li $v0, 2
	
	# D is in $f0
	lwc1 $f1, const_zero
	lwc1 $f2, const_two
	sqrt.s $f0, $f0			# Square root of D
	
	# - p / 2
	lwc1 $f3, p
	div.s $f3, $f3, $f2
	sub.s $f3, $f1, $f3
	
	# x1
	sub.s $f4, $f3, $f0
	
	# x2
	add.s $f5, $f3, $f0
	
	mov.s $f0, $f4
	mov.s $f1, $f5
	jr $ra