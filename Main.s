# Proyecto 2
# Implementacion del juego Pac-Man.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
seguir:	        .byte 1
pausar:         .byte 0
avanzar_cuadro: .byte 0
contador:       .word 0

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
	
	.globl seguir pausar avanzar_cuadro contador __init__ main

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

	# Note que su implmentación de la función PacMan debe ser lo
	# más eficiente posible. El Main tiene otras cosas qué hacer
	# Debe hacer la actividad requerida y regresar rápidamente aquí. 

	# Cada S
esperar:
	lb   $t0, avanzar_cuadro
	beqz $t0, esperar

	jal PacMan

	b main

salir:	
	li $v0, 10
	syscall

pausar_partida:
	lb   $t1, pausar
	beqz $t1, main
	
	j pausar_partida

PacMan:
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
	move $fp,     $sp
	addi $sp,     $sp, -20

    # Reinicia la variable saltar
    sb $zero, avanzar_cuadro

    # Movimiento Pac-Man
    lw $s0, xPacman
    lw $s1, yPacman
    lw $s2, D

    # Pintar de negro el pixel
    move $a0, $s0
    move $a1, $s1
    lw   $a2, colorFondo
    jal pintar_pixel

    beq $s2, 'a', PacMan_mover_PacMan_arriba    # Arriba 
    beq $s2, 'b', PacMan_mover_PacMan_abajo     # Abajo 
    beq $s2, 'i', PacMan_mover_PacMan_izquierda # Izquierda 
    beq $s2, 'd', PacMan_mover_PacMan_derecha   # Derecha 

    PacMan_mover_PacMan_arriba:
        addi $s1, $s1, 1
        sw   $s1, yPacman

        # Pintar PacMan
        move $a0, $s0
        move $a1, $s1
        lw   $a2, colorPacman
        jal pintar_pixel

        j PacMan_fin

    PacMan_mover_PacMan_abajo:
        addi $s1, $s1, -1
        sw   $s1, yPacman

        # Pintar PacMan
        move $a0, $s0
        move $a1, $s1
        lw   $a2, colorPacman
        jal pintar_pixel

        j PacMan_fin

    PacMan_mover_PacMan_izquierda:
        addi $s0, $s0, -1
        sw   $s0, xPacman

        # Pintar PacMan
        move $a0, $s0
        move $a1, $s1
        lw   $a2, colorPacman
        jal pintar_pixel

        j PacMan_fin

    PacMan_mover_PacMan_derecha:
        addi $s0, $s0, 1
        sw   $s0, xPacman

        # Pintar PacMan
        move $a0, $s0
        move $a1, $s1
        lw   $a2, colorPacman
        jal pintar_pixel

        j PacMan_fin

PacMan_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)

    jr $ra



.include "Utilidades.s"
