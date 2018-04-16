                .MODEL  TINY         
                .CODE    
                .186     
                ORG     100H                               ; ???-?????????
START           PROC    NEAR                  
                MOV     AX, 03h                                  
                INT     10h    

                MOV     AL, 0Ah
                OUT     70h, AL
                IN      AL, 71h 
                AND     AL, 11110110B
                OUT     71h, AL      


                MOV     AL, 0BH                            ; CMOS OBH - ??????????? ??????? ?
                OUT     70H, AL                            ; ???? 70H - ?????? CMOS
                IN      AL, 71H                            ; ???? 71H - ?????? CMOS
                AND     AL,  00111011B                     ;????????? 0     
                OR      AL,  01100010B                     ;????????? 1    
                OUT     71H, AL                            ; ? ???????? ???????

                MOV     AL, 01h      
                OUT     70h, AL   
                IN      AL, 71h                            
                OR     AL, 0Fh    
                OUT     71h, AL   

                MOV     AL, 01h      
                OUT     70h, AL
    MOV AL, 0Eh
                IN      AL, 71h

                
start           ENDP     
                end     start