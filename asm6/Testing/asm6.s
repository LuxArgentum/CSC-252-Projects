.data   

PROMPT:         .asciiz "Guess a number between 0 and 9: \n"
NOT_READY_MSG:  .asciiz "Ready bit is zero, looping until I find something else...\n"
CORRECT:        .asciiz "Correct!\n"
LESS:           .asciiz "Guess larger!\n"
MORE:           .asciiz "Guess smaller!\n"
NEWLINE:        .asciiz "\n"
SCORE:          .word   10                                                              # Starting score
SCORE_MSG:      .asciiz "Your score: "
SCORE_TEXT:     .space  20                                                              # Reserve 20 bytes for "Your score: XX\n"

.text   

main:           
    # Random Number Generator

    # Use syscall 42 to get a random number (enter range into $a1)

    addi    $v0,                $zero,          42
    addi    $a1,                $zero,          10
    add     $a0,                $zero,          $zero
    syscall 

    add     $s0,                $a0,            $zero

    # Prompt user to guess a number

    addi    $v0,                $zero,          4
    la      $a0,                PROMPT
    syscall 

    # Print the random number for debugging purposes

    addi    $v0,                $zero,          1
    add     $a0,                $s0,            $zero
    syscall 

    addi    $v0,                $zero,          4
    la      $a0,                NEWLINE
    syscall 

    # Initialize score to 10 at the start of the game

    li      $s2,                10                                                      # $s2 will hold the score
    la      $s3,                SCORE                                                   # $s3 points to the score variable
    sw      $s2,                0($s3)                                                  # Store initial score in memory

    # Save prompt to address for display (0xffff000c)

    la      $t0,                PROMPT                                                  # Load the address of the PROMPT into $t0

prompt_loop:    
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address

polling:        
    lw      $t2,                8($t1)                                                  # Load the control register status from $t1 + offset 8
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          polling                                 # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          OUTER_LOOP                              # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       prompt_loop                                                                 # Continue the loop

OUTER_LOOP:     

    lui     $t0,                0xffff

    lw      $t1,                0($t0)                                                  # read control register
    andi    $t1,                $t1,            0x1                                     # mask off all but bit 0 (the 'ready' bit)

    bne     $t1,                $zero,          READY

    # # print_str(NOT_READY_MSG)
    # addi    $v0,        $zero,          4
    # la      $a0,        NOT_READY_MSG
    # syscall

NOT_READY_LOOP: 
    lw      $t1,                0($t0)                                                  # read control register
    andi    $t1,                $t1,            0x1                                     # mask off all but bit 0 (the 'ready' bit)
    beq     $t1,                $zero,          NOT_READY_LOOP

READY:          
    # read the actual typed character
    lw      $t1,                4($t0)                                                  # read data from register 0xffff0004

    addi    $t1,                $t1,            -48                                     # convert to ASCII

    beq     $t1,                $s0,            CORRECT_GUESS                           # Branch to correct guess handling
    bne     $t1,                $s0,            WRONG_GUESS                             # Branch to wrong guess handling

CORRECT_GUESS:  
    # Load and display the correct message
    li      $v0,                4
    la      $a0,                CORRECT
    syscall 

    # Save prompt to address for display (0xffff000c)

    la      $t0,                CORRECT                                                 # Load the address of the PROMPT into $t0

correct_loop:   
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address

correct_polling:
    lw      $t2,                8($t1)                                                  # Load the control register status from $t1 + offset 8
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          correct_polling                         # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          DISPLAY_SCORE                           # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       correct_loop                                                                # Continue thecorrec

WRONG_GUESS:    
    # Decrement score
    lw      $s2,                0($s3)                                                  # Load current score
    addi    $s2,                $s2,            -1                                      # Decrement score
    sw      $s2,                0($s3)                                                  # Store updated score

    # Check if guess was higher or lower, then jump back to guessing
    slt     $t2,                $t1,            $s0
    beq     $t2,                $zero,          CHECK_MORE

    addi    $v0,                $zero,          4
    la      $a0,                LESS
    syscall 

    # Save prompt to address for display (0xffff000c)

    la      $t0,                LESS                                                    # Load the address of the PROMPT into $t0

less_loop:      
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address

less_polling:   
    lw      $t2,                8($t1)                                                  # Load the control register status from $t1 + offset 8
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          less_polling                            # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          OUTER_LOOP                              # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       less_loop                                                                   # Continue thecorrec

CHECK_MORE:     
    addi    $v0,                $zero,          4
    la      $a0,                MORE
    syscall 

    # Save prompt to address for display (0xffff000c)

    la      $t0,                MORE                                                    # Load the address of the PROMPT into $t0

more_loop:      
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address

more_polling:   
    lw      $t2,                8($t1)                                                  # Load the control register status from $t1 + offset 8
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          more_polling                            # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          OUTER_LOOP                              # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       more_loop                                                                   # Continue thecorrec

DISPLAY_SCORE:  
    # Load and display the score
    li      $v0,                4
    la      $a0,                SCORE_MSG
    syscall 

    lw      $s2,                0($s3)
    li      $v0,                1
    move    $a0,                $s2
    syscall 

    # Point to the beginning of the SCORE_MSG buffer
    la      $t0,                SCORE_MSG

    # Display loop similar to other display loops
score_msg_loop: 
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address
    lw      $t2,                8($t1)                                                  # Load control register status
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          score_msg_loop                          # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          score_msg_done                          # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       score_msg_loop                                                              # Continue the loop

score_msg_done: 

    # Load score, convert to ASCII, and display it
    lw      $a0,                0($s3)                                                  # Load the score from its storage
    addi    $a0,                $a0,            '0'                                     # Convert score digit to ASCII

    # Prepare the character for display
    sb      $a0,                SCORE_TEXT                                              # Store the ASCII character into SCORE_TEXT
    sb      $zero,              SCORE_TEXT+1                                            # Null-terminate the string

    # Set $t0 to the beginning of the SCORE_TEXT
    la      $t0,                SCORE_TEXT

    # Display loop for the score
score_display_loop:
    lui     $t1,                0xffff                                                  # Load upper immediate for the base address
    lw      $t2,                8($t1)                                                  # Load the control register status
    andi    $t2,                $t2,            0x1                                     # Check the ready bit
    beq     $t2,                $zero,          score_display_loop                      # Wait while not ready

    lbu     $t3,                0($t0)                                                  # Load the byte at the current address pointed by $t0
    beq     $t3,                $zero,          score_done                              # If zero, end the string display
    sw      $t3,                0xc($t1)                                                # Store the byte into the display data register
    addi    $t0,                $t0,            1                                       # Move the pointer to the next byte

    j       score_display_loop                                                          # Continue the loop

score_done:     

    li      $v0,                10                                                      # Exit syscall
    syscall 