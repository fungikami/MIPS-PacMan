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
#                 (0: Arriba, 1: Izquierda, 2: Derecha, 3: Abajo)
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
    li $t1, 1
    sb $zero, 16($v0)   # Direccion de movimiento
    
Fantasma_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Se encarga de decidir el movimiento de un fantasma 
#          tomando en cuenta su posicion actual
# Entrada: $a0: Fantasma.
# Planificacion de registros:
# $s0: Fantasma
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

    move $s0, $a0

    # Verificar si se encuentra en una interseccion
    jal Fantasma_chequear_interseccion
    
    beqz $v0, Fantasma_mover_fin
    
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

# Funcion: Se encarga de ejecutar el movimiento del fantasma
#
# Entrada: $a0: Fantasma.
# Planificacion de registros:
#
Fantasma_ejecutar_mov:
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

    # Si se dirige a un portal

    # En cambio, continua en la misma direccion 

Fantasma_ejecutar_mov_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)

    jr $ra


# Funcion: Verifica si un fantasma se encuentra en una interseccion.
# Entrada: $a0: Fantasma.
# Salida:  $v0: 1 si se encuentra en una interseccion,
#               0 de otra forma.
# Planificacion de registros:
# $s0: xFantasma
# $s1: yFantasma
# $s2: colorComida
# $s3: colorFondo
# $s4: colorPared
# $s5: colorPortal
# $t0: Color del pixel que se chequea
# $t1: Booleanos auxiliares
# $t2: Booleanos auxiliares
Fantasma_chequear_interseccion:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
    sw   $s4, -24($sp)
    move $fp,     $sp
    addi $sp,     $sp, -28

    # Guarda la posicion del fantasma
    lw $s0,  ($a0)
    lw $s1, 4($a0)
 
    # Guarda los colores a comparar
    lw $s2, colorComida
    lw $s3, colorFondo
    lw $s4, colorPared
    lw $s5, colorPortal
    
    # La condición de intersección consiste en chequear que
    # las adyacencias sean caminos y la diagonal una pared
    
    # Verifica si (x+1, y+1) es pared / Noroeste
    add $a0, $s0, 1
    add $a1, $s1, 1
    jal coord_a_dir_bitmap
    lw  $t0, ($v0)
    bne $t0, $s4, Fantasma_chequear_interseccion_der_abajo

    # Verifica si (x, y+1) es camino / Arriba
    move $a0, $s0
    add  $a1, $s1, 1
    jal  es_camino
    bnez $v0, Fantasma_chequear_interseccion_der_abajo

    # Verifica si (x+1, y) es camino / Derecha
    add  $a0, $s0, 1
    move $a1, $s1
    jal  es_camino
    bnez $v0, Fantasma_chequear_interseccion_abajo_izq

    j Fantasma_chequear_interseccion_retornar_cierto

    Fantasma_chequear_interseccion_der_abajo:
        # Verifica si (x+1, y-1) es pared / Sureste
        add $a0, $s0, 1
        add $a1, $s1, -1
        jal coord_a_dir_bitmap
        lw  $t0, ($v0)
        bne $t0, $s4, Fantasma_chequear_interseccion_abajo_izq

        # Verifica si (x+1, y) es camino / Derecha
        add  $a0, $s0, 1
        move $a1, $s1
        jal  es_camino
        bnez $v0, Fantasma_chequear_interseccion_abajo_izq

        # Verifica si (x, y-1) es camino / Abajo
        move $a0, $s0
        add  $a1, $s1, -1
        jal es_camino
        bnez $t1, Fantasma_chequear_interseccion_izq_arriba

        j Fantasma_chequear_interseccion_retornar_cierto

    Fantasma_chequear_interseccion_abajo_izq:
        # Verifica si (x-1, y-1) es pared / Suroeste
        add $a0, $s0, -1
        add $a1, $s1, -1
        jal coord_a_dir_bitmap
        lw  $t0, ($v0)
        bne $t0, $s4, Fantasma_chequear_interseccion_izq_arriba

        # Verifica si (x, y-1) es camino / Abajo
        move $a0, $s0
        add  $a1, $s1, -1
        jal  es_camino
        bnez $v0, Fantasma_chequear_interseccion_abajo_izq

        # Verifica si (x-1, y) es camino / Izquierda
        add  $a0, $s0, -1
        move $a1, $s1
        jal  es_camino 
        bnez $v0, Fantasma_chequear_interseccion_retornar_falso

        j Fantasma_chequear_interseccion_retornar_cierto

    Fantasma_chequear_interseccion_izq_arriba:
        # Verifica si (x-1, y+1) es pared / Noroeste
        add $a0, $s0, -1
        add $a1, $s1, 1
        jal coord_a_dir_bitmap
        lw  $t0, ($v0)
        bne $t0, $s4, Fantasma_chequear_interseccion_retornar_falso

        # Verifica si (x-1, y) es camino / Izquierda
        add  $a0, $s0, -1
        move $a1, $s1
        jal  es_camino
        bnez $v0, Fantasma_chequear_interseccion_retornar_falso

        # Verifica si (x, y+1) es camino / Arriba
        move $a0, $s0
        add  $a1, $s1, 1
        jal  es_camino
        bnez $v0, Fantasma_chequear_interseccion_retornar_falso

        j Fantasma_chequear_interseccion_retornar_cierto

Fantasma_chequear_interseccion_retornar_falso:
    li $v0, 0
    j  Fantasma_chequear_interseccion_fin

Fantasma_chequear_interseccion_retornar_cierto:
    li $v0, 1

Fantasma_chequear_interseccion_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)
    lw   $s4, -24($sp)

    jr $ra
    