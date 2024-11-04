libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
options linesize=75 pagesize=600 center;
title 'Shumway Oil and Gas Price Data';
data oil; set ldata.oil;N=_N_;l_oil = log(oil);run;
*proc print; run;

data gas; set ldata.gas; N=_N_;l_gas=log(gas);run;
*proc print; run;
data c; merge oil gas; by N;

*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green i=join v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot l_oil*N=1 l_gas*N=2 /overlay;
run;

*data b;*set c;run;

* Fit Box-Cox model, output results to output data sets; 

ods output boxcox=b details=d; 
*ods exclude boxcox; 

proc transreg details data=c; 
model boxcox(gas / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=tran_gas; 
run; 

proc transreg details data=c; 
model boxcox(oil / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=tran_oil; 
run; 


title2 'Modeling oil';
proc arima data=c;
/*  Look at the input series oil  */
    i var=l_oil(1);* noprint;
/*  Fit a model to the input series oil  */
    e   p=(1 4) q=(6) noint;* noprint;
*    f    lead=10 back=5  id=N out=out_oil1;
    f    lead=5 id=N out=out_oil2;
run;
/*
proc gplot data=out_oil1; where n > 150;
   plot l_oil*n=1 forecast*n=2/overlay;
   run;
*/
proc gplot data=out_oil2; where n > 150;
   plot l_oil*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;

title2 'Modeling gas without oil';
proc arima data=c;
/*  Look at the input series oil  */
    i var=l_gas(1);* noprint;
/*  Fit a model to the input series oil  */
    e   p=(1 4) q=(6) noint;* noprint;
*   f    lead=10 back=5  id=N out=out_gas1;
    f    lead=5 id=N out=out_gas2;
	run;
/*
proc gplot data=out_gas1; where n > 150;
   plot l_gas*n=1 forecast*n=2/overlay;
   run;
*/   
proc gplot data=out_gas2; where n > 150;
   plot l_gas*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;

title2 'Modeling gas with oil intervention';
proc arima data=c;
/*  Look at the input series oil  */
    i var=l_gas(1);* noprint;
/*  Fit a model to the input series oil  */
 *   e   p=(1 4) q=(6) noint;* noprint;
 *   f    lead=10 back=5  id=N out=out1;
/*  Crosscorrelation of prewhitened series  */
    i var=l_gas(1) crosscor=(l_oil(1));* noprint ;
/*  Fit the model with b=0 r=0 s=1  */
    e     q=(1  5) input=(  l_oil) noint;* noprint;
*   f    lead=10 back=5  id=N out=out_gwo1;
    f    lead=5 id=N out=out_gwo2;
	run;
/*	
proc gplot data=out_gwo1; where n > 150;
   plot l_gas*n=1 forecast*n=2/overlay;
   run;
*/   
proc gplot data=out_gwo2; where n > 150;
   plot l_gas*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;

title2 'StateSpace Modeling gas with oil';
proc statespace data=c out=out lead=10; 
      var l_oil(1) l_gas(1); 
      id n; 
   run;
 proc gplot data=out; 
      plot for1*n=1  l_oil*n=2 for2*n=1  l_gas*n=2  / 
           overlay; 
      symbol1 v=circle i=join; 
      symbol2 v=star i=none; 
      where n > 150; 
   run;
