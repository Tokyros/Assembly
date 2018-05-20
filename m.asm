.data
ARR: .space 120
NUM: .byte 0
HELPER_ARR: .space 120

#JUMP TABLE
JUMP_TABLE: ADD_NUMBER, REPLACE, DEL, FIND, AVERAGE, MAX, PRINT_ARRAY, SORT 

#Messages
MENU_MSG: .asciiz "The options are:\n1. Enter a number (base 10)\n2. Replace a number (base 10)\n3. DEL a number (base 10)\n4. Find a number in the array (base 10)\n5. Find average (base 2-10)\n6. Find Max (base 2-10)\n7. Print the array elements (base 2-10)\n8. Print sort array (base 2-10)\n9. END\n"
ARR_FULL_MSG: .asciiz "The array is full."
ARR_EMPTY_MSG: .asciiz "The array is empty."
INPUT_NUM_MSG: .asciiz "What number to add?"
REPLACE_NUM_MSG: .asciiz "What number to replace?"
REPLACE_WITH_MSG: .asciiz "Replace the number # (in index #) with what number?"
DELETE_NUM_MSG: .asciiz "What number to delete?"
FIND_NUM_MSG: .asciiz "What number to find?"