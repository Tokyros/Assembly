.data
ARR: .space 120
NUM: .byte 0
HELPER_ARR: .space 120

#JUMP TABLE
JUMP_TABLE: .word ADD_NUMBER, REPLACE, DEL, FIND, AVERAGE, MAX, PRINT_ARRAY, SORT 

#Messages
MENU_MSG: .asciiz "The options are:\n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\n"
ARR_FULL_MSG: .asciiz "The array is full."
ARR_EMPTY_MSG: .asciiz "The array is empty."
INPUT_NUM_MSG: .asciiz "What number to add?"
REPLACE_NUM_MSG: .asciiz "What number to replace?"
REPLACE_WITH_MSG: .asciiz "Replace the number # (in index #) with what number?"
DELETE_NUM_MSG: .asciiz "What number to delete?"
FIND_NUM_MSG: .asciiz "What number to find?"

.text
main:
	li $v0, 4 #Prepate print string syscall
	la $a0, MENU_MSG #Print menu options
	syscall #Print
	li $v0, 5 #Prepare read integer syscall
	syscall #Read Integer
	move $t0, $v0 #Store user input in $t0
	sll $t0, $t0, 2 #Multilply by 4 to allign with word
	lw $t0, JUMP_TABLE($t0) #Load procedure address from jump table
	jalr $t0 #Call procedure
	j main #Loop menu

#Menu procedures
ADD_NUMBER:
REPLACE:
DEL:
FIND:
AVERAGE:
MAX:
PRINT_ARRAY:
SORT:
END:
	li $v0, 10 #Prepare exit syscall
	syscall #Exit

#Helper procedures
