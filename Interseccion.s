    .data
# ------------ Variables ------------
seguir:	        .byte 1
pausar:         .byte 0
avanzarCuadro:  .byte 0
contador:       .word 0
alimRestante:   .word 0 # 573 con los fantasmas

# ------------ Mensajes ------------
mensajePausa:   .asciiz "... JUEGO PAUSADO ..."
mensajeNoPausa: .asciiz "... JUEGO DESPAUSADO ..."
mensajeSalida:  .asciiz "... JUEGO FINALIZADO ..."
mensajeVictoria:.asciiz "... VICTORIA :) ..."
mensajeDerrota: .asciiz "... DERROTA :( ..."
mensajePuntos:  .asciiz "Puntuacion: "
mensajeTiempo:  .asciiz "Tiempo: "
mensajeSeg:     .asciiz " segundos." 
dots:           .asciiz "..............................................................."
newLine:        .asciiz "\n"

# ------------ Personajes ------------
Pacman:         .word 0
Fantasma:      .word 0
	
	.globl seguir pausar avanzarCuadro contador __init__ main

	.text

__init__:
    # Inicializa Pac-Man
    jal  Pacman_crear
    bltz $v0, salir
    sw   $v0, Pacman

    # Inicializa los fantasmas
    
    # Inicializa Blinky
    li   $a0, 9
    li   $a1, 8
    lw   $a2, colorBlinky
    jal  Fantasma_crear
    bltz $v0, salir
    sw   $v0, Fantasma

    # Display tablero
    la $a0, arcTablero
    la $a1, alimRestante
    jal pintar_tablero

main:
    

    # Movimiento de los fantasmas
    lw $a0, Fantasma
    jal Fantasma_chequear_interseccion

    move $a0, $v0
    li   $v0, 1
    syscall

    # Revisa si quedan vidas disponibles
    # lw   $t0, V
    # bltz $t0, salir

	# Note que su implmentación de la función PacMan debe ser lo
	# más eficiente posible. El Main tiene otras cosas qué hacer
	# Debe hacer la actividad requerida y regresar rápidamente aquí. 

esperar:
	lb   $t0, avanzarCuadro
	beqz $t0, esperar

	jal PacMan

	b main

pausar_partida:
	lb   $t1, pausar
	beqz $t1, main
	
	j pausar_partida

salir:	
    # Imprimir mensaje de salida


	li $v0, 10
	syscall

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

    # Movimiento de los fantasmas
    lw $a0, Fantasma
    jal Fantasma_chequear_interseccion

    move $t0, $v0

    li $v0, 4
    la $a0, dots
    syscall
    
    move $a0, $t0
    li   $v0, 1
    syscall

    li $v0, 4
    la $a0, dots
    syscall

PacMan_fin:
    # Epilogo
    move $sp,     $fp
	lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

.include "Utilidades.s"
.include "Pacman.s"
.include "Fantasmas.s"
.include "Fantasma.s"
