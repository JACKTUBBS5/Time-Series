PROC IMPORT OUT= WORK.a 
            DATAFILE= "C:\Documents and Settings\Jack_Tubbs\My Documents
\Baylor_stat_classes\Time_series\Timeseries\Davis_schumway\OIL.DAT" 
            DBMS=DLM REPLACE;
     DELIMITER='00'x; 
     GETNAMES=YES;
     DATAROW=2; 
RUN;
