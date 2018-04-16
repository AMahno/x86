                .MODEL  TINY
                .data    
hello           DB      "hello"
flag            db      0
                .CODE    
                .186     
                ORG     100h                               ; Ô??-???Ä?????
START           PROC    NEAR                  
                MOV     AX, 03h                                  
                INT     10h      

                MOV     AL, 36h  
                OUT     43h, AL  

                MOV     AX, 65000  
                OUT     40h, AL
                MOV     AL, AH
                OUT     40h, AL

                                                           ;MOV     AL, 00110000b
                                                           ;OUT     43h, AL

                                                           ;MOV     AX, 1193
                                                           ;OUT     42h, AL
                                                           ;MOV     AL, AH
                                                           ;OUT     42h, AL

                MOV     AX, 3508h
                INT     21h   
                MOV     WORD PTR OLD_INT08h, BX
                MOV     WORD PTR OLD_INT08h+2, ES

                MOV     AX, 2508h     
                MOV     DX, OFFSET INT08h_HANDLER
                INT     21h           

                MOV     AH, 1 
                INT     21h   

                MOV     AX, 2508h
                MOV     DX, WORD PTR OLD_INT08h+2
                MOV     DS, DX
                MOV     DX, WORD PTR CS:OLD_INT08h
                INT     21h

                ret      

OLD_INT08h      DD      ?

start           ENDP     

INT08H_HANDLER  PROC    FAR
                PUSHA    
                PUSH    ES
                PUSH    DS   

                CMP     FLAG, '1'
                JE      CLEAR

                mov     ax, 0B800h                         ; segment of video buffer
                mov     es, ax                             ; put this into es
                mov     ah, 3                              ; attribute - cyan
                mov     cx, 5                              ; length of string to print
                mov     si, OFFSET hello                   ; DX:SI points to string
                xor     di, di

Wr_Char:                

                lodsb                                      ; put next character into al 
                mov     es:[di], al                        ; output character to video memory
                inc     di                                 ; move along to next column
                mov     es:[di], ah                        ; output attribute to video memory
                inc     di

                loop    Wr_Char                            ; loop until done

                MOV     FLAG, '1'
                JMP     EXIT

CLEAR:                  
                MOV     AX, 03h                                  
                INT     10h
                MOV     FLAG, '0'

EXIT:                   

                                                           ;MOV     AL, 'D'
                                                           ;INT     29h   

                POP     DS    
                POP     ES    
                POPA     
                JMP     CS:OLD_INT08H
INT08H_HANDLER  ENDP     

                end     start 