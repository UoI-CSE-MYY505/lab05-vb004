# ----------------------------------------------------------------------------------------
# lab05.s 
#  Verifies the correctness of some aspects of a 5-stage pipelined RISC-V implementation
# ----------------------------------------------------------------------------------------

.data
storage:
    .word 1
    .word 10
    .word 11

.text
# ----------------------------------------------------------------------------------------
# prepare register values.
# ----------------------------------------------------------------------------------------
#  la breaks into 2 instructions, which have a data dependence. Ignore this 
    la   a0, storage
    addi s0, zero, 0
    addi s1, zero, 1
    addi s2, zero, 2
    addi s3, zero, 3

# ----------------------------------------------------------------------------------------
# Verify forwarding from the previous ALU instruction to input Op1 of ALU
# There should be no added delay here.
    addi t1,   s0, 1     
    add  t2,   t1, s2 
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# Verify load-use 1 cycle stall and correct passing of load's value
    lw   t3, 4(a0)
    add  t4, zero, t3   # t4 should be storage[1] = 10
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# Check how many cycles are lost due to pipe flush following a jump.
# Also verify that the instruction(s) following the jump are not executed (i.e. writing to a register)
    j    next
    add  t5, s1, s2
    add  t6, s1, s2
next:
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# Verify that no cycles are lost when a branch is NOT taken
    beq  s1, s2, next
    add  t5, s1, s2
    add  t6, s1, s3

# ----------------------------------------------------------------------------------------
# Check how many cycles are lost when a branch IS taken
    beq  s1, s1, taken
    add  t0, zero, s3
    add  t1, zero, s2
taken:

# ----------------------------------------------------------------------------------------
# TODO: Add an example where an instruction passes its result to the 2nd following instruction
# There should be no stalls
    add  t1, s0, s1   # t1 = 1
    add t2,s0,s2     # t2 = 2
    add  t3, t1, s3   # t3 = 4
# ----------------------------------------------------------------------------------------
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# TODO: Add an example with a double hazard and check that it works corretly.
# A double hazzard is when the source register of an instruction matches the destination
#  registers of both of the two instructions preceeding it. It should get the newest value.
# There should be no stalls
    add  t1, s0, s1   # t1 = 1
    add t1, s0, s2   # t1 = 2
    add  t3, t1, s3   # t3 = 5
# ----------------------------------------------------------------------------------------
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# TODO: Add an example with a load stalling for 1 cycle to pass a value to a NOT-TAKEN branch 
#  Is this a data hazard or a control hazard?
    lw   t3, 4(a0)
    beq  t3, zero, exit
# ----------------------------------------------------------------------------------------
    # nop instructions added between examples
    add  zero, zero, zero  
    add  zero, zero, zero  
    add  zero, zero, zero  

# ----------------------------------------------------------------------------------------
# TODO: Add an example with taken branch to a label which is immediately following the branch
    beq  zero, s0, nextInstr
nextInstr:
    add  t0, s1, s2 # How far does this make it to the pipeline? Is is fetched twice?
    add  t1, s2, s3 # How about this one?
# ----------------------------------------------------------------------------------------



exit:  
    addi      a7, zero, 10    
    ecall

