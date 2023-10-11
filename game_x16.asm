; TIC-TAC-TOE GAME 
; Written in NASM Assembly For 8086
; BY @zohaibanwer984

section .data
    ; ------------------- Data Section ---------------------
    ; Game UI Components
    board db ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '
    verticalSeparator db 0AH, 0DH, '---+---+---', 0AH, 0DH, '$'
    newline db 0AH, 0DH, '$'
    
    ; Messages and Prompts
    welcomeMessage db 'Welcome to TicTacToe!', 0AH, 0DH, '$'
    promptInput db 'Enter number from 1 to 9 :', '$'
    turnO db 'Player O turns :', 0AH, 0DH, '$'
    turnX db 'Player X turns :', 0AH, 0DH, '$'
    errorOutOfRange db 'Error: Invalid Input!', 0AH, 0DH, '$'
    errorOccupiedCell db 'Error: Not Empty space !', 0AH, 0DH, '$'
    victoryMessage db ' Has Won this Game ! Yay..', 0AH, 0DH, '$'
    drawMessage db 'Oh..It is a Draw..', 0AH, 0DH, '$'
    playAgainPrompt db 'Would You Like to play again ?', 0AH, 0DH, 'Select y or n :', '$'
    farewellMessage db 'Have a good day !...', 0AH, 0DH, 'Written in x16 Assembly by ZAM', '$'

section .text
    ; ------------------- Code Section ---------------------
    org 100H        ; COM file's entry point
    call gameInit   ; Game Initialization

    exit:
        ; Print farewell and return to DOS
        mov ah, 09h
        mov dx, farewellMessage
        int 21h
        mov ax, 4c00h
        int 21h

    ; ------------------- Procedure Definitions ---------------------

    ; Initializes the game and displays the welcome message
    gameInit:
        mov ah, 09h
        mov dx, welcomeMessage
        int 21h
        call mainGameLoop
        ret

    ; Main game loop handling the game process
    mainGameLoop:
        gameRestart:
            mov bh, 'O'  ; Initialize with player 'O'
            mov di, 9    ; Total turns for a game
            call displayBoard

            gameFlowLoop:
                call handlePlayerTurn  ; Handle player turn
                call displayBoard
                call checkWinCondition
                dec di  ; Decrease the number of turns left
            jnz gameFlowLoop
            call displayDrawMessage
            ret

    ; Handle player turn, input and update the board
    handlePlayerTurn:

        ; Check if it's player 'O's turn
        CMP BH, 'O'
        JNZ X_Turn           
        ; Switch to player 'X'
        MOV BH, 'X'     
        ; Point to the message that indicates it's 'X's turn
        MOV SI, turnX   
        JMP continue
        X_Turn: 
        ; If it wasn't 'O's turn, switch to player 'O'
        MOV BH, 'O'     
        ; Point to the message that indicates it's 'O's turn
        MOV SI, turnO   
        continue:
        ; Display the message for the current player's turn
        MOV AH, 09H
        MOV DX, SI         
        INT 21H
        ; Get the chosen cell from the user
        CALL getInputFromUser
        ; Update the board with the current player's move
        MOV [SI], BH        
        ret

    ; Get input from the user and validate it
    getInputFromUser:
        ; Display the input prompt to the user
        MOV AH, 09H
        MOV DX, promptInput   
        INT 21H
        ; Use DOS service to read a single character from the user
        MOV AH, 01H           
        INT 21H               
        ; Print a newline for better formatting
        CALL printNewline
        ; Clearing AH for future operations involving AX
        MOV AH, 0             
        ; Convert the character input into its corresponding integer value
        SUB AL, '0'           
        ; Point SI to the start of the board
        MOV SI, board         
        ; Adjust SI to point to the user-selected location on the board
        ADD SI, AX            
        ; Adjust for 0-based indexing
        DEC SI                
        ; Validate the user input 
        JMP validateInput        
        back:
        CALL printNewline
        ret

    ; Validate user input
    validateInput:
        ; Check if the input is less than '1'
        CMP AL, 1
        JL invalidInput
        ; Check if the input is greater than '9'
        CMP AL, 9
        JG invalidInput
        ; Load the character at the selected tile on the board into AH
        MOV AH, [SI]     
        ; Check if the selected tile on the board is unoccupied
        CMP AH, ' '      
        ; If the tile is occupied, handle the error
        JNZ notempty     
        ; If there are no issues, proceed to the next step
        JMP back         
        ret
    
    ; Code block to handle the error when the chosen cell is already occupied
    notempty:
        ; Set AH for DOS print function
        MOV AH, 09H
        ; Load the appropriate error message address into DX
        MOV DX, errorOccupiedCell  
        ; Print the error message
        INT 21H
        ; Redirect the user to input their choice again
        JMP getInputFromUser    

    ; Code block to handle the error when user input is out of the acceptable range (1-9)
    invalidInput:
        ; Set AH for DOS print function
        MOV AH, 09H
        ; Load the appropriate error message address into DX
        MOV DX, errorOutOfRange  
        ; Print the error message
        INT 21H
        ; Redirect the user to input their choice again
        JMP getInputFromUser   

    ; Display the board
    displayBoard:
        ; Set loop counter for rows
        MOV CH, 3 
        ; Point to the start of the board array
        MOV SI, board 
        rowLoop:
            ; Set loop counter for columns
            MOV CL, 3 
            colLoop:
                ; Print leading space for the cell
                MOV AH, 02H
                MOV DL, ' '
                INT 21H
                ; Print the board value (either 'X', 'O', or ' ')
                MOV DL, [SI]
                INT 21H
                ; Print trailing space for the cell
                MOV DL, ' '
                INT 21H
                ; Move to the next board cell
                INC SI
                ; Check if we're at the end of the column to possibly skip the vertical separator
                CMP CL, 1
                JZ skipVerticalSep
                    MOV DL, '|'
                    INT 21H
                skipVerticalSep:
                    DEC CL
            JNZ colLoop
            ; Check if we're at the bottom row to possibly skip the horizontal separator
            CMP CH, 1
            JZ skipHorizontalSep
                MOV AH, 09H
                MOV DX, verticalSeparator
                INT 21H

            skipHorizontalSep:
                DEC CH
            JNZ rowLoop
        ; Print two newlines for better visual separation
        CALL printNewline
        CALL printNewline
        RET

    ; Procedure to print a newline character for formatting
    printNewline:
        ; Set AH for DOS print function
        MOV AH, 09H
        ; Point DX to the newline string
        MOV DX, newline
        ; Call DOS to print the newline string
        INT 21H
        ; Return from the procedure
        RET

    ; Procedure to check if a win condition has been met on the board
    checkWinCondition:
        ; Check for horizontal win
        MOV SI, board
        MOV BL, 0
        MOV CH, 3
        checkHorizontal:
            MOV CL, 3
            horizontalRowLoop:
                ; If the current cell matches the player's symbol, increment BL
                CMP [SI], BH
                JNZ skip_count_h
                INC BL
                skip_count_h:
                INC SI
                DEC CL
            JNZ horizontalRowLoop
            ; If 3 in a row are found, the game is won
            CMP BL, 3
            JZ gameWon
            MOV BL, 0
            DEC CH
        JNZ checkHorizontal
        ; Check for vertical win
        MOV SI, board
        MOV BL, 0
        checkVertical:
            verticalColLoop:
                CMP [SI], BH
                JNZ skip_count_v
                INC BL
                skip_count_v:
                ADD SI, 3  ; Move SI down one row in the same column
                DEC CH
                CMP CH, 0
                JZ endVerticalLoop
            JMP verticalColLoop
            endVerticalLoop:
            ; If 3 in a column are found, the game is won
            CMP BL, 3
            JZ gameWon
            MOV BL, 0
            ADD SI, -6  ; Reset SI to the top and move one column to the right
            INC CL
            CMP CL, 3
        JNZ checkVertical
        ; Check for diagonal win (from top-left to bottom-right)
        MOV SI, board
        MOV BL, 0
        checkDiagonal1:
            CMP [SI], BH
            JNZ skip_count_d1
            INC BL
            skip_count_d1:
            ADD SI, 4  ; Move SI down one row and one column to the right
            DEC CH
            CMP CH, 0
            JNZ checkDiagonal1
            ; If 3 in a diagonal are found, the game is won
            CMP BL, 3
        JZ gameWon
        ; Check for diagonal win (from top-right to bottom-left)
        MOV SI, board + 2
        MOV BL, 0
        checkDiagonal2:
            CMP [SI], BH
            JNZ skip_count_d2
            INC BL
            skip_count_d2:
            ADD SI, 2  ; Move SI down one row and one column to the left
            DEC CH
            CMP CH, 0
            JNZ checkDiagonal2
            ; If 3 in a diagonal are found, the game is won
            CMP BL, 3
        JZ gameWon
        ; Return if no win condition is met
        ret

    ; Code block to announce the player who won the game
    gameWon:
        ; Display the winning player's symbol ('X' or 'O')
        MOV AH, 02H
        MOV DL, BH
        INT 21H
        ; Display the victory message
        MOV AH, 09H
        MOV DX, victoryMessage
        INT 21H
        ; Prompt the user to play again or exit
        JMP promptPlayAgain
   
    ; Procedure to display the prompt asking the user if they want to play again
    promptPlayAgain:
        ; Display the play again prompt
        MOV AH, 09H
        MOV DX, playAgainPrompt
        INT 21H
        ; Get a single character input from the user
        MOV AH, 01H  
        INT 21H
        ; Print a newline for formatting
        CALL printNewline
        ; Check if the user wants to play again
        CMP AL, 'y'
        JZ resetGameBoard     ; If yes, reset the game board and start over
        ; Check if the user wants to exit
        CMP AL, 'n'
        JZ exit               ; If no, exit the game
        ; If input is neither 'y' nor 'n', display an error message and re-prompt the user
        MOV AH, 09H
        MOV DX, errorOutOfRange
        INT 21H
        JMP promptPlayAgain

    ; Announce game as a draw and ask for a rematch
    displayDrawMessage:
        mov ah, 09h
        mov dx, drawMessage
        int 21h
        call promptPlayAgain
        ret

    ; Procedure to reset the game board for a new game
    resetGameBoard:
        ; Print a newline for formatting
        CALL printNewline
        ; Point SI to the start of the board array
        MOV SI, board
        ; Set the loop counter to 9 (for each cell on the board)
        MOV CX, 9
        ; Set BL to the space character, which represents an empty cell
        MOV BL, ' '
        clearBoardLoop:
            ; Set the current cell to an empty cell
            MOV [SI], BL
            ; Move to the next cell
            INC SI
            ; Decrement the loop counter
            DEC CX
            ; If not all cells are cleared, repeat the loop
        JNZ clearBoardLoop
        ; Restart the game once the board is cleared
        jmp gameRestart