.data   

DASH_START: .asciiz "----------------\n"                # String to print before the argument string
DASH_END:   .asciiz "\n----------------\n"              # String to print after the argument string
NEWLINE:    .asciiz "\n"                                # Newline string
CHAR_PRINT: .asciiz ": "                                # Format string for printing a character
OTHER:      .asciiz "<other>: "                         # String to print before the count of other characters

            .globl  countLetters
            .globl  subsCipher

.text   

countLetters:                                           # countLetters(char *str)

    # Calculate the size of the array needed
    # Round length up to the nearest multiple of 4
    # Allocate an array of that size on the stack

    # Make a stack with enough room for 26 letters
    # 26 integers x 4 bytes each = 104 bytes

    addiu   $sp,                $sp,        -112        # Allocate 104 bytes on the stack
    sw      $fp,                0($sp)                  # Save $fp to the stack
    sw      $ra,                4($sp)                  # Save $ra to the stack
    addiu   $fp,                $sp,        108         # Set $fp to the top of the stack

    # Fill the stack with zeros

    sw      $zero,              8($sp)
    sw      $zero,              12($sp)
    sw      $zero,              16($sp)
    sw      $zero,              20($sp)
    sw      $zero,              24($sp)
    sw      $zero,              28($sp)
    sw      $zero,              32($sp)
    sw      $zero,              36($sp)
    sw      $zero,              40($sp)
    sw      $zero,              44($sp)
    sw      $zero,              48($sp)
    sw      $zero,              52($sp)
    sw      $zero,              56($sp)
    sw      $zero,              60($sp)
    sw      $zero,              64($sp)
    sw      $zero,              68($sp)
    sw      $zero,              72($sp)
    sw      $zero,              76($sp)
    sw      $zero,              80($sp)
    sw      $zero,              84($sp)
    sw      $zero,              88($sp)
    sw      $zero,              92($sp)
    sw      $zero,              96($sp)
    sw      $zero,              100($sp)
    sw      $zero,              104($sp)
    sw      $zero,              108($sp)

    add     $t0,                $zero,      $a0         # char *str = a0

    add     $t1,                $t0,        $zero       # char *cur = str;

    add     $t2,                $zero,      $zero       # int other = 0;

    # Print the Dash Start

    addi    $v0,                $zero,      4
    la      $a0,                DASH_START
    syscall 

    # Print the argument string

    addi    $v0,                $zero,      4
    add     $a0,                $zero,      $t1
    syscall 

    # Print the Dash End

    addi    $v0,                $zero,      4
    la      $a0,                DASH_END
    syscall 


count_loop:                                             # While current does not equal end line (\0)

    lb      $t9,                0($t1)                  # Load byte at address in $t1
    beq     $t9,                $zero,      count_end   # Compare byte to zero

    # If *cur >= a and *cur =< z

    addi    $t8,                $zero,      0x7A        # $t8 = 'z'

    slti    $t3,                $t9,        0x61        # $t3 = 1 if $t9 < 'a' (less than 0x61)
    slt     $t4,                $t8,        $t9         # $t4 = 1 if 'z' < $t9 ($t9 > 0x7A)

    or      $t5,                $t3,        $t4         # $t5 = 1 if $t9 is not in the range ['a', 'z']

    bne     $t5,                $zero,      count_upper # Jump to count_upper if $t5 != 0


    # Increment the stack at *cur - a

    lb      $t9,                0($t1)                  # Load the character pointed by $t1

    addi    $t6,                $t9,        -0x61       # $t6 = *cur - 'a'

    sll     $t6,                $t6,        2           # $t6 = $t6 * 4 (each int is 4 bytes)

    add     $t7,                $sp,        $t6         # $t7 = &stack[*cur - 'a']

    addi    $t7,                $t7,        8           # Shift 8 bytes to get to the first integer

    lw      $t6,                0($t7)                  # $t6 = stack[*cur - 'a']

    addi    $t6,                $t6,        1           # stack[*cur - 'a']++

    sw      $t6,                0($t7)                  # stack[*cur - 'a'] = $t6

    j       count_increment                             # Jump to count_increment

count_upper:

    # Else if *cur >= A and *cur =< Z

    addi    $t8,                $zero,      0x5A

    slti    $t3,                $t9,        0x41        # $t3 = *cur < 'A'

    slt     $t4,                $t8,        $t9         # $t4 = *cur > 'Z'

    or      $t5,                $t3,        $t4         # $t5 = $t3 || $t4

    bne     $t5,                $zero,      count_other # if $t5 != 0, jump to count_other

    # Increment the stack at *cur - A

    lb      $t9,                0($t1)                  # Load the character pointed by $t1

    addi    $t6,                $t9,        -0x41       # $t6 = *cur - 'a'

    sll     $t6,                $t6,        2           # $t6 = $t6 * 4 (each int is 4 bytes)

    add     $t7,                $sp,        $t6         # $t7 = &stack[*cur - 'a']

    addi    $t7,                $t7,        8           # Shift 8 bytes to get to the first integer

    lw      $t6,                0($t7)                  # $t6 = stack[*cur - 'a']

    addi    $t6,                $t6,        1           # stack[*cur - 'a']++

    sw      $t6,                0($t7)                  # stack[*cur - 'a'] = $t6

    j       count_increment                             # Jump to count_increment

count_other:

    # Else
    # Increment other

    addi    $t2,                $t2,        1           # other++

count_increment:

    # Increment cur

    addi    $t1,                $t1,        1           # cur++

    # Jump back to the while loop
    j       count_loop

count_end:  

    # For each letter in the stack
    # Print the letter and the number of times it appears

    add     $t0,                $zero,      $sp
    addi    $t0,                $t0,        8
    add     $t1,                $zero,      $zero
    addi    $t3,                $zero,      26
    addi    $t4,                $zero,      0x61

print_loop: 

    slt     $t5,                $t1,        $t3         # $t4 = $t1 < 26

    beq     $t5,                $zero,      print_end   # if !($t4 < 26), jump to print_end

    # Print the letter

    addi    $v0,                $zero,      11
    add     $a0,                $zero,      $t4
    syscall 

    addi    $v0,                $zero,      4
    la      $a0,                CHAR_PRINT
    syscall 

    # Print the count

    addi    $v0,                $zero,      1
    lw      $a0,                0($t0)
    syscall 

    addi    $v0,                $zero,      4
    la      $a0,                NEWLINE
    syscall 

    addi    $t1,                $t1,        1
    addi    $t0,                $t0,        4
    addi    $t4,                $t4,        1

    j       print_loop

print_end:  

    # Print the other count

    addi    $v0,                $zero,      4
    la      $a0,                OTHER
    syscall 

    addi    $v0,                $zero,      1
    add     $a0,                $zero,      $t2
    syscall 

    addi    $v0,                $zero,      4
    la      $a0,                NEWLINE
    syscall 

    # Restore the stack

    lw      $ra,                4($sp)                  # Restore $ra from the stack
    lw      $fp,                0($sp)                  # Restore $fp from the stack
    addiu   $sp,                $sp,        112         # Deallocate 104 bytes from the stack
    jr      $ra                                         # Return

subsCipher: 

    # Save the current frame pointer and return address
    addiu   $sp,                $sp,        -24         # Allocate 24 bytes on the stack, adjust this value based on actual usage
    sw      $fp,                0($sp)                  # Save $fp to the stack
    sw      $ra,                4($sp)                  # Save $ra to the stack
    addiu   $fp,                $sp,        20          # Set $fp to the top of the stack

    # Compute the length of the input string including null terminator

    jal     strlen                                      # Calculate length of string
    addiu   $v0,                $v0,        1           # Include space for null terminator

    # Restore the stack and return
    lw      $ra,                4($sp)                  # Restore $ra from the stack
    lw      $fp,                0($sp)                  # Restore $fp from the stack
    addiu   $sp,                $sp,        24          # Deallocate 24 bytes from the stack
    jr      $ra                                         # Return

    # Function to calculate string length
strlen:                                                 # strlen(char *str)

    add     $t0,                $zero,      $a0         # char *str = a0
    addi    $t1,                $zero,      0           # int len = 0

strlen_loop:

    lb      $t2,                0($t0)                  # Load byte at address in $t0
    beq     $t2,                $zero,      strlen_end  # Compare byte to zero

    addi    $t1,                $t1,        1           # Increment len
    addi    $t0,                $t0,        1           # Increment str
    j       strlen_loop                                 # Jump back to the while loop

strlen_end: 

    add     $v0,                $zero,      $t1         # Return len
    jr      $ra                                         # Return
