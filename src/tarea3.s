.data
titulo_bubble:
    .ascii "\nBubble Sort\n"
titulo_bubble_len = . - titulo_bubble

titulo_selection:
    .ascii "\nSelection Sort\n"
titulo_selection_len = . - titulo_selection

msg_antes:
    .ascii "Antes:   "
msg_antes_len = . - msg_antes

msg_despues:
    .ascii "Despues: "
msg_despues_len = . - msg_despues

corchete_abre:
    .ascii "["
corchete_abre_len = . - corchete_abre

corchete_cierra:
    .ascii "]\n"
corchete_cierra_len = . - corchete_cierra

coma_espacio:
    .ascii ", "
coma_espacio_len = . - coma_espacio

digito_cero:
    .ascii "0"
digito_cero_len = . - digito_cero

arreglo_bubble:
    .quad 64, 25, 12, 22, 11, 90, 3, 45, 18, 7

arreglo_selection:
    .quad 64, 25, 12, 22, 11, 90, 3, 45, 18, 7

tam_arreglo:
    .quad 10

.bss
num_buffer:
    .skip 32
num_buffer_end:

.text
.global _start

_start:
    ldr x1, =titulo_bubble              // Carga direccion del titulo Bubble
    mov x2, #titulo_bubble_len          // Carga longitud del titulo
    bl write_string                     // Imprime titulo Bubble

    ldr x1, =msg_antes                  // Carga direccion de mensaje antes
    mov x2, #msg_antes_len              // Carga longitud de mensaje antes
    bl write_string                     // Imprime mensaje antes

    ldr x0, =arreglo_bubble             // Pasa direccion del arreglo Bubble
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl print_array                      // Imprime arreglo original

    ldr x0, =arreglo_bubble             // Pasa direccion del arreglo Bubble
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl bubble_sort                      // Ordena con Bubble Sort

    ldr x1, =msg_despues                // Carga direccion de mensaje despues
    mov x2, #msg_despues_len            // Carga longitud de mensaje despues
    bl write_string                     // Imprime mensaje despues

    ldr x0, =arreglo_bubble             // Pasa direccion del arreglo Bubble
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl print_array                      // Imprime arreglo ordenado

    ldr x1, =titulo_selection           // Carga direccion del titulo Selection
    mov x2, #titulo_selection_len       // Carga longitud del titulo
    bl write_string                     // Imprime titulo Selection

    ldr x1, =msg_antes                  // Carga direccion de mensaje antes
    mov x2, #msg_antes_len              // Carga longitud de mensaje antes
    bl write_string                     // Imprime mensaje antes

    ldr x0, =arreglo_selection          // Pasa direccion del arreglo Selection
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl print_array                      // Imprime arreglo original

    ldr x0, =arreglo_selection          // Pasa direccion del arreglo Selection
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl selection_sort                   // Ordena con Selection Sort

    ldr x1, =msg_despues                // Carga direccion de mensaje despues
    mov x2, #msg_despues_len            // Carga longitud de mensaje despues
    bl write_string                     // Imprime mensaje despues

    ldr x0, =arreglo_selection          // Pasa direccion del arreglo Selection
    ldr x1, =tam_arreglo                // Carga direccion del tamano
    ldr x1, [x1]                        // Pasa cantidad de elementos
    bl print_array                      // Imprime arreglo ordenado

    mov x0, #0                          // Codigo de salida correcto
    mov x8, #93                         // Syscall exit
    svc #0                              // Termina el programa

write_string:
    mov x0, #1                          // Descriptor stdout
    mov x8, #64                         // Syscall write
    svc #0                              // Escribe x2 bytes desde x1
    ret                                 // Regresa al llamador

print_array:
    stp x29, x30, [sp, #-64]!           // Guarda fp y lr en stack
    mov x29, sp                         // Actualiza frame pointer
    stp x19, x20, [sp, #16]             // Guarda registros usados
    stp x21, x22, [sp, #32]             // Guarda registros usados
    mov x19, x0                         // Guarda direccion base
    mov x20, x1                         // Guarda tamano del arreglo
    mov x21, #0                         // Inicializa indice i

    ldr x1, =corchete_abre              // Carga direccion de [
    mov x2, #corchete_abre_len          // Carga longitud de [
    bl write_string                     // Imprime [

print_array_loop:
    cmp x21, x20                        // Compara i con tamano
    b.ge print_array_end                // Sale si i >= tamano
    ldr x0, [x19, x21, lsl #3]          // Carga arreglo[i]
    bl print_number                     // Imprime numero
    add x22, x21, #1                    // Calcula i + 1
    cmp x22, x20                        // Verifica si es ultimo
    b.ge print_array_next               // Omite coma si es ultimo
    ldr x1, =coma_espacio               // Carga direccion de coma
    mov x2, #coma_espacio_len           // Carga longitud de coma
    bl write_string                     // Imprime coma

print_array_next:
    add x21, x21, #1                    // Incrementa i
    b print_array_loop                  // Repite ciclo

print_array_end:
    ldr x1, =corchete_cierra            // Carga direccion de cierre
    mov x2, #corchete_cierra_len        // Carga longitud de cierre
    bl write_string                     // Imprime ] y salto
    ldp x21, x22, [sp, #32]             // Restaura registros
    ldp x19, x20, [sp, #16]             // Restaura registros
    ldp x29, x30, [sp], #64             // Restaura fp y lr
    ret                                 // Regresa al llamador

print_number:
    stp x29, x30, [sp, #-64]!           // Guarda fp y lr en stack
    mov x29, sp                         // Actualiza frame pointer
    stp x19, x20, [sp, #16]             // Guarda registros usados
    stp x21, x22, [sp, #32]             // Guarda registros usados
    stp x23, x24, [sp, #48]             // Guarda registros usados
    mov x19, x0                         // Guarda numero a imprimir
    cbnz x19, print_number_convert      // Convierte si no es cero
    ldr x1, =digito_cero                // Carga direccion de cero
    mov x2, #digito_cero_len            // Carga longitud de cero
    bl write_string                     // Imprime cero
    b print_number_done                 // Finaliza funcion

print_number_convert:
    ldr x20, =num_buffer_end            // Apunta al final del buffer
    mov x21, #0                         // Cuenta digitos generados
    mov x22, #10                        // Base decimal

print_number_loop:
    udiv x23, x19, x22                  // Divide numero entre 10
    mul x24, x23, x22                   // Multiplica cociente por 10
    sub x24, x19, x24                   // Obtiene residuo
    add x24, x24, #'0'                  // Convierte residuo a ASCII
    strb w24, [x20, #-1]!               // Guarda digito hacia atras
    add x21, x21, #1                    // Incrementa cantidad de digitos
    mov x19, x23                        // Actualiza numero con cociente
    cbnz x19, print_number_loop         // Repite si queda cociente
    mov x1, x20                         // Pasa direccion inicial
    mov x2, x21                         // Pasa cantidad de digitos
    bl write_string                     // Imprime numero convertido

print_number_done:
    ldp x23, x24, [sp, #48]             // Restaura registros
    ldp x21, x22, [sp, #32]             // Restaura registros
    ldp x19, x20, [sp, #16]             // Restaura registros
    ldp x29, x30, [sp], #64             // Restaura fp y lr
    ret                                 // Regresa al llamador

bubble_sort:
    stp x29, x30, [sp, #-80]!           // Guarda fp y lr en stack
    mov x29, sp                         // Actualiza frame pointer
    stp x19, x20, [sp, #16]             // Guarda registros usados
    stp x21, x22, [sp, #32]             // Guarda registros usados
    stp x23, x24, [sp, #48]             // Guarda registros usados
    stp x25, x26, [sp, #64]             // Guarda registros usados
    mov x19, x0                         // Guarda direccion base
    mov x20, x1                         // Guarda tamano del arreglo
    cmp x20, #2                         // Verifica si hay minimo 2 datos
    b.lt bubble_done                    // Sale si no hay que ordenar
    mov x21, #0                         // Inicializa i = 0

bubble_outer_loop:
    sub x25, x20, #1                    // Calcula n - 1
    cmp x21, x25                        // Compara i con n - 1
    b.ge bubble_done                    // Sale si termino el ordenamiento
    sub x22, x25, x21                   // Calcula limite interno
    mov x23, #0                         // Inicializa j = 0

bubble_inner_loop:
    cmp x23, x22                        // Compara j con limite
    b.ge bubble_outer_next              // Sale del ciclo interno
    ldr x24, [x19, x23, lsl #3]         // Carga arreglo[j]
    add x26, x23, #1                    // Calcula j + 1
    ldr x25, [x19, x26, lsl #3]         // Carga arreglo[j + 1]
    cmp x24, x25                        // Compara ambos valores
    b.le bubble_no_swap                 // No intercambia si estan en orden
    str x25, [x19, x23, lsl #3]         // Guarda menor en arreglo[j]
    str x24, [x19, x26, lsl #3]         // Guarda mayor en arreglo[j + 1]

bubble_no_swap:
    add x23, x23, #1                    // Incrementa j
    b bubble_inner_loop                 // Repite ciclo interno

bubble_outer_next:
    add x21, x21, #1                    // Incrementa i
    b bubble_outer_loop                 // Repite ciclo externo

bubble_done:
    ldp x25, x26, [sp, #64]             // Restaura registros
    ldp x23, x24, [sp, #48]             // Restaura registros
    ldp x21, x22, [sp, #32]             // Restaura registros
    ldp x19, x20, [sp, #16]             // Restaura registros
    ldp x29, x30, [sp], #80             // Restaura fp y lr
    ret                                 // Regresa al llamador

selection_sort:
    stp x29, x30, [sp, #-96]!           // Guarda fp y lr en stack
    mov x29, sp                         // Actualiza frame pointer
    stp x19, x20, [sp, #16]             // Guarda registros usados
    stp x21, x22, [sp, #32]             // Guarda registros usados
    stp x23, x24, [sp, #48]             // Guarda registros usados
    stp x25, x26, [sp, #64]             // Guarda registros usados
    stp x27, x28, [sp, #80]             // Guarda registros usados
    mov x19, x0                         // Guarda direccion base
    mov x20, x1                         // Guarda tamano del arreglo
    cmp x20, #2                         // Verifica si hay minimo 2 datos
    b.lt selection_done                 // Sale si no hay que ordenar
    mov x21, #0                         // Inicializa i = 0

selection_outer_loop:
    sub x28, x20, #1                    // Calcula n - 1
    cmp x21, x28                        // Compara i con n - 1
    b.ge selection_done                 // Sale si termino el ordenamiento
    mov x22, x21                        // min = i
    add x23, x21, #1                    // j = i + 1

selection_inner_loop:
    cmp x23, x20                        // Compara j con n
    b.ge selection_swap_check           // Sale del ciclo interno
    ldr x24, [x19, x23, lsl #3]         // Carga arreglo[j]
    ldr x25, [x19, x22, lsl #3]         // Carga arreglo[min]
    cmp x24, x25                        // Compara arreglo[j] y arreglo[min]
    b.ge selection_no_min               // Conserva min si no es menor
    mov x22, x23                        // Actualiza min = j

selection_no_min:
    add x23, x23, #1                    // Incrementa j
    b selection_inner_loop              // Repite ciclo interno

selection_swap_check:
    cmp x22, x21                        // Verifica si min cambio
    b.eq selection_outer_next           // Omite swap si min == i
    ldr x26, [x19, x21, lsl #3]         // Carga arreglo[i]
    ldr x27, [x19, x22, lsl #3]         // Carga arreglo[min]
    str x27, [x19, x21, lsl #3]         // Guarda menor en arreglo[i]
    str x26, [x19, x22, lsl #3]         // Guarda valor anterior en min

selection_outer_next:
    add x21, x21, #1                    // Incrementa i
    b selection_outer_loop              // Repite ciclo externo

selection_done:
    ldp x27, x28, [sp, #80]             // Restaura registros
    ldp x25, x26, [sp, #64]             // Restaura registros
    ldp x23, x24, [sp, #48]             // Restaura registros
    ldp x21, x22, [sp, #32]             // Restaura registros
    ldp x19, x20, [sp, #16]             // Restaura registros
    ldp x29, x30, [sp], #96             // Restaura fp y lr
    ret                                 // Regresa al llamador
