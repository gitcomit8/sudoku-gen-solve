section .data
    grid times 81 dd 0
    formatLine db "------+-------+------", 10, 0
    formatSeparator db "| ", 0
    formatBlank db "  ", 0
    formatNumber db "%d ", 0

section .bss
    i resd 1
    j resd 1
    num resd 1

section .text
    global _removeCells
    global _printGrid
    extern printf
    extern rand

_removeCells:
    ; Parameters: count in eax
    mov ecx, eax        ; ecx = count
remove_loop:
    cmp ecx, 0
    je remove_end
    call rand
    xor edx, edx
    mov ebx, 9
    div ebx             ; eax = rand() % 9
    mov esi, eax        ; esi = row
    call rand
    xor edx, edx
    mov ebx, 9
    div ebx             ; eax = rand() % 9
    mov edi, eax        ; edi = col

    ; Calculate offset: (row * 9 + col) * 4
    mov eax, esi
    imul eax, 9
    add eax, edi
    shl eax, 2          ; eax = (row * 9 + col) * 4
    mov ebx, grid
    add ebx, eax        ; ebx points to grid[row][col]
    mov eax, [ebx]
    cmp eax, 0
    je set_zero
    jmp skip_decrement
set_zero:
    mov dword [ebx], 0
    dec ecx
skip_decrement:
    jmp remove_loop
remove_end:
    ret

_printGrid:
    mov ecx, 0          ; i = 0
print_outer_loop:
    cmp ecx, 9
    jge print_end
    mov eax, ecx
    xor edx, edx
    mov ebx, 3
    div ebx
    cmp edx, 0
    jne print_inner
    cmp ecx, 0
    je skip_print_line
    push formatLine
    call printf
    add esp, 4
skip_print_line:
print_inner:
    mov [i], ecx
    mov ebx, 0          ; j = 0
print_inner_loop:
    cmp ebx, 9
    jge print_newline
    ; Calculate offset: (i * 9 + j) * 4
    mov eax, ecx        ; row = i
    imul eax, 9
    add eax, ebx         ; row * 9 + col
    shl eax, 2           ; (row * 9 + col) * 4
    mov edx, grid
    add edx, eax         ; edx points to grid[i][j]
    mov eax, [edx]

    ; Print separator if needed
    mov eax, ebx
    xor edx, edx
    mov ecx, 3
    div ecx
    cmp edx, 0
    jne skip_separator
    push formatSeparator
    call printf
    add esp, 4
skip_separator:

    ; Print number or blank
    cmp eax, 0
    jne print_number
    push formatBlank
    call printf
    add esp, 4
    jmp skip_increment
print_number:
    push eax
    push formatNumber
    call printf
    add esp, 8
skip_increment:
    inc ebx
    jmp print_inner_loop
print_newline:
    push 10          ; Newline character
    call printf
    add esp, 4
    inc ecx
    jmp print_outer_loop
print_end:
    ret