# Utilidades.s
# Archivo con distintas funciones utilizadas en Main.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 10-ene-2022

# Funcion: Abre y lee un archivo dado.
# Entrada: $a0: Archivo.
#          $a1: Buffer.
#          $a2: Tamanio Buffer.
# Salida:  $v0: negativo si no logro leer archivo.    
# Planificacion de registros:
# $t0: buffer
# $t1: archivo
leer_archivo: 
    # Prologo
	sw   $fp,   ($sp)
    sw   $ra, -4($sp)
	move $fp,    $sp
	addi $sp,    $sp, -8

    move $t0, $a0   # Archivo
    move $t1, $a1   # Buffer
    move $t2, $a2   # Tamanio Buffer

    # Abrir archivo para leer
    li $v0, 13
    move $a0, $t0
    li $a1, 0
    syscall

    bltz $v0, leer_archivo_fin
    move $a0, $v0

    # Leer archivo
    li $v0, 14
    move $a1, $t1
    move $a2, $t2
    syscall

    bltz $v0, leer_archivo_fin

    add $t1, $t1, $v0
    sb $zero, ($t1) # Termina el buffer con un null

    # Cerrar el archivo
    li $v0, 16
    syscall

leer_archivo_fin:
    # Epilogo
    move $sp,    $fp
    lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra

# Funcion: Convierte una coordenada (x, y) en una 
#          direccion del Bitmap Display.
# Entrada: $a0: Coordenada x.
#          $a1: Coordenada y.
# Salida:  $v0: Direccion del Bitmap Display 
#               correspondiente a (x, y).
# Planificacion de registros:
# $t0: Auxiliar
coord_a_dir_bitmap: 
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    # Formula: (32*(31 - y) + x)*4 + MAT
    li  $t0, 31
    sub $v0, $t0, $a1   # a = 31 - y
    sll $v0, $v0, 5     # a = a * 32
    add $v0, $v0, $a0   # a = a + x
    sll $v0, $v0, 2     # a = a * 4
    lw  $t0, MAT
    add $v0, $v0, $t0   # a = a + MAT

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Pinta un pixel del Bitmap Display.
# Entrada: $a0: Coordenada x.
#          $a1: Coordenada y.
#          $a2: Color (24-bit RGB).    
# Planificacion de registros:
# $s0: Color
pintar_pixel:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    move $s0, $a2

    # Convierte la coordenada (x, y) en su dirección
    # de memoria en el Bitmap Display.
    jal coord_a_dir_bitmap

    # Pinta el pixel en la dirección del Bitmap Display.
    sw $s0, ($v0)

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra 

# Funcion: Pinta un tablero 32x32 desde un archivo donde cada caracter
#          representa una celda, con el siguiente formato:
#             32 líneas de 32 caracteres y \n al final de cada una.
#             El tamaño del archivo es de 1055 bytes (32*32 + 31).
#                'G' representa gris oscuro (pared).
#                ' ' representa blanco (alimento).
#                'N' representa naranja (portal).
#                'P' representa amarillo (Pac-Man).
#                'R' representa rojo (Blinky).
#                'M' representa marron (Pinky).
#                'A' representa azul (Inky).
#                'V' representa verde (Clyde).
#          Usa los colores definidos en Main.s
# Entrada: $a0: Archivo.
# Salida:  $v0: negativo si ocurrió algún error.    
# Planificacion de registros:
# $s0: Archivo del tablero.
# $s1: Dir. memoria del tablero.
# $s2: xActual.
# $s3: yActual.
pintar_tablero: 
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
    sw   $s0,  -8($sp)
    sw   $s1, -12($sp)
    sw   $s2, -16($sp)
    sw   $s3, -20($sp)
	move $fp,     $sp
	addi $sp,     $sp, -24

    move $s0, $a0   # Archivo tablero

    # Reservar memoria
    li $a0, 1055
    li $v0, 9
    syscall
    bltz $v0, pintar_tablero_fin

    move $s1, $v0   # Dir. Memoria
    
    # Abrir y leer el archivo
    move $a0, $s0   # Archivo
    move $a1, $v0   # Dir. Memoria
    li   $a2, 1055  # Tamanio de memoria
    jal leer_archivo
    bltz $v0, pintar_tablero_fin

    # Pintar cada pixel
    li $s2, 0   # Coordenada x
    li $s3, 31  # Coordenada y
    for_pixel:
        lb $t0, ($s1)

        beq $t0, '\n', for_pixel_sig

        # Argumentos para pintar
        move $a0, $s2
        move $a1, $s3

        # Pintar tablero
        beq $t0, ' ', pintar_blanco
        beq $t0, 'G', pintar_gris
        beq $t0, 'N', pintar_naranja
        beq $t0, 'P', pintar_amarillo
        beq $t0, 'R', pintar_rojo
        beq $t0, 'M', pintar_marron
        beq $t0, 'A', pintar_azul

        # Si no es ninguno de los anteriores es verde
        lw $a2, colorClyde
        jal pintar_pixel
        j for_pixel_sig

        pintar_gris:
            lw $a2, colorPared
            jal pintar_pixel
            j for_pixel_sig

        pintar_blanco:
            lw $a2, colorComida
            jal pintar_pixel
            j for_pixel_sig

        pintar_naranja:
            lw $a2, colorPortal
            jal pintar_pixel
            j for_pixel_sig

        pintar_amarillo:
            lw $a2, colorPacman
            jal pintar_pixel
            j for_pixel_sig

        pintar_rojo:
            lw $a2, colorBlinky
            jal pintar_pixel
            j for_pixel_sig

        pintar_marron:
            lw $a2, colorPinky
            jal pintar_pixel
            j for_pixel_sig

        pintar_azul:
            lw $a2, colorInky
            jal pintar_pixel
            j for_pixel_sig

    for_pixel_sig:
        add $s1, $s1, 1
        add $s2, $s2, 1     # x++

        bne  $s2, 33, for_pixel

        # Si llegó al final de la línea, reinicia x y aumenta y
        add  $s3, $s3, -1   # y--
        move $s2, $zero     # x = 0
        
        bne $s3, -1, for_pixel

pintar_tablero_fin:
    # Epilogo
    move $sp,     $fp
    lw   $fp,    ($sp)
    lw   $ra,  -4($sp)
    lw   $s0,  -8($sp)
    lw   $s1, -12($sp)
    lw   $s2, -16($sp)
    lw   $s3, -20($sp)

    jr $ra

# Funcion: Obtiene el color de un pixel del Bitmap Display.
# Entrada: $a0: Coordenada x.
#          $a1: Coordenada y. 
obtener_color_pixel:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Convierte la coordenada (x, y) en su dirección
    # de memoria en el Bitmap Display.
    jal coord_a_dir_bitmap

    # Obtiene el color del pixel.
    lw $v0, ($v0)

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)
    lw   $ra, -4($sp)

    jr $ra 

