options linesize=75 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'Min Temp Sales Data';

symbol1 i=none color=red v=star ;
symbol2 i=join v=none color=blue;
symbol3 i=join color=green v=none;

/*data ldata.a; set work.import; run;*/
data a; set ldata.min_temp; t=_n_; min_temp =  min_temp + .01; run;

data a; set a;
where 120 < t < 360;						/* Defines smaller Data set*/;
run;

* graph of the data;
proc sgplot data=a;
scatter y=min_temp x=t;
series y=min_temp x=t;
run;
proc means data=a min max median; run;
proc transreg data=a ; 
title2 'Defaults no graphs'; 
model boxcox(min_temp) = identity(t); 
run;
/*
data b;set a;run;
* Fit Box-Cox model, output results to output data sets; 
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=a; 
model boxcox(min_temp / convenient lambda=-2 to 2 by 0.01) = identity(t); 
output out=trans; 
run; 
*/
data trans; set a; Tmin_temp = min_temp;run;
* graph of transformed data;
proc sgplot data=trans;
scatter y=Tmin_temp x=t;
series y=Tmin_temp x=t;
run;


data c; set trans; keep Tmin_temp t;run;

proc arima data=c;
    i var=Tmin_temp(12) center;
*    i var=Tvol(1,4);
*    i var=lz(1,12);
    e p=1 q=(12) noint method=ml; *this line seems to reproduce Splus output;
    f back=5 lead=100 id=t noprint out=out1;
	run;

proc sgplot data=out1;
*   where t > 20;
   band Upper=u95 Lower=l95 x=t
      / LegendLabel="95% Confidence Limits";
   scatter x=t y=Tmin_temp;
   series x=t y=forecast;
run;

