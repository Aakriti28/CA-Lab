.data
ssize: .space 16  

continue_ques:
    .asciiz "\nWish to continue?:"
yesorno:
    .asciiz "Y\n"
newline:
    .asciiz "\n"

parama:
    .asciiz "Enter a: "
multi:
    .asciiz "*"
modStart: 
    .asciiz " = 1 (mod "
paramm:
    .asciiz "Enter m: "
modEnd: 
    .asciiz ")"


.text

main:

    # print string "Enter a:"
    li $v0 4
    la $a0 parama
    syscall

    # take integer input a
    li $v0 5
    syscall
    move $a1 $v0

    # print string "Enter m:"
    li $v0 4
    la $a0 paramm
    syscall

    # take integer input m
    li $v0 5
    syscall
    move $a2 $v0
    move $s1 $a2

    # calculate modular inverse using recursive func
    jal recursiveInv

divideOp:
	div $t0 $s1
	li $v0 1
	mfhi $a0
	bgtz $a0  printResult

negToPostive:
	add $a0  $a0  $s1
	blez $a0  negToPostive

printResult:

    # print a
    move $s2 $a0
    li $v0 1
    move $a0 $a1
    syscall

    # print "*"
    li $v0 4
    la $a0 multi
    syscall

    # print result = modular inverse
    li $v0 1
    move $a0 $s2
    syscall

    # print " = 1 (mod "
    li $v0 4
    la $a0 modStart
    syscall

    # print m
    li $v0 1
    move $a0 $a2
    syscall

    # print ")"
    li $v0 4
    la $a0 modEnd
    syscall

    # loads wish to continue
    li $v0 4          
    la $a0  continue_ques  
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

exitAll:
    # exit otherwise
    li $v0 10 
    syscall

compareTwo:  
    add $t1 $zero $zero  
    add $t0 $zero $a0  
    add $t3 $zero $a1  

iterChars:  
    # load a byte from each ssize
    lb $t4($t0)           
    lb $t2($t3) 

    # string 1 end
    beqz $t4 checkt2      
    beqz $t2 charNoteq  

    # compare two bytes 
    slt $t6 $t4 $t2      
    bnez $t6 charNoteq 

    # t0 points to the next byte of string 1 
    addi $t0 $t0 1        
    addi $t3 $t3 1  
    j iterChars  

charNoteq:   
    addi $v0 $zero 1  
    j endFunc  
    
checkt2:  
    bnez $t2 charNoteq  
    add $v0 $zero $zero  

endFunc:  
    jr $ra

toCont:
    li $v0 4
    la $a0 newline
    syscall
    j main
	
	
recursiveInv:

    # for stack space
	addi $sp  $sp  -12
	sw $ra ($sp)
	sw $a1 4($sp) # stores a
	sw $a2 8($sp) # stores m
	
    # basecase if a = 0
	beqz $a2  basecase

    # basecase if a = 1
    # addi $t5 $a2 -1
	# beqz $t5  basecase
	
	div $a1  $a2
	move $a1  $a2
	mfhi $a2
	
	jal recursiveInv
	lw $a1 4($sp)
	lw $a2 8($sp)
	
    # updating registers
	move $t2 $t0
	move $t0 $t3
	move $t3 $t2
	
    # subtract q*d to get r
	div $a1 $a2
	mflo $t4
	mul $t4 $t4 $t0
	mul $t4 $t4 -1
	add $t3 $t3 $t4
	mul $t4 $t4 -1
	j ret
	
basecase:
	li $t0 1
	li $t3 0
	
ret:
	lw $ra  ($sp)
	addi $sp  $sp  12
	jr $ra

# string comparison reference from - https://stackoverflow.com/questions/37638391/mips-comparing-a-string-taked-in-input-with-a-stored-string
    
    