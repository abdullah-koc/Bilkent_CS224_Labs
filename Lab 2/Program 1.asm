#this program does operations on array

.text

#loading array size
lw $a1, arraySize
beq $a1, $zero, Empty	#if array is empty, no need to calculation, therefore no need to return something, just print empty texts


#showing introduction text
li $v0, 4
la $a0, introText
syscall

#loading array
la $a0, array

move $s4, $a0 	#array address is temporarily loaded to $s4

jal PrintArray

jal CheckSymmetric

#symmetry result
move $a0, $v0
li $v0, 1
syscall

la $a0, array	#a0 is used for printing symmetry result, load array to $a0 again

jal FindMinMax

#printing min and max values respectively
move $a0, $v0	#min
li $v0, 1
syscall

la $a0, comma
li $v0, 4
syscall

move $a0, $v1	#max
li $v0, 1
syscall


li $v0, 10	#exit
syscall

#---------------------------------------------------------------------
PrintArray:
	#saving registers in the stack
	subi $sp, $sp, 12
	addi $s0, $a0, 0 	#s0 = array
	addi $s1, $a1, 0	#s1 = array size
	addi $s2, $zero, 0	#s2 = temporary array value
	
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
	beq $s1, $zero, RestorePrint
	
RestorePrint:
	
	#restoring registers
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	addi	$sp, $sp, 12
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
	move $s5, $s1		#s5 = middle index
	div $s5, $s5, 2
	
	
	sw $s5, 20($sp)
	sw $s4, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

Check:
	beq $s1, 1, Symmetric
Check2:
	lw $s3, 0($s0)
	lw $s4, 0($s2)
	bne $s3, $s4, NotSymmetric #if elements are not equal, print not symmetric
	beq $s1, $s5, Symmetric #if all elements are equal, print symmetric
	subi $s1, $s1, 1
	subi $s2, $s2, 4
	addi $s0, $s0, 4
	beq $s3, $s4, Check2
	
NotSymmetric:
	
	li $v0, 4
	la $a0, SymText
	syscall
	
	li $v0, 0 	#if not symmetric, return 0
	j Restore	
	
Symmetric:

	li $v0, 4
	la $a0, SymText
	syscall
	
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
	move $a0, $s0
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
	
	li $v0, 4
	la $a0, minmaxValueText
	syscall

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
#------------------------------------------------------------
Empty:
	li $v0, 4
	la $a0, emptyText
	syscall
	
	li $v0, 4
	la $a0, SymText
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, minmaxValueText
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 4
	la $a0, comma
	syscall
	
	li $v0, 4
	la $a0, line
	syscall
	
	li $v0, 10
	syscall
	
#-------------------------------------------------------------

	
.data


introText: .asciiz "The elements of array are: "
minmaxValueText: .asciiz "\nMinimum and maximum values are respectively: "
SymText: .asciiz "\nSymmetric or not: "
emptyText: .asciiz "The array is empty."
space: .asciiz " "
comma: .asciiz ", "
line: .asciiz "-"
array: .word 10 20 30 40 30 20 10
arraySize: .word 7
