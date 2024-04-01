# test_05.s
#
# A testcase for Asm 4.



# ----------- main() -----------
.text


.globl	main
main:
	# fill the sX registers (and fp) with junk.  Each testcase will use a different
	# set of values.
	lui   $fp,      0x6a07
	ori   $fp, $fp, 0x65b0
	lui   $s0,      0x5361
	ori   $s0, $s0, 0x5d64
	lui   $s1,      0x2668
	ori   $s1, $s1, 0x1c98
	lui   $s2,      0x107a
	ori   $s2, $s2, 0x6c25
	lui   $s3,      0xba53
	ori   $s3, $s3, 0x5d9b
	lui   $s4,      0xd72a
	ori   $s4, $s4, 0x027e
	lui   $s5,      0x8f56
	ori   $s5, $s5, 0x07bc
	lui   $s6,      0x1059
	ori   $s6, $s6, 0xc443
	lui   $s7,      0x3440
	ori   $s7, $s7, 0xab24

	# instead of explicitly dumping the stack pointer, I'll push a dummy
	# variable onto the stack.  Some students are reporting different
	# stack values in their output.
	lui   $t0,      0x0223
	ori   $t0, $t0, 0x6aa7
	addiu $sp, $sp,-4
	sw    $t0, 0($sp)


.data
TEST_NAME:
	.asciiz "Bigfoot"

	.word	0xc608ace9
TEST_OBJ:
	.byte	'a'
	.byte	'b'
	.byte	'c'
	.byte	0
	.byte	'e'
	.byte	'f'
	.byte	'g'
	.byte	'h'
	.byte	'i'
	.byte	'j'
	.byte	'k'
	.byte	'l'
	.word	0x46fb1a13

.text

	# turtle_init(&TEST_OBJ, TEST_NAME)
	la      $a0, TEST_OBJ
	la      $a1, TEST_NAME
	jal     turtle_init

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	la	$a0, TEST_OBJ
	jal     turtle_turnLeft

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug

	# testcase_dump_bytes(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     testcase_dump_bytes

	# turtle_debug(&TEST_OBJ)
	la      $a0, TEST_OBJ
	jal     turtle_debug


	# dump out all of the registers.
.data
TESTCASE_DUMP1:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Magic Value (popped from the stack):                   |\n"
		.asciiz	"+-----------------------------------------------------------+\n"

TESTCASE_DUMP2:	.ascii  "\n"
               	.ascii 	"+-----------------------------------------------------------+\n"
		.ascii	"|    Testcase Register Dump (fp, then 8 sX regs):           |\n"
		.asciiz	"+-----------------------------------------------------------+\n"
.text
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP1)
	la	$a0, TESTCASE_DUMP1
	syscall

	# we pop this from the stack so that, if the stack pointer is not
	# predictable, we'll still get reliable results.
	lw      $a0, 0($sp)
	addiu   $sp, $sp,4
	jal     printHex

	# the rest of the registers have hard-coded values
	addi	$v0, $zero, 4		# print_str(TESTCASE_DUMP2)
	la	$a0, TESTCASE_DUMP2
	syscall

	add	$a0, $fp, $zero
	jal     printHex
	add	$a0, $s0, $zero
	jal     printHex
	add	$a0, $s1, $zero
	jal     printHex
	add	$a0, $s2, $zero
	jal     printHex
	add	$a0, $s3, $zero
	jal     printHex
	add	$a0, $s4, $zero
	jal     printHex
	add	$a0, $s5, $zero
	jal     printHex
	add	$a0, $s6, $zero
	jal     printHex
	add	$a0, $s7, $zero
	jal     printHex

	# terminate the program
	addi	$v0, $zero, 10		# syscall_exit
	syscall
	# never get here!



# ---- some functions that the student code can call ----

# int strcmp(char *a, char *b)
# {
#     char *p1 = a;
#     char *p2 = b;
#
#     while (*p1 != '\0' && *p2 != '\0' && *p1 == *p2)
#     {
#         p1++;
#         p2++;
#     }
#
#     return *p1 - *p2;
# }
#
# REGISTERS
#   t0 -  p1
#   t1 -  p2
#   t2 - *p1
#   t3 - *p2
#   t8 - various temporaries

.globl strcmp
strcmp:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	add     $t0, $a0,$zero          # p1 = a
	add     $t1, $a1,$zero          # p2 = b

strcmp_LOOP:
	lb      $t2, 0($t0)             # read *p1
	lb      $t3, 0($t1)             # read *p2
	beq     $t2,$zero, strcmp_DONE  # if (*p1 == '\0') break
	beq     $t3,$zero, strcmp_DONE  # if (*p2 == '\0') break
	bne     $t2,$t3,   strcmp_DONE  # if (*p1 != *p2 ) break

	addi    $t0, $t0,1              # p1++
	addi    $t1, $t1,1              # p2++
	j       strcmp_LOOP

strcmp_DONE:
	sub     $v0, $t2,$t3            # return *p1 - *p2

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



# ---- UTILITY FUNCTIONS, FOR THE TESTCASE ITSELF ----

testcase_dump_bytes:
	# standard prologue
	addiu   $sp, $sp, -24
	sw      $fp, 0($sp)
	sw      $ra, 4($sp)
	addiu   $fp, $sp, 20

	# save the sX registers
	addiu   $sp $sp,-4
	sw      $s0, 0($sp)

	# s0 will save the address of the Turtle object
	add     $s0, $a0,$zero

	# print out the 4 bytes before the struct (to check for underruns)
	lw      $a0, -4($s0)
	jal     printHex

	# print out the 12 bytes of the struct.  But we'll not print the
	# 'name' field directly (since the address of the string is
	# unpredictable); instead, we'll print out the first 4 bytes of
	# the pointed-to string

	lb      $a0, 0($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 1($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 2($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 3($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lw      $a0, 4($s0)
	lb      $a0, 0($a0)
	addi    $a1, $zero,2
	jal     printHex_size

	lw      $a0, 4($s0)
	lb      $a0, 1($a0)
	addi    $a1, $zero,2
	jal     printHex_size

	lw      $a0, 4($s0)
	lb      $a0, 2($a0)
	addi    $a1, $zero,2
	jal     printHex_size

	lw      $a0, 4($s0)
	lb      $a0, 3($a0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 8($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 9($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 10($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	lb      $a0, 11($s0)
	addi    $a1, $zero,2
	jal     printHex_size

	# print out the 4 bytes after the struct (to check for overruns)
	lw      $a0, 12($s0)
	jal     printHex

	# print_char('\n')
	addi    $v0, $zero,11
	addi    $a0, $zero,'\n'
	syscall

	# restore the sX registers
	lw      $s0, 0($sp)
	addiu   $sp $sp,4

	# standard epilogue
	lw      $ra, 4($sp)
	lw      $fp, 0($sp)
	addiu   $sp, $sp, 24
	jr      $ra



# void printHex(int val)
# {
#     printHex_recurse(val, 8);
#     printf("\n");
# }
printHex:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20

	# printHex(val, 8)
	addi   $a1, $zero, 8
	jal    printHex_recurse

	addi   $v0, $zero, 11      # print_char('\n')
	addi   $a0, $zero, 0xa
	syscall

	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



# void printHex_size(int val, int digits)
# {
#     printHex_recurse(val, digits);
#     printf("\n");
# }
printHex_size:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20

	# printHex_recurse(val, digits)
	jal    printHex_recurse

	addi   $v0, $zero, 11      # print_char('\n')
	addi   $a0, $zero, 0xa
	syscall

	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra



printHex_recurse:
	# standard prologue
	addiu  $sp, $sp, -24
	sw     $fp, 0($sp)
	sw     $ra, 4($sp)
	addiu  $fp, $sp, 20

	# if (len == 0) return;    // base case (NOP)
	beq    $a1, $zero, printHex_recurse_DONE

	# recurse first, before we print this character.
	#
	# The reason for this is because the easiest way to break up
	# a long integer is using a small shift and modulo; so *this*
	# call will be responsible for the *last* hex digit, and we'll
	# use recursion to handle the things which come *before* it.
	#
	# As we've seen just above, if the current len==1, then the
	# recursive call will be the base case, and a NOP.

	# of course, we have to save a0 before we recurse.  We do *NOT*
	# need to save a1, since we'll never need it again.
	sw     $a0, 8($sp)

	# printHex_recurse(val >> 4, len-1)
	srl    $a0, $a0,4
	addi   $a1, $a1,-1
	jal    printHex_recurse

	# restore a0
	lw     $a0, 8($sp)

	# the value we will print is (val & 0xf), interpreted as hex.
	andi   $t0, $a0,0x0f      # digit = (val & 0xf)

	slti   $t1, $t0,10        # t1 = (digit < 10)
	beq    $t1, $zero, printHex_recurse_LETTER

	# if we get here, then $t0 contains an integer from 0 to 9, inclusive.
	addi   $v0, $zero, 11     # print_char(digit+'0')
	addi   $a0, $t0, '0'
	syscall

	j      printHex_recurse_DONE

printHex_recurse_LETTER:
	# if we get here, then $t0 contains an integer from 10 to 15, inclusive.
	# convert to the equivalent letter.
	addi   $t0, $t0,-10        # digit -= 10

	addi   $v0, $zero, 11     # print_char(digit+'a')
	addi   $a0, $t0, 'a'
	syscall

	# intentional fall-through to the epilogue

printHex_recurse_DONE:
	# standard epilogue
	lw     $ra, 4($sp)
	lw     $fp, 0($sp)
	addiu  $sp, $sp, 24
	jr     $ra


