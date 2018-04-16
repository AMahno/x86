;���������������� PIC         
;�������� ���������� �� ����������
;������ ����-����� ������� � ���������� ������
;������� ���������� �����������
                stack_s segment para stack 'stack'
                stack_s ends

                data_s  segment 'data'

old_70          dd      0

                data_s  ends
                code_s  segment 'code'

                .386     
main            proc    far    

                assume  cs:code_s, ds:data_s, ss:stack_s
                mov     ax, data_s
                mov     ds, ax 
                mov     es, ax 

                MOV     AX, 03h
                INT     10h    
cli
                MOV     AL, 0BH                            ; CMOS OBH - ����������� ������� �
                OUT     70H, AL 
    nop    ; ���� 70H - ������ CMOS
                IN      AL, 71H                            ; ���� 71H - ������ CMOS
                MOV     AL,  01100011B                     ;  
                OUT     71H, AL                            ; � �������� �������
    nop
sti
                MOV     AL, 01h      
                OUT     70h, AL   
    IN      AL, 71h                            
                MOV     AL, 0h    
                OUT     71h, AL   

                MOV     AL, 03h   
                OUT     70h, AL   
                IN      AL, 71h   
                MOV     AL, 55h  
                OUT     71h, AL   

                MOV     AL, 05h   
                OUT     70h, AL   
                IN      AL, 71h                            
                MOV     AL, 10h   
                OUT     71h, AL 

;-----����������� ������� ����������� Int 70h
                mov     ax, 3570h
                int     21h
                mov     word ptr old_70, bx
                mov     word ptr old_70 + 2, es

;------��������� ������ �����������
                cli                                        ;������������ ����������

                mov     ax, 2570h
                mov     dx, seg kb_int
                mov     ds, dx
                mov     dx, offset kb_int
                int     21h
                sti                                        ;���������� ����������

int_wait:                                                  ;������������ ("�������� ����������")
                                                           ; ����� ���� ���� 
                cmp     dh, 1                              ;esc ?
                                                           ;�� - �����
                jnz     int_wait



;------�������������� ������� �����������
exit:                   
                mov     ax, 2570h
                mov     dx, word ptr old_70 +2
                mov     ds, dx
                mov     dx, word ptr old_70
                int     21h

;-----�����
                mov     ax, 4c00h
                int     21h

main            endp     


kb_int          proc     

;���������� � dh ���� ��� ������� ��� ������� �������
; � ������� ��� �� �����
                      
                MOV     DL, 'D'
                MOV     AH, 2
                INT     21h

                      
                mov     al, 20h                            ;EOI
                out     20h, al
    OUT 0AH, AL

                iret     

kb_int          endp     

; ��������� print_al.
; ������� �� ����� ����� � �������� AL � ����������������� �������
; ������������ �������� ��������� AX � DX



code_s ends
END  MAIN