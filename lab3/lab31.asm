                STACK_SEG SEGMENT PARA STACK 'STACK'       
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT                               
INPUT           DB      15, 15 DUP(' ')
OUTPUT          DB      16 DUP('*')
                DATA_SEG ENDS                                  

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

BEG_:                   
                MOV     AX, DATA_SEG                             
                MOV     DS, AX
                MOV     ES, AX

                MOV     AX, 03h                                  
                INT     10h                                      

                LEA     DX, INPUT 
                MOV     AH, 0Ah                              
                INT     21h          

                XOR     BX, BX                             ;replace dollar         
                MOV     BL, INPUT[1]                               
                MOV     INPUT[BX+2], '$'     

                                                           ;MOV     INPUT[0], '$'
                XOR     CX, CX    
                MOV     CL, INPUT[1]
                ADD     CL, 2
                STD      
                LEA     DI, OUTPUT  
                LEA     SI, INPUT   
                ADD     DI, CX      
                ADD     SI, CX      
                REP     MOVSB       

                LEA     DX, OUTPUT+2 
                MOV     AH, 09h   
                INT     21h  

                MOV     AH, 08h                              
                INT     21h                                  

                MOV     AH, 4Ch                            
                INT     21h                                

                _TEXT   ENDS                               
                END     BEG_                               