# Display.s
# Implementacion de 
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

# Configuracion del Bitmat Display:
# 
# Unit Width in pixels:      16	
# Unit Height in Pixels:     16	
# Display Width in Pixels:  512
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
    lw $a0, MAT
    lw $a1, xBlinky
    lw $a2, yBlinky
    jal coord_a_dir_bitmap

    lw $t0, colorBlinky
    sw $t0, ($v0)

    lw $a0, MAT
    lw $a1, xPinky
    lw $a2, yPinky
    jal coord_a_dir_bitmap

    lw $t0, colorPinky
    sw $t0, ($v0)

    lw $a0, MAT
    lw $a1, xInky
    lw $a2, yInky
    jal coord_a_dir_bitmap

    lw $t0, colorInky
    sw $t0, ($v0)

    lw $a0, MAT
    lw $a1, xClyde
    lw $a2, yClyde
    jal coord_a_dir_bitmap

    lw $t0, colorClyde
    sw $t0, ($v0)

fin:

li $v0 10
syscall

.include "Utilidades.s"