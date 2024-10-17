options linesize=75 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'WEI House starts_sales example';

symbol1 i=none color=red v=star ;
symbol2 i=join v=none color=blue;
symbol3 i=join color=green v=none;

data a; t=_N_;
infile  "/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series/airtrav.dat";
input  z @@;
run;

* graph of the data;
proc sgplot data=a;
scatter y=z x=t;
series y=z x=t;
run;

proc transreg data=a ; 
title2 'Defaults no graphs'; 
model boxcox(z) = identity(t); 
run;

data b;set a;run;
* Fit Box-Cox model, output results to output data sets; 
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=a; 
model boxcox(z / convenient lambda=-2 to 2 by 0.01) = identity(t); 
output out=trans; 
run; 

* graph of transformed data;
proc sgplot data=trans;
scatter y=tz x=t;
series y=tz x=t;
run;


data a; set a; lz=log(z);*id=_N_;run;
proc arima data=a;;
    i var=lz(1,12);
    e q=(1)(12) noint method=ml; *this line seems to reproduce Splus output;
    f back=12 lead=24 id=t out=out1;
	run;

title2 'Forecast Plots';
proc gplot data=out1;
     plot forecast*t=2 lz*t=1 /overlay;
run;
