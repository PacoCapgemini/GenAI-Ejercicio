       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYROLL.
       
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL. 
           SELECT EMPLOYEE-IN
           ASSIGN TO EMPLOYEE
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FS1.

           SELECT PAYROLL-OUT
           ASSIGN TO PAYROLL
           ORGANIZATION IS LINE SEQUENTIAL
           ACCESS MODE IS SEQUENTIAL
           FILE STATUS IS WS-FS2.
       
       DATA DIVISION.
       FILE SECTION.
       FD  EMPLOYEE-IN
           RECORD CONTAINS 272 CHARACTERS.
       01 EMPLOYEE-RECORD.
           COPY EMPS-NO-01.
       
       FD  PAYROLL-OUT 
           RECORD CONTAINS 282 CHARACTERS.
       01 PAYROLL-RECORD.
           COPY EMPS-NO-01.
          05 MONTHLY-SALARY        PIC S9(7)V99 COMP-3.
       
       WORKING-STORAGE SECTION.
       01 WS-VAR.
          05 WS-FS1        PIC 9(02).
          05 WS-FS2        PIC 9(02).
          05 WS-EOF-SW     PIC X(01).
             88 WS-EOF               VALUE 'Y'.
             88 WS-NOT-EOF           VALUE 'N'.       

       01 ANNUAL-SALARY     PIC S9(7)V99 COMP-3.

       PROCEDURE DIVISION.
       
       OPEN-FILES.
           OPEN INPUT EMPLOYEE-IN.
           OPEN OUTPUT PAYROLL-OUT.
       
       READ-EMPLOYEE.
           SET  WS-NOT-EOF      TO  TRUE.
           PERFORM UNTIL WS-EOF
                READ EMPLOYEE-IN 
                         AT END SET WS-EOF TO TRUE
                     NOT AT END
                        MOVE CORRESPONDING EMPLOYEE-RECORD 
                           TO PAYROLL-RECORD
                        COMPUTE MONTHLY-SALARY =
                          EMPLOYEE-SALARY OF PAYROLL-RECORD 
                          / 12 
                        WRITE PAYROLL-RECORD   
                END-READ
           END-PERFORM.
       
       CLOSE-FILES.
           CLOSE EMPLOYEE-IN.
           CLOSE PAYROLL-OUT.
       
           STOP RUN.