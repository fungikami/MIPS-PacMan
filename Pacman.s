# Pacman.s
# Personaje principal del juego
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022
        .data

        .text

# Funcion: Crea un Pacman con su posición y color (variable global
#          definida como colorPacman en myexception.s).
# Salida:   $v0:  Pacman (negativo si no se pudo crear).
#          ($v0): Coordenada x.
#         4($v0): Coordenada y.
#         8($v0): Color del Pacman.
# Planificacion de registros:
# $t0: Variable auxiliar.
Pacman_crear:
    # Prologo
    sw   $fp,   ($sp)
    move $fp,    $sp
    addi $sp,    $sp, -4

    # Reserva memoria para el Pacman
    li $a0, 12
    li $v0, 9
    syscall
    bltz $v0, Pacman_crear_fin

    # Inicializa el Pac-Man amarillo en (14, 11)
    li $t0, 14          # Coordenada x inicial
    sw $t0, ($v0)

    li $t0, 11          # Coordenada y inicial
    sw $t0, 4($v0)
    
    lw $t0, colorPacman
    sw $t0, 8($v0)
    
Pacman_crear_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)

    jr $ra

# Funcion: Se encarga del movimiento del Pac-Man y su interacción
#          con el entorno (según la variable global D).
# Entrada: $a0: Pacman.
#          $a1: Dirección de contador de alimentos restantes.
# Salida:  $v0: .
# Planificacion de registros:
# $s0: Pacman.
# $s1: Dir. contador de alimentos restantes.
# $s2: xPacman siguiente.
# $s3: yPacman siguiente.
# $s4: variable D direccion del movimiento del Pacman.
# $s5:
# $t0: Color del pixel siguiente.
# $t1: Auxiliar.
Pacman_mover:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    move $s0, $a0   # Pacman
    move $s1, $a1   # Dir. contador de alimentos restantes

    # Movimiento Pac-Man
    lw $s4, D

    beq $s4, 'a', Pacman_mover_arriba   # Arriba 
    beq $s4, 'b', Pacman_mover_abajo    # Abajo 
    beq $s4, 'i', Pacman_mover_izq      # Izquierda 
    beq $s4, 'd', Pacman_mover_der      # Derecha 

    Pacman_mover_arriba:
        # (x, y+1)       
        lw  $s2,  ($s0)
        lw  $s3, 4($s0)
        add $s3,   $s3, 1 
        
        j Pacman_mover_siguiente

    Pacman_mover_abajo:
        # (x, y-1)
        lw  $s2,  ($s0)
        lw  $s3, 4($s0)
        add $s3,   $s3, -1
        
        j Pacman_mover_siguiente

    Pacman_mover_izq:
        # (x-1, y)
        lw  $s2,  ($s0)
        add $s2,   $s2, -1  
        lw  $s3, 4($s0)
        
        j Pacman_mover_siguiente

    Pacman_mover_der:
        # (x+1, y)
        lw  $s2,  ($s0)
        add $s2,   $s2, 1  
        lw  $s3, 4($s0)
        
        j Pacman_mover_siguiente

    Pacman_mover_siguiente:
        # Convierte la coordenada (x, y) en su dirección
        # de memoria en el Bitmap Display.
        move $a0, $s2
        move $a1, $s3
        jal coord_a_dir_bitmap
        
        # Obtiene el color del pixel.
        lw $t0, ($v0)

        # Si se trata de un camino
        lw $t1, colorComida
        beq $t0, $t1, Pacman_mover_actualizar_comida
        lw $t1, colorFondo
        beq $t0, $t1, Pacman_mover_siguiente_camino

        # Si se trata de una pared
        lw $t1, colorPared
        beq $t0, $t1, Pacman_mover_siguiente_pared 

        # Si se trata de un portal
        lw $t1, colorPortal
        beq $t0, $t1, Pacman_mover_siguiente_portal
        
        Pacman_mover_actualizar_comida:
            # Actualiza el contador
            lw  $t1, ($s1)
            add $t1,  $t1, -1
            sw  $t1, ($s1)
        
        Pacman_mover_siguiente_camino:
            # Actualizar (x, y) de Pacman
            sw $s2,  ($s0)
            sw $s3, 4($s0)

            # Pintar de negro el pixel
            #    move $a0, $s0
            #    move $a1, $s1
            #    lw   $a2, colorFondo
            #    jal pintar_pixel
                  
            #    # Pintar Pacman
            #    lw $a0, xPacman
            #    lw $a1, yPacman
            #    lw $a2, colorPacman
            #    jal pintar_pixel
            
            j Pacman_mover_fin

        Pacman_mover_siguiente_pared:
            
            j Pacman_mover_fin


        Pacman_mover_siguiente_portal:
        

Pacman_mover_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra