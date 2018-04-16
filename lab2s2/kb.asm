                .MODEL  TINY         
                .DATA    

                .CODE    
                .186     
                ORG     100H                               ; ???-?????????
START           PROC    NEAR                             
                MOV     AX, 03h                                  
                INT     10h                              

                CLI      
                CALL    WAIT_KBD
                MOV     AL, 0EDh
                OUT     60h, AL
                CALL    WAIT_KBD
                MOV     AL, 00000111b
                OUT     60h, AL
                STI      

WAIT_KBD:               
    MOV CX,2500H ;ЗАДЕРЖКА ПОРЯДКА 10 МСЕК
TEST_KBD:
    IN AL,64H ;ЧИТАЕМ СОСТОЯНИЕ КЛАВИАТУРЫ
    TEST AL,2 ;ПРОВЕРКА БИТА ГОТОВНОСТИ
    LOOPNZ TEST_KBD
    
                MOV     AH, 08h                          
                INT     21h                              
                ret      

start           ENDP     


                end     start                            