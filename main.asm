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

drawSquareCandy macro startX, startY
	mov cx, 0
	mov bx, startX
	.while cx <= 16
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, squareCandyColor ; color
		mov cx, bx ;x-cord, x pt remains constant throughout
		mov dx, startY ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
	
	mov cx, 0
	mov bx, startX
	add startY, 16
	.while cx <= 16
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, squareCandyColor ; color
		mov cx, bx ;x-cord, x pt remains constant throughout
		mov dx, startY ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
	
	mov cx, 0
	mov bx, startY
	add startX, 16
	
	.while cx <= 16
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, squareCandyColor ; color
		mov cx, startX ;x-cord, x pt remains constant throughout
		mov dx, bx ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
	
	mov cx, 0
	mov bx, startY
	sub startX, 16
	
	.while cx <= 16
		push cx ; to maintain loop count & use CX
		
		mov ah, 0ch ; shows a pixel
		mov al, squareCandyColor ; color
		mov cx, startX ;x-cord, x pt remains constant throughout
		mov dx, bx ; y-cord
		int 10h
		
		inc bx;
		
		pop cx ; to maintain loop count
		inc cx
	.endw
endm

.model small
.stack 0100h
.386
.data
	
	; constants
	gridLineColor = 42h ; orange 44h -> yellow
	startingPtX = 20
	startingPtY = 20
	boxSize = 20
	numberOfBoxes = 7
	numberOfLines = 8
	gridSize = 154
	
	squareCandyColor = 44h
	
	; variables
	
.code

	mov ax, @data
	mov ds, ax

	main Proc

		;switching to video mode
		mov ah, 00h
		mov al, 13h
		int 10h

		CALL drawGrid
		CALL makeCandies
		

		mov ah, 4ch
		int 21h
	main endP
	
	makeCandies Proc
	
		;drawSquareCandy 22, 22
	
	makeCandies endP

	drawGrid Proc
		;mov ax, startingPtX
		;mov cx, 0
		drawLineVertical 20, startingPtY, gridSize
		drawLineVertical 42, startingPtY, gridSize
		drawLineVertical 64, startingPtY, gridSize
		drawLineVertical 86, startingPtY, gridSize
		drawLineVertical 108, startingPtY, gridSize
		drawLineVertical 130, startingPtY, gridSize
		drawLineVertical 152, startingPtY, gridSize
		drawLineVertical 174, startingPtY, gridSize
		
		drawLineHorizontal startingPtX, 20, gridSize
		drawLineHorizontal startingPtX, 42, gridSize
		drawLineHorizontal startingPtX, 64, gridSize
		drawLineHorizontal startingPtX, 86, gridSize
		drawLineHorizontal startingPtX, 108, gridSize
		drawLineHorizontal startingPtX, 130, gridSize
		drawLineHorizontal startingPtX, 152, gridSize
		drawLineHorizontal startingPtX, 174, gridSize

	drawGrid endP
end



