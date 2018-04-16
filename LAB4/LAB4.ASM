                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT
TIME_FIELD      DW      0DEADh, 0DEADh, 0DEADh
                DATA_SEG ENDS

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

GET_TIME        PROC    NEAR   

                PUSH    BP    
                MOV     BP, SP

                XOR     DX, DX

                MOV     AH, 2Ah                          
                INT     21h                              

                MOV     SI, 4
                MOV     CX, 3
;WRITE_TO_STACK:         
                ;MOV     [BP+SI], DX
                ;ADD     SI, 2 
                ;LOOP    WRITE_TO_STACK  
    MOV  [BP+2], DX
    MOV     [BP+6], CX
                MOV     [BP+8], AX

                POP     BP            

                RET      
                ENDP     

BEG_:                   
                PUSH    DS        
                XOR     AX, AX    
                PUSH    AX        

                MOV     AX, DATA_SEG                             
                MOV     DS, AX                                   

                MOV     AX, 03h                                  
                INT     10h                                      

                MOV     CX, 3
FILL_STACK:             
                PUSH    0DEADh       
                LOOP    FILL_STACK

                CALL    GET_TIME

                MOV     CX, 3
                XOR     BX, BX
STACK_CYCLE:            
                POP     AX     
                MOV     TIME_FIELD+BX, AX 
                ADD     BX, 2
                LOOP    STACK_CYCLE


                                                           ;POP     AX
                                                           ;MOV     AX, CX                       
                                                           ;XOR     AH, AH         
                                                           ;AAM      
                                                           ;MOV     BX, AX         
                                                           ;OR      BX, 3030h      

                MOV     AH, 2h
                MOV     DL, BH
                INT     21h
                MOV     DL, BL
                INT     21h

                MOV     AH, 08h   
                INT     21h       

                MOV     AH, 4Ch                            
                INT     21h                                

                _TEXT   ENDS                               
                END     BEG_      