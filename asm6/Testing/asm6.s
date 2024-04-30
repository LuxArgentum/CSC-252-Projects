.data   

PROMPT:         .asciiz "Guess a number between 0 and 9: \n"
NOT_READY_MSG:  .asciiz "Ready bit is zero, looping until I find something else...\n"
CORRECT:        .asciiz "Correct!\n"
LESS:           .asciiz "Guess larger!\n"
MORE:           .asciiz "Guess smaller!\n"
NEWLINE:		.asciiz "\n"

.text   

main:           
    # Random Number Generator

    # Use syscall 42 to get a random number (enter range into $a1)

    addi    $v0,        $zero,      42
    addi    $a1,        $zero,      10
    add     $a0,        $zero,      $zero
    syscall 

    add     $s0,        $a0,        $zero

    # Prompt user to guess a number

    addi    $v0,        $zero,      4
    la      $a0,        PROMPT
    syscall 

	# Print the random number for debugging purposes

    addi    $v0,        $zero,      1
    add     $a0,        $s0,        $zero
    syscall 

	addi   $v0,        $zero,      4
	la     $a0,        NEWLINE
	syscall

    # Save prompt to address for display (0xffff000c)

    #     la      $t0,        PROMPT
    # 	lw 		$t0, 		0($t0)

    # prompt_loop:

    #     lui     $t1,        0xffff

    # polling:

    # 	beq     $t0, 	  	$zero,          KEYBOARD

    #     lw      $t2,        8($t1)
    #     andi    $t2,        $t2,            0x0001
    #     beq     $t2,        $zero,          polling
    #     sw      $t0,        0xc($t1)

    # 	addi    $t0,		$t0,            1

    #     j 	 	prompt_loop

KEYBOARD:       

    # Keyboard I/O

    lui     $t0,        0xffff

    addi    $t8,        $zero,      1
    sll     $t8,        $zero,      20                                                  # LOOP_COUNT = 2^20

OUTER_LOOP:     
    lw      $t1,        0($t0)                                                          # read control register
    andi    $t1,        $t1,        0x1                                                 # mask off all but bit 0 (the 'ready' bit)

    bne     $t1,        $zero,      READY

    # # print_str(NOT_READY_MSG)
    # addi    $v0,        $zero,          4
    # la      $a0,        NOT_READY_MSG
    # syscall

NOT_READY_LOOP: 
    lw      $t1,        0($t0)                                                          # read control register
    andi    $t1,        $t1,        0x1                                                 # mask off all but bit 0 (the 'ready' bit)
    beq     $t1,        $zero,      NOT_READY_LOOP

READY:          
    # read the actual typed character
    lw      $t1,        4($t0)                                                          # read data from register 0xffff0004
	
	addi   	$t1,        $t1,        -48                                                	# convert to ASCII

    beq     $t1,        $s0,        DONE

    slt     $t2,        $t1,        $s0

    beq     $t2,        $zero,      CHECK_MORE

    addi    $v0,        $zero,      4
    la      $a0,        LESS
    syscall 

	j 		DELAY_LOOP

CHECK_MORE:     

    addi    $v0,        $zero,      4
    la      $a0,        MORE
    syscall 

DELAY_LOOP:     
    addi    $t2,        $zero,      0                                                   # i=0
    slt     $t3,        $t2,        $t8                                                 # i < LOOP_COUNT
    beq     $t3,        $zero,      DELAY_DONE

    addi    $t2,        $t2,        1                                                   # i++
    j       DELAY_LOOP

DELAY_DONE:     
    j       OUTER_LOOP

DONE:

	addi    $v0,        $zero,      4
    la      $a0,        CORRECT
    syscall 