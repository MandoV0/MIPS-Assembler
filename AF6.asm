.data
	str1:	.asciiz "Lager"
	str2:	.asciiz "Regal"
	str3:	.space 10
		.byte 0xff
		.byte 0xff

.text
main:
	la $a0, str1
	jal strtolower
	
	la $a0, str2
	jal strtolower
	
	la $a0, str1
	jal strturnaround
	
	la $a0, str2
	jal strturnaround
	
	la $a0, str3
	la $a1, str1
	la $a2, str2
	jal strcat

	la $a0, str3
	jal strispalindrome
	
	j loop
	
# void strtolower(char *str)
strtolower:
	beqz $a0, strtolower_end	# If string is null return
    	lb $t1, 0($a0)       		# Load the first byte of the string into $t1
    
tolower_loop:
	beqz $t1, strtolower_end  	# If the current byte is null (end of string), exit
    	li $t2, 0x41        		# ASCII value for 'A'	
    	li $t3, 0x5A        		# ASCII value for 'Z' Between (65 and 90) any of these values + 32 gives us the lower case version 
    	blt $t1, $t2, next_char		# branch if t1 is smaller then t2, t1 is the current char
    	bgt $t1, $t3, next_char		
    	addi $t1, $t1, 32   		# Convert uppercase to lowercase by adding 32
    	sb $t1, 0($a0)      		# Store the lowercase character back to the string
    	
next_char:
    	addi $a0, $a0, 1    	# Move to the next character in the string
    	lb $t1, 0($a0)      	# Load the next character
    	j tolower_loop
    
strtolower_end:
    	jr $ra              # Return from the function
    
loop:
	j loop

# void strturnaround(char * str)

strturnaround:
	li $t1, 0		# Variable for Length of String
	move $t0, $a0

str_length:
	lb $t2, 0($t0)
	beqz $t2, reverse_str_start
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j str_length

reverse_str_start:
	sub $t1, $t1, 1			# Subtract 1 from string length so we can use it for the index
	add $t1, $a0, $t1		# Set $t1 to the last char address of $a0 
	
reverse_str_loop:
	bge $a0, $t1, reverse_end	# Both variables are used as left and right pointers, if they cross we reversed the whole string
	lb $t2, 0($a0)			# Load the character from the left pointer
	lb $t3, 0($t1)			# Load character from the right pointer
	
	sb $t3, 0($a0)			# Store character from right pointer in left pointer
	sb $t2, 0($t1)			# Store character from left pointer in right pointer
	
	addi $a0, $a0, 1		# Move right left pointer ->
	subi $t1, $t1, 1		# Move left pointer <-
	j reverse_str_loop		# Continue until pointers cross
	
reverse_end:
	jr $ra                 # Return from the function back to where the function was called with jal
	
# void strispalindrom(char* str)
strispalindrome:
	# Cant mostly use code from strturnaround but we have to modify the loop to check if the pointers are equal and not switch the charachters
	# Have to return a value, 1 for true 0 for false
	move $t0, $a0		# Base Adress for string
	li $t1, 0		# String length variable
	
str_length_n:
	lb $t2, 0($t0)
	beqz $t2, palindrome_start
	addi $t1, $t1, 1
	addi $t0, $t0, 1
	j str_length_n

palindrome_start:
	move $t0, $a0			# Load Base Adress again as we moved it to calculate string length
	sub $t1, $t1, 1			# Subtract 1 from string length so we can use it for the index, else we would go out of range
	
palindrome_loop:
	bge $a0, $t1, palindrome_found		# Both variables are used as left and right pointers, if they cross we know its a palindrome
	lb $t2, 0($a0)				# Load the character from the left pointer
	lb $t3, 0($t1)				# Load character from the right pointer
	
	bne $t2, $t3, palindrome_not_found	# If they are not equal end the function
	
	addi $a0, $a0, 1			# Move right pointer ->
	subi $t1, $t1, 1			# Move left pointer <-
	j palindrome_loop			# Continue until pointers cross
	
palindrome_found:
	li $v0, 1				# if we found the palindrome store a 1 in $v0, (v0 and v1 are used for function return values (Palindrome found)
	jr $ra					# Palindrome found
	
palindrome_not_found:
	li $v0, 0				# else store a zero
	jr $ra                 			# Return from the function back to where the function was called with jal (Palindrome not found)

# void strcat(char* result, char* str1, char* str2)
strcat:
	# Store address of str1 and str2 in $t0, $t1
	move $t0, $a1			# $a1 is str 1
	move $t1, $a2			# $a2 is str2
	# Result	
	move $t2, $a0			# $a0 is str3
	
add_str1:			# $t0 is current char
	lb $t3, 0($t0)		# Load current char
	beqz $t3, add_str2 	# if char $t3 is terminator go to str2
	sb $t3, 0($t2)		# Store current char in result
	addi $t0, $t0, 1	# Increment pointer for str1 to point to nexht char
	addi $t2, $t2, 1	# Increment pointer for result
	j add_str1
	
add_str2:
	lb $t3, 0($t1)		# Load current char
	beqz $t3, strcat_end 
	sb $t3, 0($t2)		# Store current char in result
	addi $t1, $t1, 1	# Increment pointer for str1 to point to next char
	addi $t2, $t2, 1	# Increment pointer for result
	j add_str2

strcat_end:
	jr $ra			# return