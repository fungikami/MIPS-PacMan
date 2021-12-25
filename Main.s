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
alimRestante:   .word 569 # 573 con los fantasmas

# ------------ Personajes ------------
Pacman: .word 0 # (14, 11) Amarillo
Blinky: .word 0 # (27, 25) Rojo
Pinky:  .word 0 # (27, 24) Marrón
Inky:   .word 0 # (27, 23) Azul
Clyde:  .word 0 # (27, 22) Verde

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
    sw   $v0, pacman

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

    lw $t0, alimRestante
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

# Planificacion de registros
# $s0: xPacman
# $s1: yPacman
# $s2: Direccion actual del PacMan
# $s3: Direccion siguiente del PacMan
PacMan:
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
	move $fp,     $sp
	addi $sp,     $sp, -24

    # Reinicia la variable saltar
    sb $zero, avanzarCuadro
    
    # Movimiento Pac-Man
    lw $s0, xPacman
    lw $s1, yPacman
    lw $s2, D

    beq $s2, 'a', PacMan_mover_pacman_arriba    # Arriba 
    beq $s2, 'b', PacMan_mover_pacman_abajo     # Abajo 
    beq $s2, 'i', PacMan_mover_pacman_izquierda # Izquierda 
    beq $s2, 'd', PacMan_mover_pacman_derecha   # Derecha 

    PacMan_mover_pacman_arriba:
        move $a0, $s0
        add  $s3, $s1, 1    
        move $a1, $s3   # (x, y+1)
        jal chequear_es_pared

        beq $v0, 1, PacMan_fin
        sw  $s3, yPacman

        j PacMan_actualizar_alimento

    PacMan_mover_pacman_abajo:
        move $a0, $s0
        add  $s3, $s1, -1    
        move $a1, $s3   # (x, y-1)
        jal chequear_es_pared

        beq $v0, 1, PacMan_fin
        sw  $s3, yPacman

        j PacMan_actualizar_alimento

    PacMan_mover_pacman_izquierda:
        add  $s3, $s0, -1    
        move $a0, $s3       
        move $a1, $s1   # (x-1, y)
        jal chequear_es_pared

        beq $v0, 1, PacMan_fin
        sw  $s3, xPacman

        j PacMan_actualizar_alimento

    PacMan_mover_pacman_derecha:
        add  $s3, $s0, 1    
        move $a0, $s3       
        move $a1, $s1   # (x+1, y)
        jal chequear_es_pared

        beq $v0, 1, PacMan_fin
        sw  $s3, xPacman

    PacMan_actualizar_alimento:
        lw $a0, xPacman
        lw $a1, yPacman
        la $a2, alimRestante
        jal actualizar_alimento_restante

    PacMan_mover_pacman_pintar:
        # Pintar de negro el pixel
        move $a0, $s0
        move $a1, $s1
        lw   $a2, colorFondo
        jal pintar_pixel

        # Pintar PacMan
        lw $a0, xPacman
        lw $a1, yPacman
        lw $a2, colorPacman
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
    lw   $s3, -20($sp)

    jr $ra



.include "Utilidades.s"
