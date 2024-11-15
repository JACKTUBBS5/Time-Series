options linesize=75 pagesize=600 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'Wei Duke Energy Data';
title2 'Intervention Example';
data a; set ldata.duke_energy; run;
data c; set a ; 
Int = (N >= 130); 			/* Define the breakpoint in the data  */;
new = 2*Int + 22;
/*
proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
*/
proc sgplot; 
scatter y=price x=N;
series y=price x=N;
scatter y=new x=INT;
run;

proc arima data=c;
/*  Look at the input series oil  */
    i var=price;
    i var=price(1);* noprint;
/*  Fit the model with b=0 r=0 s=1  */
	i var=price(1) crosscor=(Int(1)) noprint ;
*    e      input=( (1 2 ) Int) noint ;
    e      input=( (1  ) Int) noint ;
    f back=5 lead=100 id=n noprint out=out1;
	run;
   
proc sgplot data=out1;
 *  where t > 20;
   band Upper=u95 Lower=l95 x=N
      / LegendLabel="95% Confidence Limits";
   scatter x=n y=price;
   series x=n y=forecast;
run;

