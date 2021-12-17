	.data
seguir:	.byte 1

	.globl seguir
	
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

