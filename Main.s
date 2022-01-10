# Proyecto 2
# Implementacion del videojuego arcade Pac-Man.
#
# Instrucciones del juego:
#   - Configurar variables MAT, D, C, V y S.
#   - Conectar Keyboard and Display MMIO.
#   - Configurar y conectar Bitmap Display.
#   - Ensamblar y correr Main.s.
#
# Comandos del juego:
#   Movimiento de Pac-Man:
#   - Arriba:       A/a
#   - Abajo:        B/b
#   - Izquierda:    I/i
#   - Derecha:      D/d
#   Menu del juego:
#   - Pausar:       P/p
#   - Salir:        Q/q
#
# Autores: Ka Fung & Christopher Gomez
# Fecha:   10-ene-2022

	.data
# ----------- Configuracion del juego ----------- 
MAT:	.word 0x10008000	# Direccion base del Bitmat Display
S:      .word 1             # Refrescamiento 
C:      .word 1200          # Base para la conversion con los tics del reloj
D:      .word 'A'           # Dir. de movimiento actual del Pac-Man
V:      .word 9             # Vidas

# ------------ Variables ------------
seguir:	        .byte 1
pausar:         .byte 0
avanzarCuadro:  .byte 0
contador:       .word 0
fueComido:      .byte 0
tiempo:         .word 0
alimRestante:   .word 0 
alimTotal:      .word 0 # 573 con los fantasmas

# ------------ Personajes ------------
Pacman:         .word 0
Fantasmas:      .word 0

# ------------ Colores ------------
colorPacman:    .word 0xFFDE1E     # Amarillo
colorBlinky:    .word 0xE61E0E     # Rojo
colorPinky:     .word 0x783014     # Marron
colorInky:      .word 0x38A4E4     # Azul
colorClyde:     .word 0x38D92B     # Verde
colorPortal:    .word 0xF16406     # Naranja
colorPared:     .word 0x33393B     # Gris oscuro
colorComida:    .word 0xFFFFFF     # Blanco
colorFondo:     .word 0x0F0015     # Morado oscuro

# ------------ Tablero ------------
# tablero: 
#     .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
#     .ascii  "G                              G"
#     .ascii  "G G GGGGGGGGGGGGGGGGGGGGGGGGG  G"
#     .ascii  "G G GGGGGG              GGGGG  G"
#     .ascii  "G G         GG     GGG         G"
#     .ascii  "G G  GGGGG  GG  G  GGG  GGGGG  G"
#     .ascii  "G G  G          G          RG  G"
#     .ascii  "G G  G GGGGGGGG G GGGGGGG  MG  G"
#     .ascii  "G G  G G        G       G  AG  G"
#     .ascii  "G G  G G G      G       G  VG  G"
#     .ascii  "G G  G G G GGGGGGGGGGG  G   G  G"
#     .ascii  "G G  G          G       G   G  G"
#     .ascii  "G G      GG GGG G GGG G G   G  G"
#     .ascii  "N G  G G GG GGG G GGG G G      N"
#     .ascii  "N G  G G GG GGG G GGG G        N"
#     .ascii  "G G GG G GG     G GGG GGGGGG   G"
#     .ascii  "G G G  G GG GGG   GGG G        G"
#     .ascii  "G G G  G    GGG G GGG G    GGG G"
#     .ascii  "G G G  G GG GGG G GGG G GG G   G"
#     .ascii  "G G G  G        G       GG G   G"
#     .ascii  "G G G  GGGGG  P G  GG   GG G   G"
#     .ascii  "G G             G       GG     G"
#     .ascii  "G G  G  G  GGGGGGGGGGG  GG  G  G"
#     .ascii  "G G  G          G           G  G"
#     .ascii  "G G  G        G G   G       G  G"
#     .ascii  "G G  G  GG    G G   G   GG  G  G"
#     .ascii  "G G  G  GG GGGG G GGGGG GG  G  G"
#     .ascii  "G G  GGGGG G    G   G   GGGGG  G"
#     .ascii  "G G        G        G          G"
#     .ascii  "G GGGGG      GGG       GGGGGG  G"
#     .ascii  "G                              G"
#     .asciiz "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"

tablero: 
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG  RGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG  MGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG  AGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG  VGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG   GGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGG   GGGG"
    .ascii  "G G      GG GGG G GGG G G   G  G"
    .ascii  "N G  G G GG GGG G GGG G G      N"
    .ascii  "N G  G G GG GGG G GGG G        N"
    .ascii  "G G GG G GG     G GGG GGGGGG   G"
    .ascii  "G G G  G GG GGG   GGG G        G"
    .ascii  "G G G  G    GGG G GGG G    GGG G"
    .ascii  "G G G  G GG GGG G GGG G GG G   G"
    .ascii  "G G G  G        G       GG G   G"
    .ascii  "G G G  GGGGG  P G  GG   GG G   G"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .ascii  "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"
    .asciiz "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG"

# ------------ Mensajes ------------
msgPausa:       .asciiz "\n.-^^-..-^^-..-^^-.  JUEGO PAUSADO .-^^-..-^^-..-^^-.\n"
msgNoPausa:     .asciiz "\n.-^^-..-^^-..-^^- JUEGO DESPAUSADO -^^-..-^^-..-^^-.\n"
msgSalida:      .asciiz "\n.-^^-..-^^-..-^^- JUEGO FINALIZADO -^^-..-^^-..-^^-.\n"
msgVictoria:    .asciiz "\n.-^^-..-^^-..-^^-.. VICTORIA  :) ..-^^-..-^^-..-^^-.\n"
msgDerrota:     .asciiz "\n.-^^-..-^^-..-^^-.. DERROTA   :( ..-^^-..-^^-..-^^-.\n"
msgVidas:       .asciiz " Vidas restantes: "
msgComida:      .asciiz " Progreso:        Te has comido "
msgComida2:     .asciiz "% del alimento."
msgTiempo:      .asciiz " Tiempo:          "
msgTiempo2:     .asciiz " segundos."
puntos:         .asciiz "\n.-^^-..-^^-..-^^-..-^^-..-^^-..-^^-..-^^-..-^^-..-^^-.\n"
nuevaLinea:     .asciiz "\n"
	
	.globl MAT S C D V
	.globl seguir pausar avanzarCuadro contador fueComido tiempo
    .globl __init__ main

	.text

__init__:
    # Inicializa Pac-Man
    jal  Pacman_crear
    bltz $v0, salir
    sw   $v0, Pacman

    # Inicializa los fantasmas
    jal  Fantasmas_crear
    bltz $v0, salir
    sw   $v0, Fantasmas

    # Display tablero
    la $a0, tablero
    la $a1, alimRestante
    la $a2, alimTotal
    jal pintar_tablero

main:
    # Revisa si el juego ya finalizo
	lb   $t1, seguir
	beqz $t1, salir

    # Revisa si el juego esta pausado
	lb  $t1, pausar
	beq $t1, 1, pausar_partida

    # Revisa si el Pac-Man ha sido comido
    lb  $t0, fueComido
    beq $t0, 1, siguiente_partida

    # Revisa si Pac-Man se ha comido todo el alimento
    lw   $t0, alimRestante
    bgtz $t0, esperar
    
siguiente_partida:
    # Disminuye el numero de vidas
    lw  $t0, V 
    add $t0, $t0, -1
    sw  $t0, V 

    # Si se consumen todas las vidas, termina el juego
    beqz $t0, salir

    # Si no fue comido, imprime Victoria
    la   $a0, msgVictoria
    lb   $t0, fueComido
    beqz $t0, siguiente_partida_imprimir_resultado
    la   $a0, msgDerrota

    siguiente_partida_imprimir_resultado:
        jal imprimir_puntuacion

    # Se reinicia el tablero si se consumio todos los alimentos
    lw     $t0, alimRestante
    add    $t0, $t0, -1
    la     $a0, tablero
    la     $a1, alimRestante
    la     $a2, alimTotal
    bltzal $t0, pintar_tablero
    
    # Reinicia Fantasmas
    lw  $a0, Fantasmas
    jal Fantasmas_reiniciar

    # Reinicia Pac-Man
    lw  $a0, Pacman
    jal Pacman_reiniciar # Reinicia posicion y dibuja

    # Reinicia variable que indica si fue comido el Pac-Man
    sb $zero, fueComido 
 
    j main    

esperar:
	lb   $t0, avanzarCuadro
	beqz $t0, esperar

	jal PacMan

	b main

pausar_partida:
	lb   $t1, pausar
	beqz $t1, main
	
	j pausar_partida

salir:	
    # Imprimir resultado
    la  $a0, msgSalida
    jal imprimir_puntuacion
    
	li $v0, 10
	syscall

# Funcion: Avanza por un cuadro el movimiento 
#          de los personajes en el tablero.
PacMan:
    # Prologo
	sw   $fp,   ($sp)
    sw   $ra, -4($sp)
	move $fp,    $sp
	addi $sp,    $sp, -8

    # Reinicia la variable saltar
    sb $zero, avanzarCuadro
    
    # Movimiento de Pac-Man
    lw  $a0, Pacman
    la  $a1, alimRestante
    jal Pacman_mover

    # Movimiento de los fantasmas
    lw  $a0, Fantasmas
    jal Fantasmas_mover

PacMan_fin:
    # Epilogo
    move $sp,    $fp
	lw   $fp,   ($sp)
    lw   $ra, -4($sp)

    jr $ra

.include "Utilidades.s"
.include "Pacman.s"
.include "Fantasmas.s"
.include "Fantasma.s"
