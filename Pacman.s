# Pacman.s
# Personaje principal del juego
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022
        .data

        .text

# Funcion: Crea un Pacman con su posicion y color (variable global
#          definida como colorPacman en myexception.s).
# Salida:   $v0:  Pacman (negativo si no se pudo crear).
#          ($v0): Coordenada x.
#         4($v0): Coordenada y.
#         8($v0): Color del Pacman.
# Planificacion de registros:
# $t0: Variable auxiliar.
Pacman_crear:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

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
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Se encarga del movimiento del Pac-Man y su interaccion
#          con el entorno (segun la variable global D).
# Entrada: $a0: Pacman.
#          $a1: Direccion de contador de alimentos restantes.
# Planificacion de registros:
# $s0: Pacman.
# $s1: Dir. contador de alimentos restantes.
# $s2: xPacman siguiente.
# $s3: yPacman siguiente.
# $t0: Color del pixel siguiente.
# $t1: Auxiliar.
Pacman_mover:
    # Prologo
    sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
    move $fp,     $sp
    addi $sp,     $sp, -24

    move $s0, $a0   # Pacman
    move $s1, $a1   # Dir. contador de alimentos restantes

    # Movimiento Pac-Man
    lw $t1, D

    beq $t1, 'A', Pacman_mover_arriba   # Arriba 
    beq $t1, 'b', Pacman_mover_abajo    # Abajo 
    beq $t1, 'I', Pacman_mover_izq      # Izquierda 
    beq $t1, 'D', Pacman_mover_der      # Derecha 

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
        # Convierte la coordenada (x, y) en su direccion
        # de memoria en el Bitmap Display.
        move $a0, $s2
        move $a1, $s3
        jal coord_a_dir_bitmap
        
        # Obtiene el color del pixel.
        lw $t0, ($v0)

        # Si se trata de un camino
        lw  $t1, colorComida
        beq $t0, $t1, Pacman_mover_actualizar_comida
        lw  $t1, colorFondo
        beq $t0, $t1, Pacman_mover_siguiente_camino

        # Si se trata de una pared (no hace nada)
        lw  $t1, colorPared
        beq $t0, $t1, Pacman_mover_fin 

        # Si se trata de un portal
        lw  $t1, colorPortal
        beq $t0, $t1, Pacman_mover_siguiente_portal

        # En cambio, se trata de un fantasma
        
        
        Pacman_mover_actualizar_comida:
            # Actualiza el contador
            lw  $t1, ($s1)
            add $t1,  $t1, -1
            sw  $t1, ($s1)
        
        Pacman_mover_siguiente_camino:
            # Pintar de negro el pixel
            lw $a0,  ($s0)
            lw $a1, 4($s0)
            lw $a2, colorFondo
            jal pintar_pixel

            # Actualizar (x, y) de Pacman
            sw $s2,  ($s0)
            sw $s3, 4($s0)

            j Pacman_mover_pintar_pacman

        Pacman_mover_siguiente_portal:
            # Pintar de negro el pixel
            lw $a0,  ($s0)
            lw $a1, 4($s0)
            lw $a2, colorFondo
            jal pintar_pixel

            # Actualiza (x, y) de Pacman segun corresponda
            beqz $s2, Pacman_mover_siguiente_portal_izq
            
            # De otra forma, se trata del portal derecho
            # Se mueve al Pac-Man al portal izquierdo
            li $s2, 1
            sw $s2,  ($s0)
            sw $s3, 4($s0)
            j Pacman_mover_pintar_pacman
            
            Pacman_mover_siguiente_portal_izq:
                # Se mueve al Pac-Man al portal derecho
                li $s2, 30
                sw $s2,  ($s0)
                sw $s3, 4($s0)

        Pacman_mover_pintar_pacman:
            # Pintar Pacman
            move $a0,   $s2
            move $a1,   $s3
            lw   $a2, 8($s0)
            jal pintar_pixel

Pacman_mover_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)

    jr $ra