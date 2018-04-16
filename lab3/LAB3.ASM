                STACK_SEG SEGMENT PARA STACK 'STACK'
                DB      100 DUP(?)                         
                STACK_SEG ENDS                             

                DATA_SEG SEGMENT                             
INPUT           DB      50, 50 DUP(' '), '$'
                STRING_STATE LABEL BYTE
STREND          DB      0       
STRBEG          DB      1       
                DATA_SEG ENDS                                  

                _TEXT   SEGMENT PARA 'CODE'                ; code segment
                ASSUME  CS:_TEXT, SS:STACK_SEG, DS:DATA_SEG, ES:DATA_SEG

BEG_:                   
                MOV     AX, DATA_SEG                             
                MOV     DS, AX                                   

                MOV     AX, 03h                            ;clear screen                                 
                INT     10h                                      

                LEA     DX, INPUT                          ;read input string                           
                MOV     AH, 0Ah                              
                INT     21h                                  

                XOR     BX, BX                             ;replace dollar         
                MOV     BL, INPUT[1]                               
                MOV     INPUT[BX+2], '$'                           

                MOV     DH, 1                              ;move cursor      
                MOV     DL, 0                                                
                MOV     BH, 0                                                
                MOV     AH, 2h                                               
                INT     10h                                                  

                XOR     BX, BX                                               
                XOR     AX, AX                                               
                MOV     BX, 1                              ;start from 1
_PLACE_DEAD:            
                CMP     STREND, 1                          ;if end of string...              
                JE      _PGM_EXIT                          ;leave after priting                 
                PUSH    0DEADh                             ;put stack end mark                  
_WORD_TO_STACK:         
                INC     BX                                 ;...cos of this INC            
                CMP     INPUT[BX], ' '                     ;leave only                   
                JE      _EXIT                              ;when the word ends        
                CMP     INPUT[BX], '$'                                        
                JE      _DOLLAR                                               

                XOR     AX, AX                             ;push new symbol  
                MOV     AL, INPUT[BX]                                        
                PUSH    AX                                                   

                JMP     _WORD_TO_STACK                                               

_DOLLAR:                
                MOV     STREND, 1                                                  

_EXIT:                  
                CMP     STRBEG, 1                                                  
                MOV     STRBEG, 0                                                  
                JE      _STACK_TO_CONSOLE                                          

                MOV     AH, 2                              ;add a space                                             
                MOV     DX, ' '                            ;TODO:                                 
                INT     21h                                ;fix line beg           
_STACK_TO_CONSOLE:       
                MOV     AH, 2                              ;print until                  
                POP     DX                                 ;a mark is hit           

                CMP     DX, 0DEADh                                                 
                JE      _PLACE_DEAD                        ;and push it again               

                INT     21h                                                        

                JMP     _STACK_TO_CONSOLE                                          

_PGM_EXIT:              
                MOV     AH, 08h                            ;wait for a key press               
                INT     21h                                                        

                MOV     AH, 4Ch                            ;and leave              
                INT     21h                                                        

                _TEXT   ENDS                                                       
                END     BEG_                                                       