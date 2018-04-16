                NAME    TIME_M         
                DATA_SEG SEGMENT
TIME_FIELD      DW      0DEADh, 0DEADh, 0DEADh 
                DATA_SEG ENDS                 

                _TEXT   SEGMENT 'CODE'        
                PUBLIC  TIME                  
                ASSUME  CS:_TEXT, DS:DATA_SEG   
BEG_:                   
TIME            PROC    FAR                   

                MOV     BP, SP                
xor bx, bx

                MOV     AX, [BP+2]
                MOV     TIME_FIELD[bx], AX
                MOV     AX, [BP+6]
                MOV     TIME_FIELD[bx+2], AX
                MOV     AX, [BP+8]
                MOV     TIME_FIELD[bx+4], AX 

                
                RETF  6   
TIME            ENDP     
                _TEXT   ENDS
                END     BEG_    