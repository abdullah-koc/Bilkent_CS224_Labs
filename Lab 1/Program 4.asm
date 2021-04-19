.text

#displaying first message
li $v0, 4
la $a0, info
syscall


#asking b, c and d

#b
li $v0, 5
syscall
add $t0, $v0, 0
beq $t0, $zero, displayerror #B cannot be 0 because it is denominator
bne $t0, $zero, continue

displayerror:
	li $v0, 4
	la $a0, error
	syscall
	j exit


continue:
	#c
	li $v0, 5
	syscall
	add $t1, $v0, 0

	#d	
	li $v0, 5
	syscall
	add $t2, $v0, 0

	#result text
	li $v0, 4
	la $a0, res
	syscall

	#calculation

	mult $t0, $t1
	mflo $t3 #$t3 = b * c -32

	div $t4, $t2, $t0 #$t4 = d / b 

	sub $t5, $t3, $t4 #t5 = b*c - d/b 

	sub $t6, $t5, $t1 #$t6 = b*c - d/b - c 

	div $t6, $t0
	mfhi $t7
	
	bge $t7, $zero, print
	blt $t7, $zero, makepositive #if the modulo is negative, make positive
	
makepositive: 
	#adds abs(b) until the result >= 0
	abs $s0, $t0
	add $t7, $t7, $s0
	blt $t7, $zero, makepositive
	bge $t7, $zero, print
	

print:
	#printing the result

	li $v0, 1
	move $a0, $t7
	syscall

	#explanation

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, info2
	syscall

	li $v0, 1
	move $a0, $t3
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, info3
	syscall

	li $v0, 1
	move $a0, $t4
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, info4
	syscall

	li $v0, 1
	move $a0, $t5
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, info5
	syscall

	li $v0, 1
	move $a0, $t6
	syscall

	li $v0, 4
	la $a0, newline
	syscall

	li $v0, 4
	la $a0, info6
	syscall

	li $v0, 1
	move $a0, $t7
	syscall

	#exit
exit:

	li $v0, 10
	syscall




.data

info: .asciiz "(B * C - D / B - C ) % B will be calculated\nPlease enter B, C and D subsequently:\n"
info2: .asciiz "Explanation:   B * C is "
error: .asciiz "Error, B cannot be 0"
info3: .asciiz "D / B is "
info4: .asciiz "B * C - D / B is "
info5: .asciiz "B * C - D / B - C is "
info6: .asciiz "B * C - D / B - C mod B is "
newline: .asciiz "\n"
res: .asciiz "Result: "
