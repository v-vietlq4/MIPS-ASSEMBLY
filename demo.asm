.data

	Array: .word 23, 34 , 45 ,23

.text
	la $a0, Array
	li $s0, 1
	
	li $t7, 4
		
	mult $s0, $t7
	mflo $t0 
	
	add $t0, $t0, $a0
	lw $t0, ($t0)
	li $v0, 1
	move $a0, $t0
	syscall

	bge 