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
Pacman:    .word 0
Fantasmas: .word 0
	
	.globl seguir pausar avanzarCuadro contador __init__ main

	.text

__init__:

main:

esperar:
	lb   $t0, avanzarCuadro
	beqz $t0, esperar

	jal test

	b main

test:
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
	move $fp,     $sp
	addi $sp,     $sp, -8

    # Reinicia la variable saltar
    sb $zero, avanzarCuadro

    # Prueba del random
    li $a0, 3
    li $a1, 0
    li $a2, 1
    li $a3, 2
    jal escoger_aleatorio

    move $a0, $v0
    li $v0, 1
    syscall
    
	# lb $a0, 0x72
	# li $a1, 256
	# li $a2, 88
	# lb $a3, 0x7F
	# li $v0, 31
	# syscall

test_fin:
    # Epilogo
    move $sp,     $fp
	lw   $fp,    ($sp)
    lw   $ra,  -4($sp)

    jr $ra

.include "Utilidades.s"
.include "Pacman.s"
.include "Fantasmas.s"
.include "Fantasma.s"

# beep:     .byte 72
# duration: .byte 100
# volume:   .byte 127
