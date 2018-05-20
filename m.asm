.data
ARR: .space 120
NUM: .byte 0
HELPER_ARR: .space 120

#JUMP TABLE
JUMP_TABLE: .word ADD_NUMBER, REPLACE, DEL, FIND, AVERAGE, MAX, PRINT_ARRAY, SORT 

#Messages
MENU_MSG: .asciiz "\nThe options are:\n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\n"
ARR_FULL_MSG: .asciiz "The array is full."
NUMBER_EXISTS_MSG: .asciiz "Number exists at index: "
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
	subi $t0, $t0, 1 #Subtract 1 from user choice
	sll $t0, $t0, 2 #Multilply by 4 to allign with word
	lw $t0, JUMP_TABLE($t0) #Load procedure address from jump table
	
	la $a1, NUM #Load num address as first argument
	la $a2, ARR #Load arr address as second argument
	la $a3, HELPER_ARR #Load helper arr as third argument
	jalr $t0 #Call procedure
	j main #Loop menu

#Menu procedures
ADD_NUMBER:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address

	lb $s2, ($a1) # get array length
	beq $s2, 30, print_arr_full # if array is full, print it and return to main
	
	li $v0, 4 # Prepare print string
	la $a0, INPUT_NUM_MSG # ask user for number
	syscall # Print string
	
	li $v0, 5 # read integer
	syscall # read integer
	
	sub $sp, $sp, -8 # Decrement $sp
	sw $v0, 4($sp) # Push number input to stack
	sw $ra, 8($sp) # Push $ra to stack
	
	move $a1, $s2 # Pass array length as first argument
	move $a3, $a2 # Pass array address as third argument
	move $a2, $v0 # Pass user input as second argument
	
	jal CHECK # Call check procedure
	lw $t3 4($sp) # Pop user input from stack
	lw $ra, 8($sp) # Pop $ra from stack
	addi $sp, $sp, 8 # Increment stack pointer
	move $t1, $v0 # Store check result in $t1
	
	bge $t1, 0, print_number_exists # If check returned an index, print that the number exists
	sll $t2, $s2, 2 # Calculate last array index using NUM value
	add $t2, $t2, $s1 # Calculate last array address
	sw $t3, ($t2) # Store user input in arr
	addi $s2, $s2, 1 # Increment arr length by 1
	sw $s2, ($s0) # Store arr length to NUM
	jr $ra # Return to caller
	
print_arr_full:
	li $v0, 4 # Prepare print string
	la $a0, ARR_FULL_MSG # Notify array is full
	syscall # Print string
	jr $ra # Return to $ra

print_number_exists:
	li $v0, 4 # Prepare print string
	la $a0, NUMBER_EXISTS_MSG # Notify number exists
	syscall # Print string
	li $v0, 1 # Prepare print integer
	move $a0, $t1 # Print index value returned from CHECK
	syscall # Print integer
	jr $ra # Return to main

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
#$a1 = Arr Length
#$a2 = Number to check for
#$a3 = Arr address
CHECK:
	li $t0, 0 # Loop counter
	move $t3, $a3 #Array base address
check_loop:
	beq $t0, $a1, number_not_found # Finished iterating array (number not found)
	sll $t1, $t0, 2 # Multiply counter to align with word
	add $t4, $t3, $t1 # Calculate current arr address
	lw $t2, ($t4) # Read value from array
	beq $t2, $a2, number_found # Value from array == argument number -> return index
	addi $t0, $t0, 1 # Increment loop counter
	j check_loop # loop
	
number_not_found:
	li $v0, -1 # Return -1 when number is not found
	jr $ra # Return to caller

number_found:
	move $v0, $t0 # return index where number was found
	jr $ra # Return to caller