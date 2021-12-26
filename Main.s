# Proyecto 2
# Implementacion del juego Pac-Man.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
seguir:	        .byte 1
pausar:         .byte 0
avanzarCuadro:  .byte 0
contador:       .word 0
alimRestante:   .word 0 # 573 con los fantasmas

# ------------ Personajes ------------
Pacman: .word 0 # (14, 11) Amarillo
Blinky: .word 0 # (27, 25) Rojo
Pinky:  .word 0 # (27, 24) Marrón
Inky:   .word 0 # (27, 23) Azul
Clyde:  .word 0 # (27, 22) Verde

# ------------ Portales ------------
xPortal5:   .word 31
yPortal5:   .word 18

xPortal6:   .word 0
yPortal6:   .word 18
	
	.globl seguir pausar avanzarCuadro contador __init__ main

	.text

__init__:
    # Inicializa personajes
    jal  Pacman_crear
    bltz $v0, salir
    sw   $v0, Pacman

    # Inicializar contador de alimentos restantes

    # Display tablero
    la $a0, arcTablero
    la $a1, alimRestante
    jal pintar_tablero

main:
	lb   $t1, seguir
	beqz $t1, salir

	lb  $t1, pausar
	beq $t1, 1, pausar_partida

	# Aqui habrá un conjunto de instrucciones.
	# Éstas respetaran las convenciones

    lw   $t0, alimRestante
    bgtz $t0, esperar
    
    li $v0, 11
    li $a0, 'w'
    syscall
    b salir

	# Note que su implmentación de la función PacMan debe ser lo
	# más eficiente posible. El Main tiene otras cosas qué hacer
	# Debe hacer la actividad requerida y regresar rápidamente aquí. 

	# Cada S
esperar:
	lb   $t0, avanzarCuadro
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

# Función: Avanza por un cuadro el movimiento de los personajes
#          en el tablero.
# Planificacion de registros:
PacMan:
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
	move $fp,     $sp
	addi $sp,     $sp, -8

    # Reinicia la variable saltar
    sb $zero, avanzarCuadro
    
    # Movimiento Pac-Man
    lw  $a0, Pacman
    la  $a1, alimRestante
    jal Pacman_mover

PacMan_fin:
    # Epilogo
    move $sp,     $fp
	lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

.include "Utilidades.s"
.include "Pacman.s"