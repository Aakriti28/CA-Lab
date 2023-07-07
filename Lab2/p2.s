.text
main:
	li $v0, 5
	syscall
	move $a1, $v0

	li $v0, 5
	syscall
	move $a2, $v0

	move $s1, $a2

	jal calc

op:
	div $t1, $s1
	li $v0, 1
	mfhi $a0
	bgtz $a0, end

makepos:
	add $a0, $a0, $s1
	blez $a0, makepos

end:
	syscall
	li $v0, 10
	syscall

calc:
	addi $sp, $sp, -12
	sw $ra, ($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	beqz $a2, base
	
	div $a1, $a2
	move $a1, $a2
	mfhi $a2
	
	jal calc
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	
	move $t4, $t1
	move $t1, $t2
	move $t2, $t4
	
	div $a1, $a2
	mflo $t3
	mul $t3, $t3, $t1
	mul $t3, $t3, -1
	add $t2, $t2, $t3
	mul $t3, $t3, -1
	j ret
	
base:
	li $t1, 1
	li $t2, 0
	
ret:
	lw $ra, ($sp)
	addi $sp, $sp, 12
	jr $ra