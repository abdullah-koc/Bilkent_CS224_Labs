.text

la $t0, array
move $a1, $t0
lw $t1, arraySize

addi $t2, $zero, 0 #sum will be stored in $t2
#average will be stored in $f12
lw $t4, 0($t0)     #min will be stored in $t4
lw $t5, 0($t0)     #max will be stored in $t5

addi $t6, $zero, 0 #current index will be stored in $t6

li $v0, 4
la $a0, text
syscall


calculate:
	lw $t7, 0($t0)
	blt $t7, $t4, changemin #if current value is smaller, change min
	bgt $t7, $t5, changemax #if current value is larger, change max
	add $t2, $t2, $t7 #add the elements of array
	addi $t6, $t6, 1
	addi $t0, $t0, 4
	blt $t6, $t1, calculate
	beq $t6, $t1, calculateavg #when loop ends, calculate average
	

changemin:
	lw $t4, 0($t0)
	j calculate
	
changemax:
	lw $t5, 0($t0)
	j calculate

calculateavg: #calculates average with decimals
	mtc1 $t2, $f12
	mtc1 $t1, $f2
	div.s $f12, $f12, $f2
	j printresult
	

printresult: #address and value table
	li $v0, 34
	la $a0, 0($a1)
	syscall	
	
	li $v0, 4
	la $a0, space
	syscall
	
	li $v0, 1
	lw $s1, 0($a1)
	move $a0, $s1
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	addi $a1, $a1, 4
	addi $s2, $s2, 1
	blt $s2, $t1, printresult
	beq $s2, $t1, quit

quit: #print avg, min and max

	li $v0, 4
	la $a0, average
	syscall
	
	li $v0, 2
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, maximum
	syscall
	
	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, minimum
	syscall
	
	li $v0, 1
	move $a0, $t4
	syscall
	
	
	#exit
	li $v0, 10
	syscall



.data 

text: .asciiz "Memory Address Position    Array Element Value\n"  #46 characters
array: .word 5, 20, 10, 100, 3, 0, 3123 #defining array
arraySize: .word 7 #defining size of the array
space: .asciiz "                 "
newline: .asciiz "\n"
average: .asciiz "Average: "
maximum: .asciiz "Max: "
minimum: .asciiz "Min: "
