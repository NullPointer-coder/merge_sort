# This program that implements two functions, merge and print_array,
# and calls those two functions to show that the operate correctly
# Jingbo Wang

  .data
array1:                     # global variable for array1
  .word 1, 3, 4, 5, 8, 9
    
  .align 4
array2:                     # global variable for array2
  .word 2, 6, 7, 8

  .align 6
newline:
  .asciiz "\n"

  .text
  .globl main
main:
  # s0: the length of array1
  # s1: the length of array2

  la    $a0, array1         # copy array1 to argument a0
  move  $t0, $zero          # i = 0
  move  $a1, $a0            # store array1 to argument a0 
  
while1:                     # to calculate the length of array1
  sll   $t1, $t0, 2         # $t1 = i * 4
  addu  $t1, $t1, $a0       # $t1 = &array1[i]
  lw    $t2, 0($t1)         # $t2 = array1[i]
  beq   $t2, $zero, done1   # goto done if array1[i] == \0
  addiu $t0, 1              # i++
  j     while1
done1:
  move  $s0, $t0            # store i into s0

  la    $a0, array2         # copy array2 to argument 0
  move  $t0, $zero          # i = 0

while2:                     # to calculate the length of array2
  sll	$t1, $t0, 2         # $t1 = i * 4
  addu  $t1, $t1, $a0       # $t1 = &array2[i]
  lw    $t2, 0($t1)         # $t2 = array2[i]
  beq   $t2, $zero, done2   # goto done if array2[i] = \0
  addiu $t0, 1              # i++
  j     while2
done2:
  move  $s1, $t0            # store i into s0
 
  move  $a2, $s0            # store array1 length into a2
  jal   print_array         # print out array1
  
  la    $a0, newline        # echo print newline
  li    $v0, 4                
  syscall
  
  la    $a1, array2         # store array2 into a1
  move  $a2, $s1            # store array2 length into a2
  jal   print_array         # print out array2
  
  la    $a0, newline        # echo print newline
  li    $v0, 4                
  syscall
  
  la    $a1, array1         # store array1 length into a1
  la    $a2, array2         # store array2 length into a2
  jal   merge
  
    
  la    $a0, newline        # echo print newline
  li    $v0, 4                
  syscall
  
  la    $a1, array1         # store array1 into a1
  add   $a2, $s0, $s1       # result array length = s0 + s1
  jal   print_array         # print out array1

exit:
  li    $v0, 10             # exit
  syscall
  .end main 

merge:
  # a0: the temp value which be put into stack
  # a1: the parameter to the array1
  # a2: the parameter to the array2
  # a3: the length of new array
  # s0: the length of array1
  # s1: the length of array2
  # t0: the index of array1
  # t1: the index of array2
  # t2: the index of result array
  # t3: the shift left logical reference address to array1[i]
  # t4: the shift left logical reference address to array2[i]
  # t5: the value of array1[i]
  # t6: the value of array2[i]

  addiu $sp, -4             # push ra
  sw    $ra, 0($sp)
  addiu $sp, -4             # push t0
  sw    $t0, 0($sp)            
  addiu $sp, -4             # push t1
  sw    $t1, 0($sp)  
  addiu $sp, -4             # push t2
  sw    $t2, 0($sp)
  addiu $sp, -4             # push t3
  sw    $t3, 0($sp)  
  addiu $sp, -4             # push t4
  sw    $t4, 0($sp)
  addiu $sp, -4             # push t5
  sw    $t5, 0($sp)
  addiu $sp, -4             # push t6
  sw    $t6, 0($sp)
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp)
  addiu $sp, -4             # push a1
  sw    $a1, 0($sp) 
  addiu $sp, -4             # push a2
  sw    $a2, 0($sp) 
  addiu $sp, -4             # push a3
  sw    $a3, 0($sp)  
  
  move  $t0, $zero          # a_index = 0
  move  $t1, $zero          # b_index = 0
  move  $t2, $zero          # r_index = 0
  
first_merge:
  bge   $t0, $s0, merge2    # goto merge2 if a_index >= array1 length  
  bge   $t1, $s1, merge2    # goto merge2 if b_index >= array2 length
  
  sll	$t3, $t0, 2         # t3 = a * 4
  addu  $t3, $t3, $a1       # t3 = &a[a_index]
  lw    $t5, 0($t3)         # t5 = a[a_index]

  sll	$t4, $t1, 2         # t4 = a * 4
  addu  $t4, $t4, $a2       # t4 = &a[b_index]
  lw    $t6, 0($t4)         # t6 = b[b_index]

if:
  bge   $t5, $t6, else      # if a[a_index] >= b[b_index]
  lw    $a0, 0($t3)         # a0 = a[a_index]
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp) 
  addiu $t0, 1              # a_index++
  j     if_exit
else: 
  lw    $a0, 0($t4)         # a0 = b[b_index]
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp) 
  addiu $t1, 1              # b_index++
if_exit:
  addiu $t2, 1              # r_index++
  j     first_merge 

merge2:
  bge   $t0, $s0, merge3    # goto merge2 if a_index >= array1 length

  sll	$t3, $t0, 2         # t3 = a * 4
  addu  $t3, $t3, $a1       # t3 = &a[a_index]
  lw    $a0, 0($t3)         # t3 = a[a_index]
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp)

  addiu $t0, 1              # a_index++
  addiu $t2, 1              # r_index++ 
  j     merge2

merge3:
  bge   $t1, $s1, store     # goto store if b_index >= array2 length 

  sll	$t4, $t1, 2         # t4 = b * 4
  addu  $t4, $t4, $a2       # t4 = &a[b_index]
  lw    $a0, 0($t4)         # t3 = b[b_index]
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp)

  addiu $t1, 1              # b_index++
  addiu $t2, 1              # r_index++ 
  j     merge3

store:
  add   $a3, $t2, $zero     # result_length = r_index
  subu  $t2, $t2, 1         # r_index = r_length - 1

store_for:
  blt   $t2, $zero, for_over# if r_index < 0 goto for_over

  lw    $a0, 0($sp)         # pop a0
  addiu $sp, 4

  sll	$t3, $t2, 2         # t3 = t2 * 4
  addu  $t3, $t3, $a1       # t3 = &a[r_index] 
  sw    $a0, 0($t3)         # a[r_index] = a0
  sub   $t2, 1              # r_index--
  j     store_for
  
for_over:
  move  $a2, $a3            # a2 = result_length
  jal   print_array         # print out new array1
  
over:                       # merge sort function over
  lw    $a3, 0($sp)         # pop a3
  addiu $sp, 4
  lw    $a2, 0($sp)         # pop a2
  addiu $sp, 4
  lw    $a1, 0($sp)         # pop a1
  addiu $sp, 4
  lw    $a0, 0($sp)         # pop a0
  addiu $sp, 4
  lw    $t6, 0($sp)         # pop t6
  addiu $sp, 4
  lw    $t5, 0($sp)         # pop t5
  addiu $sp, 4
  lw    $t4, 0($sp)         # pop t4
  addiu $sp, 4
  lw    $t3, 0($sp)         # pop t3
  addiu $sp, 4
  lw    $t2, 0($sp)         # pop t2
  addiu $sp, 4
  lw    $t1, 0($sp)         # pop t1
  addiu $sp, 4
  lw    $t0, 0($sp)         # pop t0
  addiu $sp, 4
  lw    $ra, 0($sp)         # pop ra
  addiu $sp, 4
  jr    $ra                 

print_array:
  # a0: the printing array[i]
  # a1: the parameter to the an array
  # a2: the length of the array
  # v0: the commend for syscall to print 
  # t0: the index of array
  # t1: the shift left logical reference address to array[i]

  addiu $sp, -4             # push t0
  sw    $t0, 0($sp)            
  addiu $sp, -4             # push t1
  sw    $t1, 0($sp)
  addiu $sp, -4             # push v0
  sw    $v0, 0($sp)

  move  $t0, $zero          # i = 0  
for:
  sll	$t1, $t0, 2         # $t1 = i * 4
  addu  $t1, $t1, $a1       # $t1 = &array[i]
  bge   $t0, $a2, print_over# goto print_over if t0 >= array length
  addiu $t0, 1              # i++
  
  addiu $sp, -4             # push a0
  sw    $a0, 0($sp)

  lw    $a0, 0($t1)         # a0 = array[i] 
  li    $v0, 1              # print out int value
  syscall

  lw    $a0, 0($sp)         # pop a0
  addiu $sp, 4
  j     for   

print_over:                 # print out all value in the array
  lw    $v0, 0($sp)         # pop v0
  addiu $sp, 4
  lw    $t1, 0($sp)         # pop t1
  addiu $sp, 4
  lw    $t0, 0($sp)         # pop t0
  addiu $sp, 4
  jr    $ra
