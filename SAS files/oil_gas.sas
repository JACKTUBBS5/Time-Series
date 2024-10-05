options linesize=75 pagesize=600 center;
title 'Shumway Oil and Gas Price Data';
data a; set sasuser.oil;N=_N_;l_oil = log(oil);run;
proc print; run;

data b; set sasuser.gas; N=_N_;l_gas=log(gas);run;
proc print; run;
data c; merge a b; by N;

*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green i=join v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot l_oil*N=1 l_gas*N=2 /overlay;
run;
/*
data b;set c;run;

* Fit Box-Cox model, output results to output data sets; 

ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=a; 
model boxcox(gas / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=trans; 
run; 


proc print noobs label data=b(drop=rmse); 
title2 'Confidence Interval'; 
where ci ne ' ' or abs(lambda - round(lambda, 0.5)) < 1e-6; 
label convenient = '00'x ci = '00'x; 
run;

* Store values for reference lines; 

data _null_; 
set d; 
if description = 'CI Limit' 
then call symput('vref', formattedvalue); 
if description = 'Lambda Used' 
then call symput('lambda', formattedvalue); 
run; 


data _null_; 
set b end=eof; 
where ci ne ' '; 
if _n_ = 1 
then call symput('href1', compress(put(lambda, best12.))); 
if ci = '<' 
then call symput('href2', compress(put(lambda, best12.))); 
if eof 
then call symput('href3', compress(put(lambda, best12.))); 
run;

* Plot log likelihood, confidence interval; 
axis1 label=(angle=90 rotate=0) minor=none; 
axis2 minor=none; 

proc gplot data=b; 
title2 'Log Likelihood'; 
plot loglike * lambda / vref=&vref href=&href1 &href2 &href3 
vaxis=axis1 haxis=axis2 frame cframe=ligr; 
footnote "Confidence Interval: &href1 - &href2 - &href3, " 
"Lambda = &lambda"; 
symbol v=none i=spline c=blue; 
run; 

footnote; 
title2 'RMSE'; 
plot rmse * lambda / vaxis=axis1 haxis=axis2 frame cframe=ligr; 
run; 

title2 'R-Square'; 
plot rsquare * lambda / vaxis=axis1 haxis=axis2 frame cframe=ligr; 
axis1 order=(0 to 1 by 0.1) label=(angle=90 rotate=0) minor=none; 
run; quit;
*/
proc arima data=c;
/*  Look at the input series oil  */
    i var=l_oil(1) noprint;
/*  Fit a model to the input series oil  */
    e   p=(1 4) q=(6) noint noprint;
/*  Crosscorrelation of prewhitened series  */
    i var=l_gas(1) crosscor=(l_oil(1)) noprint ;
/*  Fit the model with b=0 r=0 s=1  */
    e     q=(1  5) input=(  l_oil) noint noprint;
    f    lead=10 back=5  id=N out=out1;
    f    lead=5 id=N out=out2;
	run;
proc gplot data=out1; where n > 150;
   plot l_gas*n=1 forecast*n=2/overlay;
   run;
proc gplot data=out2; where n > 150;
   plot l_gas*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;
run;
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
