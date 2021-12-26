# Fantasmas.s
# Estructura que empaqueta los 4 enemigos del juego 
# implementado en Main.s
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022
        .data

        .text

# Funcion: Crea los Fantasmas con su posición y color.
# Salida:   $v0:  Fantasma (negativo si no se pudo crear).
#          ($v0): Blinky.
#         4($v0): Pinky.
#         8($v0): Inky.
#        12($v0): Clyde.
# Planificacion de registros:
# $s0: Dirección de la estructura.
Fantasmas_crear:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Reserva memoria para los Fantasmas
    li $a0, 16
    li $v0, 9
    syscall
    bltz $v0, Fantasmas_crear_fin
    
    move $s0, $v0   # Dir. de la estructura Fantasmas

    # Inicializa Blinky
    li   $a0, 27
    li   $a1, 25
    lw   $a2, colorBlinky
    jal  Fantasma_crear
    bltz $v0, Fantasmas_crear_fin
    sw   $v0, ($s0)

	# Inicializa Pinky
    li   $a0, 27
    li   $a1, 24
    lw   $a2, colorPinky
    jal  Fantasma_crear
    bltz $v0, Fantasmas_crear_fin
    sw   $v0, 4($s0)

    # Inicializa Inky
    li   $a0, 27
    li   $a1, 23
    lw   $a2, colorInky
    jal  Fantasma_crear
    bltz $v0, Fantasmas_crear_fin
    sw   $v0, 8($s0)

    # Inicializa Clyde
    li   $a0, 27
    li   $a1, 22
    lw   $a2, colorClyde
    jal  Fantasma_crear
    bltz $v0, Fantasmas_crear_fin
    sw   $v0, 16($s0)
    
Fantasmas_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra