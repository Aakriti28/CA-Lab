.data
string_inputn:
    .asciiz "Enter a:"
string_inputr:
    .asciiz "Enter m:"
string_c:
    .asciiz "*"
string_left: 
    .asciiz " = 1 (mod "
string_right: 
    .asciiz ")"

write:
    .asciiz "\nWish to continue?:"

string_yes:
    .asciiz "Y\n"

break_string:
    .asciiz "\n"

string: .space 20  

.text

main:
    li $v0 4
    la $a0 string_inputn
    syscall
    li $v0 5
    syscall
    move $a1 $v0

    li $v0 4
    la $a0 string_inputr
    syscall
    li $v0 5
    syscall
    move $a2 $v0

    move $s1 $a2
    jal calc

# op
	div $t1, $s1
	li $v0, 1
	mfhi $a0
	bgtz $a0, end

makepos:
	add $a0, $a0, $s1
	blez $a0, makepos

end:

    move $t8 $a0
    li $v0 1
    move $a0 $a1
    syscall

    li $v0 4
    la $a0 string_c
    syscall

    li $v0 1
    move $a0 $t8
    syscall

    li $v0 4
    la $a0 string_left
    syscall
    li $v0 1
    move $a0 $a2
    syscall
    # answer printed
    li $v0 4
    la $a0 string_right
    syscall

toContinue:

    li $v0,4        # loads wish to continue  
    la $a0, write  
    syscall
    li $v0,8
    la $a0,string
    addi $a1,$zero,20
    syscall 
    la $a0,string
    la $a1,string_yes         #pass address of str2  
    jal methodComp
    beq $v0 $zero ok
    li $v0 10 # exit
    syscall



methodComp:  
    add $t0,$zero,$zero  
    add $t1,$zero,$a0  
    add $t2,$zero,$a1  

loop:  
    lb $t3($t1)         #load a byte from each string  
    lb $t4($t2)  
    beqz $t3,checkt2    #str1 end  
    beqz $t4,missmatch  
    slt $t6,$t3,$t4     #compare two bytes  
    bnez $t6,missmatch  
    addi $t1,$t1,1      #t1 points to the next byte of str1  
    addi $t2,$t2,1  
    j loop  

missmatch:   
    addi $v0,$zero,1  
    j endfunction  
    
checkt2:  
    bnez $t4,missmatch  
    add $v0,$zero,$zero  

endfunction:  
    jr $ra

ok:
    li $v0 4
    la $a0 break_string
    syscall
    j main
	
	
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

    
    