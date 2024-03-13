; Title: Assignment-2
; Author: Kevin Bui
; Date: March 13, 2024
; ID: 110110133
; Description: Assignment 3

; Including necessary libraries
INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    MAX = 20 ; Maximum size of the vector
    N BYTE ? ; Variable for the size of the vector
    UserVector DWORD MAX DUP(?) ; Vector to store user values

    exiting BYTE "I am exiting... Thank you Honey... and Get lost...", 0Ah, 0Dh, 0

    ; Prompts for user interaction
    promptFirst BYTE "what do you want to do now? (Code broke, on first prompt ENTER can continue code rather than numbers usually)> ", 0
    prompt_two BYTE "What is the size N of Vector? > ", 0
    promptThird BYTE "What are the ", 0
    promptFour BYTE " values in Vector? > ", 0
    promptFifth BYTE "Size of Vector is N = ", 0
    promptSixth BYTE "Vector = ", 0

    empty BYTE "Stack is empty ", 0Ah, 0Dh, 0
    notEmpty BYTE "Stack not empty", 0Ah, 0Dh, 0

    space_text BYTE ", ", 0

    ; Prompts for stack operations
    Prompt_7 BYTE "Vector is ", 0
    Prompt_8 BYTE "before ArrayToStack ", 0Ah, 0Dh, 0
    Prompt_9 BYTE "Stack is ", 0
    Prompt_10 BYTE "after ArrayToStack", 0Ah, 0Dh, 0

    Prompt_11 BYTE "Vector is ", 0
    Prompt_12 BYTE "before StackToArray ", 0Ah, 0Dh, 0
    Prompt_13 BYTE "Stack is ", 0
    Prompt_14 BYTE "after StackToArray", 0Ah, 0Dh, 0

    prompt_15 BYTE "Vector is ", 0
    prompt_16 BYTE "before StackReverse ", 0Ah, 0Dh, 0
    prompt_17 BYTE "Stack is ", 0
    prompt_18 BYTE "after StackReverse", 0Ah, 0Dh, 0

    ; Variables for stack operations
    variable1 DWORD ?
    variable2 DWORD ?

.code

; Procedure to check if the stack is empty
StackEmpty PROC
    mov EAX, ESP
    ADD EAX, DWORD
    CMP variable1, EAX
    JE emptying_here

    other_stack:
        mov EDX, OFFSET notEmpty
        Call WriteString
        jmp if_empty
    emptying_here:
        mov EDX, OFFSET empty
        Call WriteString
    if_empty:
    ret
StackEmpty ENDP

; Procedure to print values in the vector
print_values PROC
    movzx ECX, N ; Set loop counter to the length of the vector
    mov EDI, OFFSET UserVector ; Point EDI to the beginning of the vector

    Loop_Print:
        ; Display the current element
        mov EAX, [EDI]
        Call WriteDec

        ; Display space between elements
        mov EDX, OFFSET space_text
        Call WriteString

        ; Move to the next element in the vector
        add EDI, DWORD ; Assuming each element is a double-word (4 bytes)
        
        ; Decrement the loop counter
        loop Loop_Print

    ret
print_values ENDP

; Procedure to print values in the stack
stack_valuez PROC
    mov EDI, ESP
    movzx ECX, N
    IterateThroughStack:
        ADD EDI, DWORD
        mov EAX, [EDI]
        Call WriteDec
        mov EDX, OFFSET space_text
        Call WriteString
        loop IterateThroughStack
    ret
stack_valuez ENDP

main PROC
    
    mov variable1, ESP
    mainLoop:
        ; Display main prompt and read user input
        mov EDX, OFFSET promptFirst
        Call WriteString
        Call ReadInt
        Call Crlf

        ; Compare user input to determine action
        CMP EAX, -1
        JE Finishing
        CMP EAX, 0
        JE make_start
        CMP EAX, 1
        JE VectorToStack
        CMP EAX, 2
        JE StackToVector
        CMP EAX, 3
        JE StackReverse

    ; Create a vector
    make_start:
        mov EDX, OFFSET prompt_two
        Call WriteString
        Call ReadInt
        mov N, AL
        movzx ECX, N
        Call Crlf

        mov EDX, OFFSET promptThird
        Call WriteString
        Call WriteDec
        mov EDX, OFFSET promptFour
        Call WriteString
        Call Crlf

        mov EDI, OFFSET UserVector
    loop_vector:
        Call ReadInt
        mov [EDI], EAX
        add EDI, DWORD
        loop loop_vector
        mov EDX, OFFSET promptFifth
        Call WriteString
        movzx EAX, N
        Call WriteDec
        Call Crlf
        movzx ECX, N
        mov EDX, OFFSET promptSixth
        Call WriteString
        Call print_values
        Call Crlf
        Call StackEmpty
        jmp mainLoop

    ; Vector to Stack operation
    VectorToStack:
        mov EDX, OFFSET Prompt_7
        Call WriteString
        Call print_values
        mov EDX, OFFSET Prompt_8
        Call WriteString
        movzx ECX, N
        mov EDI, OFFSET UserVector
    loopVstack:
        push [EDI]
        mov EAX, 0
        mov [EDI], EAX
        add EDI, DWORD 
        loop loopVstack
        Call Crlf
        mov EDX, OFFSET Prompt_9
        Call WriteString
        Call stack_valuez
        mov EDX, OFFSET Prompt_10
        Call WriteString
        Call Crlf
        mov EDX, OFFSET Prompt_7
        Call WriteString
        Call print_values
        mov EDX, OFFSET Prompt_10
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop

    ; Stack to Vector operation
    StackToVector:
        mov EDX, OFFSET Prompt_13
        Call WriteString
        Call stack_valuez
        mov EDX, OFFSET Prompt_12
        Call WriteString
        mov EDI, OFFSET UserVector
        movzx EAX, N
        add EAX, EAX
        add EAX, EAX
        add EDI, EAX
        sub EDI, DWORD
        movzx ECX, N
    stack_vector:
        pop EAX
        mov [EDI], EAX
        sub EDI, DWORD
        loop stack_vector
        mov EDX, OFFSET Prompt_11
        Call WriteString
        Call print_values
        mov EDX, OFFSET Prompt_14
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop

    ; Reverse Stack operation
    StackReverse:
        mov EDX, OFFSET prompt_15
        Call WriteString
        Call print_values
        mov EDX, OFFSET prompt_16
        Call WriteString

        mov esi, OFFSET UserVector
        
        movzx ecx, N
        mov edi, OFFSET UserVector
        add edi, ecx
        add edi, ecx
        add edi, ecx
        sub edi, 4
        
        loop_R:
            mov eax, [esi]
            xchg eax, [edi]
            mov [esi], eax
            
            add esi, 4
            sub edi, 4
            
            cmp esi, edi
            jae stack_loop_finish
            
            jmp loop_R
        
        stack_loop_finish:
        mov EDX, OFFSET prompt_17
        Call WriteString
        Call stack_valuez
        mov EDX, OFFSET prompt_18
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop

    ; Exit option
    Finishing:
        mov EDX, OFFSET exiting
        Call WriteString

    exit

main ENDP
END main
