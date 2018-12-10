.data
	newLine: .asciiz "\n"


.text
	main:
		addi $t0,$0, 30
		jal AddNumber
		#jal PrintTheValue
		

	li $v0, 10
	syscall

	AddNumber:
		addi $sp, $sp, 8
		sw $t0, 0($sp)
		sw $ra, 4($sp)
		addi $t0, $t0, 5
		jal PrintTheValue
		lw $t0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra
	PrintTheValue:
		li $v0, 1
		add $a0,$0, $t0 
		syscall
		jr $ra
		
			
