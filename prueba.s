# Configuracion del Bitmat Display:
# 
# Unit Width in pixels:       16	
# Unit Height in Pixels:      16	
# Display Width in Pixels:   512
# Display Height in Piexels: 512

        .data
        
# ------------ Colores ------------
pacmanColor: .word 0xFFFF00     # Amarillo
blinkyColor: .word 0xFF0000     # Rojo
pinkyColor:  .word 0x993400     # Marron
inkyColor:   .word 0x00FFFF     # Azul
clydeColor:  .word 0x31AC73     # Verde

# Otras cosas

MAT:	.word 0x10008000

        .text

lw $t0, pacmanColor
lw $s0, MAT

sw $t0, ($s0)

lw $t0, blinkyColor
sw $t0, 4($s0)

lw $t0, pinkyColor
sw $t0, 8($s0)

lw $t0, inkyColor
sw $t0, 12($s0)

lw $t0, clydeColor
sw $t0, 16($s0)

fin:

li $v0 10
syscall