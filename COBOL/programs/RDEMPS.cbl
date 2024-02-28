       IDENTIFICATION DIVISION.
       PROGRAM-ID. RDEMPS.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
           SELECT EMPLOYEE-OUT
           ASSIGN TO EMPLOYEE
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS ECODE.
       
       DATA DIVISION.
       FILE SECTION.
       FD  EMPLOYEE-OUT
           RECORD CONTAINS 272 CHARACTERS.
       01 EMPLOYEE-OUT-REC PIC X(272).
       
       WORKING-STORAGE SECTION.
       
       01 WS-EOF-INDICATOR PIC X(1) VALUE 'N'.
       
       01 ECODE         PIC X(2).
       
           EXEC SQL
               INCLUDE EMPS-CPY
           END-EXEC.
      
           EXEC SQL 
             INCLUDE SQLCA 
           END-EXEC.        
       
       
       PROCEDURE DIVISION.
       
       OPEN-FILES.
           OPEN OUTPUT EMPLOYEE-OUT
       
           EXEC SQL
               DECLARE EMPLOYEE-CURSOR CURSOR FOR
                   SELECT * FROM EMPLOYEE-TABLE
           END-EXEC
       
           EXEC SQL
               OPEN EMPLOYEE-CURSOR
           END-EXEC
       
           PERFORM READ-EMPLOYEE UNTIL WS-EOF-INDICATOR = 'Y'.
       
       CLOSE-FILES.
           CLOSE EMPLOYEE-OUT.
       
           EXEC SQL
               CLOSE EMPLOYEE-CURSOR
           END-EXEC.
       
           STOP RUN.
       
       READ-EMPLOYEE.
           EXEC SQL
               FETCH EMPLOYEE-CURSOR INTO
                 :EMPLOYEE-ID,
                 :EMPLOYEE-LASTNAME,
                 :EMPLOYEE-FIRSTNAME,
                 :EMPLOYEE-SALARY,
                 :EMPLOYEE-DEPARTMENT,
                 :EMPLOYEE-LEVEL

           END-EXEC.
       
           IF SQLCODE < 0 OR SQLCODE = 100
               MOVE 'Y' TO WS-EOF-INDICATOR
           ELSE
               MOVE 'N' TO WS-EOF-INDICATOR
           END-IF.
       
           IF WS-EOF-INDICATOR = 'N'
               WRITE EMPLOYEE-OUT-REC FROM EMPLOYEE-RECORD 
           END-IF.
       
           EXIT.