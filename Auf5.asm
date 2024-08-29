.text
# INIT r4, r5
addi $4, $0, 17
addi $5, $0, 51
add $2, $0, $5

gcd:
	# r4 == 0
	beq $4, $0, r4_eq_zero # 4
	# r5 == 0
	beq $5, $0, r5_eq_zero	

	slt $10, $4, $5				# $10 = r5 < r4
	bne $10, $zero, r4_gt_then_r5		# r4 > r5
	beq $10, $zero, r4_less_then_r5

r4_eq_zero:
	# Go into Infinite Loop
	j end

r5_eq_zero:
	add $2, $0, $4
	j end
	
r4_gt_then_r5:
	subu $5, $5, $4
	j gcd

r4_less_then_r5:
	subu $4, $4, $5		# r4 = r4 - r5
	j gcd
	
end:
	j end
