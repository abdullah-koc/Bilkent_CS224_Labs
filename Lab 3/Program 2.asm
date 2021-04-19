#this program finds the division of a positive number by another positive number
#by successive subtractions using recursion in a subprogram
.text

StartLoop:
	li $v0, 4
	la $a0, text0			#asking operation text
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 0, Exit		#if operation = 0, exit the program
	beq $v0, 1, MakeCalculation	#if operation = 1, ask numbers
	
	li $v0, 4
	la $a0, text4			#if operation is not 0 or 1, print invalid value text, and go back to the asking operation
	syscall
	j StartLoop
	

MakeCalculation:
	li $v0, 4
	la $a0, text1			#asking the number to be divided
	syscall
	
	li $v0, 5
	syscall
	
	move $s0, $v0			#moving dividend to s0 temporarily
	
	li $v0, 4
	la $a0, text2			#asking divider
	syscall
	
	li $v0, 5
	syscall
	
	move $a1, $v0
	beq $a1, 0, DivideError		#if divider is 0, print an error message and go back to the menu
	
	move $a0, $s0
	
	li $v0, 0			#result will be stored in $v0
	
	jal Calculate
	
	move $s0, $v0			#after calculation, move result to s0 temporarily
	
	li $v0, 4
	la $a0, text3			#result text
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	j StartLoop			#back to the main menu
	
DivideError:
	li $v0, 4
	la $a0, text5			#print cannot divide by 0 message
	syscall
	
	j StartLoop			#back to the main menu
	
Exit:
	li $v0, 10			#exit
	syscall



Calculate:				#result will be stored in $v0

	subi $sp, $sp, 4		#store $ra in stack
	sw $ra, 0($sp)
	
	blt $a0, $a1, Finish		#when dividend becomes smaller than divider, end the recursion
	
	sub $a0, $a0, $a1		#subtract divider from the dividend
	addi $v0, $v0, 1		#add result 1
	
	jal Calculate			#recursion

Finish: 
	lw $ra, 0($sp)			#restore stack and $ra 
	addi $sp, $sp, 4
	
	jr $ra				#finish the subprogram




.data

text0: .asciiz "\nPlease enter the operation you  want: 1 --> Division calculation,   0 --> Exit: "
text1: .asciiz "Please enter the number you want to divide: "
text2: .asciiz "Please enter the divider: "
text3: .asciiz "Result: "
text4: .asciiz "Invalid operation.\n"
text5: .asciiz "You cannot divide a number with 0."