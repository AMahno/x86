                .model  tiny
                .code    
                ORG     100h                                 
START:                  
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

HELLO           DB      "Hello, $"
WORLD           DB      15, 15 DUP(' '), '$'

                END     START         