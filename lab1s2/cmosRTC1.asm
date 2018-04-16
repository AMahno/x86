;  ����� 2
;  ���뢠��� ���� � �६��� ������� �� ॣ���஢ CMOS
;

                DATAS   segment  'Data'
; ����⮢� ᮮ�饭��
Txt1            DB      "���������� ���� � ������� �� CMOS", 10, 13
                DB      "������� ���� � �����:", '$'
; �������� �������
change          DB      10, 13, "������ ᯮᮡ ��� � �ଠ� �६���"
                DB      10, 13, "0 - bcd&12"
                DB      10, 13, "1 - bcd&24"
                DB      10, 13, "2 - bin&12"
                DB      10, 13, "3 - bin&24"
                DB      10, 13, "<space>- �� ��������"
                DB      10, 13, "Q - Exit", '$'
; ������ ���� � �६���
Date_Time       DB      10, 13, "00.00.0000  00:00:00   ", '$'
; ���祭�� ���� � CMOS
CMOS_Century    DB      ?                                  ; reg 32h
CMOS_Year    DB ?
CMOS_Month   DB ?
CMOS_Day     DB ?
; ���祭�� �६��� � CMOS
CMOS_Hour    DB ?
CMOS_Minute  DB ?
CMOS_Second  DB ?
; ����� � ��᪨ ᯮᮡ� ��� � �ଠ� �६���
BIN_BCD_Flag DB 0
_24_12_Flag  DB 0
AM_PM        DW '  '
MASKA        DB ?
prochod      DB 0
DATAS ENDS

stacks  segment para stack 'STACK'
        DB 20h DUP(?)
stacks ENDS
hour24  equ       2
bin     equ       4

CmosRead          MACRO   MEM
;; AL = regCmos
        out    70h,al
        nop
        in      al,71h
        mov     MEM,al
                  ENDM
                  
schowBcdBinByte   MACRO   date
LOCAL  bcd,bin,ASCII
;; �����⮢��� � �뢮�� al(packetBCD|BIN) => AX(ASCII)
;; STORE ES:DI,DI+1
        xor     ax,ax
        mov     al,date        ;;al=xy
        cmp     BIN_BCD_Flag,1
        je      bin
bcd:
        shl     ax,4
        shr     al,4           ;; ax = 0x0y
        jmp     ASCII

bin:
        aam                    ;; ax = unpack BCD
ASCII:
        or     ax,3030h
        xchg   ah,al
        stosw
        ENDM

Convert macro Hour
LOCAL   _am,_pm,done
        xor     ax,ax
        mov     al,Hour
        cmp _24_12_Flag,1        ;24 mode?
        je  done

        test    al,80h           ;am/pm?
        jz     _am
_pm:                             ; pm = post meridiem (�����㤭�)
        and     al,7Fh          ; clear al.7
        mov     AM_PM,'mp'
        jmp     done
_am:                             ; am = ante meridiem (�� ���㤭�)
        mov     AM_PM,'ma'
done:                         ; al = converted Hour
        mov    Hour,al
        ENDM


CODES  segment 'code'
.386
;*****************************
;* �᭮���� ����� �ணࠬ�� *
;*****************************
        ASSUME SS:STACKS, DS:DATAS, CS:CODES
Start:
        mov     AX,DATAS
        mov     DS,AX
        mov     ES,AX
; ��⠭����� ⥪�⮢� ०�� � ������ �࠭
        mov     AX,3
        int     10h
; �뢥�� ��������� �� �࠭
        lea dx,Txt1
        mov ah,09
        int 21h

 NEXT:
        inc byte ptr prochod      ; ���� ��室
; ������� ���뢠���
        cli
; �஢���� 䫠� ���������� ���ﭨ�
@@TestUIP:
        mov     AL,0Ah    ;ॣ���� ���ﭨ� A
        out     70h,AL
        nop
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;������� ����
; �⥭�� �६��� �� CMOS
        mov     AL,00h    ;ॣ���� ᥪ㭤
        CmosRead   CMOS_Second
        mov     AL,02h    ;ॣ���� �����
        CmosRead   CMOS_Minute
        mov     AL,04h    ;ॣ���� �ᮢ
        CmosRead   CMOS_Hour
; �஢���� 䫠� ���������� ���ﭨ�
        mov     AL,0Ah    ;ॣ���� ���ﭨ� A
        out     70h,AL
        nop
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;������� ����
; �⥭�� ���� �� CMOS
        mov     AL,07h    ;����� ��� �����
        CmosRead   CMOS_Day
        mov     AL,08h    ;����� �����
        CmosRead   CMOS_Month
        mov     AL,09h    ;����� ���� � �⮫�⨨
        CmosRead   CMOS_Year
        mov     AL,32h    ;����� �⮫���
        CmosRead   CMOS_Century
; �஢���� 䫠� ���������� ���ﭨ�
        mov     AL,0Ah    ;ॣ���� ���ﭨ� A
        out     70h,AL
        in      AL,71h
        test    AL,80h
        jnz     @@TestUIP ;������� ����
; ������� ���뢠���
        sti

; ��।����� ᯮᮡ ��� � �ଠ� �।�⠢����� �६���
        mov     al,0Bh
        out     70h,al
        nop
        in      al,71h

;         00000000b
;         ||||||||___ 1-Enable summer time
;         |||||||____ 0-12/1-24 hour format
;         ||||||_____ 0-bcd/1-bin data
;         |||||______ reserved
;         ||||_______ 1-Enable int when updating time
;         |||________ 1-Enable int watchdog
;         ||_________ 1-Enable period int
;         |__________ 1-Enable write time /

        mov       byte ptr _24_12_Flag,0
        mov       byte ptr BIN_BCD_Flag,0
        mov     AM_PM,'  '
        test      al,hour24
        SETNZ     _24_12_Flag           ; �. [�㡪�� �.�., ���.47]
        test      al,bin
        SETNZ     BIN_BCD_Flag


; �����⮢��� � �뢮�� ����  dd.mm.YYYY
        mov     DI,offset Date_Time+2
schowBcdBinByte CMOS_Day
        inc  DI
schowBcdBinByte CMOS_Month
        inc  DI
schowBcdBinByte CMOS_Century
schowBcdBinByte CMOS_Year
        inc  DI
        inc  DI

; �����⮢��� � �뢮�� �६�  hh:mm:ss [am|pm]
convert   CMOS_Hour
schowBcdBinByte CMOS_Hour
        inc  DI
schowBcdBinByte CMOS_Minute
        inc  DI
schowBcdBinByte CMOS_Second
        inc  DI
        mov  ax,AM_PM
        stosw
; �뢮� ᮮ�饭��
        mov  DX, offset Date_Time
        mov  ah,09
        int  21h

; �������� ᯮᮡ ��� � �ଠ� �६���

        cmp byte ptr prochod, 1
        jne  continue
        mov  DX, offset change
        mov  ah,09
        int  21h
continue:
        mov  ah,6
        mov  dl,' '
        int 21h
        mov  ah,01
        int  21h
        cmp  al,'Q'
        je  exit
        cmp al,' '
        je   NEXT
        and al,0fh
        
        irp char,<0,1,2,3>
        cmp  al,char
        jne  L&char
        mov al,char
L&char:
        nop
        endm

        shl al,1
        mov MASKA,al
;; change RTC reg0B
        mov  al,0Bh
        out  70h,al
        in   al,71h
        and  al,11111001b
        or   al,MASKA
        out  71h,al
 more:  jmp NEXT
 exit:

; �����⠭����� ⥪�⮢� ०�� (������ �࠭)
        mov     ax,3
        int     10h
; ��室 � DOS
        mov     AH,4Ch
        int     21h

ENDS

END Start