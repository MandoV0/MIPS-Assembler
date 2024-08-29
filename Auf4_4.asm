.data
	# Make sure to select appropiate DataType for proper alignment 
	.byte 0xa0			# (1 Byte - 8 Bits) / out of range Warning because 0xa0 is 170 which is out of range (-128, 127)
	.half 0xb1b0			# (2 Byte - 16 Bits)
	.word 0xc3c2c1c0		# (4 Byte - 32 Bits)
	.asciiz "Das Ende"		# String with null terminator "\0"
	# "Das Ende" get stored as "s a D" "e d n E", (ASCII 0x20 is Space)