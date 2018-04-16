                .MODEL  TINY         
                .CODE    
                .186     
                ORG     100H                               ; ‘-ƒ€€
START           PROC    NEAR                  
                MOV     AX, 03h                                  
                INT     10h        

                cli      

                MOV     AX, 3570h
                INT     21h   
                MOV     WORD PTR OLD_INT70h, BX
                MOV     WORD PTR OLD_INT70h+2, ES

                MOV     AX, 2570h
                MOV     DX, OFFSET INT70h_HANDLER
                INT     21h 


                cli      
                MOV     AL, 0BH                            ; CMOS OBH - “€‚‹™‰ …ƒ‘’ ‚
                OUT     70H, AL                            ; ’ 70H - „…‘ CMOS
                nop      
                MOV     AL,  10000010B                     ;γαβ ­®Άª¨ 0     
                OUT     71H, AL                            ;  ‡€‘€’ €’       

                MOV     AL, 00h
                OUT     70h, AL
                IN      AL, 71h
                ADD     AL, 10
                PUSH    AX  

                MOV     AL, 01h
                OUT     70h, AL

                POP     AX
                OUT     71h, AL   


                MOV     AL, 02h
                OUT     70h, AL
                IN      AL, 71h
                ADD     AL, 10
                PUSH    AX  

                MOV     AL, 03h
                OUT     70h, AL

                POP     AX
                OUT     71h, AL   


                MOV     AL, 04h
                OUT     70h, AL
                IN      AL, 71h
                ADD     AL, 10
                PUSH    AX  

                MOV     AL, 05h
                OUT     70h, AL

                POP     AX
                OUT     71h, AL   


                MOV     AL, 0BH                            ; CMOS OBH - “€‚‹™‰ …ƒ‘’ ‚
                OUT     70H, AL                            ; ’ 70H - „…‘ CMOS
                nop      
                MOV     AL,  00110011B                     ;γαβ ­®Άª¨ 0     
                OUT     71H, AL                            ;  ‡€‘€’ €’

                MOV     AL, 0Ah
                OUT     70h, AL
                NOP      
                MOV     AL, 01100110b
                OUT     71h, AL

                sti      


                MOV     AH, 1 
                INT     21h   

                MOV     AX, 2570h
                MOV     DX, WORD PTR OLD_INT70h+2
                MOV     DS, DX
                MOV     DX, WORD PTR CS:OLD_INT70h
                INT     21h

                ret      

OLD_INT70h      DD      ?

start           ENDP     

INT70H_HANDLER  PROC    FAR
                PUSHA    
                PUSH    ES
                PUSH    DS

                MOV     AL, 'D'
                INT     29h

                POP     DS
                POP     ES
                POPA     
                JMP     CS:OLD_INT70H
INT70H_HANDLER  ENDP     

                end     start