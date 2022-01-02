# Proyecto 2
# Implementacion del juego Pac-Man.
#
# 
#
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
# ------------ Variables ------------
seguir:	        .byte 1
pausar:         .byte 0
avanzarCuadro:  .byte 0
contador:       .word 0
alimRestante:   .word 0 
alimTotal:      .word 0 # 573 con los fantasmas
tiempo:         .word 0
fueComido:      .byte 0

# ------------ Mensajes ------------
msgPausa:       .asciiz "\n.................. JUEGO PAUSADO .................\n"
msgNoPausa:     .asciiz "\n................ JUEGO DESPAUSADO ................\n"
msgSalida:      .asciiz "\n................ JUEGO FINALIZADO ................\n"
msgVictoria:    .asciiz "\n.................. VICTORIA :) ...................\n"
msgDerrota:     .asciiz "\n................... DERROTA :( ...................\n"
msgVidas:       .asciiz " Vidas restantes: "
msgComida:      .asciiz " Puntuacion:      Te has comido "
msgComida2:     .asciiz "% del alimento."
msgTiempo:      .asciiz " Tiempo:          "
msgTiempo2:     .asciiz " segundos."
puntos:         .asciiz "\n..................................................\n"
nuevaLinea:     .asciiz "\n"

# ------------ Personajes ------------
Pacman:         .word 0
Fantasmas:      .word 0
	
	.globl seguir pausar avanzarCuadro contador alimRestante alimTotal fueComido tiempo
    .globl __init__ main
    .globl msgPausa msgNoPausa msgSalida msgVictoria msgDerrota msgVidas 
    .globl msgComida msgComida2 msgTiempo msgTiempo2 puntos nuevaLinea

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

dibujar_tablero:
    # Display tablero
    la $a0, tablero
    la $a1, alimRestante
    la $a2, alimTotal
    jal pintar_tablero

main:
    # Revisa si el juego ya finalizo
	lb   $t1, seguir
	beqz $t1, salir

    # Revisa si el juego esta pausado
	lb  $t1, pausar
	beq $t1, 1, pausar_partida

    # Revisa si el Pac-Man ha sido comido
    lb  $t0, fueComido
    beq $t0, 1, siguiente_partida

    # Revisa si Pac-Man se ha comido todo el alimento
    lw   $t0, alimRestante
    bgtz $t0, esperar
    
siguiente_partida:
    # Disminuye el numero de vidas
    lw  $t0, V 
    add $t0, $t0, -1
    sw  $t0, V 

    # Si se consumen todas las vidas, termina el juego
    beqz $t0, salir

    # Se reinicia el tablero si se consumio todos los alimentos
    lw     $t0, alimRestante
    add    $t0, $t0, -1
    la     $a0, tablero
    la     $a1, alimRestante
    bltzal $t0, pintar_tablero

    # Reinicia Fantasmas
    lw  $a0, Fantasmas
    jal Fantasmas_reiniciar

    # En cambio, se reinicia los personajes para la siguiente partida
    lw  $a0, Pacman
    jal Pacman_reiniciar # Reinicia posicion y dibuja

    sb $zero, fueComido 

    j main    

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
    # Imprimir puntuacion
    jal imprimir_puntuacion
    
	li $v0, 10
	syscall

# Funcion: Avanza por un cuadro el movimiento 
#          de los personajes en el tablero.
PacMan:
    # Prologo
	sw   $fp,   ($sp)
    sw   $ra, -4($sp)
	move $fp,    $sp
	addi $sp,    $sp, -8

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
    move $sp,    $fp
	lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra

.include "Utilidades.s"
.include "Pacman.s"
.include "Fantasmas.s"
.include "Fantasma.s"
