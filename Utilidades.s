# Utilidades.s
# Archivo con distintas funciones utilizadas en Main.s
# 
# Autores: Ka Fung & Christopher Gomez
# Fecha: 10-ene-2022

# Funcion: Convierte una coordenada (x, y) en una 
#          direccion del Bitmap Display.
# Entrada: $a0: Direccion base del MAT.
#          $a1: Coordenada x.
#          $a2: Coordenada y.
# Salida:  $v0: Direccion del MAT.    
# Planificacion de registros:
# $t0: Auxiliar
coord_a_dir_bitmap: 
    # Prologo
	sw   $fp, ($sp)
	move $fp,  $sp
	addi $sp,  $sp, -4

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


