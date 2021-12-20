; this macro takes the starting cords, line lenght
drawLineVertical macro ptX, ptY, lenght
	mov cx, 0
	mov bx, ptY
	.while cx <= lenght
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, gridLineColor ; color
		mov cx, ptX ;x-cord, x pt remains constant throughout
		mov dx, bx ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
endm

drawLineHorizontal macro ptX, ptY, lenght
	mov cx, 0
	mov bx, ptX
	.while cx <= lenght
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, gridLineColor ; color
		mov cx, bx ;x-cord, x pt remains constant throughout
		mov dx, ptY ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
endm

makePixel macro x, y, color
	mov ah, 0ch ; shows a pixel
	mov al, color ; color
	mov cx, x ;x-cord
	mov dx, y ; y-cord
	int 10h
endm

makeSquare macro x, y, len, color
	mov cx, len
	mov bx, x
	.while(cx>0)
		push cx
		
		makePixel bx, y, color
		
		inc bx
		pop cx
		dec cx
	.endw
	
	mov cx, len
	mov bx, x
	.while(cx>0)
		push cx
		
		makePixel x, bx, color
		
		inc bx
		pop cx
		dec cx
	.endw
	
	mov cx, len
	mov bx, x
	mov si, y
	add si, len
	inc cx
	.while(cx>0)
		push cx
		
		makePixel bx, si, color
		
		inc bx
		pop cx
		dec cx
	.endw
	
	mov cx, len
	mov bx, x
	mov si, y
	add si, len
	
	.while(cx>0)
		push cx
		
		makePixel si, bx, color
		
		inc bx
		pop cx
		dec cx
	.endw

endm 

displayBigValue macro p1
	push cx
	push dx
	push ax
	
	mov dx, p1
	add dx, 48
	mov ah, 02h
	int 21h
	;sub dx, 48
	
	pop ax
	pop dx
	pop cx
endm


displaySmallValue macro p1
	push cx
	push dx
	push ax
	
	mov dl, p1
	add dl, 48
	mov ah, 02h
	int 21h
	;sub dl, 48
	
	pop ax
	pop dx
	pop cx
endm

getMatrixIndex macro i, j

	;displayThis j
	
	;displayThis -16
	
	mov cx, 0
	mov ax, j
	mov cx, 6
	mul cx ; got (j*6)
	
	;displayThis ax
	;displayThis -16
	
	add ax, i ; (j*6) + i
	
	;mov ax, cx
	
endm

blankScreen macro 
	mov ah,0
	mov al,13h
	int 10h
endm

.model small
.stack 0100h
.386
.data
	
	; constants
	gridLineColor = 0Fh ; orange 44h -> yellow
	startingPtX = 15
	startingPtY = 15
	boxSize = 24
	numberOfBoxes = 7
	numberOfLines = 8
	gridSize = 175
	
	squareCandyColor = 44h
	
	LoliPopColor1 = 0Eh ; yellow
	LoliPopColor2 = 0Ch ; red
	
	LoliPopColor3 = 05h
	LoliPopColor4 = 0Eh
	
	CandyColor = 42h
	
	pinkColor = 0Dh
	yellowColor = 0Eh
	greenColor = 0Ah
	lightBlueColor = 0Bh
	redColor = 0Ch
	purpleColor = 09h
	brownColor = 06h
	
	
	; Variables
	
	gridMatrix db 49 dup(0) ; 2D array containing each candy
	matrixIteratorX dw 0 ; to navigate the array x
	matrixIteratorY dw 0 ; to navigate the array y
	matrixIteratorMain dw 0; combination of X and Y
	
	; Global
	scoreStr db "Score$", 0
	usernameStr db 20 dup('$')
	enterNameStr db "Enter your name$"
	gameNameStr db "Candy Crush$"
	currentScoreStr db "12$"
	loopCounter dw 0
	generatedNumber db 0
	
	; For candies
	sx dw 0
	sy dw 0

	v dw 0
	h dw 0
	startingX dw 0
	startingY dw 0

	count dw 0
	count2 dw 0
	depth dw 1
	repeatt dw 8
	
.code

	mov ax, @data
	mov ds, ax

	main Proc

		;switching to video mode
		mov ah, 00h
		mov al, 13h
		int 10h
		
		;CALL titleScreen		
		blankScreen
			
		CALL drawGrid
		;CALL makeBombCandy
		CALL makeCandies
		CALL displayString
		
		CALL matrixTraversal

		mov ah, 4ch
		int 21h
	main endP
	
	makeCandies Proc
		mov cx, 7
		mov ax, 30
		mov bx, 16
		mov matrixIteratorX, 0
		mov matrixIteratorY, 0
		.while(cx>0)
			push cx
			mov cx, 7
			.while (cx>0)
				push cx
				
				mov startingX, ax
				mov startingY, bx
				push ax
				push bx
				;CALL makeLolipopCandy
				;CALL makeToffeeCandy
				;CALL makeLoliPop2
				;CALL makeColorFulCandy
				;CALL makeBombCandy
				;CALL makeStickCandy
				CALL selectCandy
				
				push dx
				mov dx, matrixIteratorMain
				;displaySmallValue [gridMatrix+dx]
				pop dx
				
				pop bx
				pop ax
				
				add ax, 25
				inc matrixIteratorX
				
				pop cx
				dec cx
			.endw
			mov matrixIteratorX, 0
			inc matrixIteratorY
			mov ax, 30
			add bx, 25
			pop cx
			dec cx
		.endw
				
		ret
	makeCandies endP
	
	generateRandomNumber Proc	
		
		mov ah, 00h  ; interrupts to get system time        
		int 1AH      ; CX:DX now hold number of clock ticks since midnight      

		mov  ax, dx
		xor  dx, dx
		mov  cx, 5 
		div  cx       ; here dx contains the remainder of the division - from 0 to 9

		mov generatedNumber, dl

		ret
	generateRandomNumber endP
	
	testing Proc
		displaySmallValue -35 
		mov cx, 7
		mov matrixIteratorX, 0
		mov matrixIteratorY, 0
		.while(cx>0)
			push cx
			mov cx, 7
			.while (cx>0)
				push cx
				
				getMatrixIndex matrixIteratorX, matrixIteratorY
		
				mov matrixIteratorMain, ax
				push ax
				displaySmallValue [gridMatrix+dx]
				pop ax
				;push dx
				;mov dx, matrixIteratorMain
				;displaySmallValue [gridMatrix+dx]
				;pop dx
				
				inc matrixIteratorX
				
				pop cx
				dec cx
			.endw
			mov matrixIteratorX, 0
			inc matrixIteratorY
			pop cx
			dec cx
		.endw
	testing endP
	
	matrixTraversal Proc USES cx bx ax
		displaySmallValue -35 
		;mov si, offset gridMatrix
		
		;mov cx, 49
		mov count, 0
		mov matrixIteratorX, 0
		mov matrixIteratorY, 0
		;mov ax, 49
		.while(count<49)
			;push cx
			;displayBigValue cx ;can display current index form here
			;sub cx, 4
			mov bx, count
			displaySmallValue [gridMatrix+bx] ; displaying matix value
			displayBigValue -16 ; display a space ' '
			inc count
			;inc ax

			;pop cx
			;dec cx
		.endw
		ret
	matrixTraversal endP
	
	selectCandy Proc USES cx ax bx
		CALL generateRandomNumber
		
		getMatrixIndex matrixIteratorX, matrixIteratorY
		
		mov matrixIteratorMain, ax
		
		mov bl, generatedNumber
		mov [gridMatrix+ax], bl
		
		mov cx,65500
		.while cx>0
		dec cx
		.endw
		
		mov cx,65500
		.while cx>0
			dec cx
		.endw
		
		.if(generatedNumber == 0)
			CALL makeLolipopCandy
		.elseif(generatedNumber == 1)
			CALL makeColorFulCandy
		.elseif(generatedNumber == 2)
			CALL makeLoliPop2
		.elseif(generatedNumber == 3)
			CALL makeToffeeCandy
		.elseif(generatedNumber == 4)
			CALL makeStickCandy
			;CALL makeBombCandy
		.endif
		
		;displayBigValue ax ; can display current index
		displaySmallValue [gridMatrix+ax] ; displaying each index of the matrix
		displayBigValue -16 ; displays a space ' '
		ret
	selectCandy endP

	drawGrid Proc
		mov cx, 8
		mov ax, 20
		
		drawLineVertical 15, startingPtY, gridSize
		drawLineVertical 40, startingPtY, gridSize
		drawLineVertical 65, startingPtY, gridSize
		drawLineVertical 90, startingPtY, gridSize
		drawLineVertical 115, startingPtY, gridSize
		drawLineVertical 140, startingPtY, gridSize
		drawLineVertical 165, startingPtY, gridSize
		drawLineVertical 190, startingPtY, gridSize
		
		drawLineHorizontal startingPtX, 15, gridSize
		drawLineHorizontal startingPtX, 40, gridSize
		drawLineHorizontal startingPtX, 65, gridSize
		drawLineHorizontal startingPtX, 90, gridSize
		drawLineHorizontal startingPtX, 115, gridSize
		drawLineHorizontal startingPtX, 140, gridSize
		drawLineHorizontal startingPtX, 165, gridSize
		drawLineHorizontal startingPtX, 190, gridSize
		ret
	drawGrid endP
	
	displayString Proc
		mov ah,02h
		mov bx,0
		mov dh,2   ; y-axis
		mov dl,26  ; x-axis
		int 10h

		lea dx, usernameStr   ;Displaying the string
		mov ah,09h 
		int 21h
		
		mov ah,02h
		mov bx,0
		mov dh,4   ; y-axis
		mov dl,26  ; x-axis
		int 10h

		lea dx, scoreStr   ;Displaying the string
		mov ah,09h 
		int 21h
		
		mov ah,02h
		mov bx,0
		mov dh,6   ; y-axis
		mov dl,26  ; x-axis
		int 10h

		lea dx, currentScoreStr   ;Displaying the string
		mov ah,09h 
		int 21h
		ret
	displayString endP
	
	makeBombCandy Proc	USES ax bx cx dx si
		sub startingX, 10
		sub startingY, -4
		
		makeSquare startingX, startingY, 15, redColor
		inc startingX
		inc startingY
		makeSquare startingX, startingY, 13, redColor
		inc startingX
		inc startingY
		
		makeSquare startingX, startingY, 11, lightBlueColor
		inc startingX
		inc startingY
		makeSquare startingX, startingY, 9, lightBlueColor
		inc startingX
		inc startingY
		
		makeSquare startingX, startingY, 7, pinkColor
		inc startingX
		inc startingY
		makeSquare startingX, startingY, 5, pinkColor
		inc startingX
		inc startingY
		
		makeSquare startingX, startingY, 3, purpleColor
		inc startingX
		inc startingY
		makeSquare startingX, startingY, 1, purpleColor		
		ret
	makeBombCandy endP
	
	makeLolipopCandy Proc
		;mov startingX, 21
		;mov startingY, 21

		mov bx,3
		mov ax,0

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 6

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor1
		mov cx, v
		mov dx, h
		int 10h
		dec v
		dec h
		dec count
		.endw

		mov dx, startingX
		sub dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 6

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor1
		mov cx, v
		mov dx, h
		int 10h
		inc v
		dec h
		dec count
		.endw

		mov cx, 9
		mov dx, startingX
		sub dx,7
		mov v, dx; x s
		mov dx,startingY
		 add dx,2
		mov h,dx

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor1
		mov cx, v
		mov dx, h
		int 10h
		inc v
		dec count
		.endw

		mov cx, 9
		mov dx, startingX
		sub dx,7
		mov v, dx; x s
		mov dx,startingY
		 add dx,3
		mov h,dx

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor1
		mov cx, v
		mov dx, h
		int 10h
		inc h
		dec count
		.endw

		mov cx, 11
		mov dx, startingX
		add dx,2
		mov v, dx; x s
		mov dx,startingY
		add dx,12

		mov h,dx
		mov count,cx
		.while(count>0)
		mov ah, 0cH
		mov al, LoliPopColor1 ;0Ah for blue
		mov cx, v
		mov dx, h
		int 10h
		dec h
		dec count
		.endw

		mov cx, 10
		mov dx, startingX
		sub dx,7
		mov v, dx; x s
		mov dx,startingY
		 add dx,12
		mov h,dx

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor1
		mov cx, v
		mov dx, h
		int 10h
		inc v
		dec count
		.endw

		cmp bx,0
		je exitMakePopliPop

		dec bx
		mov dx, startingX
		sub dx,2
		mov v, dx; x s
		mov dx,startingY
		add dx,20
		mov h,dx
		mov cx, 9

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor2
		mov cx, v
		mov dx, h
		int 10h
		dec h
		dec count
		.endw

		mov dx, startingX
		sub dx,3
		mov v, dx; x s
		mov dx,startingY
		add dx,20
		mov h,dx
		mov cx, 9

		mov count,cx
		.while(count>0)
		mov ah, 0CH
		mov al, LoliPopColor2
		mov cx, v
		mov dx, h
		int 10h
		;dec v
		dec h
		dec count
		.endw

		exitMakePopliPop:
		ret
	makeLolipopCandy endP
	
	makeToffeeCandy Proc
		
		add startingY, 7
	
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx, 6

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec count
		.endw

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,7
		mov h,dx
		mov cx, 6

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec count
		.endw

		mov dx, startingX
		add dx,1
		mov v, dx; x s

		mov dx,startingY
		add dx,1
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		mov dx, startingX
		add dx,2
		mov v, dx; x s

		mov dx,startingY
		add dx,2
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		mov dx, startingX
		add dx,2
		mov v, dx; x s

		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		mov dx, startingX
		add dx,1
		mov v, dx; x s

		mov dx,startingY
		add dx,6
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		sub startingX,8

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,3
		mov h,dx
		mov cx, 2

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			inc h
			dec count
		.endw

		mov dx, startingX
		add dx,11
		mov v, dx; x s
		mov dx,startingY
		add dx,3
		mov h,dx
		mov cx, 2

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			inc h
			dec count
		.endw

		add startingX,8

		sub startingX,5
		mov dx, startingX
		sub dx,1
		mov v, dx; x s

		mov dx,startingY
		add dx,1
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		mov dx, startingX
		sub dx,2
		mov v, dx; x s

		mov dx,startingY
		add dx,2
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h


		mov dx, startingX
		sub dx,2
		mov v, dx; x s

		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		mov dx, startingX
		sub dx,1
		mov v, dx; x s

		mov dx,startingY
		add dx,6
		mov h,dx
		mov cx, 6

		mov ah, 0CH
		mov al, CandyColor
		mov cx, v
		mov dx, h
		int 10h

		add startingX,5

		sub startingX,10
		sub startingY,3

		mov dx, startingX
		sub dx,2
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 4

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec h
			dec count
		.endw

		add startingX,10
		add startingY,3

		sub startingX,7
		sub startingY,7

		mov dx, startingX
		sub dx,2
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 4

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw
		add startingX,7
		add startingY,7

		add startingX,4
		add startingY,3

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx, 4

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec h
			dec count
		.endw

		mov dx, startingX
		add dx,3
		mov v, dx; x s
		mov dx,startingY
		add dx,4
		mov h,dx
		mov cx, 4

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		sub startingX,27
		add startingY,7

		add startingX,10
		sub startingY,2

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx, 9

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec h
			dec count
		.endw

		mov dx, startingX
		add dx,21
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx, 9

		mov count, cx
		.while(count>0)
			mov ah, 0CH
			mov al, CandyColor
			mov cx, v
			mov dx, h
			int 10h
			dec h
			dec count
		.endw
		
		ret
	makeToffeeCandy endP
	
	makeLoliPop2 Proc
	
		sub startingX, 4
		add startingY, 6
	
		mov ax,0
		mov cx, 4
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			inc h
			dec count
		.endw

		mov dx, startingX
		add dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			inc h
			dec count
		.endw

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		mov dx, startingX
		sub dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec h
			dec count
		.endw

		cmp bx,0
		mov dx, startingX
		add dx,8
		mov v, dx; x s
		mov dx,startingY
		add dx,12
		mov h,dx
		mov cx, 3

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor4
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		mov dx, startingX
		add dx,7
		mov v, dx; x s
		mov dx,startingY
		add dx,13
		mov h,dx
		mov cx, 3

		je exitLoliPop2
		dec startingX
		dec startingY

		mov ax,0
		mov cx, 4
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			inc h
			dec count
		.endw

		mov dx, startingX
		add dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			inc h
			dec count
		.endw

		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		mov dx, startingX
		sub dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec h
			dec count
		.endw

		cmp bx,0
		mov dx, startingX
		add dx,8
		mov v, dx; x s
		mov dx,startingY
		add dx,12
		mov h,dx
		mov cx, 3

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor4
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		mov dx, startingX
		add dx,7
		mov v, dx; x s
		mov dx,startingY
		add dx,13
		mov h,dx
		mov cx, 3

		dec startingX
		dec startingY

		mov ax,0
		mov cx, 4
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			inc h
			dec count
		.endw

		mov dx, startingX
		add dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			inc h
			dec count
		.endw


		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		add dx,10
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw


		mov dx, startingX
		sub dx,5
		mov v, dx; x s
		mov dx,startingY
		add dx,5
		mov h,dx
		mov cx, 4

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor3
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec h
			dec count
		.endw

		cmp bx,0

		mov dx, startingX
		add dx,8
		mov v, dx; x s
		mov dx,startingY
		add dx,12
		mov h,dx
		mov cx, 3

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, LoliPopColor4
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec h
			dec count
		.endw

		mov dx, startingX
		add dx,7
		mov v, dx; x s
		mov dx,startingY
		add dx,13
		mov h,dx
		mov cx, 3
		
		exitLoliPop2:
		ret
	makeLoliPop2 endP
	
	makeColorFulCandy Proc
	
		add startingY, 14
		
		sub startingY,10
		sub startingX,5

		mov dx,startingX
		mov sx, dx
		mov dx,startingY
		mov sy, dx

		sub startingY,4
		mov cx, 8
		mov depth,10
		mov count2,cx

		.while(count2>0)
			inc startingX
			mov dx, startingX
			sub dx,2
			mov v, dx; x s

			mov dx,startingY
			add dx,16
			mov h,dx
			dec depth
			mov cx,depth
			mov count,cx
			.while(count>0)
				mov ah, 0CH
				mov al, yellowColor
				mov cx, v
				mov dx, h
				int 10h
				dec h
				dec count
			.endw
			dec count2
		.endw

		mov dx,sx
		mov startingX,dx
		mov dx,sy
		mov startingY,dx

		sub startingY,10

		mov dx,startingX
		mov sx, dx
		mov dx,startingY
		mov sy, dx

		add startingX,10
		add startingY,6
		mov cx, 8
		mov depth,10
		mov count2,cx

		.while(count2>0)
			dec startingX
			mov dx, startingX
			sub dx,2
			mov v, dx; x s

			mov dx,startingY
			add dx,16
			mov h,dx
			dec depth
			mov cx,depth
			mov count,cx
			.while(count>0)
				mov ah, 0CH
				mov al, greenColor
				mov cx, v
				mov dx, h
				int 10h
				dec h
				dec count
			.endw
			dec count2
		.endw

		mov dx,sy
		add dx,13
		mov h,dx
		mov dx,sx
		sub dx,1
		mov v,dx
		mov cx,9

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, pinkColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec count
		.endw

		inc sy
		mov dx,sy
		add dx,13
		mov h,dx
		mov dx,sx
		mov v,dx
		mov cx,7

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, pinkColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec count
		.endw


		inc sy
		mov dx,sy
		add dx,13
		mov h,dx
		mov dx,sx
		add dx,1
		mov v,dx
		mov cx,5

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, pinkColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec count
		.endw


		inc sy
		mov dx,sy
		add dx,13
		mov h,dx
		mov dx,sx
		add dx,2
		mov v,dx
		mov cx,3

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, pinkColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec count
		.endw


		inc sy
		mov dx,sy
		add dx,13
		mov h,dx
		mov dx,sx
		add dx,3
		mov v,dx
		mov cx,1

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, pinkColor
			mov cx, v
			mov dx, h
			int 10h
			inc v
			dec count
		.endw

		sub sy,4
		ret
	makeColorFulCandy endP
	
	makeStickCandy Proc
		sub startingX, 4
		add startingY, 19

		mov dx,startingX
		mov sx, dx
		mov dx,startingY
		mov sy, dx

		mov cx, 4
		mov count2,cx
		.while(count2>0)
			inc startingX
			mov dx, startingX
			mov v, dx; x s
			mov dx,startingY
			mov h,dx
			mov cx,15
			mov count,cx
			.while(count>0)
				mov ah, 0CH
				mov al, 0EH
				mov cx, v
				mov dx, h
				int 10h
				dec h
				dec count
			.endw
			dec count2
		.endw

		mov cx,sx
		mov startingX,cx
		mov cx,sy
		mov startingY,cx
		sub startingY,16
		add startingX,4
		inc startingY
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx,8

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, 0EH
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec count
		.endw

		mov cx,sx
		mov startingX,cx
		mov cx,sy
		mov startingY,cx
		sub startingY,17
		add startingX,4
		inc startingY
		mov dx, startingX
		mov v, dx; x s
		mov dx,startingY
		mov h,dx
		mov cx,8

		mov count,cx
		.while(count>0)
			mov ah, 0CH
			mov al, 0EH
			mov cx, v
			mov dx, h
			int 10h
			dec v
			dec count
		.endw


		mov cx,sx
		mov startingX,cx
		mov cx,sy
		mov startingY,cx
		add startingY,3
		inc startingX
		mov cx, 8
		mov count2,cx
		.while(count2>0)
			dec startingY;
			dec startingY
			mov dx, startingX
			mov v, dx; x s
			mov dx,startingY
			mov h,dx
			mov cx,4

			mov count,cx
			.while(count>0)
				mov ah, 0CH
				mov al, 0CH
				mov cx, v
				mov dx, h
				int 10h
				inc v
				dec count
			.endw

			dec count2
		.endw
		
		ret
	makeStickCandy endP
	
	titleScreen Proc
	
		mov ah,02h
		mov bx,0
		mov dh,3  ; y-axis
		mov dl,12  ; x-axis
		int 10h
		
		lea dx, gameNameStr ;Displaying game name
        mov ah,09h 
		int 21h
	
		mov ah,02h
		mov bx,0
		mov dh,10   ; y-axis
		mov dl,12  ; x-axis
		int 10h
		
		lea dx, enterNameStr ;Displaying the Enter Name String
        mov ah,09h 
		int 21h

		mov ah,02h
		mov bx,0
		mov dh,12 
		mov dl,12
		int 10h

		mov si,offset usernameStr
		
		inputname:
			mov ah,01h
			int 21h
			mov [si],al
			inc si
			cmp al,13
		jne inputname
		
		mov ah, 09h
		mov dx, offset usernameStr
		int 21h
				
		ret
	titleScreen endP
end

