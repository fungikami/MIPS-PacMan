# Fantasma.s
# Personaje enemigo del juego
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022
        .data

        .text

# Funcion: Crea un Fantasma con su posición y color.
# Entrada:  $a0:  Coordenada x.
#           $a1:  Coordenada y.
#           $a2:  Color del fantasma.
# Salida:   $v0:  Fantasma (negativo si no se pudo crear).
#          ($v0): Coordenada x.
#         4($v0): Coordenada y.
#         8($v0): Color del Fantasma.
#        12($v0): Color de la capa de fondo.
#        16($v0): Dir. de movimiento del fantasma.
#                 (0: Arriba, 1: Abajo, 2: Izquierda, 3: Derecha)
# Planificacion de registros:
# $t0: Coordenada x del fantasma.
# $t1: Variable auxiliar.
Fantasma_crear:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $t0, $a0

    # Reserva memoria para el Fantasma
    li $a0, 17
    li $v0, 9
    syscall
    bltz $v0, Fantasma_crear_fin

    # Inicializa el fantasma
    sw $t0,  ($v0)      # Coordenada x inicial
    sw $a1, 4($v0)      # Coordenada y inicial
    sw $a2, 8($v0)      # Color del fantasma
    lw $t1, colorComida
    sw $t1, 12($v0)     # Color capa de fondo
    li $t1, 2
    sw $t1, 16($v0)     # Dir. de movimiento inicial (izq)
    
Fantasma_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Se encarga del movimiento de un fantasma y su interacción
#          con el entorno.
# Entrada: $a0: Fantasma.
# Planificacion de registros:
#
Fantasma_mover:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
    move $fp,     $sp
    addi $sp,     $sp, -24

    # Si se encuentra en una interseccion o choca con una pared


    # En cambio, continua en la misma direccion 

    
Fantasma_mover_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)

    jr $ra