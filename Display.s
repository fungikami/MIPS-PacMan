# Display.s
# Implementacion de 
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

# Configuracion del Bitmat Display:
# 
# Unit Width in pixels:       16	
# Unit Height in Pixels:      16	
# Display Width in Pixels:   512
# Display Height in Pixels: 512

        .data
        
# ------------ Colores ------------
colorPacman: .word 0xFFFF00     # Amarillo
colorBlinky: .word 0xFF0000     # Rojo
colorPinky:  .word 0x993400     # Marron
colorInky:   .word 0x00FFFF     # Azul
colorClyde:  .word 0x38D92B     # Verde
colorPortal: .word 0xFF8000     # Naranja
colorPared:  .word 0x828282     # Gris oscuro
colorComida: .word 0xFFFFFF     # Blanco

        .text

lw $t0, colorPacman
lw $s0, MAT

sw $t0, ($s0)

lw $t0, colorBlinky
sw $t0, 4($s0)

lw $t0, colorPinky
sw $t0, 8($s0)

lw $t0, colorInky
sw $t0, 12($s0)

lw $t0, colorClyde
sw $t0, 16($s0)

lw $t0, colorPortal
sw $t0, 20($s0)

lw $t0, colorPared
sw $t0, 24($s0)

lw $t0, colorComida
sw $t0, 28($s0)

fin:

li $v0 10
syscall
