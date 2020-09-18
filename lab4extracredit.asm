.data
space: .asciiz " "
newline: .asciiz "\n"
addy: .word 0x10010060
max: .word 0x7FFFFFFF
pa: .asciiz "Program arguments:\n"
iv: .asciiz "Integer values:\n"
sv: .asciiz "Sorted values:\n"
.text
move $t0, $a0
move $t1, $a1
move $a2, $a0
la $a0, pa
li $v0, 4
syscall
printargs:
lw $a0, ($t1)
li $v0, 4
syscall
addi $t1, $t1, 4
sub $t0, $t0, 1
li $v0, 4
la $a0, space
syscall
bnez $t0, printargs
move $t1, $a1
li $v0, 4
la $a0, newline
syscall
li $v0, 4
la $a0, newline
syscall
ulw $t2, ($t1)    #t3,   #t4
move $s0, $a2
lw $s1, addy
la $a0, iv
li $v0, 4
syscall
printint:
ulw $t3, ($t2)
srl $t3, $t3, 24
ulw $t4, ($t2)
sll $t4, $t4, 8
srl $t4, $t4, 24
blt $t3, 58, setnum3
bgt $t3, 64, setlet3
convt3:
bltu $t4, 58, setnum4
bgtu $t4, 64, setlet4
convt4:
j postconvert
setnum3:
subi $t3, $t3, 48
j convt3
setlet3:
subi $t3, $t3, 55
j convt3
setnum4:
subi $t4, $t4, 48
j convt4
setlet4:
subi $t4, $t4, 55
j convt4
postconvert:
mul $t4, $t4, 16
add $t3, $t3, $t4
sw $t3, ($s1)
move $s5, $t3
j printdigit       ########
printreturn:
sub $t2, $t2, 5
sub $s0, $s0, 1
li $v0, 4
la $a0, space
syscall
addi $s1, $s1, 4
bgtz $s0, printint
li $v0, 4
la $a0, newline
syscall
li $v0, 4
la $a0, newline
syscall
la $a0, sv
li $v0, 4
syscall
subi $s1, $s1, 4
move $s2, $s1
move $t6, $a2
move $t7, $a2
lw $t9, ($s1)
lw $a1, max
add $a3, $a3, 1
sort:
lw $t8, ($s1)
blt $t8, $t9 min
retmin:
subi $s1, $s1, 4
subi $t7, $t7, 1
bgtz $t7, sort
move $s5, $t9
j printdigit                ########
printreturn1:
li $v0, 4
la $a0, space
syscall
mul $k0, $k0, 4
add $s1, $s1, $k0
sw $a1, ($s1)
move $s1, $s2
subi $t6, $t6, 1
move $t7, $a2
lw $t9, max
bgtz $t6, sort
li $v0, 4
la $a0, newline
syscall
j end
min:
move $t9, $t8
move $k0, $t7
j retmin

printdigit:
li $v0, 11
beqz $s5, jp1
div $a0, $s5, 100
bgtz $a0, printhund
returnhun:
mul $a0, $a0, 100
sub $s5, $s5, $a0
div $a0, $s5, 10
bgtz $a0, printten
beqz $a0, pzero
returnten:
mul $a0, $a0, 10
sub $s5, $s5, $a0
div $a0, $s5, 1
j printone
returnone:
bgtz $a3, printreturn1
j printreturn
pzero:
beqz $s7, returnten
add $a0, $a0, 48
syscall
sub $a0, $a0, 48
j returnten 
jp1:
move $a0, $s5
j printone
printhund:
li $s7, 1
ITN100:
add $a0, $a0, 48
syscall
sub $a0, $a0, 48
j returnhun
printten:
ITN10:
add $a0, $a0, 48
syscall
sub $a0, $a0, 48
j returnten
printone:
ITN1:
add $a0, $a0, 48
syscall
sub $a0, $a0, 48
j returnone
end:
li $v0, 10
syscall

