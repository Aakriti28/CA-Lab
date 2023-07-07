.data
ssize: .space 16  

continue_ques:
    .asciiz "\nWish to continue?:"
yesorno:
    .asciiz "Y\n"
newline:
    .asciiz "\n"

param_n:
    .asciiz "Enter n: "
choice:
    .asciiz "C"
param_r:
    .asciiz "Enter r: "
colon: 
    .asciiz ": "

.text


init:
   move $t3 $zero
   addi $t3 $t3 1

nCk:
    addi $sp $sp -16
    sw $ra 8($sp)
    sw $a1 4($sp)
    sw $a0 ($sp)

    # n != r and r>0
    slt $t3 $zero $a1
    slt $t2 $a0 $a1
    slt $t5 $a1 $a0

    add $t2 $t2 $t5
    add $t2 $t2 $t3

    move $t0 $zero
    addi $t0 $t0 1

    # if n != r and r>0, then recruse
    bne $t0 $t2 nMnius1

    move $v1 $t0
    addi $sp $sp 16
    jr $ra

nMnius1:
    # call function for (n-1)Cr
    addi $a0  $a0  -1
    jal nCk

    lw $a0 ($sp)
    lw $a1 4($sp)
    sw $v1 12($sp)

    # call function for (n-1)C(r-1)
    addi $a1 $a1  -1
    addi $a0 $a0  -1
    jal nCk

    # add (n-1)Cr + (n-1)C(r-1) and store return val in v1
    lw $t4 12($sp)
    add $v1 $t4 $v1

    # restore registers
    lw $a0 ($sp)
    lw $a1 4($sp)
    lw $ra 8($sp)

    addi $sp $sp 16
    jr $ra



main:
    # print "Enter n:"
    li $v0 4
    la $a0 param_n
    syscall

    # read input n and store in t1
    li $v0 5
    syscall
    move $t1 $v0

    # print "Enter r:"
    li $v0 4
    la $a0 param_r
    syscall

    # read input n and store in a1
    li $v0 5
    syscall
    move $a1 $v0

    # copy n to a0
    move $a0 $t1

    # claa the recursive fucntion
    jal nCk

    # print n
    li $v0 1
    syscall

    # print C
    li $v0 4
    la $a0 choice
    syscall

    # print r
    li $v0 1
    move $a0 $a1
    syscall

    # print ": "
    li $v0 4
    la $a0 colon
    syscall

    # print result nCr
    li $v0 1
    move $a0 $v1
    syscall

wishtoCont:

    # Print wish to continue
    li $v0 4        
    la $a0 continue_ques  
    syscall

    # take string input
    li $v0 8
    la $a0 ssize
    addi $a1 $zero 16
    syscall 

    # compare strings to see if Y is recieved or N
    la $a0 ssize
    la $a1 yesorno        
    jal compareTwo

    # continue if Y
    beq $v0 $zero toCont

    # exit otherwise
    li $v0 10
    syscall


compareTwo:  
    add $t1 $zero $zero  
    add $t0 $zero $a0  
    add $t3 $zero $a1  

iterChars:  
    # load a byte from each ssize 
    lb $t2($t0)          
    lb $t5($t3) 

    # string 1 end  
    beqz $t2 checkt5    
    beqz $t5 charNoteq  

    # compare two bytes 
    slt $t4 $t2 $t5      
    bnez $t4 charNoteq 

    # t0 points to the next byte of string 1 
    addi $t0 $t0 1        
    addi $t3 $t3 1  
    j iterChars  

charNoteq:   
    addi $v0 $zero 1  
    j endFunc  
    
checkt5:  
    bnez $t5 charNoteq  
    add $v0 $zero $zero  

endFunc:  
    jr $ra

toCont:
    li $v0 4
    la $a0 newline
    syscall
    j main

# string comparison reference from - https://stackoverflow.com/questions/37638391/mips-comparing-a-string-taked-in-input-with-a-stored-string

    