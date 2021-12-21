# Proyecto 2
# Implementacion del juego Pac-Man.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data

# Variables globales
seguir:	.byte 1
MAT:	.word 0x10008000	# Dirección base del Bitmat Display
S:      .word 1             # Refrescamiento 
C:      .word 1             # Base para la conversión con los tics del reloj
D:      .word 'A'           # Dirección actual del Pac-Man
V:      .word 3             # Vidas

# ------------ Tablero ------------
arcTablero:  .asciiz "/home/fung/Downloads/Orga/proyecto2/tablero.txt"

# ------------ Colores ------------
colorPacman: .word 0xFFFF00     # Amarillo
colorBlinky: .word 0xFF0000     # Rojo
colorPinky:  .word 0x993400     # Marron
colorInky:   .word 0x00FFFF     # Azul
colorClyde:  .word 0x38D92B     # Verde
colorPortal: .word 0xFF8000     # Naranja
colorPared:  .word 0x828282     # Gris oscuro
colorComida: .word 0xFFFFFF     # Blanco

# ------------ Posiciones ------------
xPacman:    .word 14
yPacman:    .word 11

xBlinky:    .word 27
yBlinky:    .word 25

xPinky:     .word 27
yPinky:     .word 24

xInky:      .word 27
yInky:      .word 23

xClyde:		.word 27
yClyde:		.word 22

xPortal5:   .word 31
yPortal5:   .word 18

xPortal6:   .word 0
yPortal6:   .word 18

	.globl seguir
	.globl MAT
	.globl S
	.globl C
	.globl D
	.globl V
	.globl xBlinky
	.globl yBlinky
	.globl xPinky
	.globl yPinky
	.globl xInky
	.globl yInky
	.globl xClyde
	.globl yClyde

	.globl colorPacman
	.globl colorBlinky
	.globl colorPinky
	.globl colorInky
	.globl colorClyde
	.globl colorPortal
	.globl colorPared
	.globl colorComida
	
	.globl main

	.text
main:
    # Display tablero
    lw $a0, MAT
    la $a1, arcTablero
    jal pintar_tablero

    b salir


	lb $t1 seguir
	beqz $t1 salir

	# Aqui habrá un conjunto de instrucciones.
	# Éstas respetaran las convenciones

	# Note que su implmentación de la función PacMan debe ser lo
	# más eficiente posible. El Main tiene otras cosas qué hacer
	# Debe hacer la actividad requerida y regresar rápidamente aquí. 

	jal PacMan

	b main

salir:	
	li $v0 10
	syscall

PacMan:
    # Prologo
	sw   $fp, ($sp)
	move $fp, $sp
	addi $sp, $sp, -4



    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra


.include "Utilidades.s"
