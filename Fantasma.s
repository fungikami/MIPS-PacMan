# Fantasma.s
# Personaje enemigo del juego
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022
        .data

        .text

# Funcion: Crea un Fantasma con su posicion y color.
# Entrada:  $a0:  Coordenada x.
#           $a1:  Coordenada y.
#           $a2:  Color del fantasma.
# Salida:   $v0:  Fantasma (negativo si no se pudo crear).
#          ($v0): Coordenada x.
#         4($v0): Coordenada y.
#         8($v0): Color del Fantasma.
#        12($v0): Color de la capa de fondo.
#        16($v0): Dir. de movimiento del fantasma.
#                 (0: Izquierda, 1: Arriba, 2: Abajo, 3: Derecha)
# Planificacion de registros:
# $t0: Coordenada x del fantasma.
# $t1: Variable auxiliar.
Fantasma_crear:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $t0, $a0

    # Reserva memoria para el fantasma
    li $a0, 17
    li $v0, 9
    syscall
    bltz $v0, Fantasma_crear_fin

    # Inicializa el fantasma
    sw $t0,     ($v0)       # Coordenada x inicial
    sw $a1,    4($v0)       # Coordenada y inicial
    sw $a2,    8($v0)       # Color del fantasma
    lw $t1,   colorComida
    sw $t1,   12($v0)       # Color capa de fondo
    sb $zero, 16($v0)       # Direccion de movimiento
    
Fantasma_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Se encarga del movimiento del fantasma por el tablero, tomando
#          en cuenta las intersecciones y colisiones.
# Entrada: $a0: Fantasma.
# Planificacion de registros:
# $s0: Fantasma
# $t0: Auxiliar
Fantasma_mover:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    move $fp,     $sp
    addi $sp,     $sp, -12

    # Guarda fantasma
    move $s0, $a0

    # Verifica si se encuentra en una interseccion
    jal Fantasma_chequear_interseccion
    
    beqz $v0, Fantasma_mover_revisar_sig
    
    move $a0, $s0
    jal  Fantasma_cambiar_dir
    
    j Fantasma_mover_ejecutar
    
    Fantasma_mover_revisar_sig:
        # Guarda xFantasma y yFantasma
        lw $a0,  ($s0)
        lw $a1, 4($s0)
        
        # Revisa la direccion actual del fantasma
        lb   $t0, 16($a0)
        beqz $t0, Fantasma_mover_revisar_sig_izq
        beq  $t0, 1, Fantasma_mover_revisar_sig_arriba
        beq  $t0, 2, Fantasma_mover_revisar_sig_abajo
        
        # Derecha (x+1, y)
        add $a0, $a0, 1  
        j   Fantasma_mover_chequear_colision

        Fantasma_mover_revisar_sig_izq:
            # (x-1, y)
            add $a0, $a0, -1  
            j   Fantasma_mover_chequear_colision
            
        Fantasma_mover_revisar_sig_arriba:
            # (x, y+1)    
            add $a1, $a1, 1  
            j   Fantasma_mover_chequear_colision

        Fantasma_mover_revisar_sig_abajo:
            # (x, y-1)
            add $a1, $a1, -1

    Fantasma_mover_chequear_colision: 
        jal  es_camino
        beqz $v0, Fantasma_mover_ejecutar

        # Si hay alguna colision, se busca una nueva dir. aleatoria
        move $a0, $s0
        jal  Fantasma_cambiar_dir
    
    Fantasma_mover_ejecutar:
        move $a0, $s0
        jal  Fantasma_ejecutar_mov

Fantasma_mover_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)

    jr $ra

# Funcion: Mueve el pixel del fantasma a la direccion especificada
#          en la estructura.
# Entrada:  $a0:  Fantasma.
# Planificacion de registros:
# $s0: Fantasma.
# $s1: xFantasma siguiente.
# $s2: yFantasma siguiente.
# $t0: Auxiliar.
Fantasma_ejecutar_mov:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    move $fp,     $sp
    addi $sp,     $sp, -20

    # Guarda Fantasma
    move $s0, $a0
    
    # Guarda xFantasma y yFantasma
    lw $s1,  ($s0)
    lw $s2, 4($s0)
            
    # Revisa la direccion actual del fantasma
    lb   $t0, 16($s0)
    beqz $t0, Fantasma_ejecutar_mov_izq
    beq  $t0, 1, Fantasma_ejecutar_mov_arriba
    beq  $t0, 2, Fantasma_ejecutar_mov_abajo
    
    # Derecha (x+1, y)
    add $s1, $s1, 1  
    j   Fantasma_ejecutar_mov_verif_portal

    Fantasma_ejecutar_mov_izq:
        # (x-1, y)
        add $s1, $s1, -1  
        j   Fantasma_ejecutar_mov_verif_portal
        
    Fantasma_ejecutar_mov_arriba:
        # (x, y+1)    
        add $s2, $s2, 1  
        j   Fantasma_ejecutar_mov_verif_portal

    Fantasma_ejecutar_mov_abajo:
        # (x, y-1)
        add $s2, $s2, -1

    Fantasma_ejecutar_mov_verif_portal:
        bnez $s1, Fantasma_ejecutar_mov_verif_portal_der
        li   $s1, 30
        j    Fantasma_ejecutar_mov_pintar

    Fantasma_ejecutar_mov_verif_portal_der:
        bne $s1, 31, Fantasma_ejecutar_mov_pintar
        li  $s1, 1    
    
    Fantasma_ejecutar_mov_pintar:
        # Pinta (x, y) del color de la capa de fondo del fantasma
        lw $a0,   ($s0)
        lw $a1,  4($s0)
        lw $a2, 12($s0)
        jal pintar_pixel

        # Actualiza fondo del fantasma
        move $a0, $s1
        move $a1, $s2
        jal  coord_a_dir_bitmap
        lw   $t0,   ($v0)
        sw   $t0, 12($s0)

        # Actualiza nuevo (x, y) del fantasma
        sw $s1,  ($s0)
        sw $s2, 4($s0)

        # Pinta el nuevo (x, y) del fantasma
        lw $a0,  ($s0)
        lw $a1, 4($s0)
        lw $a2, 8($s0)
        jal pintar_pixel
        
Fantasma_ejecutar_mov_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)

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
    
    # La condicion de interseccion consiste en chequear que
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


# Funcion: Escoge aleatoriamente una direccion valida para el siguiente
#          movimiento del fantasma. Solo retorna la direccion contraria
#          a la actual si es la unica disponible
# Entrada: $a0: Fantasma.
# Salida:  $v0: Dir. aleatoria valida de movimiento del fantasma.
#               (0: Izquierda, 1: Arriba, 2: Abajo, 3: Derecha)
# Planificacion de registros:
# $s0: Fantasma
# $s1: xFantasma
# $s2: yFantasma
# $s3: Direccion opuesta al movimiento del fantasma
# $s4: Contador de direcciones disponibles / Auxiliar
# $t0: Auxiliar
Fantasma_cambiar_dir:
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

    # Guarda Fantasma, xFantasma, yFantasma y Dir. opuesta de movimiento
    move $s0,    $a0    
    lw   $s1,   ($a0)  
    lw   $s2,  4($a0)   
    move $s3, 16($a0)  
    andi $s3,    $s3, 0xF
    sub  $s3,    $s3, 3 

    # Si es una interseccion, chequea caminos disponibles
    # No tomara en cuenta la direccion opuesta como disponible
    move $s4, $zero

    # Arriba (salta la direccion si es la opuesta)
    beq $s3, 1, Fantasma_cambiar_dir_chequear_derecha
    
    # (x, y+1) es camino
    move $a0, $s1
    add  $a1, $s2, 1
    jal es_camino

    bnez $v0, Fantasma_cambiar_dir_chequear_derecha
    
    # Empila las direcciones disponibles para moverse
    li  $t0,  1
    sw  $t0, ($sp)
    add $s4,  $s4, 1 

    Fantasma_cambiar_dir_chequear_derecha:
        beq $s3, 3, Fantasma_cambiar_dir_chequear_abajo
        
        # (x+1, y) es camino
        add  $a0, $s1, 1
        move $a1, $s2
        jal es_camino

        bnez $v0, Fantasma_cambiar_dir_chequear_abajo

        li  $t0,  3
        sll $t1,  $s4, 2
        sub $t1,  $sp, $t1
        sw  $t0, ($t1)
        add $s4,  $s4, 1

    Fantasma_cambiar_dir_chequear_abajo:
        beq $s3, 2, Fantasma_cambiar_dir_chequear_izquierda

        # (x, y-1) es camino
        move $a0, $s1
        add  $a1, $s2, -1
        jal es_camino

        bnez $v0, Fantasma_cambiar_dir_chequear_izquierda

        li  $t0,  2
        sll $t1,  $s4, 2
        sub $t1,  $sp, $t1
        sw  $t0, ($t1)
        add $s4,  $s4, 1

    Fantasma_cambiar_dir_chequear_izquierda:
        beqz $s3, Fantasma_cambiar_dir_chequear_arriba

        # (x-1, y) es camino
        add  $a0, $s1, -1
        move $a1, $s2
        jal es_camino

        bnez $v0, Fantasma_cambiar_dir_verificar

        li  $t0,  0
        sll $t1,  $s4, 2
        sub $t1,  $sp, $t1
        sw  $t0, ($t1)
        add $s4,  $s4, 1

    Fantasma_cambiar_dir_verificar:
        bnez $s4, Fantasma_cambiar_dir_escoger_direccion

        # Se mueve en la direccion contraria si es la unica opcion
        sw  $s3, ($sp)
        add $s4, $s4, 1

    Fantasma_cambiar_dir_escoger_direccion:
        move $a0, $s4
        la   $a1, $sp

        add $s4, $s4, 1
        sll $s4, $t0, 2
        add $sp, $sp, $s4

        # Guarda la nueva direccion del fantasma
        jal escoger_aleatorio
        sb  $v0, 16($s0)

        # Desempila direcciones disponibles
        sub $sp, $sp, $s4
    
Fantasma_cambiar_dir:
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