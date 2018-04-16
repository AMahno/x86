                CODE_SEG SEGMENT 
                ASSUME  CS:CODE_SEG, DS:CODE_SEG, SS:CODE_SEG, ES:CODE_SEG  
                ORG     100h                                 
START_:                 
                JMP     BEG_                                              
INPUT           DB      15, 15 DUP('*'), '$'                 

BEG_:                   
                MOV     AX, 03h                            ; clear screen
                INT     10h                                              

                MOV     SI, 80h      
                CMP     BYTE PTR[SI], 0
                JE      EXIT_        

                XOR     CX, CX            
                MOV     CL, BYTE PTR[SI]
                INC     CX              

                LEA     DI, INPUT 
                REP     MOVSB        

                XOR     BX, BX
                MOV     BL, INPUT[0]
                MOV     INPUT[BX+1], '$'

                LEA     DX, INPUT+2                        ; print string
                MOV     AH, 09h                                         
                INT     21h                                                                         

                MOV     AH, 08h      
                INT     21h      
EXIT_:                  
                RET      

                CODE_SEG ENDS               
                END     START_          