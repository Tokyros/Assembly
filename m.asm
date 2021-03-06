#Shahar Rosen
#204541791

.data
ARR: .space 120
HELPER_ARR: .space 120
NUM: .byte 0

#JUMP TABLE
JUMP_TABLE: .word ADD_NUMBER, REPLACE, DEL, FIND, AVERAGE, MAX, PRINT_ARRAY, SORT, END

#Messages
MENU_MSG: .asciiz "\nThe options are:\n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\n"
ARR_FULL_MSG: .asciiz "The array is full."
NUMBER_EXISTS_MSG: .asciiz "Number exists at index: "
NUMBER_NOT_FOUND_MSG: .asciiz "The number does not exist in the array"
ARR_EMPTY_MSG: .asciiz "The array is empty."
INPUT_NUM_MSG: .asciiz "What number to add?"
REPLACE_NUM_MSG: .asciiz "What number to replace?"
REPLACE_WITH_MSG: .asciiz "Replace the number "
IN_INDEX_MSG: .asciiz " (in index "
WITH_WHAT_NUMBER_MSG: .asciiz ") with what number?"
DELETE_NUM_MSG: .asciiz "What number to delete?"
FIND_NUM_MSG: .asciiz "What number to find?"
CHOOSE_BASE_MSG: .asciiz "What basis should be used when printing the average? (2-10)"

.text
#Main procedure, shows the menu and asks for an option from the user
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

#Tries to add a number to the array from user input, 
#if the number the user tries to add exists or the array, notify and don't add
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
ADD_NUMBER:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
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
	
	move $a1, $v0 # Store check result in $t1
	bge $a1, 0, print_number_exists # If check returned an index, print that the number exists
	
	sll $t2, $s2, 2 # Calculate last array index using NUM value
	add $t2, $t2, $s1 # Calculate last array address
	sw $t3, ($t2) # Store user input in arr
	addi $s2, $s2, 1 # Increment arr length by 1
	sw $s2, ($s0) # Store arr length to NUM
	jr $ra # Return to caller

#Asks the user for a number to replace, if that number exists, asks the user what number
#To replace it with and replaces it
#If the array is empty - notify and do nothing
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
REPLACE:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to replace, notify and return to main
	
	li $v0, 4 # Prepare print string
	la $a0, REPLACE_NUM_MSG # What number to replace?
	syscall # Print string
	
	li $v0, 5 # Prepare Read integer
	syscall # Read Integer
	
	sub $sp, $sp, -8 # Decrement $sp
	sw $v0, 4($sp) # Push number input to stack
	sw $ra, 8($sp) # Push $ra to stack
	
	move $a1, $s2 # Pass array length as first argument
	move $a3, $s1 # Pass array address as third argument
	move $a2, $v0 # Pass user input as second argument
	
	jal CHECK # Call check procedure
	
	lw $t3 4($sp) # Pop user input from stack
	lw $ra, 8($sp) # Pop $ra from stack
	addi $sp, $sp, 8 # Increment stack pointer
	
	move $t4, $v0 # Store check result in $t4
	beq $t4, -1, print_number_not_found # If number is not found, notify and return to main
	
	li $v0, 4 # Prepare print string
	la $a0, REPLACE_WITH_MSG # Replace message
	syscall 
	li $v0, 1 # Prepare print Integer
	move $a0, $t3 # Number found
	syscall
	li $v0, 4 # Prepare print string
	la $a0, IN_INDEX_MSG # in index
	syscall
	li $v0, 1 # Prepare print Integer
	move $a0, $t4 # Index found
	syscall
	li $v0, 4 # Prepare print string
	la $a0, WITH_WHAT_NUMBER_MSG # with what number
	syscall

	li $v0, 5 # Prepare read integer
	syscall # Read integer
	
	sub $sp, $sp, -8 # Decrement $sp
	sw $v0, 4($sp) # Push number input to stack
	sw $ra, 8($sp) # Push $ra to stack
	
	move $a1, $s2 # Pass array length as first argument
	move $a3, $s1 # Pass array address as third argument
	move $a2, $v0 # Pass user input as second argument
	
	jal CHECK # Call check procedure
	
	lw $t3 4($sp) # Pop user input from stack
	lw $ra, 8($sp) # Pop $ra from stack
	addi $sp, $sp, 8 # Increment stack pointer
	
	move $a1, $v0 #Pass check result to print_number_exists
	bge $v0, 0, print_number_exists # If the number exists, do no replace
	
	sll $t7, $t4, 2 # Calculate word offset of index found
	add $t7, $t7, $s1 # Address of number to replace
	sw $t3, ($t7) # Store new number in old number address
	
	jr $ra # Return to main

#Asks the user for a number to delete, if the number exists it is deleted and
#the array is rearanged acordingly (so it won't contain blank spaces)
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
DEL:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to delete, notify and return to main
	
	li $v0, 4 # Prepare print string
	la $a0, DELETE_NUM_MSG # what number to delete?
	syscall # Print string
	li $v0, 5 # Prepare read integer
	syscall # Read integer
	
	sub $sp, $sp, -8 # Decrement $sp
	sw $v0, 4($sp) # Push number input to stack
	sw $ra, 8($sp) # Push $ra to stack
	
	move $a1, $s2 # Pass array length as first argument
	move $a3, $s1 # Pass array address as third argument
	move $a2, $v0 # Pass user input as second argument
	
	jal CHECK # Call check procedure
	
	lw $t3 4($sp) # Pop user input from stack
	lw $ra, 8($sp) # Pop $ra from stack
	addi $sp, $sp, 8 # Increment stack pointer
	
	blt $v0, 0, print_number_not_found
	
	move $a1, $s0 # Pass NUM address as first argument
	move $a2, $s1 # Pass ARR address as second argument
	move $a3, $v0 # Pass Index to delete as third argument
	j REDUCTION
	
#Askes the user for a number to find inside the array,
#If the number exists it shows the index of the found number.
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
FIND:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to delete, notify and return to main
	
	li $v0, 4 # Prepare print string
	la $a0, FIND_NUM_MSG # What number to find
	syscall # Print string
	
	li $v0, 5 # Prepare read integer
	syscall # read integer
	
	sub $sp, $sp, -8 # Decrement $sp
	sw $v0, 4($sp) # Push number input to stack
	sw $ra, 8($sp) # Push $ra to stack
	
	move $a1, $s2 # Pass array length as first argument
	move $a3, $s1 # Pass array address as third argument
	move $a2, $v0 # Pass user input as second argument
	
	jal CHECK # Call check procedure
	
	lw $t0 4($sp) # Pop user input from stack
	lw $ra, 8($sp) # Pop $ra from stack
	addi $sp, $sp, 8 # Increment stack pointer
	
	blt, $v0, 0, print_number_not_found # If number was not found by check, notify and return to caller
	
	sub $sp, $sp, -4 # Push to stack
	sw $ra, 4($sp) # Store ra on stack
	
	move $a1, $v0 # Pass found index as first argument
	jal print_number_exists # Print the found number's index
	
	lw $ra, 4($sp) # Read ra from stack
	addi $sp, $sp, 4 # Pop stack
	
	jr $ra #return to caller
	
#Calculates the average of all items in the array and prints it in a basis
#according to user input between 2-10
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
AVERAGE:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to average, notify and return to main
	
	li $t0, 0 # Running total
	li $t1, 0 # Index counter
sum_loop:
	sll $t2, $t1, 2 # Calculate word offset
	add $t3, $t2, $s1 # Calculate array address
	lw $t4, ($t3) # Read value from array
	add $t0, $t0, $t4 # Sum values
	addi $t1, $t1, 1 # Increment index counter
	ble $t1, $s2, sum_loop # Keep iterating until end of array
	
	div $t0, $s2 # Divide sum by array length
	mflo $t0 # Get the quotatient from the division
	
	li $v0, 4 # Prepare print string
	la $a0, CHOOSE_BASE_MSG #What basis to print?
	syscall # Print string
	
	li $v0, 5 # Prepare read integer
	syscall # Read integer
	
	sub $sp, $sp, -4 # Decrement $sp
	sw $ra, 4($sp) # Push $ra to stack
	
	move $a1, $t0 # Pass average to print
	move $a2, $v0 # Pass basis to print in
	
	jal PRINT_NUM # Call print_num procedure
	
	lw $ra, 4($sp) # Pop $ra from stack
	addi $sp, $sp, 4 # Increment stack pointer
	
	jr $ra

#Finds the highest number in the array and prints it in a chosen basis (2-10)
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
MAX:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to delete, notify and return to main
	
	lw $t0, ($s1) # load first number from array
	li $t1, 0 # index counter
loop_max:
	sll $t2, $t1, 2 # Calculate word offset for index
	add $t3, $t2, $s1 # Calculate current address of array
	lw $t4, ($t3) # Read value from array
	bgt $t4, $t0, replace_max # Check if current value is greater than max number so far
	addi $t1, $t1, 1 # Increment index counter
continue_loop:
	ble $t1, $s2, loop_max # loop until end of array
	
	li $v0, 4 # Prepare print string
	la $a0, CHOOSE_BASE_MSG #What basis to print?
	syscall # Print string
	
	li $v0, 5 # Prepare read integer
	syscall # Read integer
	
	sub $sp, $sp, -4 # Decrement $sp
	sw $ra, 4($sp) # Push $ra to stack
	
	move $a1, $t0 # Pass max to print
	move $a2, $v0 # Pass basis to print in
	
	jal PRINT_NUM # Call print_num procedure
	
	lw $ra, 4($sp) # Pop $ra from stack
	addi $sp, $sp, 4 # Increment stack pointer
	
	jr $ra # return to caller

replace_max:
	move $t0, $t4 # store the new max value in t0
	j continue_loop # return to loop

#Prints all elements in array in a chosen basis (2-10)
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
PRINT_ARRAY:
	move $s0, $a1 # NUM address
	move $s1, $a2 # ARR address
	lb $s2, ($a1) # ARR length
	
	beq $s2, 0, print_arr_empty # If array is empty, nothing to delete, notify and return to main
	
	li $s3, 0 # index counter
	
	li $v0, 4 # Prepare print string
	la $a0, CHOOSE_BASE_MSG #What basis to print?
	syscall # Print string
	
	li $v0, 5 # Prepare read integer
	syscall # Read integer
	
	move $s4, $v0 # Store basis in $s0
	
loop_array:
	sll $t1, $s3, 2 # Calculate word offset
	add $t2, $t1, $s1 # Calculate current address of array
	lw $t3, ($t2) # load number from array

	sub $sp, $sp, -4 # Decrement $sp
	sw $ra, 4($sp) # Push $ra to stack
	
	move $a1, $t3 # Pass max to print
	move $a2, $s4 # Pass basis to print in
	
	jal PRINT_NUM # Call print_num procedure
	
	lw $ra, 4($sp) # Pop $ra from stack
	addi $sp, $sp, 4 # Increment stack pointer
	
	li $v0, 11 # Prepare print char
	li $a0, ',' # Print ,
	syscall
	
	addi $s3, $s3, 1 # increment index counter
	blt $s3, $s2, loop_array # loop until end of array
	
	jr $ra # return to caller

#Unimplemented - should sort the array into the helper array
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
SORT:
	jr $ra

#Quits the program
#$a1 = num address
#$a2 = arr address
#$a3 = helper arr address
END:
	li $v0, 10 #Prepare exit syscall
	syscall #Exit

#==================
#Helper procedures=
#==================

#Procedure that returns the index of a number in an array (if not found, returns -1)
#$a1 = Arr Length
#$a2 = Number to check for
#$a3 = Arr base address
CHECK:
	li $t0, 0 # Loop counter
check_loop:
	beq $t0, $a1, number_not_found # Finished iterating array (number not found)
	sll $t1, $t0, 2 # Multiply counter to align with word
	add $t2, $a3, $t1 # Calculate current arr address
	lw $t3, ($t2) # Read value from array
	beq $t3, $a2, number_found # Value from array == argument number -> return index
	addi $t0, $t0, 1 # Increment loop counter
	j check_loop # loop
	
number_not_found:
	li $v0, -1 # Return -1 when number is not found
	jr $ra # Return to caller

number_found:
	move $v0, $t0 # return index where number was found
	jr $ra # Return to caller
#END OF CHECK

#Procedure that deletes a value from the array and updates the state of the array accordingly
#$a1 = NUM address
#$a2 = ARR address
#$a3 = Index to delete
REDUCTION:
	move $t0, $a3 # Index counter
	addi $t1, $t0, 1 # Current index to move back
	lb $t2, ($a1) #Array length
reduction_loop:
	sll $t3, $t0, 2 # Calculate word offset
	add $t4, $a2, $t3 # Calculate current address to delete
	bge $t0, $t2, end_reduction # Keep looping until end of array reached
	add $t5, $t4, 4 # Calculate address of next number
	lw $t6, ($t5) # Read next number from memory
	sw $t6, ($t4) # Replace current number with next number
	addi $t0, $t0, 1 # Increment index counter
	addi $t1, $t1, 1 # Increment next number index
	j reduction_loop # loop

end_reduction:
	sw $0, ($t4) # Delete last element from old array
	sub $t2, $t2, 1 # Decrement array length
	sw $t2, ($a1) # Save new array length to memory
	jr $ra # Return to caller
	
#A procedure to convert a number to a specified base and print it
#$a1 = number to print
#$a2 = base
PRINT_NUM:
	move $t0, $a1 # store number in temp
	li $t1, 0 # stack pushes counter
	bge $t0, 0, print_num_loop # if number is positive, simply print
	
	li $v0, 11 # Prepare print char
	li $a0, '-' #print minus sign
	syscall
	abs $t0, $t0 # Replace with absolute value

print_num_loop:
	beq $t0, 0, print_from_stack # when number is 0 we're done
	div $t0, $a2 # devide number by base
	mfhi $t2 # remainder
	mflo $t0 # quotiant
	
	sub $sp, $sp, 4 # push stack
	addi $t1, $t1, 1 # count how many pushes were made
	sw $t2, ($sp) # save remainder to stack
	j print_num_loop

print_from_stack:
	lw $t4, ($sp) # read current num from stack
	addi $sp, $sp, 4

	li $v0, 1 # Prepare print integer
	move $a0, $t4 # print current num from stack
	syscall
	
	subi $t1, $t1, 1 # Decrement push counter

	bgt $t1, 0, print_from_stack # When push counter is 0 we are done reading from the stack
	jr $ra # return to caller

#====================
#Printing procedures=
#====================

print_arr_empty:
	li $v0, 4 # Prepare print string
	la $a0, ARR_EMPTY_MSG # Notify array is empty
	syscall # Print string
	jr $ra # Return to main
	
print_arr_full:
	li $v0, 4 # Prepare print string
	la $a0, ARR_FULL_MSG # Notify array is full
	syscall # Print string
	jr $ra # Return to $ra

print_number_not_found:
	li $v0, 4 # Prepare print string
	la $a0, NUMBER_NOT_FOUND_MSG # Number does not exist in array
	syscall # Print string
	jr $ra # Return to main
	
#$a1 = index of number
print_number_exists:
	li $v0, 4 # Prepare print string
	la $a0, NUMBER_EXISTS_MSG # Notify number exists
	syscall # Print string
	li $v0, 1 # Prepare print integer
	move $a0, $a1 # Print index value returned from CHECK
	syscall # Print integer
	jr $ra # Return to main
