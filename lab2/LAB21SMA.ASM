                .model  small
                .data        
HELLO           DB      "Hello, $"
WORLD           DB      15, 15 DUP(' '), '$'
                .code    
START:                  
                                                           ;ASSUME  CS:@CODE, SS:@DATA, DS:@DATA, ES:@DATA
                MOV     AX, @data  
                MOV     DS, AX

                MOV     AX, 03h                                  
                INT     10h                                      

                LEA     DX, WORLD
                MOV     AH, 0Ah
                INT     21h  

                XOR     BX, BX
                MOV     BL, WORLD[1]
                MOV     WORLD[BX+2], '$'

                LEA     DX, HELLO
                MOV     AH, 09h
                INT     21h  

                LEA     DX, WORLD+2
                INT     21h       

                MOV     AH, 08h
                INT     21h   

                MOV     AH, 4Ch
                INT     21h   

                END     START  