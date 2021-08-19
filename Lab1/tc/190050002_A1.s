.data

sizeprompt:
    .asciiz "Enter the size of the array:\n"

elemprompt:
    .asciiz "Enter the elements of the array:\n"

.text

main:

    # t1 will store prev, t2 will store now
    li $t3, 0 # i=0, iterator which will increment every time new element is read

    li $t4, 1 # answer = 1
    li $s1, 0 # sign function result now = 0
    # sign function's result previous will be stored in s0

    li $v0, 4 # print string
    la $a0, sizeprompt
    syscall
    li $v0 5 # read int (size of array)
    syscall
    move $t0, $v0 # store length of array in t0

    li $v0, 4 # print string
    la $a0, elemprompt
    syscall

    li $v0 5 # read int
    syscall
    move $t2, $v0 # store current read value in t2
    addi $t3, $t3, 1 # increment t3
    bne $t0, $t3, LOOP # continue in loop if more elements are to be read
    beq $t0, $t3, EXIT # exit from loop if all elements done

LOOP:

    move $s0, $s1 # update sign function previous result in s0
    move $t1, $t2 # update previous value t1

	li $v0 5 # read int 
    syscall
    move $t2, $v0 # read new value in t2
    # sub $t1, $t2, $t1 # store the difference of oprevious and new value in t1
    addi $t3, $t3, 1 # increment t3

    blt $t2, $t1, MINUS1 # if new element - previous element < 0, then sign function now = -1
    bgt $t2, $t1, PLUS1 # if new element - previous element > 0, then sign function now = +1

    bne $t0, $t3, LOOP # continue in loop if more elements are to be read
    beq $t0, $t3, EXIT # exit from loop if all elements done

ADD1:

    addi $t4, 1
    bne $t0, $t3, LOOP # continue in loop if more elements are to be read
    beq $t0, $t3, EXIT # exit from loop if all elements done
    
PLUS1:

    li $s1, 1
    bne $s0, $s1, ADD1 # if sign function changes value, increment answer by 1
    bne $t0, $t3, LOOP # continue in loop if more elements are to be read
    beq $t0, $t3, EXIT # exit from loop if all elements done

MINUS1:

    li $s1, -1
    bne $s0, $s1, ADD1 # if sign function changes value, increment answer by 1
    bne $t0, $t3, LOOP # continue in loop if more elements are to be read
    beq $t0, $t3, EXIT # exit from loop if all elements done

# #################Exiting#################
EXIT:

    li $v0, 1 # print answer
    move $a0, $t4
    syscall

	li $v0 10 # exit
	syscall


