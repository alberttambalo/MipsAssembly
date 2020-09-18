#Spring20 Lab5 Template File

# Macro that stores the value in %reg on the stack 
#  and moves the stack pointer.
.macro push(%reg)
subi $sp, $sp, 4
sw %reg, 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
lw %reg, 0($sp)
addi $sp, $sp, 4
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
push(%input)
andi %y, %input, 0x000000ff
andi %x, %input, 0x00ff0000 
srl %x, %x , 16
pop(%input)
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
push(%x)
push(%y)
sll %x, %x, 16
add %output, %x, %y
pop(%y)
pop(%x)
.end_macro 


.data
originAddress: .word 0xFFFF0000

.text
j done
    
    done: nop
    li $v0 10 
    syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
clear_bitmap: nop
    push($s0)
    push($s1)
    lw $s0, originAddress
    li $s1, 65532
clear_loop:    
    sw $a0,($s0)
    addi $s0, $s0, 4
    subi $s1, $s1, 4 
    bgez $s1, clear_loop
    pop($s1)
    pop($s0)
	jr $ra
	
#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
draw_pixel: nop
    push($s0)
    push($s1)
    push($s2)
    getCoordinates($a0, $s0, $s1)
    mul $s1, $s1, 128
    add $s0, $s0, $s1
    mul $s0, $s0, 4
    lw $s2, originAddress
    add $s2, $s2, $s0
    sw $a1, 0($s2)
    pop($s2)
    pop($s1)
    pop($s0)
	jr $ra
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
    push($s0)
    push($s1)
    push($s2)
    getCoordinates($a0, $s0, $s1)
    mul $s1, $s1, 128
    add $s0, $s0, $s1
    mul $s0, $s0, 4
    lw $s2, originAddress
    add $s2, $s2, $s0
    lw $v0,($s2)
    pop($s2)
    pop($s1)
    pop($s0)	
	jr $ra

#***********************************************
# draw_solid_circle:
#  Considering a square arround the circle to be drawn  
#  iterate through the square points and if the point 
#  lies inside the circle (x - xc)^2 + (y - yc)^2 = r^2
#  then plot it.
#-----------------------------------------------------
# draw_solid_circle(int xc, int yc, int r) 
#    xmin = xc-r
#    xmax = xc+r
#    ymin = yc-r
#    ymax = yc+r
#    for (i = xmin; i <= xmax; i++) 
#        for (j = ymin; j <= ymax; j++) 
#            a = (i - xc)*(i - xc) + (j - yc)*(j - yc)	 
#            if (a < r*r ) 
#                draw_pixel(x,y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_solid_circle: nop
    push($a0)
    push($a1)
    push($s0)
    push($s1)
    push($s2)
    push($s3)
    push($s4)
    push($s5)
    push($s6)
    push($s7)
    push($t0)
    push($t1)
    push($t2)
    push($t3)
    getCoordinates($a0, $s0, $s1)
    #xmin
    sub $s2, $s0, $a1
    #xmax
    add $s3, $s0, $a1
    #ymin
    sub $s4, $s1, $a1
    #ymax
    add $s5, $s1, $a1
    #i
    sub $s6, $s0, $a1
    #j
    sub $s7, $s1, $a1
first_loop: 
    add $s6, $s6, 1
    sub $s7, $s1, $a1
second_loop:
    add $s7, $s7, 1
    #(i - xc)*(i - xc)
    sub $t0, $s6, $s0
    mul $t0, $t0, $t0
    #(j - yc)*(j - yc)
    sub $t1, $s7, $s1
    mul $t1, $t1, $t1
    
    add $t2, $t0, $t1
    mul $t3, $a1, $a1      
    bge $t2, $t3, skip######
    push($a1)
    push($a0)
    push($ra)
    move $a1, $a2
    formatCoordinates($a0, $s6, $s7)
    jal draw_pixel
    pop($ra)
    pop($a0)
    pop($a1)
skip:
    ble $s7, $s5, second_loop
    ble $s6, $s3, first_loop 
    pop($t3) 
    pop($t2)
    pop($t1)
    pop($t0)
    pop($s7)
    pop($s6)
    pop($s5)
    pop($s4)
    pop($s3)
    pop($s2)
    pop($s1)
    pop($s0)
    pop($a1)
    pop($a0)
	jr $ra
		
#***********************************************
# draw_circle:
#  Given the coordinates of the center of the circle
#  plot the circle using the Bresenham's circle 
#  drawing algorithm 	
#-----------------------------------------------------
# draw_circle(xc, yc, r) 
#    x = 0 
#    y = r 
#    d = 3 - 2 * r 
#    draw_circle_pixels(xc, yc, x, y) 
#    while (y >= x) 
#        x=x+1 
#        if (d > 0) 
#            y=y-1  
#            d = d + 4 * (x - y) + 10 
#        else
#            d = d + 4 * x + 6 
#        draw_circle_pixels(xc, yc, x, y) 	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of the circle center in format (0x00XX00YY)
#    $a1 = radius of the circle
#    $a2 = color of line in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_circle: nop
    push($a0)
    push($a1)
    push($s0)
    push($s1)
    push($s2)
    push($s3)
    push($s4)
    push($s5)
    push($s6)
#   x = 0
    li $s2, 0
#   y = r
    move $s3, $a1
#   d = 3 - 2 * r
    mul $s4, $a1, 2
    li $s5, 3
    sub $s4, $s5, $s4
    move $a1, $a2
    move $a2, $s2
    move $a3, $s3
    push($ra)
    jal draw_circle_pixels
    pop($ra)
While_loop:
    add $s2, $s2, 1
    bgtz $s4, D_gr8er
#   d = d + 4 * x + 6
#   4 * x = $s6
    mul $s6, $s2, 4
#   d + $s6 + 6
    addi $s6, $s6, 6
    add $s4, $s4, $s6
    push($ra)
    move $a2, $s2
    move $a3, $s3
    jal draw_circle_pixels
    pop($ra)
    bge $s3, $s2, While_loop 
D_gr8er:
    sub $s3, $s3, 1
#   d = d + 4 * (x - y) + 10
#   (x-y) = $s5
    sub $s5, $s2, $s3
#   $s5 *4  
    mul $s5, $s5, 4   
#   d + $s5 + 10 = $s4  
    addi $s5, $s5, 10
    add $s4, $s4, $s5
    push($ra)
    move $a2, $s2
    move $a3, $s3
    jal draw_circle_pixels
    pop($ra)
    bge $s3, $s2, While_loop
    pop($s6)
    pop($s5)
    pop($s4)
    pop($s3)
    pop($s2)
    pop($s1)
    pop($s0)
    pop($a1)
    pop($a0)
	jr $ra
	
#*****************************************************
# draw_circle_pixels:
#  Function to draw the circle pixels 
#  using the octans' symmetry
#-----------------------------------------------------
# draw_circle_pixels(xc, yc, x, y)  
#    draw_pixel(xc+x, yc+y) 
#    draw_pixel(xc-x, yc+y)
#    draw_pixel(xc+x, yc-y)
#    draw_pixel(xc-x, yc-y)
#    draw_pixel(xc+y, yc+x)
#    draw_pixel(xc-y, yc+x)
#    draw_pixel(xc+y, yc-x)
#    draw_pixel(xc-y, yc-x)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of circle center in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#    $a2 = current x value from the Bresenham's circle algorithm
#    $a3 = current y value from the Bresenham's circle algorithm
#   Outputs:
#    No register outputs	
#*****************************************************
draw_circle_pixels: nop
    push($a0)
    push($a1)
    push($s0)
    push($s1)
    push($s2)
    push($s3)
    push($s4)
    push($s5)
    push($s6)
    push($s7)
    push($t0)
    push($t1)
    getCoordinates($a0, $s0, $s1)
#   (xc+x) = $s2
    add $s2, $s0, $a2
#   (xc-x) = $s3
    sub $s3, $s0, $a2
#   (xc+y) = $s4
    add $s4, $s0, $a3
#   (xc-y) = $s5
    sub $s5, $s0, $a3
#   (yc+y) = $s6
    add $s6, $s1, $a3
#   (yc-y) = $s7
    sub $s7, $s1, $a3  
#   (yc+x) = $t0
    add $t0, $s1, $a2
#   (yc-x) = $t1
    sub $t1, $s1, $a2 
#   draw_pixel(xc+x, yc+y)
    push($ra)
    formatCoordinates($a0,$s2,$s6)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc-x, yc+y)
    push($ra)
    formatCoordinates($a0,$s3,$s6)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc+x, yc-y)
    push($ra)
    formatCoordinates($a0,$s2,$s7)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc-x, yc-y)#
    push($ra)
    formatCoordinates($a0,$s3,$s7)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc+y, yc+x)
    push($ra)
    formatCoordinates($a0,$s4,$t0)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc-y, yc+x)
    push($ra)
    formatCoordinates($a0,$s5,$t0)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc+y, yc-x)
    push($ra)
    formatCoordinates($a0,$s4,$t1)
    jal draw_pixel
    pop($ra)
#   draw_pixel(xc-y, yc-x)
    push($ra)
    formatCoordinates($a0,$s5,$t1)
    jal draw_pixel
    pop($ra)   
    
    pop($t1)
    pop($t0)
    pop($s7)
    pop($s6)
    pop($s5)
    pop($s4)
    pop($s3)
    pop($s2)
    pop($s1)
    pop($s0)
    pop($a1)
    pop($a0)
	jr $ra
