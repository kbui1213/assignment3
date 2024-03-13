TITLE

; Name: 
; Date: 
; ID: 
; Description: 

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

; these two lines are only necessary if you're not using Visual Studio
INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
; Define maximum array size
N equ 20

; Array to store data
Vector dd 20 dup(?)

.code
main PROC

; Get user input for operation
mov eax, 0   ; for displaying menu
call GetString
mov eax, 4    ; for newline
call WriteString

; Display menu
mov eax, offset menu
call WriteString

loop1:
; Get user choice
mov eax, 0
call GetInt

; Perform operation based on choice
cmp eax, 1
je ArrayToStack  ; Choice 1: ArrayToStack
cmp eax, 2
je StackToArray  ; Choice 2: StackToArray
cmp eax, 3
je StackReverse  ; Choice 3: StackReverse
cmp eax, 0
jne loop1        ; Loop until exit (choice 0)

; Exit program
mov eax, 4
call WriteString
mov eax, 1
call ExitProcess

; --- Function implementations ---

ArrayToStack PROC
; Push elements from Vector onto stack
push ecx         ; Save register (optional)

mov ecx, 0
loop2:
    cmp ecx, N
    jge done       ; Exit loop when reaching array size

    mov eax, [Vector + ecx*4] ; Load element from array
    push eax       ; Push element onto stack

    add ecx, 1
    jmp loop2

done:
    pop ecx         ; Restore register (optional)
    ret             ; Return from function

ArrayToStack ENDP

StackToArray PROC
; Pop elements from stack back to Vector
push ecx         ; Save register (optional)

mov ecx, N-1
loop3:
    cmp ecx, -1
    jl done2        ; Exit loop when stack is empty

    pop eax          ; Pop element from stack
    mov [Vector + ecx*4], eax ; Store element back to array

    sub ecx, 1
    jmp loop3

done2:
    pop ecx         ; Restore register (optional)
    ret             ; Return from function

StackToArray ENDP

StackReverse PROC
; Reverse elements in Vector using stack
    push ecx         ; Save register (optional)

    call ArrayToStack ; Push elements onto stack
    call StackToArray  ; Pop elements back in reverse order

    pop ecx         ; Restore register (optional)
    ret             ; Return from function
StackReverse ENDP

; --- Data for menu ---

menu db "What do you want to do now? (0 - Exit, 1 - ArrayToStack, 2 - StackToArray, 3 - StackReverse)", 10, 0

main ENDP
END main