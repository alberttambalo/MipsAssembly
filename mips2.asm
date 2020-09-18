.data
   star: .asciiz "*\t"
   newline: .asciiz "\n"
   tab: .asciiz "\t"
   msgForHeight: .asciiz "Enter the height of the pattern (must be greater than 0):\t"
   msgInvalid: .asciiz "Invalid Entry!\n"

.text
li $v0,4               # system call code for printing string = 4
la $a0,msgForHeight       # load address of string to be printed into $a0
syscall               # call operating system to perform print operation

li $v0,5               # system call code for reading integer
syscall               # call operating system to perform read operation
move $t0,$v0             #move the read integer sum to register t0

VALIDATE_LOOP:
   sle $t1,$t0,$0       #set less than if number is less than 0
   beqz $t1,VALIDATE_LOOP_END   #branch if set condition is zero
  
   li $v0,4               # system call code for printing string = 4
   la $a0,msgInvalid       # load address of string to be printed into $a0
   syscall               # call operating system to perform print operation
  
   li $v0,4               # system call code for printing string = 4
   la $a0,msgForHeight       # load address of string to be printed into $a0
   syscall               # call operating system to perform print operation

   li $v0,5               # system call code for reading integer
   syscall               # call operating system to perform read operation
   move $t0,$v0             #move the read integer sum to register t0
   j VALIDATE_LOOP
  
VALIDATE_LOOP_END:

li $v0,4               # system call code for printing string = 4
la $a0,newline           # load address of string to be printed into $a0
syscall               # call operating system to perform print operation


li $t2,1               #temporary regiters for storing the temp values  
li $t3,0

li $t4,1           #variable for loop that is starting with 1
  
LOOP:
   bgt $t4,$t0,LOOP_END   #branch if t4 greater than number
   li $t5,1           #variable for loop1
   LOOP1:
       bgt $t5,$t4,LOOP1_END   #branch if t5 greater than t4
       li $v0,1           # system call code for printing int = 1
       move $a0,$t2       # load address of int to be printed into $a0(result is printed)
       syscall           # call operating system to perform print operation
      
       li $v0,4               # system call code for printing string = 4
       la $a0,tab           # load address of string to be printed into $a0
       syscall               # call operating system to perform print operation
      
       addi $t2,$t2,1       #increment t2
       addi $t5,$t5,1       #increment t5
       j LOOP1           #jump to loop1
   LOOP1_END:  
   la $t5,($t4)       #variable for loop2
   LOOP2:
       bge $t5,$t0,LOOP2_END   #branch if t5 greater than or equal number
      
       li $v0,4               # system call code for printing string = 4
       la $a0,star           # load address of string to be printed into $a0
       syscall               # call operating system to perform print operation
      
       addi $t5,$t5,1        #increment t5
       j LOOP2           #jump to loop2
   LOOP2_END:
   la $t5,($t4)       #variable for loop3
   LOOP3:
       bge $t5,$t0,LOOP3_END   #branch if t5 greater than or equal number
      
       li $v0,4               # system call code for printing string = 4
       la $a0,star           # load address of string to be printed into $a0
       syscall               # call operating system to perform print operation
      
       addi $t5,$t5,1        #increment t5
       j LOOP3           #jump to loop2
   LOOP3_END:
  
   add $t3,$t3,$t4   #temperory value that is declared before loop
   la $t6,($t3)  
  
   li $t5,1       #variable for loop4
   LOOP4:
       bgt $t5,$t4,LOOP4_END #branch if t5 greater than t4
      
       li $v0,1           # system call code for printing int = 1
       move $a0,$t6       # load address of int to be printed into $a0(result is printed)
       syscall           # call operating system to perform print operation
      
       IF:       #put tab in between not in end
           seq $t7,$t5,$t4           #check the equality of t5 and t4
           beq $t7,1,END_IF           #branch if t7 is set to 1
           li $v0,4               # system call code for printing string = 4
           la $a0,tab           # load address of string to be printed into $a0
           syscall               # call operating system to perform print operation
       END_IF:
      
       subi $t6,$t6,1       #decrement t6
       addi $t5,$t5,1       #increment t5
       j LOOP4           #jump to loop 4
   LOOP4_END:
       li $v0,4               # system call code for printing string = 4
       la $a0,newline           # load address of string to be printed into $a0
       syscall               # call operating system to perform print operation
          
       addi $t4,$t4,1   #increment t4
       j LOOP       #jump to loop
LOOP_END:
li $v0,10       # system call code for printing exit (end of program)
syscall           # call operating system to perform print operation