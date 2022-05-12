%include "io64.inc"
section .rodata
    string: db "%lld", 0 ;строка формата для считываемых данных (long-long)
    delimeter: db " ", 0 
    
section .text
global CMAIN
CEXTERN scanf 
CEXTERN printf
CEXTERN malloc
CEXTERN free
CMAIN:
    mov rbp, rsp; for correct debugging    
    push r8 
    push r9
    push r12
    push r13
    push r14
    push r15
    push rbp
    mov rbp, rsp
    sub rsp, 40; shadow space
    and rsp, -16; выравнивание стека по границе 16 байт
    
    lea rcx, [string] ;передача первого аргумента (формата данных long-long)
    lea rdx, [rbp-8]  ;передача второго аргумента (куда сохраняем)
    call scanf
    mov r14, [rbp-8] ;кол-во элементов  r14 
    
    ;выделение памяти
    mov rcx, r14 ;в rcx  кол-во аргументов
    mov rax, 8 ;в rax помещаем размер одного элемента массива
    mul rcx ;в rax - количество байт необходимые для массива 
    mov rcx, rax ;передача первым аргументом количество необходимых байт
    call malloc ;вызываем malloc
    mov r15, rax ;в r15 - указатель на выделенную память
    
    mov r13, 0; счетчик равен 0
loop1: 
    lea rcx, [string] ;передача первого аргумента
    lea rdx, [rbp-8]  ;передача второго аргумента
    call scanf
    mov rax, [rbp-8] ; помещаем в rax считанное значение
    mov [r15+8*r13], rax; копирует содержимое ИСТОЧНИКА(rax)счетчик и помещает это содержимое в ПРИЁМНИК
    inc r13; увеличиваем счетчик на 1
    cmp r13, r14; проверка на равенство
    jnz loop1
    
    mov r10, r14
    dec r10
    xor r8,r8
    xor r9,r9    ; j
    xor r12, r12 ; i
    xor r13, r13 ; min
for_i:
    mov rax, [r15+r12*8]; принимаем за минимум первый элемент неотсортированной части массива 
    lea r9, [r12+1] ;  помещает в приемник адрес источника
    mov r13, r12
    for_j:
        cmp rax, [r15+r9*8]; сравнивание "минимума" с другими элементами массива
        jng not_min
        mov rax, [r15+r9*8]; если "минимум" оказался не минимумом, то другой элемент им становится
        mov r13,r9; эксперимент запоминания места
        inc r9;переходим к след элементу
        cmp r9, r14
        jl for_j
    not_min:
        inc r9;переходим к след элементу
        cmp r9, r14
        jl for_j
    xchg [r15+r12*8], rax; в первый элемент неотсортированного массива переносится минимум
    mov [r15+r13*8], rax ; хочу в место где был найден минимум записать первый элемент
    inc r12; сдвиг массива на 1, чтоб не трогать отсортированный
    cmp r12, r10
    jl for_i
    mov r13, 0; счетчик равен 0
    inc r12
print:
    lea rcx, [string]; передача первого аргумента
    mov rdx, [r15 + 8*r13]; передача второго аргумента, то есть элемента из отсортированного массива
    call printf
    lea rcx, [delimeter] ; передаем аргумент
    call printf
    inc r13
    cmp r13, r14
    jnz print
    ;освобождение памяти
    lea rcx, [r15] ;прокидываем первым аргументов указатель на выделенную память     
    call free ;освобождаем
    mov rsp, rbp ; в rsp значение rbp
    pop rbp 
    pop r15
    pop r14
    pop r13
    pop r12 ;эпилог (достаем со стека В ОБРАТНОМ ПОРЯДКЕ)
    pop r9
    pop r8
    xor rax,rax
    ret
    