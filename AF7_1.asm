# Implement functions int ncstr(char* str, char c), returns how ofter the char c is in the string

.data
	String_Prompt:	.asciiz "Type a string>"
	Char_Prompt:	.asciiz "Type a char>"
	Occurences_Out:	.asciiz " occurence(s)"
	New_Line:	.asciiz "\n"
	String_In:	.space 256
	Char_In:	.space 1
	
.text
	
main:
#	- String In
	li $v0, 4                # System call for print string
	la $a0, String_Prompt
	syscall
	
	li $v0, 8		# Syscall to read string
	la $a0, String_In
	li $a1, 256		# 256 character max including terminator
	syscall
	
#	- Char In
	li $v0, 4                # System call for print string
	la $a0, Char_Prompt
	syscall
	
	li $v0, 12		# Syscall to read string
	syscall
	sb $v0, Char_In

#--------------------------------------- Function call start
	# $a adresses for Input
	# $v adresses for return
	la $a0, String_In
	la $a1, Char_In
	jal ncstr
#--------------------------------------- Function call end
	
	move $t3, $v0
	
	li   $v0, 4                # System call for print string
        la   $a0, New_Line
        syscall
	
	li $v0, 1		# Syscall to print integer
	move $a0, $t3		# Pass count
	syscall
	
	li   $v0, 4                # System call for print string
        la   $a0, Occurences_Out
        syscall
        
       	li $v0, 10			# Syscall to exit programm
       	syscall

# $a0 is string: str, $a1 is char: c
ncstr:
	# Need a counter variable so initalize it as $t0
	addi $t0, $0, 0
	lb $t1, 0($a0)		# Load first byte of string
	lb $t2, 0($a1)		# Load char
	
ncstr_loop:
	beqz $t1, ncstr_end		# If current byte is $t1 is null terminator then end
	beq $t1, $t2, ncstr_match	# If bytes match then increment the counter
	j ncstr_continue

ncstr_continue:
	addi $a0, $a0, 1		# Go to next byte in string
	lb $t1, 0($a0)			# Load next byte
	j ncstr_loop

ncstr_match:
	addi $t0, $t0, 1		# Increment counter by one
	j ncstr_continue

ncstr_end:
	# Return counter $t0 into $v0
	move $v0, $t0
	jr $ra				# Return