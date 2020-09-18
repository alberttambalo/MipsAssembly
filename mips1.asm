.data 
asterisk: .asciiz "*\t"
newline: .asciiz "\n"
tab: .asciiz "\t"
prompt: .asciiz "Enter the height of the pattern (must be greater than 0): \t"
errorprompt: .asciiz "Invalid Entry!\n"
zero: .word 0
.text
inputloop:
li $v0, 4
la $a0, prompt
syscall              #outputs prompt
li $v0, 5
syscall
move $t0, $v0         #moves input to $t0
blez $t0, error	#if invalid number less than 1 jump to error message
j passed
error:			#output error prompt
li $v0, 4
la $a0, errorprompt
syscall
j inputloop
passed:         #t0 #t1 #t2 #t3 #t4
move $t1, $t0
lw $t2, zero
lw $t4, zero
check:
add $t2, $t2, 1
lw $t3, zero
bgt $t2, $t0 end
sub $t3, $t0, $t2 	#t3 = (t1-t2) #
add $t3, $t3, $t3	#t3 = 2 x t3
lw $t5, zero
j printnumber
postprintnumber:
printasterisk:
li $v0, 4
la $a0, asterisk
syscall
sub $t3, $t3, 1
beqz $t3 postprintasterisk
j printasterisk	
postprintasterisk:
li $v0, 1
move $a0, $t6
syscall
li $v0, 4
la $a0, tab
syscall
sub $t6, $t6, 1
sub $t5, $t5, 1
bgtz $t5, postprintasterisk
li $v0, 4
la $a0, newline
syscall
sub $t1, $t1, 1
j check
printnumber:
add $t5, $t5, 1
add $t4, $t4, 1
li $v0, 1
move $a0, $t4
syscall
li $v0, 4
la $a0, tab
syscall
move $t6, $t4
beq $t5, $t0 postprintasterisk
beq  $t5, $t2 postprintnumber
j printnumber
end: