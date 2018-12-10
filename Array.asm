.data
	Array: .space 10000
	Input: .asciiz "Enter number of elements: "
	Output: .asciiz "Array: "
	Sum: .asciiz "\nSum = "
	Max: .asciiz "\nMax = "
	newLine: .asciiz "\n"
	space: .asciiz " "
	Prime: .asciiz "\nPrimes : "
	Position: .asciiz "\nPos= "
	NotPosition: .asciiz "\nNot Found"
	Menu: .asciiz "	\n1. Xuat ra cac phan tu.\n2. Tinh tong cac phan tu.\n3. Liet ke cac phan tu la so nguyen to.\n4. Tim max.\n5. Tim phan tu co gia tri x (nguoi dung nhap vao) trong mang.\n6. Thoat chuong trinh "
	Enter: .asciiz "\nLua chon cua ban la: "
	findx: .asciiz "Enter of Element need to find: "
.globl main 
.text
	main:
	jal InputAmount  # Enter number of elements
	move $s0, $t0    #  save number of element to the register $s0
	move $s1, $s0    # save number of element to the register $s1 in order to processing the function
	move $t0, $0     #  remove data of register $t0

	la $t0, Array    #  register $t0 give adress of Array
	jal InputArray   # input elements of array

	jal CHOOSE       # jump to the Menu and choose the function
	



	# Enter Number of elements
	InputAmount:            
		li $v0, 4                 # print screen string Input
		la $a0,Input
		syscall

		
		li $v0, 5                 # tell the users enter amount of elements
		syscall
		
		
		blez $v0, InputAmount     # if the value <0 , enter of other value
		addi $t0, $v0, 0		
		jr $ra

	# Enter elements of the Array
	InputArray:
		beq $s1, 0, nInputArray   # check amount of array equal 0, if its equal 0 jump to the label nInputArray 
		li $v0, 5                 # input from keyboard
		syscall
		sw $v0, ($t0)             # save to adress $t0, $t0 give adress the Array
		
		addi $s1, $s1, -1         # after a input element and then sub s1--
		addi $t0, $t0, 4          #  increase the adress array. ex. array[0], array[1],...
		b InputArray	          # jump to the Input	
	nInputArray:
		la $t0, Array             # update adress
		move $s1, $s0             # update amount of Array to process the other funtion
		jr $ra                    # jump to main funtion

	# Print the elements of Array to screen
	OutputArray:
		beq $s1, 0, nOutputArray  # if s1=0 jump to nOutputArray label
		lw $t6,($t0)              #  get the element of Array
		li $v0, 1                 # print to the screen
		move $a0, $t6
		syscall
		li $v0, 4                 # print the " " to the screen
		la $a0, space
		syscall
		
		addi $t0, $t0, 4          # increase the next position 
		addi $s1, $s1, -1         #  s1--
		j OutputArray             # jump to OutputArray 
			
	nOutputArray:
		la $t0, Array             # update 
		move $s1, $s0
		j CHOOSE                  # jump to CHOOSE label
	
	#Caculate Sum all elements of the Array
	SumOfArray:
		beq $s1, 0, nSumOfArray   # check the s1==0
		lw $t6, ($t0)             # load the element
		
		add $t1, $t1, $t6         # add the elements of array
		addi $t0, $t0, 4          # increase the next position
		addi $s1, $s1, -1         # s1--
		j SumOfArray              # jump to the SumOfArray

	nSumOfArray:
		li $v0, 4
		la $a0, Sum               # print string Sum to screen
		syscall
		li $v0, 1
		move $a0, $t1             # print value of Sum 
		syscall
		la $t0, Array             #update 
		move $s1, $s0
		j CHOOSE                  # jump to CHOOSE label
	
	# Find the Max Element of the Array
	FindMax:
		beq $s1, 0, nFindMax      #check s1==0
		lw $t6, ($t0)             #load elements of array
		bgt $t6, $t1, swap        # if greater than , swap it 
		addi $t0, $t0, 4          # increase the next position
		addi $s1, $s1, -1         #s1--
		j FindMax                 #jump to FindMax
	swap:
		addi $t1,$t6, 0           #Swap 2 elements
		j FindMax
	nFindMax:
		li $v0, 4                 #print the string Max 
		la $a0, Max
		syscall
		li $v0, 1                 #prin the value of Max
		move $a0, $t1
		syscall	
		la $t0, Array             #update
		move $s1, $s0
		j CHOOSE                  #jump to CHOSSE label

	#Print the Prime Elements of the Array
	printPrimeElements:
		beq $s1, 0, nprintPrimeElements         # check s1==0
		lw $t6, ($t0)				# load value of elements
		move $t1, $t6				# save to register $t1
		addi $t2, $0, 2				# i=2
		addi $t0, $t0, 4			# increase the next position
		addi $s1, $s1, -1
		#Check the element is Prime
		isPrime:
			beq $t1, $t2, true		#t2==t1 , the element is prime
			div $t1, $t2			# process division a[i] , i
			mfhi $t4			# get the  value of a[i] mod i
			beq $t4, $0, false		#if ==0 then false
			addi $t2, $t2, 1		# i++
			j isPrime			#jump to isPrime
		true:
			li $v0, 1			#if true print the screen
			move $a0, $t1
			syscall
			li $v0, 4
			la $a0, space
			syscall
			j printPrimeElements

		false:
			j printPrimeElements		#else jump to printPrimeElements
		

	nprintPrimeElements:				#update
		la $t0, Array
		move $s1, $s0
		j CHOOSE

	# Find the number of the array
	FindElement:
		beq $s1, 0, NotFind			#s1==0 , not found
		lw $t6 ($t0)				#load the value of element	
		beq $t6, $t1, Find			#if == , found it 
		addi $t0, $t0, 4			#else increase the next position and find 
		addi $s1, $s1, -1
		j FindElement

		Find:
			sub $t2, $s0, $s1		#the position s1 from n-> 0 , so we sub the s0-s1
			li $v0, 4
			la $a0, Position
			syscall

			li $v0, 1
			move $a0, $t2
			syscall

			la $t0, Array
			move $s1, $s0
			j CHOOSE

		NotFind:
			li $v0, 4
			la $a0, NotPosition		#print Not Found
			syscall
			la $t0, Array
			move $s1, $s0
			j CHOOSE
	#Input the number to find and then call the FindElement function
	FindElementArray:
		addu $sp, $sp, -4			# tell the user input the number to find
		li $v0, 4
		la $a0, findx
		syscall
		
		li $v0, 5
		syscall
		addi $t1, $v0, 0
		sw $ra, 0($sp)
		jal FindElement				# tell the function FindElement
		lw $ra, ($sp)
		addu $sp, $sp, 4 
		j CHOOSE	

	#Print the Menu and choose the function 
	CHOOSE:
		li $v0, 4
		la $a0, Menu
		syscall
 
		li $v0, 4
		la $a0, Enter
		syscall
		
		li $v0, 5
		syscall
		move $t2, $v0
		
		bgt $t2, 6, CHOOSE
		blez $t2, CHOOSE
		la $t0, Array
		li $t1, 0
		beq $t2, 1, OutputArray
		beq $t2, 2, SumOfArray 
		beq $t2, 3, printPrimeElements
		beq $t2, 4, FindMax
		beq $t2, 5, FindElementArray
		beq $t2, 6, Exit
	#tell the system the end of the main funtion
	Exit:
		li $v0, 10
		syscall
				
