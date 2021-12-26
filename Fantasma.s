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
    sw $t1, 16($v0)     # Dir. de movimiento inicial
    
Fantasma_crear_fin:
    # Epilogo
    move $sp,  $fp
    lw   $fp, ($sp)

    jr $ra