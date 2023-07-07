.text
main:
    li t0 45 
    li t1 45 
    li a0 45 
    add t0 t0 t1
    li a7 45 
    add a0 a0 t0
    li t1 45
    li t0 45
    add a7 a7 t1
    add a0 a0 t0
    li t1 45
    li t0 45
    add a0 a0 a7
    add t0 t0 t1
    li a7 45
    li t1 45
    add a0 a0 t0
    add t1 a7 t1
    li a7 1
    add a0 a0 t1
    ecall
    
    