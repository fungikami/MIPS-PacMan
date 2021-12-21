# Proyecto 2
# Implementacion del juego "PacMan".
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data

# Variables globales
seguir:	.byte 1
MAT:	.word 0x10008000
S:      .word 1             # Refrescamiento 
C:      .word 1             # Base para la conversión con los tics del reloj
D:      .word 'A'           # Dirección actual del PacMan
V:      .word 3             # Vidas

	.globl seguir
	.globl MAT
	.globl S
	.globl C
	.globl D
	.globl V
	.globl main

	.text
main:
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