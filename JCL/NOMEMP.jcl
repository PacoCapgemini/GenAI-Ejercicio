//PAYROLL JOB (383),PAYROLL,CLASS=A,MSGCLASS=X
//**********************************************************************
//*
//* Calculo de la nomina mensual a partir del sueldo anual              
//*
//**********************************************************************
//STEP1     EXEC  PGM=IDCAMS
//SYSPRINT  DD   SYSOUT=*
//SYSIN     DD   *
   DELETE EMPLOYEE.DAT PURGE
   SET MAXCC = 0
/*
//*
//* Lectura de la tabla de empleados de la empresa (COBOL-DB2)                  
//**********************************************************************
//STEP2    EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=A
//EMPLOYEE DD DSN=EMPLOYEE.DAT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=272,BLKSIZE=0)
//SYSTSIN  DD *
  DSN SYSTEM(DB2SSID)
  RUN PROGRAM(RDEMPS) PLAN(RDEMPLN)
  END
/*
//SYSUDUMP DD SYSOUT=A
//*
//* Ordenacion de la lista de empleados por dptmo, area y appellidos
//**********************************************************************
//STEP3    EXEC PGM=SORT
//SYSOUT   DD SYSOUT=A
//SORTIN   DD DSN=EMPLOYEE.DAT,DISP=SHR
//SORTOUT  DD DSN=EMPLOYEE.SORTED,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=272,BLKSIZE=0)
//SORTWK01 DD UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE)
//SORTWK02 DD UNIT=SYSDA,SPACE=(CYL,(1,1),RLSE)
//SYSTDIN  DD *
  SORT FIELDS=(21,5,CH,A,18,2,CH,A,6,150,CH,A)
/*
//*
//* Calculo de la nomina a partir del sueldo anual
//**********************************************************************
//STEP4    EXEC PGM=PAYROLL
//SYSOUT   DD SYSOUT=A
//EMPLOYEE DD DSN=EMPLOYEE.SORTED,DISP=SHR
//PAYROLL  DD DSN=PAYROLL.ALL.MMAAAA,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(1,1),RLSE),
//            DCB=(RECFM=FB,LRECL=278,BLKSIZE=0)
//*
//* Listado de la nomina
//**********************************************************************
//STEP5    EXEC PGM=LISTROLL
//SYSOUT   DD SYSOUT=A
//PAYROLL  DD DSN=PAYROLL.ALL.MMAAAA,DISP=SHR
//*
//* Envio del fichero de nomina a un sistema externo via FTP
//**********************************************************************
//STEP6    EXEC PGM=FTP,REGION=6M
//SYSOUT   DD SYSOUT=A
//NETRC    DD *
  FTPUSER  FTPPASSWORD
  BIN
  CD /destination/path
  PUT PAYROLL.ALL.MMAAAA
  BYE
/*