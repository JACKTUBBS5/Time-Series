options linesize=75 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'Electric Production Data';

symbol1 i=none color=red v=star ;
symbol2 i=join v=none color=blue;
symbol3 i=join color=green v=none;

/*data ldata.Electric_Production; set work.import;run;*/
data a; set ldata.Electric_production;t =_n_; vol=IPG2211A2N;
keep t date vol;
run;

* graph of the data;
proc sgplot data=a;
scatter y=vol x=t;
series y=vol x=t;
run;

proc transreg data=a ; 
title2 'Defaults no graphs'; 
model boxcox(vol) = identity(t); 
run;

data b;set a;run;
* Fit Box-Cox model, output results to output data sets; 
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=a; 
model boxcox(vol / convenient lambda=-2 to 2 by 0.01) = identity(t); 
output out=trans; 
run; 

* graph of transformed data;
proc sgplot data=trans;
scatter y=Tvol x=t;
series y=Tvol x=t;
run;


data c; set trans; keep Tvol t; 
where t < 150;						/* Defines subset of the data */;
run;

proc arima data=c;
*    i var=Tvol(1);
    i var=Tvol(12) center;
*    i var=lz(1,12);
*    e q=(2,4) noint method=ml; *this line seems to reproduce Splus output;
    e p=1 q=(11,12) noint  method=ml; 

    f back=12 lead=50 id=t out=out1 noprint;
	run;
	
proc sgplot data=out1;
*   where t > 20;
   band Upper=u95 Lower=l95 x=t
      / LegendLabel="95% Confidence Limits";
   scatter x=t y=Tvol;
   series x=t y=forecast;
run;

