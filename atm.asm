include 'emu8086.inc'
JMP START
   

DATA SEGMENT 
    TOTAL        DW 20

    IDS1         DW 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H
    IDS2         DW 000AH,000BH,000CH,000DH,000EH,000FH,0010H,0011H,0012H,0013H 

    PASSWORDS1   DB 00H,01H,02H,03H,04H,05H,06H,07H,08H,09H
    PASSWORDS2   DB 0AH,0BH,0CH,0DH,0EH,0FH,10H,11H,12H,13H

    DATA1        DB '****** WELCOME *******',0
    DATA2        DB 0DH,0AH,'ENTER YOUR ID: ',0
    DATA3        DB 0DH,0AH,'ENTER YOUR PASSWORD: ',0 
    DATA4        DB 0DH,0AH,'DENIED 0',0  
    DATA5        DB 0DH,0AH,'ALLOWED 1',0 
    DATA6        DB 0DH,0AH,'****** VISIT AGAIN *******',0      

    MSG_WRONG DB 0DH,0AH,'Wrong password! Attempts left: ',0
    MSG_FAIL  DB 0DH,0AH,'No attempts left. Access denied!',0  
    MSG_INVALID DB 0DH,0AH,'Invalid ID! Try again...',0


    IDINPUT      DW ?
    PASSINPUT    DB ?
DATA ENDS


CODE SEGMENT

START:
      MOV AX,DATA
      MOV DS,AX  

DEFINE_SCAN_NUM           
DEFINE_PRINT_STRING 


AGAIN:
      LEA SI,DATA1
      CALL PRINT_STRING

      LEA SI,DATA2
      CALL PRINT_STRING

      MOV SI,-1

      CALL SCAN_NUM
      MOV IDINPUT,CX
      MOV AX,CX
      MOV CX,0 


L1:
      INC CX
      CMP CX,TOTAL
      JE  INVALID_ID

      INC SI          
      MOV DX,SI
      MOV BX,SI
      SHL BX,1         

      CMP IDS1[BX],AX
      JE PASS1

      CMP IDS2[BX],AX
      JE PASS2

      JMP L1


PASS1:
      MOV BL,3             
      MOV DI,SI            

TRY_P1:
      LEA SI,DATA3
      CALL PRINT_STRING

      CALL SCAN_NUM
      MOV AL,CL            

      MOV SI,DI
      CMP PASSWORDS1[SI],AL
      JE DONE              

 
      DEC BL
      JZ PW_FAIL

      LEA SI,MSG_WRONG
      CALL PRINT_STRING

      MOV AL,BL
      ADD AL,'0'
      MOV DL,AL
      MOV AH,02H
      INT 21H

      JMP TRY_P1


PW_FAIL:
      LEA SI,MSG_FAIL
      CALL PRINT_STRING

      LEA SI,DATA6     
      CALL PRINT_STRING

      MOV AH,4CH        
      INT 21H


PASS2:
      MOV BL,3
      MOV DI,SI

TRY_P2:
      LEA SI,DATA3
      CALL PRINT_STRING

      CALL SCAN_NUM
      MOV AL,CL

      MOV SI,DI
      CMP PASSWORDS2[SI],AL
      JE DONE

      DEC BL
      JZ PW_FAIL2

      LEA SI,MSG_WRONG
      CALL PRINT_STRING

      MOV AL,BL
      ADD AL,'0'
      MOV DL,AL
      MOV AH,02H
      INT 21H

      JMP TRY_P2


PW_FAIL2:
      LEA SI,MSG_FAIL
      CALL PRINT_STRING

      LEA SI,DATA6
      CALL PRINT_STRING

      MOV AH,4CH
      INT 21H


ERROR:
      LEA SI,DATA4
      CALL PRINT_STRING

      PRINT 0DH   
      PRINT 0AH    

      JMP AGAIN
 
INVALID_ID:
      LEA SI,MSG_INVALID
      CALL PRINT_STRING

      PRINT 0DH
      PRINT 0AH

      JMP AGAIN


DONE:
      LEA SI,DATA5
      CALL PRINT_STRING

      LEA SI,DATA6
      CALL PRINT_STRING

      MOV AH,4CH
      INT 21H



CODE ENDS
END START
