       IDENTIFICATION DIVISION.
       PROGRAM-ID. LISTROLL.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
           SELECT PAYROLL-IN
           ASSIGN TO PAYROLL
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FS1.
       
       DATA DIVISION.
       FILE SECTION.
       FD  PAYROLL-IN
           RECORD CONTAINS 282 CHARACTERS.
       01 PAYROLL-RECORD.
           COPY EMPS-NO-01.
          05 MONTHLY-SALARY        PIC S9(7)V99 COMP-3.
       
       WORKING-STORAGE SECTION.

       01 SALARY-DISP PIC Z9(7).99.
       01 DISP-LINE PIC X(250).
       01 WS-VAR.
          05 WS-FS1        PIC 9(02).
          05 WS-EOF-SW     PIC X(01).
             88 WS-EOF               VALUE 'Y'.
             88 WS-NOT-EOF           VALUE 'N'.       

       PROCEDURE DIVISION.
       
       OPEN-FILES.
           OPEN OUTPUT PAYROLL-IN.
       
       READ-EMPLOYEE.
           SET  WS-NOT-EOF      TO  TRUE.
           PERFORM UNTIL WS-EOF
                READ PAYROLL-IN 
                         AT END SET WS-EOF TO TRUE
                     NOT AT END
                       MOVE MONTHLY-SALARY TO SALARY-DISP 
                       STRING EMPLOYEE-DEPARTMENT DELIMITED BY SIZE,
                         SPACE,
                         EMPLOYEE-LEVEL DELIMITED BY SIZE,
                         SPACE,
                         EMPLOYEE-LASTNAME DELIMITED BY SIZE,
                         SPACE,
                         EMPLOYEE-FIRSTNAME DELIMITED BY SIZE,
                         SPACE,
                         SALARY-DISP DELIMITED BY SIZE  
                       INTO DISP-LINE
                       DISPLAY DISP-LINE
                END-READ
           END-PERFORM.
       
       CLOSE-FILES.
           CLOSE PAYROLL-IN.
       
           STOP RUN.