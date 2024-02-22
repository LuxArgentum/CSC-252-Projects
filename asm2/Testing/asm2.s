.data

PRINT1:		.asciiz "Fibonacci Numbers:\n"			# String 1
PRINT2: 	.asciiz	"  0: 1\n"				# String 2
PRINT3: 	.asciiz	"  1: 1\n"				# String 3

Space:		.asciiz "  "					# Space
ColonSpace:	.asciiz ": "					# Colon Space
Newline:	.asciiz "\n"					# Newline

lr_plus:	.asciiz "+"					# lr_plus
mid_plus:	.asciiz "-"					# mid_plus
lr_bar:		.asciiz "|"					# lr_bar

ASCENDING:	.asciiz "Run Check: ASCENDING\n"			# Ascending
DESCENDING:	.asciiz "Run Check: DESCENDING\n"			# Descending
NEITHER:	.asciiz "Run Check: NEITHER\n"			# Neither

COUNT_MSG:	.asciiz	"Word Count: "				# Count message
REV_STRING:	.asciiz	"String successfully swapped!\n"	# Rev String


.text


.globl studentMain
studentMain:
	addiu	$sp, $sp, -24 		    	# allocate stack space -- default of 24 here
	sw 	$fp, 0($sp)			# save caller’s frame pointer
	sw 	$ra, 4($sp) 			# save return address
	addiu 	$fp, $sp, 20 			# setup main’s frame pointer
	
	# FIB TASK
	
	# Check whether to do Fib or not
	
	la 	$s0, fib			# $s0 = &fib
	lw 	$s0, 0($s0)			# $s0 = fib
	
	beq 	$s0, $zero, SKIPFIB		# If (fib != 0)
	
	# printf("Fibonacci Numbers:\n");
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, PRINT1                  	# $a0 = &PRINT1
    	syscall                                 # Print PRINT1
	
	# printf(" 0: 1\n");
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, PRINT2                  	# $a0 = &PRINT2
    	syscall                                 # Print PRINT2
    	
	# printf(" 1: 1\n");
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, PRINT3                  	# $a0 = &PRINT3
    	syscall                                 # Print PRINT3
	
	# int prev = 1, beforeThat = 1;
	# int n = 2;
	addi	$s1, $zero, 1			# prev
	addi	$s2, $zero, 1			# beforeThat
	addi	$s3, $zero, 2			# n
	
	# while (n <= fib)
	
	LOOPFIB:
	slt 	$t0, $s0, $s3			# $t0 = fib < n
	bne	$t0, $zero, EXITFIB		# if !(fib < n == 0) GoTo EXITFIB
	
	add	$t1, $s1, $s2			# int cur = prev+beforeThat;
	
	# printf(" %d: %d\n", n, cur);
	
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, Space	              	# $a0 = &Space
    	syscall         
    	
	addi 	$v0, $zero, 1               	# $v0 = 4
    	add 	$a0, $zero, $s3               	# $a0 = &n
    	syscall     
    	
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, ColonSpace                 # $a0 = &ColonSpace
    	syscall     
    	
	addi 	$v0, $zero, 1               	# $v0 = 4
    	add 	$a0, $zero, $t1                 # $a0 = &cur
    	syscall                             	
    	
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, Newline                  	# $a0 = &Newline
    	syscall                             	
    	
	# n++;
	addi	$s3, $s3, 1
	# beforeThat = prev;
	add	$s2, $s1, $zero
	# prev = cur;
	add	$s1, $t1, $zero
	
	j	LOOPFIB				# Loop Fib again
	
	EXITFIB:
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
	
	SKIPFIB:
	
	# SQUARE TASK
	
	# if (square != 0)
	
	# Check whether to do Square or not
	
	la 	$t0, square			# $t0 = &square
	lw 	$t0, 0($t0)			# $t0 = square
	
	beq 	$t0, $zero, SKIPSQUARE		# If (square != 0)
	
	# Get square_size & square_fill
	
	# square_size is a word
	
	la	$s1, square_size		# $s1 = &square_size
	lw	$s1, 0($s1)			# $s1 = square_size
	
	# square_fill is a byte
	
	la	$s2, square_fill		# $s2 = &square_fill
	lb	$s2, 0($s2)			# $s2 = square_fill
	
	# for (int row=0; row < square_size; row++)
	
	add	$t0, $zero, $zero		# row = 0
	
	LOOPSQUARE:
	
	slt	$t1, $t0, $s1			# row < square_size
	beq	$t1, $zero, EXITSQUARE		# if !(row < square_size) GoTo EXITSQUARE
	
	# if (row == 0 || row == square_size-1)
	addi	$t2, $s1, -1			# square_size - 1
	beq	$t0, $zero, PLUSPRINT		# if (row != 0) GoTo PLUSPRINT
	beq	$t0, $t2, PLUSPRINT		# if (row != square_size - 1) GoTo PLUSPRINT
	
	# Print lr_bar & mid_bar (square_fill)
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, lr_bar			# $a0 = &lr_bar
	syscall
	
	# for (int i=1; i<square_size-1; i++)
	
	addi	$t3, $zero, 1
	
	BARLOOP:
	
	slt	$t4, $t3, $t2
	beq	$t4, $zero, END_BAR
	
	addi 	$v0, $zero, 11			# $v0 = 1
	add	$a0, $s2, $zero			# $a0 = square_fill
	syscall
	
	addi	$t3, $t3, 1
	
	j 	BARLOOP
	
	END_BAR:
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, lr_bar			# $a0 = &lr_plus
	syscall
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
	
	j	ENDCHARLOOP
	
	PLUSPRINT:
	
	# Print lr_plus & mid_plus
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, lr_plus			# $a0 = &lr_plus
	syscall
	
	# for (int i=1; i<square_size-1; i++)
	
	addi	$t3, $zero, 1
	
	PLUSLOOP:
	
	slt	$t4, $t3, $t2
	beq	$t4, $zero, END_PLUS
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, mid_plus			# $a0 = &mid_plus
	syscall
	
	addi	$t3, $t3, 1
	
	j 	PLUSLOOP
	
	END_PLUS:
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, lr_plus			# $a0 = &lr_plus
	syscall
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
		
	ENDCHARLOOP:
	
	addi	$t0, $t0, 1
	
	j	LOOPSQUARE
	
	EXITSQUARE:
	
	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
	
	SKIPSQUARE:
	
	# RUN CHECK TASK
	
	la 	$t0, runCheck			# $t0 = &runCheck
	lw 	$t0, 0($t0)			# $t0 = runCheck
	
	beq 	$t0, $zero, SKIPRUN		# If (runCheck != 0)
	
	la	$s1, intArray			# $t0 = &intArray
	
	la	$s2, intArray_len		# $t0 = &intArray_len
	lw	$s2, 0($s2)			# $t0 = intArray_len
	
	add	$t1, $zero, $zero		# $t2 = i
	
	addi	$s3, $zero, 1			# $s3 = 1 (Ascending)
	addi	$s4, $zero, 1			# $s4 = 1 (Descending)
	
	RUNLOOP:
	
	slt	$t2, $s2, $t1			# $t3 = (i > len)
	bne	$t2, $zero, ENDRUNLOOP		# if !(i < len) goto ENDRUNLOOP
	
	lw	$t0, 0($s1)			# $t0 = intArray[0]
	lw	$t3, 4($s1)			# $t3 = intArray[4]
	
	slt 	$t4, $t3, $t0            	# $t4 = 1 if $t0 > $t3 (ascending order check)
    	slt 	$t5, $t0, $t3           	# $t5 = 1 if $t3 < $t0 (descending order check)
    	
    	bne 	$t4, $zero, NOT_ASCEND      	# If not ascending, clear ascending $s3 = 0
    	
    	j 	CONTINUE
    	
    	NOT_ASCEND:
    	
    	add	$s3, $zero, $zero		# $s3 = 0
    	
    	CONTINUE:
    	
    	bne 	$t5, $zero, NOT_DESCEND     	# If not descending, clear descFlag
    	
    	j 	NEXT_LOOP
    	
    	NOT_DESCEND:
    	
    	add	$s4, $zero, $zero		# $s4 = 0
    	
    	NEXT_LOOP:
    	
    	addi 	$s1, $s1, 4             	# Move to the next element
    	addi 	$t1, $t1, 1             	# i++
    	
    	j 	RUNLOOP
    	
    	ENDRUNLOOP:
    	
    	beq	$s3, $zero, DES_CHECK
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, ASCENDING                  # $a0 = &ASCENDING
    	syscall
    	
    	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
    	
    	DES_CHECK:
    	
    	beq	$s4, $zero, NEITHER_CHECK
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, DESCENDING                 # $a0 = &DESCENDING
    	syscall
    	
    	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
    	
    	NEITHER_CHECK:
    	
    	bne	$s3, $zero, SKIPRUN
    	bne	$s4, $zero, SKIPRUN
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, NEITHER                  	# $a0 = &NEITHER
    	syscall
    	
    	addi 	$v0, $zero, 4			# $v0 = 4
	la	$a0, Newline			# $a0 = &Newline
	syscall
    	
    	j	SKIPRUN
	
	SKIPRUN:
	
	# COUNT WORDS TASK
	
	la 	$t0, countWords			# $t0 = &countWords
	lw 	$t0, 0($t0)			# $t0 = countWords
	
	beq 	$t0, $zero, SKIPCOUNT		# If (countWords != 0)
	
	la	$s0, str			# $s0 = &str
	add	$t0, $zero, $zero		# $t1 = 0 (word count)
	addi	$t1, $zero, 1			# $t2 = 1 (outside word)
	
	COUNT_LOOP:
	
	lb	$t2, 0($s0)			# $t2 = str
	beq	$t2, $zero, PRINT_COUNT
	
	addi 	$t3, $zero, 32             	# ASCII for space
    	addi 	$t4, $zero, 10             	# ASCII for newline
    	
    	beq 	$t2, $t3, CHECK_STATE
    	beq 	$t2, $t4, CHECK_STATE
    	
    	bne 	$t1, $zero, IN_WORD
    	
    	j 	COUNT_CONTINUE
    	
    	CHECK_STATE:
    	
    	beq 	$t1, $zero, OUT_WORD
    	
    	j 	COUNT_CONTINUE
    	
    	IN_WORD:
    	
    	add	$t1, $zero, $zero
    	addi	$t0, $t0, 1
    	
    	j	COUNT_CONTINUE
    	
    	OUT_WORD:
    	
    	addi	$t1, $zero, 1
    	
    	COUNT_CONTINUE:
    	
    	addi	$s0, $s0, 1
    	
    	j	COUNT_LOOP
    	
    	PRINT_COUNT:
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, COUNT_MSG                  # $a0 = &COUNT_MSG
    	syscall
    	
    	addi 	$v0, $zero, 1               	# $v0 = 1
    	add 	$a0, $zero, $t0                 # $a0 = $t0
    	syscall
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, Newline                  	# $a0 = &Newline
    	syscall
    	
    	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, Newline                  	# $a0 = &Newline
    	syscall
	
	SKIPCOUNT:

	
	# Rev String Task
	
	la 	$t0, revString			# $t0 = &revString
	lw 	$t0, 0($t0)			# $t0 = revString
	
	beq 	$t0, $zero, DONE		# If (revString != 0)
	
	la	$t0, str
	
	add	$s1, $zero, $zero
	add	$s2, $zero, $zero
	
	REV_LOOP_TAIL:
	
	add	$t1, $t0, $s2
	lb	$t2, 0($t1)
	
	beq	$t2, $zero, SWAP
	
	addi	$s2, $s2, 1
	
	j	REV_LOOP_TAIL
	
	SWAP:
	
	addi	$s2, $s2, -1
	
	SWAP_LOOP:
	
	slt	$t3, $s1, $s2
	beq	$t3, $zero, PRINT
	
	# Calculate the address for str[head] and str[tail]
    	add 	$t4, $t0, $s1    		# Address of str[head] in $t4
    	add 	$t5, $t0, $s2    		# Address of str[tail] in $t5
	
    	# Load the characters from head and tail positions into $t6 and $t7
    	lb 	$t6, 0($t4)       		# Load the byte from head into $t6
    	lb 	$t7, 0($t5)       		# Load the byte from tail into $t7
	
    	# Swap the characters
    	sb 	$t6, 0($t5)       		# Store the byte from head into tail position
    	sb 	$t7, 0($t4)       		# Store the byte from tail into head position
	
    	# Increment the head index and decrement the tail index
    	addi $s1, $s1, 1     			# Increment head index
    	addi $s2, $s2, -1    			# Decrement tail index
	
	j	SWAP_LOOP
	
	PRINT:
	
	# printf("String successfully swapped!\n");
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, REV_STRING                  # $a0 = &REV_STRING
    	syscall
	

	# printf("\n");
	
	addi 	$v0, $zero, 4               	# $v0 = 4
    	la 	$a0, Newline                  	# $a0 = &Newline
    	syscall
	
	DONE:
	
	lw 	$ra, 4($sp) 			# get return address from stack
	lw 	$fp, 0($sp) 			# restore the caller’s frame pointer
	addiu 	$sp, $sp, 24 			# restore the caller’s stack pointer
	jr 	$ra 				# return to caller’s code
