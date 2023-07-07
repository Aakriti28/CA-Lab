.data
ssize: .space 20  

continue_ques:
    .asciiz "\nWish to continue?:"
yesorno:
    .asciiz "Y\n"
newline:
    .asciiz "\n"

param_n:
    .asciiz "Enter n:"
choice:
    .asciiz "C"
param_r:
    .asciiz "Enter r:"
colon: 
    .asciiz ": "

.text


init:
   move $t2 $zero
   addi $t2 $t2 1

nCk:
    addi $sp $sp -16
    sw $ra, 8($sp)
    sw $a1, 4($sp)
    sw $a0, 0($sp)
    move $t1 $zero
    # n != r and r>0
    slt $t2 $zero $a1
    slt $t3 $a0 $a1
    slt $t4 $a1 $a0
    add $t3 $t3 $t4
    add $t3 $t3 $t2


    addi $t1 $t1 1
    bne $t1 $t3 recurse
    #addi $t1 $t1 1
    move $v1 $t1
    addi $sp $sp 16
    jr $ra

recurse:
    addi $a0, $a0, -1
    jal nCk
    lw $a0 0($sp)
    lw $a1 4($sp)
    sw $v1 12($sp)
    addi $a0, $a0, -1
    addi $a1, $a1, -1
    jal nCk
    lw $t5 12($sp)
    add $v1 $t5 $v1
    lw $a0 0($sp)
    lw $a1 4($sp)
    lw $ra 8($sp)
    addi $sp $sp 16
    jr $ra



main:
    # print "Enter n:"
    li $v0 4
    la $a0 param_n
    syscall

    # read input n and store in a0
    li $v0 5
    syscall
    move $a0 $v0

    # print "Enter r:"
    li $v0 4
    la $a0 param_r
    syscall

    # read input n and store in a1
    li $v0 5
    syscall
    move $a1 $v0
    move $t0 $a0

    # recursive function called
    jal nCk
    
    li $v0 1
    # move $a0 $v1
    syscall
    li $v0 4
    la $a0 choice
    syscall
    li $v0 1
    move $a0 $a1
    syscall
    li $v0 4
    la $a0 colon
    syscall
    li $v0 1
    move $a0 $v1
    syscall
    li $v0,4        
    la $a0,continue_ques  
    syscall
    li $v0,8
    la $a0,ssize
    addi $a1,$zero,20
    syscall 
    la $a0, ssize
    la $a1, yesorno        
    jal methodComp
    beq $v0 $zero tocontinue
    li $v0 10 # exit
    syscall


methodComp:  
    add $t0,$zero,$zero  
    add $t1,$zero,$a0  
    add $t2,$zero,$a1  

loop:  
    lb $t3($t1)         # load a byte from each ssize  
    lb $t4($t2)  
    beqz $t3,checkt2    # str1 end  
    beqz $t4,character_ne  
    slt $t5,$t3,$t4     # compare two bytes  
    bnez $t5,character_ne  
    addi $t1,$t1,1      # t1 points to the next byte of str1  
    addi $t2,$t2,1  
    j loop  

character_ne:   
    addi $v0,$zero,1  
    j endfunction  
    
checkt2:  
    bnez $t4,character_ne  
    add $v0,$zero,$zero  

endfunction:  
    jr $ra

tocontinue:
    li $v0 4
    la $a0 newline
    syscall
    j main
    