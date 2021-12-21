# Utilidades.s
# Archivo con distintas funciones utilizadas en Main.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 10-ene-2022

# Funcion: Convierte una coordenada (x, y) en una 
#          direccion del Bitmap Display.
# Entrada: $a0: Direccion base del Bitmap Display 
#               correspondiente a (x, y).
#          $a1: Coordenada x.
#          $a2: Coordenada y.
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
    sub $v0, $t0, $a2   # a = 31 - y
    sll $v0, $v0, 5     # a = a * 32
    add $v0, $v0, $a1   # a = a + x
    sll $v0, $v0, 2     # a = a * 4
    add $v0, $v0, $a0   # a = a + MAT

    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra

# Funcion: Pinta un pixel del Bitmap Display.
# Entrada: $a0: Direccion base del Bitmap Display 
#               correspondiente a (x, y).
#          $a1: Coordenada x.
#          $a2: Coordenada y.
#          $a3: Color (24-bit RGB).    
# Planificacion de registros:
# $s0: Color
pintar_pixel:
    # Prologo
    sw   $fp,   ($sp)
    sw   $ra, -4($sp)
    sw   $s0, -8($sp)
    move $fp,    $sp
    addi $sp,    $sp, -12

    move $s0, $a3

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