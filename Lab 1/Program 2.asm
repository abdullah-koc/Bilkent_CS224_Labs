.text

#displaying first message
li $v0, 4
la $a0, info
syscall

#asking a,b,c and d

#a
li $v0, 5
syscall
add $t0, $v0, 0
	
#b
li $v0, 5
syscall
add $t1, $v0, 0

#c
li $v0, 5
syscall
add $t2, $v0, 0

#d	
li $v0, 5
syscall
add $t3, $v0, 0

#result text
li $v0, 4
la $a0, res
syscall

#calculation
sub $t4, $t1, $t2 #subtraction
mult $t0, $t4 #multiplication
mflo $t5 #getting multiplication result
div $t5, $t3 #division
mfhi $t7 #getting remainder (modulo)
bge $t7, $zero, print
blt $t7, $zero, makepositive #if the modulo is negative, make positive

makepositive: #adds d until the result >= 0
	add $t7, $t7, $t3
	blt $t7, $zero, makepositive
	bge $t7, $zero, print

print:
	#printing result
	li $v0, 1
	move $a0, $t7
	syscall
	
	#exit
	li $v0, 10
	syscall







.data

info: .asciiz "a * ( b - c ) % d will be calculated\nPlease enter a,b,c,d\n"

res: .asciiz "The result is " 
