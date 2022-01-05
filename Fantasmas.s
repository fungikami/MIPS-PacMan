# Fantasmas.s
# Estructura que guarda los 4 enemigos del juego.
# implementado en Main.s
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

        .data

        .text

# Funcion: Crea los Fantasmas con su posicion y color.
# Salida:   $v0:  Fantasma (negativo si no se pudo crear).
#          ($v0): Blinky (27, 25).
#         4($v0): Pinky  (27, 24).
#         8($v0): Inky   (27, 23).
#        12($v0): Clyde  (27, 22).
# Planificacion de registros:
# $s0: Direccion de la estructura.
Fantasmas_crear:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

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
    sw   $v0, 12($s0)
    
    move $v0, $s0
    
Fantasmas_crear_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra

# Funcion: Reinicia los Fantasmas con su posicion inicial.
# Entrada: $a0: Fantasmas
# Planificacion de registros:
# $s0: Direccion de la estructura.
Fantasmas_reiniciar:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12
    
    move $s0, $a0   # Dir. de la estructura Fantasmas

    # Reinicia Blinky
    lw  $a0, ($s0)
    li  $a1,  27
    li  $a2,  25 
    jal Fantasma_reiniciar

	# Reinicia Pinky
    lw  $a0, 4($s0)
    li  $a1, 27
    li  $a2, 24
    jal Fantasma_reiniciar

    # Reinicia Inky
    lw  $a0, 8($s0)
    li  $a1, 27
    li  $a2, 23
    jal Fantasma_reiniciar
    
    # Reinicia Clyde
    lw  $a0, 12($s0)
    li  $a1, 27
    li  $a2, 22 
    jal Fantasma_reiniciar 
    
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra

# Funcion: Ejecuta los movimientos de cada uno de los Fantasmas.
# Entrada: $a0: Direccion de la estructura Fantasmas.
# Planificacion de registros:
# $s0: Direccion de la estructura Fantasmas.
Fantasmas_mover:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    move $s0, $a0   # Dir. de la estructura Fantasmas

    # Movimiento de Blinky
    lw  $a0, ($s0)
    jal Fantasma_mover

	# Movimiento de Pinky
    lw  $a0, 4($s0)
    jal Fantasma_mover

    # Movimiento de Inky
    lw  $a0, 8($s0)
    jal Fantasma_mover

    # Movimiento de Clyde
    lw  $a0, 12($s0)
    jal Fantasma_mover
    
Fantasmas_mover_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra