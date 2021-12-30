# Proyecto 2
# Implementacion del juego Pac-Man.
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
# ------------ Variables ------------
seguir:	        .byte 1
pausar:         .byte 0
avanzarCuadro:  .byte 0
contador:       .word 0
alimRestante:   .word 0 # 573 con los fantasmas
fueComido:      .byte 0

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
Fantasmas:      .word 0
	
	.globl seguir pausar avanzarCuadro contador fueComido __init__ main

	.text

__init__:
    # Inicializa Pac-Man
    jal  Pacman_crear
    bltz $v0, salir
    sw   $v0, Pacman

    # Inicializa los fantasmas
    jal  Fantasmas_crear
    bltz $v0, salir
    sw   $v0, Fantasmas

	# Superclase Fantasmas
	#	 lista = [Blinky, Pinky, Inky, Clyde]
	#	 fun T(f: funcion):
	# 		for (fantasma in lista):
	# 			f(fantasma)
	# Clase Fantasma

    # Display tablero
    la $a0, tablero
    la $a1, alimRestante
    jal pintar_tablero

main:
    # Revisa si el juego ya finalizo
	lb   $t1, seguir
	beqz $t1, salir

    # Revisa si el juego esta pausado
	lb  $t1, pausar
	beq $t1, 1, pausar_partida

	# Aqui habra un conjunto de instrucciones.
	# Estas respetaran las convenciones

    # Revisa si Pac-Man se ha comido todo el alimento
    lw   $t0, alimRestante
    bgtz $t0, esperar

    # Revisa si quedan vidas disponibles
    lw   $t0, V
    bltz $t0, salir
    
    li $v0, 11
    li $a0, 'w'
    syscall
    b salir

	# Note que su implmentacion de la funcion PacMan debe ser lo
	# mas eficiente posible. El Main tiene otras cosas que hacer
	# Debe hacer la actividad requerida y regresar rapidamente aquí. 

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

# Funcion: Avanza por un cuadro el movimiento de los personajes
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
    
    # Movimiento de Pac-Man
    lw  $a0, Pacman
    la  $a1, alimRestante
    jal Pacman_mover

    # Movimiento de los fantasmas
    lw  $a0, Fantasmas
    jal Fantasmas_mover

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
