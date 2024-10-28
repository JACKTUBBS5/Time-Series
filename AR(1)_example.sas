libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
options linesize=75 pagesize=600 center;

title 'SAS AR(1) Example';
%let N = 100;
data AR1(keep=t y);
call streaminit(12345);
phi = 0.7;   yLag = 0; eps_lag=0; theta=-.3;
do t = -10 to &N;
   eps = rand("Normal");                       /* variance of 1            */
   y = phi*yLag + eps + theta*eps_lag;         /* expected value of Y is 0 */
   if t>0 then output;
   yLag = y;eps_lag=eps;
end;
run; 

*ods graphics on;
proc arima data=AR1;* plots=all; *plots(unpack only)=(series(corr));
   identify var=y nlag=20;                       /* estimate AR1 lag */
   estimate P=1 Q=1;
    f back=5 lead=10 id=t out=out1;
	run;
   
proc sgplot data=out1;
 *  where t > 20;
   band Upper=u95 Lower=l95 x=t
      / LegendLabel="95% Confidence Limits";
   scatter x=t y=y;
   series x=t y=forecast;
run;
