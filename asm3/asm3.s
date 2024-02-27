.data   

BOTTLES_OF:         .asciiz " bottles of "
ON_THE_WALL:        .asciiz " on the wall, "
ON_THE_WALL_PERIOD: .asciiz " on the wall.\n"
ON_THE_WALL_END:    .asciiz " on the wall!\n"
TAKE_ONE_DOWN:      .asciiz "Take one down, pass it around, "
NO_MORE_BOTTLES:    .asciiz "No more bottles of "
EXCLAIM:            .asciiz "!\n"
NEWLINE:            .asciiz "\n"

                    .globl  

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
    addiu   $sp,            $sp,                -4              # Deallocate 4 bytes on the stack

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

    add     $t0,            $a0,                $zero           # $t0 = $a0 + $zero
    add     $t1,            $a1,                $zero           # $t1 = $a1 + $zero
    slt     $t2,            $t0,                $t1             # $t2 = ($t0 < $t1) ? 1 : 0
    beq     $t2,            $zero,              GCF_BASE        # if $t2 == $zero then goto GCF_BASE

GCF_BASE:           

    bne     $t1,            1,                  GCF_REMAIN      # if $t1 != 1 then goto GCF_REMAIN
    add     $v0,            1,                  $zero           # $v0 = 1 + $zero
    jr      $ra                                                 # return

GCF_REMAIN:         

    div     $t0,            $t1                                 # $t0 / $t1
    mfhi    $t3                                                 # $t3 = $t0 % $t1
    bne     $t3,            $zero,              GCF_RECURSIVE   # if $t3 != $zero then goto GCF_RECURSIVE
    add     $v0,            $t1,                $zero           # $v0 = $t1 + $zero
    jr      $ra                                                 # return

GCF_RECURSIVE:      

    jal     gcf                                                 # jump to gcf and save position to $ra
    add     $v0,            $v0,                $zero           # $v0 = $v0 + $zero

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

    add     $t0,            $a0,                $zero           # $t0 = $a0 + $zero'
    add     $s0,            $a1,                $zero           # $s0 = $a1 + $zero

BOTTLES_LOOP:       

    slt     $t1,            $zero,              $t0             # $t1 = ($zero < $t0) ? 1 : 0
    beq     $t1,            $zero,              BOTTLE_END      # if $t1 == $zero then goto BOTTLE_END

    # Print "(count) bottles of (*thing) on the wall, (count) bottles of (*thing)!"
    addi    $v0,            $zero,              1               # $v0 = $zero + 1
    add     $a0,            $t0,                $zero           # $a0 = $t0 + $zero
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            BOTTLES_OF                          # $a0 = BOTTLES_OF
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            $s0                                 # $a0 = $s0
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            ON_THE_WALL                         # $a0 = ON_THE_WALL
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            EXCLAIM                             # $a0 = EXCLAIM
    syscall                                                     # print $a0

    # Print "Take one down, pass it around, (count - 1) bottles of (*thing) on the wall"

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            TAKE_ONE_DOWN                       # $a0 = TAKE_ONE_DOWN
    syscall                                                     # print $a0

    addi    $t1,            $t0,                -1              # $t1 = $t0 + -1

    addi    $v0,            $zero,              1               # $v0 = $zero + 1
    add     $a0,            $t1,                $zero           # $a0 = $t1 + $zero
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            BOTTLES_OF                          # $a0 = BOTTLES_OF
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            $s0                                 # $a0 = $s0
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            ON_THE_WALL_PERIOD                  # $a0 = ON_THE_WALL
    syscall                                                     # print $a0

    # Print a newline

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            NEWLINE                             # $a0 = NEWLINE
    syscall                                                     # print $a0

    addi    $t0,            $t0,                -1              # $t0 = $t0 - 1
    j       BOTTLES_LOOP                                        # goto BOTTLES_LOOP

BOTTLE_END:         

    # Print "No more bottles of Y on the wall!"

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            NO_MORE_BOTTLES                     # $a0 = NO_MORE_BOTTLES
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            $s0                                 # $a0 = $s0
    syscall                                                     # print $a0

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            ON_THE_WALL_END                     # $a0 = ON_THE_WALL_END
    syscall                                                     # print $a0

    # Print a newline

    addi    $v0,            $zero,              4               # $v0 = $zero + 4
    la      $a0,            NEWLINE                             # $a0 = NEWLINE
    syscall                                                     # print $a0

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

    addiu   $sp,            $sp,                -12             # Allocate 4 bytes on the stack
    sw      $s0,            8($sp)                              # Save $s0 to the stack
    sw      $s1,            4($sp)                              # Save $s1 to the stack
    sw      $s2,            0($sp)                              # Save $s2 to the stack

    add     $t0,            $a0,                $zero           # $t0 = *array
    add     $t1,            $a1,                $zero           # $t1 = length
    add     $s0,            $zero,              $zero           # streak = 0
    add     $t2,            $zero,              $zero           # current_streak = 0
    add     $t3,            $zero,              $zero           # current_index = 0
    addi    $t4,            $t3,                1               # array_index = current_index + 1

    # Check if array is 0 or 1 in length

    slt     $t2,            $t1,                2               # $t2 = (length < 2)
    beq     $t2,            $zero,              LONG_FAST_END   # if (length < 2) == false, then goto LONG_FAST_END

    lw      $s1,            0($t0)                              # $s1 = array[0]
    add     $s2,            $t0,                $t4             # $s2 = array + 1
    lw      $s2,            0($s2)                              # $s2 = array[1]

LONG_LOOP:          

    slt     $t5,            $t3,                $t1             # $t5 = (current_index < length)
    beq     $t5,            $zero,              LONG_END        # if (current_index < length) == false, then goto LONG_END

    # Compare array[i] and array[i + 1]

    slt     $t6,            $s1,                $s2             # $t6 = (array[i] < array[i + 1])
    beq     $t6,            $zero,              END_STREAK      # if (array[i] < array[i + 1]) == false, then goto END_STREAK
    addi    $t2,            $t2,                1               # current_streak++
    j       LONG_ITERATE                                        # goto LONG_ITERATE

END_STREAK:                                                     # End the streak

    slt     $t6,            $s0,                $t2             # $t6 = (streak < current_streak)
    bne     $t6,            $zero,              UPDATE_STREAK   # if (streak < current_streak) == true, then goto UPDATE_STREAK
    j       RESTART_STREAK                                      # goto RESTART_STREAK

UPDATE_STREAK:                                                  # Update the streak with current_streak

    add     $s0,            $t2,                $zero           # streak = current_streak
    j       RESTART_STREAK                                      # goto RESTART_STREAK

RESTART_STREAK:                                                 # Set current_streak to 0

    add     $t2,            $zero,              $zero           # current_streak = 0
    j       LONG_ITERATE

LONG_ITERATE:                                                   # Iterate the loop

    addi    $t3,            $t3,                1               # current_index++
    sll     $t4,            $t3,                2               # $t4 = $t4 << 2 (array_index * 4)
    lw      $s1,            0($s2)                              # array[i] = array[i + 1]
    add     $s2,            $t0,                $t4             # $s2 = array + array_index
    lw      $s2,            0($s2)                              # $s2 = array[i + 1]
    j       LONG_LOOP                                           # goto LONG_LOOP

LONG_FAST_END:      

    add     $s0,            $t1,                $zero           # streak = length

LONG_END:           

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

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $fp,            0($sp)                              # Save $fp to the stack
    sw      $ra,            4($sp)                              # Save $ra to the stack
    addiu   $fp,            $sp,                20              # Set $fp to the top of the stack

    addiu   $sp,            $sp,                -24             # Allocate 24 bytes on the stack
    sw      $s0,            20($sp)                             # Save $s0 to the stack
    sw      $s1,            16($sp)                             # Save $s1 to the stack
    sw      $s2,            12($sp)                             # Save $s2 to the stack
    sw      $s3,            8($sp)                              # Save $s3 to the stack
    sw      $s4,            4($sp)                              # Save $s4 to the stack
    sw      $s5,            0($sp)                              # Save $s5 to the stack

    add     $s1,            $a1,                $zero           # a
    add     $s2,            $a2,                $zero           # b
    add     $s3,            $a3,                $zero           # c
    add     $s4,            $t0,                $zero           # d
    add     $s5,            $t1,                $zero           # e
    add     $s0,            $t2,                $zero           # f

    add     $s0,            $zero,              $zero           # retval = 0
    add     $t3,            $a0,                $zero           # index = count

ROTATE_LOOP:        

    slt     $t5,            $t3,                $a0             # $t5 = (index < count)
    beq     $t5,            $zero,              ROTATE_END      # if (index < count) == false, then goto ROTATE_END

    addiu   $sp,            $sp,                8               # Allocate 8 bytes on the stack
    sw      $t3,            4($sp)                              # Save $t3 to the stack
    sw      $s0,            0($sp)                              # Save $s0 to the stack

    jal     util                                                # jump to util

    lw      $a0,            32($sp)
    lw      $a1,            28($sp)
    lw      $a2,            24($sp)
    lw      $a3,            20($sp)
    lw      $t0,            16($sp)
    lw      $t1,            12($sp)
    lw      $t2,            8($sp)
    lw      $t3,            4($sp)
    lw      $s0,            0($sp)
    addiu   $sp,            $sp,                36

    add     $s0,            $s0,                $v0             # retval += $v0

    add     $t4,            $a1,                $zero           # temp = a
    add     $a1,            $a2,                $zero           # a = b
    add     $a2,            $a3,                $zero           # b = c
    add     $a3,            $t0,                $zero           # c = d
    add     $t0,            $t1,                $zero           # d = e
    add     $t1,            $t2,                $zero           # e = f
    add     $t2,            $t4,                $zero           # f = temp (a)

    addi    $t3,            $t3,                1               # index++
    j       ROTATE_LOOP                                         # goto ROTATE_LOOP

ROTATE_END:         

    add     $v0,            $s0,                $zero           # $v0 = retval

    lw      $s0,            0($sp)                              # Restore $s0 from the stack
    addiu   $sp,            $sp,                4               # Deallocate 4 bytes on the stack

    lw      $ra,            4($sp)                              # Restore $ra from the stack
    lw      $fp,            0($sp)                              # Restore $fp from the stack
    addiu   $sp,            $sp,                24              # Deallocate 24 bytes on the stack
    jr      $ra                                                 # return
