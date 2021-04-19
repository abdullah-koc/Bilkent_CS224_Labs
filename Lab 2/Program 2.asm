#this program reverses a number and prints result as hexadecimal

.text 

#displaying first message
li $v0, 4
la $a0, info
syscall

li $v0, 5
syscall


move $a0, $v0

jal Reverse


move $a0, $v0	#get result from return value v0
li $v0, 34
syscall

li $v0, 4
la $a0, info2
syscall

li $v0, 10	#exit
syscall

Reverse:
	li $s0, 31 #number of loop - 1 (it loops 32 times)
	add $v0, $zero, $zero #result will be stored in $v0 (Return value)
	
	#define stack
	subi $sp, $sp, 8
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
Loop:
	subi $s0, $s0, 1
	
	and $s1, $a0, 1		#getting lsb
	
	xor $v0, $v0, $s1	#adding it to the result
	
	sll $v0, $v0, 1		#shift result 1 bit left
	
	srl $a0, $a0, 1		#shift input 1 bit right
	
	bgt $s0, $zero, Loop
	
	#restore stack
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra


.data
info: .asciiz "Please enter the number you want to reverse: "
info2: .asciiz " is the reversed value in hex format."
