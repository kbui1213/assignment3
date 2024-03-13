Assignment 3 Q4
; Name: Kevin Bui
; Date: March 13 2024
; ID: 110110133
; Description: Assignment 3

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
    MAX = 20 ; Maximum size of the vector
    N BYTE ?
    UserVector DWORD MAX DUP(?)
    initialAddress DWORD ?
    currentAddress DWORD ?

    promptFirst BYTE "what do you want to do now? > ", 0

    prompt_two BYTE "What is the size N of Vector? > ", 0
    promptThird BYTE "What are the ", 0
    promptFour BYTE " values in Vector? > ", 0
    promptFifth BYTE "Size of Vector is N = ", 0
    promptSixth BYTE "Vector = ", 0

    
    empty BYTE "Stack is empty ", 0Ah, 0Dh, 0
    notEmpty BYTE "Stack not empty", 0Ah, 0Dh, 0

    space_text BYTE ", ", 0

    Prompt_7 BYTE "Vector is ", 0
    Prompt_8 BYTE "before ArrayToStack ", 0Ah, 0Dh, 0
    Prompt_9 BYTE "Stack is ", 0
    Prompt_10 BYTE "after ArrayToStack", 0Ah, 0Dh, 0

    Prompt_11 BYTE "Vector is ", 0
    Prompt_12 BYTE "before StackToArray ", 0Ah, 0Dh, 0
    Prompt_13 BYTE "Stack is ", 0
    Prompt_14 BYTE "after StackToArray", 0Ah, 0Dh, 0

    Prompt_15 BYTE "Vector is ", 0
    Prompt_16 BYTE "before StackReverse ", 0Ah, 0Dh, 0
    Prompt_17 BYTE "Stack is ", 0
    Prompt_18 BYTE "after StackReverse", 0Ah, 0Dh, 0

    ExitPrompt BYTE "I am exiting... Thank you Honey... and Get lost...", 0Ah, 0Dh, 0

.code

StackEmpty PROC
    mov EAX, ESP
    ADD EAX, DWORD
    CMP initialAddress, EAX
    JE EmptyStack

    NotEmptyStack:
        mov EDX, OFFSET notEmpty
        Call WriteString
        jmp ExitingStackEmpty
    EmptyStack:
        mov EDX, OFFSET empty
        Call WriteString
    ExitingStackEmpty:
    ret
StackEmpty ENDP

PrintVector PROC
    ; Display the vector
    movzx ECX, N ; Set the loop counter to the size of the vector
    mov EDI, OFFSET UserVector ; Set EDI to point to the beginning of the vector

    PrintVectorLoop:
        ; Display the current element
        mov EAX, [EDI]
        Call WriteDec

        ; Display space between elements
        mov EDX, OFFSET space_text
        Call WriteString

        ; Move to the next element in the vector
        add EDI, DWORD ; Assuming each element is a double-word (4 bytes)
        
        ; Decrement the loop counter
        loop PrintVectorLoop

    ret
PrintVector ENDP

PrintStack PROC
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
PrintStack ENDP

main PROC
    
    mov initialAddress, ESP
    mainLoop:
        mov EDX, OFFSET promptFirst
        Call WriteString

        Call ReadInt
        Call Crlf

        CMP EAX, -1
        JE ExitVal
        CMP EAX, 0
        JE CreateVector
        CMP EAX, 1
        JE VectorToStack
        CMP EAX, 2
        JE StackToVector
        CMP EAX, 3
        JE StackReverse


    ; Start of 0
    CreateVector:
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
    VectorLoop:
        Call ReadInt
        mov [EDI], EAX
        add EDI, DWORD
        loop VectorLoop
        mov EDX, OFFSET promptFifth
        Call WriteString
        movzx EAX, N
        Call WriteDec
        Call Crlf
        movzx ECX, N
        mov EDX, OFFSET promptSixth
        Call WriteString
        Call PrintVector
        Call Crlf
        Call StackEmpty
        jmp mainLoop
    ; End of 0
    ; Start of 1
    VectorToStack:
        mov EDX, OFFSET Prompt_7
        Call WriteString
        Call PrintVector
        mov EDX, OFFSET Prompt_8
        Call WriteString
        movzx ECX, N
        mov EDI, OFFSET UserVector
    VectorToStackLoop:
        push [EDI]
        mov EAX, 0
        mov [EDI], EAX
        add EDI, DWORD 
        loop VectorToStackLoop
        Call Crlf
        mov EDX, OFFSET Prompt_9
        Call WriteString
        Call PrintStack
        mov EDX, OFFSET Prompt_10
        Call WriteString
        Call Crlf
        mov EDX, OFFSET Prompt_7
        Call WriteString
        Call PrintVector
        mov EDX, OFFSET Prompt_10
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop
    ; End of 1
    ; Start of 2
    StackToVector:
        mov EDX, OFFSET Prompt_13
        Call WriteString
        Call PrintStack
        mov EDX, OFFSET Prompt_12
        Call WriteString
        mov EDI, OFFSET UserVector
        movzx EAX, N
        add EAX, EAX
        add EAX, EAX
        add EDI, EAX
        sub EDI, DWORD
        movzx ECX, N
    StackToVectorLoop:
        pop EAX
        mov [EDI], EAX
        sub EDI, DWORD
        loop StackToVectorLoop
        mov EDX, OFFSET Prompt_11
        Call WriteString
        Call PrintVector
        mov EDX, OFFSET Prompt_14
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop
    ; End of 2
    ; Start of 3
    StackReverse:
        mov EDX, OFFSET Prompt_15
        Call WriteString
        Call PrintVector
        mov EDX, OFFSET Prompt_16
        Call WriteString

        mov esi, OFFSET UserVector
        
        movzx ecx, N
        mov edi, OFFSET UserVector
        add edi, ecx
        add edi, ecx
        add edi, ecx
        sub edi, 4
        
        StackReverseLoop:
            mov eax, [esi]
            xchg eax, [edi]
            mov [esi], eax
            
            add esi, 4
            sub edi, 4
            
            cmp esi, edi
            jae StackReverseExitLoop
            
            jmp StackReverseLoop
        
        StackReverseExitLoop:
        mov EDX, OFFSET Prompt_17
        Call WriteString
        Call PrintStack
        mov EDX, OFFSET Prompt_18
        Call WriteString
        Call Crlf
        Call StackEmpty
        jmp mainLoop
    ; End of 3
    ; Start of -1
    ExitVal:
        mov EDX, OFFSET ExitPrompt
        Call WriteString

    exit

main ENDP
END main
