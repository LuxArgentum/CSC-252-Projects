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

