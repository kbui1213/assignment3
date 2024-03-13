TITLE ASSIGNMENT-3

; Name: Kayden Ions
; Date: 03/13/2024
; ID: 110102877
; Description: Grabs a vector from the user, the user can convert it to the stack from a vector and from a vector to a stack and also reverse the vector using the stack.

INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib

INCLUDELIB kernel32.lib
INCLUDELIB user32.lib

.data
	MAX = 20 ; Start of vector variables
	N BYTE ?
	UserVector DWORD MAX DUP(?) ; Vector
	initialAddress DWORD ? ; ESP address at the start of the program

	mainPrompt BYTE "What do you want to do now? > ", 0 ; Start of prompts in order

	; Strings for main loop 0
	secondPrompt BYTE "What is the size N of Vector? > ", 0 
	secondPromptA BYTE "What are the ", 0
	secondPromptB BYTE " values in Vector? > ", 0
	secondPromptC BYTE "Size of Vector is N = ", 0
	secondPromptD BYTE "Vector = ", 0 
	; End of strings for main loop 0

	printVectorOffSet BYTE ", ", 0 ; Printing the offset

	empty BYTE "Stack is empty", 0Ah, 0Dh, 0 ; When stack is empty
	notEmpty BYTE "Stack not empty", 0Ah, 0Dh, 0 ; When stack is not empty

	; Start of strings for main loop 1
	thirdPromptA BYTE "Vector is ", 0
	thirdPromptB BYTE "before ArrayToStack ", 0Ah, 0Dh, 0
	thirdPromptC BYTE "Stack is ", 0
	thirdPromptD BYTE "after ArrayToStack", 0Ah, 0Dh, 0
	; End of strings for main loop 1

	; Start of strings for main loop 2
	fourthPromptA BYTE "before StackToArray ", 0Ah, 0Dh, 0
	fourthPromptB BYTE "after StackToArray", 0Ah, 0Dh, 0
	; End of strings for main loop 2

	; Start of strings for main loop 3
	fifthPromptA BYTE "before StackReverse", 0Ah, 0Dh, 0
	fifthPromptB BYTE "After StackReverse", 0Ah, 0Dh, 0
	; End of strings for main loop 3

	; Start of string errors
	ErrorN BYTE "N Must be greater than 0 and less than ", 0
	ErrorStack BYTE "Error Stack is empty: Cannot perform StackToArray", 0Ah, 0Dh, 0
	ErrorMainLoop BYTE "Error, main integer should be between -1 and 3", 0Ah, 0Dh, 0
	; End of string errors

	; Exit string when main is -1
	ExitPrompt BYTE "I am exiting... Thank you Honey... and Get lost...", 0Ah, 0Dh, 0

.code

; Stack empty procedure
StackEmpty PROC
	mov EAX, ESP
	ADD EAX, DWORD
	CMP initialAddress, EAX ; If the initial address is equal to the current ESP
	JE EmptyStack ; Then display that the stack is empty, otherwise display that the stack isnt empty

	NotEmptyStack:
		mov EDX, OFFSET notEmpty
		Call WriteString ; Display string
		jmp ExitingStackEmpty
	EmptyStack:
		mov EDX, OFFSET empty
		Call WriteString ; Display string
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
        mov EDX, OFFSET printVectorOffSet
        Call WriteString

        ; Move to the next element in the vector
        add EDI, DWORD
        
        ; Decrement the loop counter
        loop PrintVectorLoop

    ret
PrintVector ENDP

; Display every element in the stack
PrintStack PROC
	mov EDI, ESP
	movzx ECX, N
	; Iterate throught the stack using ESP at EDI
	IterateThroughStack:
		ADD EDI, DWORD
		mov EAX, [EDI]
		Call WriteDec ; Print value at EDI
		mov EDX, OFFSET printVectorOffSet
		Call WriteString ; Print space between values
		loop IterateThroughStack
	ret
PrintStack ENDP


main PROC
	; Set the initial address to ESP
	mov initialAddress, ESP
	; Main loop to tell the program what to do
	mainLoop:
		mov EDX, OFFSET mainPrompt
		Call WriteString

		Call ReadInt
		Call Crlf

		; If EAX = -1 then Exit
		CMP EAX, -1
		JE ExitVal
		; If EAX = 0 then Create the new vector
		CMP EAX, 0
		JE CreateVector
		; If EAX = 1 then Convert vector to the stack
		CMP EAX, 1
		JE VectorToStack
		; If EAX = 2 then Convert the stack to vector
		CMP EAX, 2
		JE StackToVector
		; If EAX = 3 then reverse the vector using the stack
		CMP EAX, 3
		JE StackReverse
		; Otherwise, if EAX > 3 and EAX < -1, display an error message and start from the beginning
	ErrorMainInt:
		mov EDX, OFFSET ErrorMainLoop
		Call WriteString
		jmp mainLoop
	; Start of 0
	CreateVector:
		mov EDX, OFFSET secondPrompt
		Call WriteString

		Call ReadInt
		mov N, AL
		CMP EAX, 0
		JLE ErrorNInt
		CMP EAX, MAX
		JG ErrorNInt
		; If N < 1, then display an error message and go to the beginning. Otherwise set the counter to N
		movzx ECX, N

	
		Call Crlf

		mov EDX, OFFSET secondPromptA
		Call WriteString
		Call WriteDec
		mov EDX, OFFSET secondPromptB
		Call WriteString
		Call Crlf

		mov EDI, OFFSET UserVector
	VectorLoop: ; Develop Vector
		Call ReadInt ; Read each integer, N times
		mov [EDI], EAX ; Move integer into the value at EDI
		add EDI, DWORD ; Increment EDI by 4 bytes
		loop VectorLoop ; Loop 
		; Start writing the size of the vector
		mov EDX, OFFSET secondPromptC 
		Call WriteString 
		movzx EAX, N
		Call WriteDec
		Call Crlf
		; End writing the size of the vector

		; Write the values of the vector 
		movzx ECX, N
		mov EDX, OFFSET secondPromptD
		Call WriteString ; Writes the prompt
		Call PrintVector ; Prints the vector to the console
		Call Crlf 
		Call StackEmpty ; Checks whether the stack is empty		
		jmp mainLoop ; Jump back to the main loop
	; End of 0
	; Writes the error string if N is not between 0 and N
	ErrorNInt:
		mov EDX, OFFSET ErrorN
		Call WriteString
		mov EAX, MAX
		Call WriteDec
		Call Crlf
		Call Crlf 
		jmp mainLoop
	
	; Start of 1
	VectorToStack:
		mov EDX, OFFSET thirdPromptA
		Call WriteString
		Call PrintVector ; Print original vector
		mov EDX, OFFSET thirdPromptB
		Call WriteString
		movzx ECX, N
		mov EDI, OFFSET UserVector
	VectorToStackLoop:
		push [EDI] ; Push value in the vector at EDI to the stack
		mov EAX, 0 
		mov [EDI], EAX ; Sets the value at EDI to 0
		add EDI, DWORD ; Increment by 4 bytes
		loop VectorToStackLoop ; Loop again
		Call Crlf
		mov EDX, OFFSET thirdPromptC
		Call WriteString 
		Call PrintStack ; Print stack values
		mov EDX, OFFSET thirdPromptD
		Call WriteString
		Call Crlf
		mov EDX, OFFSET thirdPromptA
		Call WriteString
		Call PrintVector ; Print vector values
		mov EDX, OFFSET thirdPromptD
		Call WriteString
		Call Crlf
		Call StackEmpty
		jmp mainLoop
	; End of 1
	; If the stack is empty and you try to acess it, then display the error message
	ErrorStackEmpty:
		mov EDX, OFFSET ErrorStack
		Call WriteString
		jmp mainLoop
	; Start of 2
	StackToVector:
		; Check if the stack is empty or not
		mov EAX, ESP
		CMP initialAddress, EAX
		je ErrorStackEmpty
		; Jumps above to ErrorStackEmpty if so
		; Otherwise print the stack
		mov EDX, OFFSET thirdPromptC
		Call WriteString
		Call PrintStack
		mov EDX, OFFSET fourthPromptA
		Call WriteString
		; Move EDI to the address at the last element of the Vector
		mov EDI, OFFSET UserVector
		movzx EAX, N
		add EAX, EAX
		add EAX, EAX
		add EDI, EAX
		sub EDI, DWORD
		; Move the loop counter to the value of N which is the number of elements
		movzx ECX, N
	; Loop to convert the stack to the vector
	StackToVectorLoop:
		; Pop the lastest value in the stack to EAX
		pop EAX
		; Move the value in EAX into the value at EDI
		mov [EDI], EAX
		; Decrement by 4 bytes
		sub EDI, DWORD
		; Loop back
		loop StackToVectorLoop
		mov EDX, OFFSET thirdPromptA
		Call WriteString
		Call PrintVector ; Print vector
		mov EDX, OFFSET fourthPromptB
		Call WriteString
		Call Crlf
		Call StackEmpty ; Print whether the stack is empty or not
		jmp mainLoop ; Go to the start of the main loop
	; End of 2
	; Start of 3
	StackReverse:
		mov EDX, OFFSET thirdPromptA
		Call WriteString
		Call PrintVector ; Print original vector
		mov EDX, OFFSET fifthPromptB
		Call WriteString
		movzx ECX, N
		mov EDI, OFFSET UserVector
	; Reverse the original vector
	PushStackReverseLoop:
		push [EDI] ; Push the value at EDI onto the stack
		mov EAX, 0
		mov [EDI], EAX
		add EDI, DWORD ; Increment EDI by 4 bytes
		loop PushStackReverseLoop
		movzx ECX, N ; Prepare for the pop loop
		mov EDI, OFFSET UserVector
		Call StackEmpty ; Print whether the stack is empty
	PopStackReverseLoop:
		pop EAX ; Pops the lastest value in the stack into EAX
		mov [EDI], EAX ; Move EAX into the value at EDI
		add EDI, DWORD ; Increment by 4 bytes
		loop PopStackReverseLoop 
		mov EDX, OFFSET thirdPromptA
		Call WriteString 
		Call PrintVector ; Print the reversed vector
		mov EDX, OFFSET fifthPromptB 
		Call WriteString
		Call StackEmpty ; Print whether the stack is empty or not
		jmp mainLoop	
	;End of 3
	; Start of -1
	ExitVal:
		mov EDX, OFFSET ExitPrompt
		Call WriteString

	exit

main ENDP
END main

