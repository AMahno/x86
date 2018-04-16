                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT

                DATA_SEG ENDS

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                EXTRN   TIME:FAR
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

BEG_:                   
                MOV     AX, DATA_SEG                             
                MOV     DS, AX                                   

                MOV     AX, 03h                                  
                INT     10h                                      

                MOV     CX, 3

                MOV     AH, 2Ah                          
                INT     21h

                PUSH    AX
                PUSH    CX
                PUSH    DX

                CALL    TIME

                MOV     AH, 08h   
                INT     21h       

                MOV     AH, 4Ch                            
                INT     21h                                

                _TEXT   ENDS                               
                END     BEG_      