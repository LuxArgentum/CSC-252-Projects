.data

DASH_START: .asciiz "----------------\n"
DASH_END: .asciiz "\n----------------\n"

.text

countLetters:

# Make a stack with enough room for 26 letters
# Fill the stack with zeros
# A register with zero? (int other = 0)

# Print the Dash Start, the argument string, and the Dash End (char *str)

# Register for current character (char *cur = str)

# While current does not equal end line (\0)

# If *cur >= a and *cur =< z
# Increment the stack at *cur - a

# Else if *cur >= A and *cur =< Z
# Increment the stack at *cur - A

# Else
# Increment other

# Increment cur

# Jump back to the while loop

# For each letter in the stack
# Print the letter and the number of times it appears

# Print the other count

subsCipher:

# Calculate the size of the array needed
# Round length up to the nearest multiple of 4
# Allocate an array of that size one the stack

# Receive char *str and char *map

# Get len of str with strLen and add 1 to the output it returns (int len = strLen(str) + 1)

# Round up the length to the nearest multiple of 4 (int len4 = (len + 3) & ~0x3)

# Make a duplicate string with the length of len4 

# Iterate over every character in the original string

# Add the map value of each character to the duplicate string

# At the end of the string, add the null terminator

# Print the string

strLen: # Calculate the length of the string