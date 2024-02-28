.data

BOTTLES_OF:         .asciiz " bottles of "
ON_THE_WALL:        .asciiz " on the wall, "
ON_THE_WALL_PERIOD: .asciiz " on the wall.\n"
ON_THE_WALL_END:    .asciiz " on the wall!\n"
TAKE_ONE_DOWN:      .asciiz "Take one down, pass it around, "
NO_MORE_BOTTLES:    .asciiz "No more bottles of "
EXCLAIM:            .asciiz "!\n"
NEWLINE:            .asciiz "\n"

                    .globl  strlen
                    .globl  gcf
                    .globl  bottles
                    .globl  longestSorted
                    .globl  rotate

.text

    # strlen()

strlen:

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                20              # Set $fp to the top of the stack

    addiu   $sp,            $sp,                -4              # Allocate 4 bytes on the stack
    sw      $s0,            0($sp)                              # Save $s0 to the stack

    add     $s0,            $a0,                $zero           # $s0 = &string
    add     $t0,            $zero,              $zero           # $t0 = $zero + $zero

LEN_LOOP:

    add     $t1,            $s0,                $t0             # $t1 = $s0 + $t0
    lb      $t1,            0($t1)                              # $t1 = *($t1 + 0)
    beq     $t1,            $zero,              LEN_END         # if $t1 == $zero then goto LEN_END
    addi    $t0,            $t0,                1               # $t0 = $t0 + 1
    j       LEN_LOOP                                            # goto LEN_LOOP

LEN_END:

    add     $v0,            $t0,                $zero           # $v0 = $t0 + $zero

    lw      $s0,            0($sp)                              # Restore $s0 from the stack
    addiu   $sp,            $sp,                4               # Deallocate 4 bytes on the stack

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack
    jr      $ra                                                 # return

    # gcf( int a, int b )

gcf:

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                20              # Set $fp to the top of the stack

    add     $t0,            $a0,                $zero           # $t0 = a
    add     $t1,            $a1,                $zero           # $t1 = b
    slt     $t2,            $t0,                $t1             # $t2 = (a < b)
    beq     $t2,            $zero,              GCF_BASE        # if (a < b) == false then goto GCF_BASE

    add     $t2,            $t0,                $zero           # $t2 = a
    add     $t0,            $t1,                $zero           # $t0 = b
    add     $t1,            $t2,                $zero           # $t1 = a

GCF_BASE:

    addi    $t2,            $zero,              1               # $t2 = 1
    bne     $t1,            $t2,                GCF_REMAIN      # if b != 1 then goto GCF_REMAIN
    addi    $v0,            $zero,              1               # $v0 = 1

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack

    jr      $ra                                                 # return

GCF_REMAIN:

    div     $t0,            $t1                                 # a / b
    mfhi    $t3                                                 # $t3 = a % b
    bne     $t3,            $zero,              GCF_RECURSIVE   # if (a % b) != $zero then goto GCF_RECURSIVE
    add     $v0,            $t1,                $zero           # $v0 = b

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack

    jr      $ra                                                 # return

GCF_RECURSIVE:

    add     $a0,            $t1,                $zero           # $a0 = b
    add     $a1,            $t3,                $zero           # $a1 = a % b

    jal     gcf                                                 # jump to gcf and save position to $ra

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack
    jr      $ra                                                 # return

    # bottles( int count, char *thing )

bottles:

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                20              # Set $fp to the top of the stack

    addiu   $sp,            $sp,                -4              # Allocate 4 bytes on the stack
    sw      $s0,            0($sp)                              # Save $s0 to the stack

    add     $t0,            $a0,                $zero           # $t0 = count
    add     $s0,            $a1,                $zero           # $s0 = thing

BOTTLES_LOOP:

    slt     $t1,            $zero,              $t0             # $t1 = (count > 0)
    beq     $t1,            $zero,              BOTTLE_END      # if (count > 0) == false, then goto BOTTLE_END

    # Print "(count) bottles of (*thing) on the wall, (count) bottles of (*thing)!"
    addi    $v0,            $zero,              1               # $v0 = 1
    add     $a0,            $t0,                $zero           # $a0 = count
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            BOTTLES_OF                          # $a0 = BOTTLES_OF
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    add     $a0,            $zero,              $s0             # $a0 = thing
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            ON_THE_WALL                         # $a0 = ON_THE_WALL
    syscall                                                     # print $a0

    addi    $v0,            $zero,              1               # $v0 = 1
    add     $a0,            $t0,                $zero           # $a0 = count
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            BOTTLES_OF                          # $a0 = BOTTLES_OF
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    add     $a0,            $s0,                $zero           # $a0 = thing
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            EXCLAIM                             # $a0 = EXCLAIM
    syscall                                                     # print $a0

    # Print "Take one down, pass it around, (count - 1) bottles of (*thing) on the wall"

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            TAKE_ONE_DOWN                       # $a0 = TAKE_ONE_DOWN
    syscall                                                     # print $a0

    addi    $t1,            $t0,                -1              # $t1 = count - 1

    addi    $v0,            $zero,              1               # $v0 = 1
    add     $a0,            $t1,                $zero           # $a0 = count - 1
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            BOTTLES_OF                          # $a0 = BOTTLES_OF
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    add     $a0,            $zero,              $s0             # $a0 = thing
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            ON_THE_WALL_PERIOD                  # $a0 = ON_THE_WALL
    syscall                                                     # print $a0

    # Print a newline

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            NEWLINE                             # $a0 = NEWLINE
    syscall                                                     # print $a0

    addi    $t0,            $t0,                -1              # $t0 = count - 1

    j       BOTTLES_LOOP                                        # goto BOTTLES_LOOP

BOTTLE_END:

    # Print "No more bottles of Y on the wall!"

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            NO_MORE_BOTTLES                     # $a0 = NO_MORE_BOTTLES
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    add     $a0,            $zero,              $s0             # $a0 = thing
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            ON_THE_WALL_END                     # $a0 = ON_THE_WALL_END
    syscall                                                     # print $a0

    # Print a newline

    addi    $v0,            $zero,              4               # $v0 = 4
    la      $a0,            NEWLINE                             # $a0 = NEWLINE
    syscall                                                     # print $a0

    lw      $s0,            0($sp)                              # Restore $s0 from the stack
    addiu   $sp,            $sp,                4               # Deallocate 4 bytes on the stack

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack
    jr      $ra                                                 # return

    # longestSorted( int *array, int length )
    # $a0 = *array, $a1 = length
    # $v0 = length of longest sorted streak
    # $t0 = array
    # $t1 = length_of_array
    # $s0 = streak
    # $t2 = current_streak
    # $t3 = current_index
    # $t4 =

longestSorted:

    # for ( int i = 0; i < length; i++ ) {
    #     if ( array[i] < array[i + 1] ) {
    #         current_streak++;
    #     } else {
    #         if ( current_streak > streak ) {
    #             streak = current_streak;
    #         }
    #         current_streak = 0;
    #     }
    # }

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                20              # Set $fp to the top of the stack

    addiu   $sp,            $sp,                -12             # Allocate 12 bytes on the stack
    sw      $s0,            8($sp)                              # Save $s0 to the stack
    sw      $s1,            4($sp)                              # Save $s1 to the stack
    sw      $s2,            0($sp)                              # Save $s2 to the stack

    add     $t0,            $a0,                $zero           # $t0 = *array
    add     $t1,            $a1,                $zero           # $t1 = length
    add     $s0,            $zero,              $zero           # streak = 0
    add     $t2,            $zero,              $zero           # current_streak = 0
    addi    $t3,            $zero,              1               # current_index = 1

    # Check if array is 0 or 1 in length

    slti    $t5,            $t1,                2               # $t5 = (length < 2)
    bne     $t5,            $zero,              LONG_FAST_END   # if (length < 2) == true, then goto LONG_FAST_END

LONG_LOOP:

    slt     $t5,            $t3,                $t1             # $t5 = (current_index < length)
    beq     $t5,            $zero,              LONG_END        # if (current_index < length) == false, then goto LONG_END

    # Compare array[i] and array[i + 1]

    addi    $s1,            $t3,                -1              # $s1 = current_index - 1
    sll     $s1,            $s1,                2               # array_index = (current_index - 1) * 4
    add     $s1,            $t0,                $s1             # $s1 = array + array_index
    lw      $s1,            0($s1)                              # $s1 = array[current_index - 1]
    sll     $s2,            $t3,                2               # array_index = current_index * 4
    add     $s2,            $t0,                $s2             # $s2 = array + array_index
    lw      $s2,            0($s2)                              # $s2 = array[current_index]

    slt     $t5,            $s2,                $s1             # $t5 = (array[i-1] > array[i])
    bne     $t5,            $zero,              END_STREAK      # if (array[i-1] <= array[i]) == false, then goto END_STREAK
    addi    $t2,            $t2,                1               # current_streak++
    j       LONG_ITERATE                                        # goto LONG_ITERATE

END_STREAK:                                                     # End the streak

    addi    $t2,            $t2,                1               # current_streak + 1 to account for the first eleement
    slt     $t5,            $s0,                $t2             # $t5 = (streak < current_streak)
    bne     $t5,            $zero,              UPDATE_STREAK   # if (streak < current_streak) == true, then goto UPDATE_STREAK
    j       RESTART_STREAK                                      # goto RESTART_STREAK

UPDATE_STREAK:                                                  # Update the streak with current_streak

    add     $s0,            $t2,                $zero           # streak = current_streak
    j       RESTART_STREAK                                      # goto RESTART_STREAK

RESTART_STREAK:                                                 # Set current_streak to 0

    add     $t2,            $zero,              $zero           # current_streak = 0
    j       LONG_ITERATE

LONG_ITERATE:                                                   # Iterate the loop

    addi    $t3,            $t3,                1               # current_index++

    j       LONG_LOOP                                           # goto LONG_LOOP

LONG_FAST_END:

    add     $s0,            $t1,                $zero           # streak = length

    j       LONG_CONTINUE                                       # goto LONG_CONTINUE

LONG_END:

    addi    $t2,            $t2,                1               # current_streak + 1 to account for the first eleement
    slt     $t5,            $s0,                $t2             # $t5 = (streak < current_streak)
    beq     $t5,            $zero,              LONG_CONTINUE   # if (streak < current_streak) == true, then goto LONG_CONTINUE

    add     $s0,            $t2,                $zero           # streak = current_streak

LONG_CONTINUE:

    add     $v0,            $s0,                $zero           # $v0 = streak

    lw      $s0,            8($sp)                              # Restore $s0 from the stack
    lw      $s1,            4($sp)                              # Restore $s1 from the stack
    lw      $s2,            0($sp)                              # Restore $s2 from the stack
    addiu   $sp,            $sp,                12              # Deallocate 12 bytes on the stack

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack
    jr      $ra                                                 # return


rotate:

    # int rotate(int count, int a, int b, int c, int d, int e, int f)
    # {
    #     int retval = 0;
    #     for (int i=0; i<count; i++)
    #     {
    #         retval += util(a,b,c,d,e,f);
    #         int tmp = a;
    #         a = b;
    #         b = c;
    #         c = d;
    #         d = e;
    #         e = f;
    #         f = tmp;
    #     }
    #     return retval;
    # }

    # $s0 = retval
    # $a0 = count
    # $a1 = a
    # $a2 = b
    # $a3 = c
    # $t0 = d
    # $t1 = e
    # $t2 = f
    # $t3 = index
    # $t4 = temp

    addiu   $sp,            $sp,                -36             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                28              # Set $fp to the top of the stack

    add     $t1,            $a1,                $zero           # a
    add     $t2,            $a2,                $zero           # b
    add     $t3,            $a3,                $zero           # c
    lw      $t4,            24($sp)                             # d
    lw      $t5,            28($sp)                             # e
    lw      $t6,            32($sp)                             # f
    add     $t0,            $a0,                $zero           # $t0 = count

    addiu   $sp,            $sp,                -28             # Allocate 24 bytes on the stack
    sw      $s0,            24($sp)                             # Save $s0 to the stack
    sw      $s1,            20($sp)                             # Save $s1 to the stack
    sw      $s2,            16($sp)                             # Save $s2 to the stack
    sw      $s3,            12($sp)                             # Save $s3 to the stack
    sw      $s4,            8($sp)                              # Save $s4 to the stack
    sw      $s5,            4($sp)                              # Save $s5 to the stack
    sw      $s6,            0($sp)                              # Save $s6 to the stack

    add     $s1,            $t1,                $zero           # a
    add     $s2,            $t2,                $zero           # b
    add     $s3,            $t3,                $zero           # c
    add     $s4,            $t4,                $zero           # d
    add     $s5,            $t5,                $zero           # e
    add     $s6,            $t6,                $zero           # f
    add     $s0,            $zero,              $zero           # retval = 0
    add     $t2,            $zero,              $zero           # index = 0

ROTATE_LOOP:

    slt     $t3,            $t2,                $t0             # $t5 = (index < count)
    beq     $t3,            $zero,              ROTATE_END      # if (index < count) == false, then goto ROTATE_END

    addiu   $sp,            $sp,                -8              # Allocate 4 bytes on the stack
    sw      $t0,            4($sp)                              # Save $t0 to the stack
    sw      $t2,            0($sp)                              # Save $t2 to the stack

    add     $a0,            $s1,                $zero           # a
    add     $a1,            $s2,                $zero           # b
    add     $a2,            $s3,                $zero           # c
    add     $a3,            $s4,                $zero           # d
    add     $t1,            $s5,                $zero           # e
    sw      $t1,            -8($sp)                             # Save $t1 to the next stack
    add     $t1,            $s6,                $zero           # f
    sw      $t1,            -4($sp)                             # Save $t1 to the next stack

    jal     util                                                # jump to util

    lw      $t0,            4($sp)                              # Restore $t0 from the stack
    lw      $t2,            0($sp)                              # Restore $t0 from the stack
    addiu   $sp,            $sp,                8               # Deallocate 4 bytes on the stack

    add     $s0,            $s0,                $v0             # retval += $v0

    add     $t1,            $s1,                $zero           # temp = a
    add     $s1,            $s2,                $zero           # a = b
    add     $s2,            $s3,                $zero           # b = c
    add     $s3,            $s4,                $zero           # c = d
    add     $s4,            $s5,                $zero           # d = e
    add     $s5,            $s6,                $zero           # e = f
    add     $s6,            $t1,                $zero           # f = temp (a)

    addi    $t2,            $t2,                1               # index++
    j       ROTATE_LOOP                                         # goto ROTATE_LOOP

ROTATE_END:

    add     $v0,            $s0,                $zero           # $v0 = retval

    lw      $s0,            24($sp)                             # Restore $s0 from the stack
    lw      $s1,            20($sp)                             # Restore $s1 from the stack
    lw      $s2,            16($sp)                             # Restore $s2 from the stack
    lw      $s3,            12($sp)                             # Restore $s3 from the stack
    lw      $s4,            8($sp)                              # Restore $s4 from the stack
    lw      $s5,            4($sp)                              # Restore $s5 from the stack
    lw      $s6,            0($sp)                              # Restore $s6 from the stack
    addiu   $sp,            $sp,                28              # Deallocate 28 bytes on the stack

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                36              # Deallocate 28 bytes on the stack
    jr      $ra                                                 # return
