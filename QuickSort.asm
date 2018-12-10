#------------------------QUICKSORT IN C++-----------------------#
#	int Partition(int* a, int low, int hight)		#
#	 {							#
#		int i = low;					#
#		int j = hight;					#
#		int pivot = low;				#
#		while (i < j)					#
#		{						#
#			while (a[i] <= a[pivot])		#
#			{					#
#				i++;				#
#			}					#
#			while (a[j] >= [pivot])			#
#			{					#
#				j--;				#
#			}					#
#			if (i < j)				#
#				swap(a[i], a[j]);		#
#		}						#
#		swap(a[pivot],a[j]);				#
#		return pivot;					#
#	}							#									#
#	 							#
#	void QuickSort(int *a, int left, int right)		#
#	 {							#
#		if (left < right)				#
#		{						#
#		   	int pivot = Partition( a, left, right);	#
#		   	QuickSort( a, left, pivot - 1);		#
#		   	QuickSort( a, pivot + 1, right);	#
#		}						#
#	 }							#
#								#	
#################################################################

.data
	Array: .space 4000
	Size: .space 4
	fileWord: .space 4000
	fin: .asciiz "input_sort.txt"
	

.text
	main:
	jal ReadFile
	jal SaveArray

	la $a0, Array
	li $a1, 0
	la $a3, Size
	lw $a2, ($a3)
	addi $a2, $a2, -1
	
	jal QuickSort
	lw $t6 , 4($a0)

	li $v0, 1
	move $a0, $t6
	syscall

	li $v0, 10
	syscall

	# Function to read file and return adress string FileWord
	ReadFile:
		li $v0, 13
		la $a0, fin
		li $a1, 0
		syscall
		move $s0, $v0
	
		li $v0, 14
		move $a0, $s0
		la $a1, fileWord
		la $a2, 4000
		syscall
 
		li $v0, 16
		move $a0, $s0
		syscall
		jr $ra
	# read and Stored to the array
	StoredtoArray:
		lb $t6, ($t0)
		move $s2, $t6
		beq $s2, 0, nStoredtoArray
		beq $s2, 13, StoredNumberofElements 
		addi $s2, $s2, -48
		bltz $s2, Stored 
		#beq $t1, 1,Stored
		addi $s3, $0, 10
		mult $s1, $s3
		mflo $s1
		add $s1, $s1, $s2
		addi $t0, $t0, 1
		j StoredtoArray

		Stored:
			addi $t0, $t0, 1
			sw $s1, ($s0)
			addi $s0, $s0, 4
			move $s1, $0
			
			j StoredtoArray

		StoredNumberofElements:
			addi $t0, $t0, 2
			sw $s1, Size
			move $s1, $0
			
			j StoredtoArray
		
	nStoredtoArray:	
		sw $s1, ($s0)
		jr $ra

	#Save Array
	SaveArray:
		addu $sp, $sp, -4
		la $t0, fileWord
		la $s0, Array
		addi $s1,$0, 0
		sw $ra, 0($sp)
		jal StoredtoArray
		lw $ra, ($sp)
		addu $sp, $sp, 4
		jr $ra

		
	
		
		
	# int Partition(int *a, int low, int hight)
	Partition:
		addu $sp, $sp, -24
		sw $s0, 0($sp)	# store s0
		sw $s1, 4($sp)	# store s1
		sw $s2, 8($sp)	# store s2
		
		sw $a1, 12($sp)	# store a1
		sw $a2, 16($sp)	# store a2
		sw $ra, 20($sp)	# store ra
		
		move $s0, $a1			# l = left
		move $s1, $a2			# r = right 
		move $s2, $a1			# pivot = left
		
		
		# While l < r
		While_partition:
			bge $s0, $s1, nWhile_partition
			
			# While a[i]<= a[pivot]
			While_left:
				li $t7, 4

				mult $s0, $t7
				mflo $t0
				add $t0, $t0, $a0
				lw $t0, ($t0)
				
				mult $s2, $t7
				mflo $t1
				add $t1, $t1, $a0
				lw $t1,($t1)

				bgt $t0, $t1, nWhile_left
				
				addi $s0, $s0, 1
				j While_left

			nWhile_left:
			# While a[j]>= a[piviot]
			While_right:
				li $t7, 4

				mult $s1, $t7
				mflo $t0
				add $t0, $t0, $a0
				lw $t0, ($t0)

				mult $s2, $t7
				mflo $t1
				add $t1, $t1, $a0
				lw $t1, ($t1)

				blt $t0, $t1, nWhile_right
				addi $s1, $s1, -1
				j While_right
				
			nWhile_right:

			blt $s0, $s1, Swap 
			j While_partition

			Swap:
				li $t7, 4
				mult $s0, $t7
				mflo $t6
				add $t0, $t6, $a0
				
				mult $s1, $t7
				mflo $t6
				add $t1, $t6, $a0

				lw $t2, ($t0)
				lw $t3, ($t1)
				sw $t3, ($t0)
				sw $t2, ($t1)
				j While_partition
	
		nWhile_partition:
				li $t7, 4
				mult $s1, $t7
				mflo $t6
				add $t0, $t6, $a0
				
				mult $s2, $t7
				mflo $t6
				add $t1, $t6, $a0
				
				lw $t2, ($t0)
				lw $t3, ($t1)
				sw $t3, ($t0)
				sw $t2, ($t1)
				sw $s1, 8($sp)
			
				lw $s2, 8($sp)
				lw $a1, 12($sp)
				lw $a2, 16($sp)
				lw $ra 20($sp)
				addi $sp, $sp, 24
				jr $ra


		
		QuickSort:
			addu $sp, $sp, -24
			sw $s0, 0($sp)	# store s0
			sw $s1, 4($sp)	# store s1
			sw $s2, 8($sp)	# store s2
			
			sw $a1, 12($sp)	# store a1
			sw $a2, 16($sp)	# store a2
			sw $ra, 20($sp)	# store ra
			
			move $s0, $a1			# l = left
			move $s1, $a2			# r = right 
			move $s2, $a1			# pivot = left
			bge $s0, $s1, nQuickSort
			jal Partition
			move $t3, $s2
			QuickSort1:
				move $a1, $t3
				addi $a1, $a1, 1
				jal QuickSort
				lw $a1, 12($sp)
				lw $a2, 16($sp)
				lw $ra, 20($sp)
		
			QuickSort2:
				move $a2, $t3
				addi $a2, $a2, -1
				jal QuickSort
				lw $a1, 12($sp)
				lw $a2, 16($sp)
				lw $ra, 20($sp)

			nQuickSort:
				lw $s0, 0($sp)	# store s0
				lw $s1, 4($sp)	# store s1
				lw $s2, 8($sp)	# store s2
				addu $sp, $sp, 24
				jr $ra	
	

	
