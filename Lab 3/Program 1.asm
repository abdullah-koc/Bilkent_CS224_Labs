#this program calculates the add and lw instructions between labels
.text

Example:	#this part consists of example codes for counting add and lw
	addi $t1, $t2, 3
	la $t0, examplearray
	lw $t2, 0($t0)
	lw $t3, 4($t0)
	lw $t3, 8($t0)
	add $t2, $t2, $t3
	add $t2, $t2, $t3
	add $t2, $t2, $t3
	add $t2, $t2, $t3
	
	
End:
	#loading main labels in a0 and a1
	la $a0, Example
	la $a1, End
	jal Calculate	#calculation
	
	move $s6, $v0	#move return value to s6 temporarily
	li $v0, 4
	la $a0, noOfAdd	#text
	syscall
	
	li $v0, 1
	move $a0, $s6	#print number of add operations
	syscall
	
	li $v0, 4
	la $a0, noOfLw	#text
	syscall
	
	li $v0, 1
	move $a0, $v1	#print number of lw operations
	syscall
	
	#load labels of subprogram
	la $a0, Calculate
	la $a1, Finish
	
	#make counters 0
	li $s1, 0
	li $s4, 0
	
	jal Calculate	#calculation
	
	move $s6, $v0
	li $v0, 4
	la $a0, noOfAdd	#text
	syscall
	
	li $v0, 1
	move $a0, $s6	#print number of add operations
	syscall
	
	li $v0, 4
	la $a0, noOfLw	#text
	syscall
	
	li $v0, 1
	move $a0, $v1	#print number of lw operations
	syscall
	
	li $v0, 10	#exit
	syscall

Calculate:
	
	move $s0, $a0	#duplicate a0 for add and lw operations
	
LoopAdd:
	lw $s2, 0($s0)	#load the instruction
	lw $s3, 0($s0)	#load the instruction
	srl $s2, $s2, 26	#rightshift 26 bits for opcode of add
	beq $s2, 0, ContinueAdd	#if opcode is 0, check function code
	addi $s0, $s0, 4	#next instruction
	bne $s0, $a1, LoopAdd	
	beq $s0, $a1, LoopLw	#if all instructions are checked, go to checking lw instructions
	
ContinueAdd:
	
	#shift 26 bit left and right for function code
	sll $s3, $s3, 26
	srl $s3, $s3, 26
	
	beq $s3, 32, IncrementAdd	#if function code is 32 (20 in hex), increase add counter
	addi $s0, $s0, 4	#next instruction
	beq $s0, $a1, LoopLw
	j LoopAdd
	
	
IncrementAdd:
	addi $s1, $s1, 1	#no of add nstruction
	addi $s0, $s0, 4	#next instruction
	beq $s0, $a1, LoopLw
	j LoopAdd
	
	
LoopLw:
	lw $s2, 0($a0)	#load the instruction
	srl $s2, $s2, 26		#shift 26 bit right for opcode of lw
	beq $s2, 35, IncrementLw	#if opcode is 35 (23 in hex), increase lw counter
	addi $a0, $a0, 4	#next instruction
	bne $a0, $a1, LoopLw
	beq $a0, $a1, Finish	#if all instructions are checked, finish the code
	
IncrementLw:
	addi $s4, $s4, 1	#no of lw instruction
	addi $a0, $a0, 4
	beq $a0, $a1, Finish
	j LoopLw

Finish:
	move $v0, $s1	#return number of add operations in $v0
	
	move $v1, $s4	#return number of lw operations in $v1
	
	jr $ra

.data

noOfAdd: .asciiz "\nNumber of add operations in the function = "
noOfLw: .asciiz "\nNumber of lw operations in the function = "

examplearray: .word 10 20 30 40 #an example array for lw instruction