                CODE_SEG SEGMENT 
                ASSUME  CS:CODE_SEG, DS:CODE_SEG, SS:CODE_SEG, ES:CODE_SEG  
                ORG     100h                                 
START_:                 
                JMP     BEG_                                 
HELLO           DB      "Hello, $"                           
WORLD           DB      15, 15 DUP(' '), '$'                 

BEG_:                   
                MOV     AX, 03h                            ; clear screen
                INT     10h                                              

                LEA     DX, WORLD                          ; read input         
                MOV     AH, 0Ah                                          
                INT     21h                                  

                XOR     BX, BX                             ; remove CR symbol
                MOV     BL, WORLD[1]                         
                MOV     WORLD[BX+2], '$'                     

                LEA     DX, HELLO                          ; print string
                MOV     AH, 09h                                         
                INT     21h                                             

                LEA     DX, WORLD+2                        ; print input
                INT     21h                                  

                MOV     AH, 08h 
                INT     21h     

                RET           

                CODE_SEG ENDS               
                END     START_          