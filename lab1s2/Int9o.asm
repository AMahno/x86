;���������������� PIC
;�������� ���������� �� ����������
;������ ����-����� ������� � ���������� ������
;������� ���������� �����������
                stack_s segment para stack 'stack'
                stack_s ends

                data_s  segment 'data'

old_09          dd      0

                data_s  ends
                code_s  segment 'code'

                .386     
main            proc    far

                assume  cs:code_s, ds:data_s, ss:stack_s
                mov     ax, data_s
                mov     ds, ax
 mov  es,ax

 
;-----����������� ������� ����������� Int 09h
 mov ax,3509h
 int 21h
 mov word ptr old_09,bx
 mov word ptr old_09 + 2,es

;------��������� ������ �����������
 cli ;������������ ����������

 mov ax,2509h
 mov dx,seg kb_int
 mov ds,dx
 mov dx,offset kb_int
 int 21h
        sti ;���������� ����������


int_wait:  ;������������ ("�������� ����������")
   ; ����� ���� ���� 
 cmp dh,1 ;esc ?
 ;�� - �����
 jnz int_wait
 


;------�������������� ������� �����������
exit:
 mov ax,2509h
 mov dx,word ptr old_09 +2
 mov ds,dx
 mov dx,word ptr old_09
 int 21h

;-----�����
 mov ax,4c00h
 int 21h

main endp


kb_int proc 
 
;���������� � dh ���� ��� ������� ��� ������� �������
; � ������� ��� �� �����
 cli
 in al,60h ;�������� �������
 mov dh,al
 ;������������� �����
 in al,61h
 or al,080h
 out 61h,al
 and al,7fh
 out 61h,al
        ;����� ����-���� �� �����
        push dx
        mov al,dh
 call print_al
; ������ 
        mov ah,02h
 mov dl,20h
 int 21h
        pop dx
  
 sti
 mov al,20h         ;EOI
 out   20h, al
 
        iret

kb_int endp

; ��������� print_al.
; ������� �� ����� ����� � �������� AL � ����������������� �������
; ������������ �������� ��������� AX � DX


print_al proc
 mov dh,al
 and dh,0Fh  ; DH - ������� 4 ����
 shr al,4  ; AL - �������
 call print_nibble ; ������� ������� �����
 mov al,dh  ; ������ AL �������� ������� 4 ����
print_nibble:  ; ��������� ������ 4 ��� (����������������� �����)
 cmp al,10  ; ��� �������, ����������� ����� � AL
 sbb al,69h  ; � ��������������� ASCII-���
 das   ; (��. �������� ������� DAS)

 mov dl,al  ; ��� ������� � DL
 mov ah,2  ; ����� ������� DOS � AH
 int 21h  ; ����� �������
 ret  ; ���� RET �������� ��� ���� - ���� ��� ��� �������� ��
; ��������� print_nibble, ��������� ��� ������� �����,
; � ������ ��� - ��� �������� �� print_al
print_al endp


code_s ends
END  MAIN