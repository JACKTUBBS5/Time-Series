options linesize=75 center pagesize=500;
title 'Simulated Data Using R';
* write(x,file="arima_out.dat");
* x<-arima.sim(list(order=c(1,1,2), ar=.8, ma=c(1.3,-.5)), n=200);
data a; N=_N_;
infile 'F:\Time Series\arima_out.dat';
input  z @@;run;
/*
data b; N=_N_;
infile 'C:\Documents and Settings\Jack_Tubbs\My Documents\Baylor_stat_classes\Time_series\Timeseries\Wei\z5.dat';
input  z @@;
*proc print data=a;run;
/*proc means;
proc plot; plot z*N='*';*/
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot z*N=1 z*N=3 /overlay ;
run;
proc arima data=a;
    i var=z(1)noprint scan minic esacf stationarity=(adf=(2,5))perror=(1:5);
   e p=1 q=2 noint plot;
run;
/*
proc arima data=b;
    i var=z;
    e p=2 q=1 plot noint;
run;

*z3<-arima.sim(list(order=c(2,1,1), ar=c(1,-.5), ma=.4), n=200);
*z2<-arima.sim(list(order=c(2,0,1), ar=c(1,-.5), ma=.4), n=200);

*/
proc statespace data=a out=out lead=10; 
      var z(1); 
      id n; 
   run;
 proc gplot data=out; 
      plot for1*n=1  z*n=2  / 
           overlay; 
      symbol1 v=circle i=join; 
      symbol2 v=star i=none; 
      where n > 150; 
   run;
