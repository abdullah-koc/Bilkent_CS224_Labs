.text

LoopOperation:

	li $v0, 4
	la $a0, operationText
	syscall
	
	li $v0, 5
	syscall
	
	beq $v0, 0, Exit
	beq $v0, 1, CreateArray
	beq $v0, 2, PrepareSymmetric
	beq $v0, 3, PrepareFindMinMax
	bge $v0, 4, Invalid
	bne $v0, 0, LoopOperation
	

Invalid:
	li $v0, 4
	la $a0, invalid
	syscall
	
	j LoopOperation
	
CreateArray:
	li $v0, 4
	la $a0, sizeText
	syscall

	jal getArray	#array operations

	#move return values to s6 and s7 temporarily
	move $s6, $v0	#array
	move $s7, $v1	#size of array
	
	j LoopOperation



PrepareSymmetric:
	move $a0, $s6
	move $a1, $s7
	jal CheckSymmetric
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, SymText
	syscall
	j LoopOperation
	
PrepareFindMinMax:
	move $a0, $s6
	move $a1, $s7
	jal FindMinMax
	
	move $a0, $v0
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	move $a0, $v1
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, minmaxValueText
	syscall
	
	j LoopOperation

Exit:
	li $v0, 10
	syscall
#---------------------------------------------------------------------
getArray:
	#loading array size
	li $v0, 5
	syscall
	
	move $s1, $v0		#size of the array
	
	beq $s1, $zero, EndProgram	#if array is empty, no need to calculation, therefore no need to return something, just print empty texts
	
	li $v0, 4
	la $a0, askText
	syscall


	mul $a0, $s1, 4		#memory size to be allocated
	
	li $v0, 9
	syscall
	
	move $s0, $v0		#start of the array is stored in $s0

	subi $sp, $sp, 12
	sw $ra, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
InputLoop:	#this loop gets values from the user
	subi $s1, $s1, 1
	
	li $v0, 5
	syscall
	
	sw $v0, 0($s0)
	
	
	addi $s0, $s0, 4
	bgt $s1, $zero, InputLoop
	
	#restore stack except for $ra value
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	li $v0, 4
	la $a0, elmText		#print text
	syscall
	
	#we need to pass array and size in a0 and a1
	move $a0, $s0
	move $a1, $s1

	jal PrintArray
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	#return values
	move $v0, $s0
	move $v1, $s1
	
	jr $ra
	
EndProgram:
	li $v0, 4
	la $a0, emptyText
	syscall
	
	li $v0, 10
	syscall
	
#---------------------------------------------------------------------	
	
PrintArray:
	#saving registers in the stack
	subi $sp, $sp, 16
	addi $s0, $a0, 0 	#s0 = array
	addi $s1, $a1, 0	#s1 = array size
	addi $s2, $zero, 0	#s2 = temporary array value
	
	sw $ra, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
LoopPrint:
	subi $s1, $s1, 1
	lw $s2, 0($s0)
	
	#printing the element
	li $v0, 1
	move $a0, $s2
	syscall
	
	li $v0, 4
	la $a0, space
	syscall
	
	addi $s0, $s0, 4
	
	
	bgt $s1, $zero, LoopPrint
	
	
	#restoring registers
	lw	$ra, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 16
	move $a0, $s0	
	
	
	jr $ra
	
#-------------------------------------------------------------------
CheckSymmetric:
	move $s2, $a0 #right side of the array will be stored in $s2
	subi $s2, $s2, 4
	addi $s5, $zero, 0 #temp index for loop
FindLastElement:
	addi $s5, $s5, 1
	addi $s2, $s2, 4
	blt $s5, $a1, FindLastElement
	bge $s5, $a1, DefineStack
	
DefineStack:
	subi $sp, $sp, 24
	addi $s3, $zero, 0	#s3 = temporary array value
	addi $s4, $zero, 0	#s4 = temporary reverse array value
	move $s5, $a1	#s5 = middle index
	div $s5, $s5, 2
	
	
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

Check:
	lw $s3, 0($s0)
	lw $s4, 0($s2)
	bne $s3, $s4, NotSymmetric #if elements are not equal, print not symmetric
	beq $s1, $s5, Symmetric #if all elements are equal, print symmetric
	subi $s1, $s1, 1
	subi $s2, $s2, 4
	addi $s0, $s0, 4
	beq $s3, $s4, Check
	
NotSymmetric:
	
	li $v0, 0 	#if not symmetric, return 0
	j Restore	
	
Symmetric:
	
	li $v0, 1 	#if symmetric, return 1
	j Restore
	
		
Restore:
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	
	addi $sp, $sp, 24
	
	jr $ra
#-----------------------------------------------------------------------

FindMinMax:
	#saving registers in the stack
	move $s0, $a0
	move $s1, $a1
	subi $sp, $sp, 20
	addi $s2, $zero, 0	#s2 = temporary array value
	lw $s3, 0($s0)		#s3 = min
	lw $s4, 0($s0)		#s4 = max
	
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
LoopMinMax:
	lw $s2, 0($s0)
	blt $s2, $s3, ChangeMin #if current value is smaller, change min
	bgt $s2, $s4, ChangeMax #if current value is larger, change max
	subi $s1, $s1, 1
	addi $s0, $s0, 4
	bgt $s1, $zero, LoopMinMax
	ble $s1, $zero, PrintMinMax
		

ChangeMin:
	lw $s3, 0($s0)
	j LoopMinMax

ChangeMax:
	lw $s4, 0($s0)
	j LoopMinMax


PrintMinMax:

	#return statements
	addi $v0, $s3, 0
	addi $v1, $s4, 0
	
	#restoring registers
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	
	addi	$sp, $sp, 20
	move $a0, $s0
	move $a1, $s1
	
	jr $ra
	
	

	
.data

askText: .asciiz "Please enter the elements: "
sizeText: .asciiz "Please enter the size of the array: "
elmText: .asciiz "The elements of array are: "
operationText: .asciiz "\nPlease enter the operation you want: 1 --> Create Array, 2 --> Check symmetry, 3 --> Find min-max, 0 --> Exit: "
minmaxValueText: .asciiz " are minimum and maximum values are respectively"
SymText: .asciiz " is the result of symmetric or not"
emptyText: .asciiz "The array is empty. Therefore, none of operations can be executed. Exitting the program..."
invalid: .asciiz "Invalid operation. "
space: .asciiz " "
comma: .asciiz ", "
line: .asciiz "-"
array: .word 1 2 3 4 
arraySize: .word 4
