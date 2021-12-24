# Proyecto 2
# Implementacion del juego Pac-Man.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
seguir:	.byte 1
pausar: .byte 0

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
	
	.globl seguir pausar __init__ main

	.text

__init__:
    # Display tablero
    la $a0, arcTablero
    jal pintar_tablero

main:
	lb   $t1, seguir
	beqz $t1, salir

	lb  $t1, pausar
	beq $t1, 1, pausar_partida

	# Aqui habrá un conjunto de instrucciones.
	# Éstas respetaran las convenciones

    li $t0, 'm'
	sw $t0, 0xFFFF0008 

	# Note que su implmentación de la función PacMan debe ser lo
	# más eficiente posible. El Main tiene otras cosas qué hacer
	# Debe hacer la actividad requerida y regresar rápidamente aquí. 

	jal PacMan

	b main

salir:	
	li $v0, 10
	syscall

pausar_partida:
	lb   $t1, pausar
	beqz $t1, main

	li $t0, 'p'
	sw $t0, 0xFFFF0008 
	
	j pausar_partida

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
