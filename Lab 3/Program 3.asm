#printng data of linkedlist reversely by recursion
	.text
# CS224 Spring 2021, Program to be used in Lab3
# February 23, 2021
# 	
	li $v0, 4
	la $a0, enterSizeText
	syscall
	
	li $v0, 5
	syscall
	
	move $a0, $v0
		
	beq $a0, 0, Exit
	
	jal	createLinkedList
	move $s6, $v0
	
	li $v0, 4
	la $a0, introText
	syscall
		
	li $v0, 5
	syscall
			
	beq $v0, 1, PrintPrepare
	beq $v0, 2, PrintReversePrepare
	beq $v0, 0, Exit
	
	bne $v0, 0, Invalid
	bne $v0, 1, Invalid
	bne $v0, 2, Invalid
	
	Invalid:
		li $v0, 4
		la $a0, invalidText
		syscall
		
		j Exit
		

	PrintPrepare:
		move $a0, $s6
		jal printLinkedList
		j Exit
	PrintReversePrepare:
		move $a0, $s6
		jal	printReverse
		j Exit
		
		
	Exit:	
	# Stop. 
		li	$v0, 10
		syscall

createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	move $s7, $a0

	la $a0, enterText
	li $v0, 4
	syscall
	
	move $a0, $s7
	
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	move $s7, $a0
	
	li $v0, 5
	syscall
	
	move $s4, $v0
	move $a0, $s7
	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.
	
	move $s7, $a0
	
	li $v0, 5
	syscall
	
	move $s4, $v0
	move $a0, $s7
			
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$s4, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	move 	$s7, $a0
	addi	$sp, $sp, -24
	sw	$s7, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	lw 	$s7, 20($sp)
	addi	$sp, $sp, 24
	move $v0, $s7
	jr	$ra
#=========================================================	

printReverse:
	addi $sp, $sp, -16
	sw $s3, 12($sp)	#node number
	sw $s0, 8($sp)	#value
	sw $a0, 4($sp)	#address
	sw $ra, 0($sp)
	bne $a0, 0, Reverse
	
	addi $sp, $sp, 16
	jr $ra

Reverse:
	addi $s3, $s3, 1	#increase node number
	lw $a0, 0($a0)		#go to next node
	
	jal printReverse
	
	move $s0, $a0
	
	sw $s0, 8($sp)
	
	#restore
	lw $s3, 12($sp)
	lw $a0, 4($sp)	#restore a0
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	
	move $s4, $a0
	
	li $v0, 4
	la $a0, nodeNumberLabel
	syscall
	
	addi $a0, $s3, 1
	li $v0, 1	#node number
	syscall
	
	li $v0, 4
	la $a0, dataValueOfCurrentNode
	syscall
	
	move $a0, $s0
	lw $a0, 4($sp)	#restore a0
	
	li $v0, 1
	lw $a0, 4($s4)	#current value to be printed
	syscall
	
	move $v0, $s0
	
	jr $ra
			
	.data
line:	
	.asciiz "\n--------------------------------------"

nodeNumberLabel:
	.asciiz	"\nNode No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\nAddress of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\nAddress of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\nData Value of Current Node: "

reversetext:
	.asciiz "\n\nThe array elements in reverse order:"	
	
introText:
	.asciiz "Please enter the operation: 1 --> Print list, 2 --> Print list in reverse order, 0 --> Exit: "	
	
invalidText:
 	.asciiz "Invalid operation, exitting the program..."
 	
enterSizeText:
 	.asciiz "Please enter the size of linkedlist: "

enterText:
	.asciiz "Please enter the elements\n"	


