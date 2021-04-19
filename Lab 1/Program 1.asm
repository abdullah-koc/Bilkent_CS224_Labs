.text

la $a1, array
lw $t2, arraySize
lw $t3, middleindex
lw $t8, temp
lw $t6, middletemp
move $t4, $a1
move $t3, $t2
div $t3, $t3, 2


showarray:    #printing the array
	lw $a0, 0($a1)
	li $v0, 1
	syscall
	
	li $v0, 4
     	la $a0, space
     	syscall
	
	addi $t8, $t8, 1
	addi $a1, $a1, 4
	beq $t8, $t2, putline
	blt $t8, $t2, showarray
	
putline:
	li $v0, 4
     	la $a0, newline
     	syscall
     	addi $a1, $a1, -4
     	j control
	

control:
	#comparing the element in left side and the element in right side
	lw $s2, 0($t4)
	lw $s3, 0($a1)
	
	
	addi $t6, $t6, 1
	
	bne $s2, $s3, notsymmetric #if one of elements is not symmetric, print not symmetric
	beq $t3, $t6, symmetric #if all elements are symmetric, print symmetric
	
	addi $a1, $a1, -4 #one element left from the end
	addi $t4, $t4, 4 #one element right from the beginning
	
	beq $s2, $s3, control
	
     	
notsymmetric:
	li $v0, 4
	la $a0, notsymtext
	syscall
	j out
	
	
symmetric:
	li $v0, 4
	la $a0, symtext
	syscall
	
out:
	li $v0, 10
	syscall



.data

array: .word 10, 20, 30, 30, 10 #defining array
arraySize: .word 5 #defining size of the array
temp: .word 0
middleindex: .word 0
middletemp: .word 0
symtext: .asciiz "The above array is symmetric"
notsymtext: .asciiz "The above array is not symmetric"
arrdisplay: .asciiz "Array: "
space: .asciiz " "
newline: .asciiz "\n"
