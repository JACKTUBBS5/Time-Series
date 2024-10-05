options center nodate pagesize=100 ls=80;
symbol1 i=none color=red v=star ;
symbol2 i=join v=none color=blue;
symbol3 i=join color=green v=none;
data a; t=_N_;
infile  "F:\Time Series\airtrav_1.txt";
input  z @@;
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










title 'Air Travel Data';
ods listing close;
filename reports 'R:/export/home/jtubbs/public_html/Courses/Timeseries/Wei/airtrav.html';
ods html body=reports (no_bottom_matter) style = D3D;
data a; set a; lz=log(z);run;
ods html close;
filename reports 'R:/export/home/jtubbs/public_html/Courses/Timeseries/Wei/airtrav.html' mod;
ods html body=reports (no_top_matter no_bottom_matter) anchor='arima' style = D3D;
proc arima;
    i var=lz(1,12);
    e q=(1)(12) noint method=ml; *this line seems to reproduce Splus output;
    f back=12 lead=24 id=n out=out1;
	run;
ods html close;
filename reports 'R:/export/home/jtubbs/public_html/Courses/Timeseries/Wei/airtrav.html' mod;
ods html body=reports (no_top_matter) style = D3D;
title2 'Forecast Plots';
proc gplot data=out1;
     plot forecast*n=2 lz*n=1 /overlay;
run;
