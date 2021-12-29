# Utilidades.s
# Archivo con distintas funciones utilizadas en Main.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 10-ene-2022

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

    # Convierte la coordenada (x, y) en su direccion
    # de memoria en el Bitmap Display.
    jal coord_a_dir_bitmap

    # Pinta el pixel en la direccion del Bitmap Display.
    sw $s0, ($v0)

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)
    lw   $ra, -4($sp)
    lw   $s0, -8($sp)

    jr $ra 

# Funcion: Pinta un tablero 32x32 desde una cadena de caracteres terminada
#          en nulo, donde cada caracter representa una celda, con el siguiente
#          formato:
#             El tamaño de la cadena es de 1025 bytes (32*32 + 1).
#                'G' representa gris oscuro (pared).
#                ' ' representa blanco (alimento).
#                'N' representa naranja (portal).
#                'P' representa amarillo (Pac-Man).
#                'R' representa rojo (Blinky).
#                'M' representa marron (Pinky).
#                'A' representa azul (Inky).
#                'V' representa verde (Clyde).
#          Usa los colores definidos en Main.s
#          Cuenta y actualiza a su vez la cantidad de alimento en el mapa.
# Entrada: $a0: Direccion de la cadena que contiene el tablero.
#          $a1: Direccion de contador de alimentos restantes.
# Salida:  $v0: negativo si ocurrio algun error. 
# Planificacion de registros:
# $t0: Auxiliar.
# $t1: Direccion a escribir en el Bitmap Display.
# $t2: Color del pixel a pintar.
# $t3: colorPared.
# $t4: colorComida.
pintar_tablero: 
    # Prologo
	sw   $fp,    ($sp)
    sw   $ra,  -4($sp)
	move $fp,     $sp
	addi $sp,     $sp, -8
 
    lw $t1, MAT
    lw $t3, colorPared
    lw $t4, colorComida

    pintar_tablero_for_pixel:
        lb  $t0, ($a0)
        beq $t0, $zero, pintar_tablero_for_pixel_end
        add $a0, $a0, 1

        # Pintar tablero
        beq $t0, ' ', pintar_tablero_blanco
        beq $t0, 'G', pintar_tablero_gris
        beq $t0, 'N', pintar_tablero_naranja
        beq $t0, 'P', pintar_tablero_amarillo
        beq $t0, 'R', pintar_tablero_rojo
        beq $t0, 'M', pintar_tablero_marron
        beq $t0, 'A', pintar_tablero_azul

        # Si no es ninguno de los demas es verde
            lw $t2, colorClyde
            sw $t2, ($t1)
            j  pintar_tablero_aumentar_contador

        pintar_tablero_gris:
            sw $t3, ($t1)
            j  pintar_tablero_for_pixel_sig

        pintar_tablero_blanco:
            sw $t3, ($t1)
            j  pintar_tablero_aumentar_contador

        pintar_tablero_naranja:
            lw $t2, colorPortal
            sw $t2, ($t1)
            j  pintar_tablero_for_pixel_sig

        pintar_tablero_amarillo:
            lw $t2, colorPacman
            sw $t2, ($t1)
            j  pintar_tablero_for_pixel_sig

        pintar_tablero_rojo:
            lw $t2, colorBlinky
            sw $t2, ($t1)
            j  pintar_tablero_aumentar_contador

        pintar_tablero_marron:
            lw $t2, colorPinky
            sw $t2, ($t1)
            j  pintar_tablero_aumentar_contador

        pintar_tablero_azul:
            lw $t2, colorInky
            sw $t2, ($t1)
            j  pintar_tablero_aumentar_contador

    pintar_tablero_aumentar_contador:
        # Aumenta contador de alimentos restantes
        lw  $t0, ($a1)
        add $t0,  $t0, 1
        sw  $t0, ($a1)

    pintar_tablero_for_pixel_sig:
        add $t1, $t1, 4
        j   pintar_tablero_for_pixel

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

# Funcion: Escoge una palabra pseudo-aleatoriamente del arreglo de entrada.
# Entrada: $a0: Numero de elementos del arreglo (1-3). 
#          $a1: Direccion de arreglo de $a0 palabras
# Salida:  $v0: Opcion elegida pseudo-aleatoriamente.
# Planificacion de registros:
# $t0: Auxiliar.
# $t1: Opcion 1.
escoger_aleatorio:
    # Prologo
    sw   $fp, ($sp)
    move $fp,  $sp
    addi $sp,  $sp, -4

    move $t0, $a0
    move $t1, $a1

    beq  $a0, 1, escoger_aleatorio_primero
    
    # (tiempo del sistema) mod (numero de opciones)
    li   $v0, 30
	syscall
    abs  $a0, $a0
    div  $a0, $t0
	mfhi $t0

    beqz $t0, escoger_aleatorio_primero
    beq  $t0, 1, escoger_aleatorio_segundo
    
    # Si no es 0 o 1, es 2 (se escoge $a3)
    lw $v0, 8($t1)
    j  escoger_aleatorio_fin 

    escoger_aleatorio_primero:
        lw $v0, ($t1)
        j  escoger_aleatorio_fin

    escoger_aleatorio_segundo:
        lw $v0, 4($t1)
    
escoger_aleatorio_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Verifica si (x, y) es un camino.
# Entrada: $a0: Coordenada x.
#          $a1: Coordenada y.
# Salida:  $v0: 0 si (x, y) es un camino.
#               1 de otra forma.
# Planificacion de registros:
# $t0: Color de comida
# $t1: Color de fondo
# $t2: Color de camino
# $t3: Color del pixel en (x, y)
es_camino:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    move $fp,    $sp
    addi $sp,    $sp, -8

    # Convierte la coordenada (x, y) en su direccion
    # de memoria en el Bitmap Display.
    jal coord_a_dir_bitmap
    lw  $t3, ($v0)

    # Si es un camino (comida, fondo o portal)
    move $v0, $zero
    lw   $t0, colorComida
    beq  $t3, $t0, es_camino_fin

    lw  $t1, colorFondo
    beq $t3, $t1, es_camino_fin
    
    lw  $t2, colorPortal
    beq $t3, $t2, es_camino_fin

    li $v0, 1
    
es_camino_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)
    lw   $ra, -4($sp)
    
    jr $ra 