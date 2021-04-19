.text

li $v0, 4
la $a0, text1
syscall

li $v0, 5
syscall

move $a1, $v0 #number

li $v0, 4
la $a0, text2
syscall

li $v0, 5
syscall

move $s5, $v0 #pattern

li $v0, 4
la $a0, text3
syscall

li $v0, 5
syscall

move $a2, $v0 #pattern size



li $v0, 4
la $a0, textnumber
syscall

li $v0, 34
move $a0, $a1
syscall

li $v0, 4
la $a0, textpattern
syscall

li $v0, 34
move $a0, $s5
syscall

jal Calculate

move $a3, $v0

li $v0, 4
la $a0, textresult
syscall


move $a0, $a3
li $v0, 1
syscall

li $v0, 10
syscall

#------------------------------------------------------

Calculate:
	
	li $s0, 32 	#total number of bits
	
	li $s1, 32	#s1 will be 32 - pattern bit number
	sub $s1, $s1, $a2
	
	subi $sp, $sp, 8	#because this is only function in program, no need to have a stack
	sw $s1, 4($sp)		#but because this lab focuses on stacks, i put it
	sw $s0, 0($sp)
	
	li $v0, 0	#result
	li $s2, 0	#hold temp xor result
	
Loop:
	sub $s0, $s0, $a2
	
	xor $s2, $a0, $a1	#if the pattern is the same, xor result should be 0 for last $a2 bits
	sllv $s2, $s2, $s1	#shifting the result $s1 times, in order to get pattern bit result
	
	srlv $a1, $a1, $a2	#shift the original number by $a2
	bne $s2, 0, Continue
	beq $s2, 0, Increase	#if result is 0, it means that pattern is the same with $a2 bits of number, increase result by 1
Continue:
	bge $s0, $a2, Loop
	blt $s0, $a2, Finish
	
Increase:
	addi $v0, $v0, 1	#increase result by 1
	j Continue
	
Finish:
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	
	jr $ra			#return


.data

text1: .asciiz "Please enter the number: "
text2: .asciiz "Please enter the pattern: "
text3: .asciiz "Please enter the size of pattern: "
textnumber: .asciiz "Number is: "
textpattern: .asciiz "\nPattern is: "
textresult: .asciiz "\nNumber of occurrences are: "

number: .word -1
pattern: .word 255
patternlength: .word 8
