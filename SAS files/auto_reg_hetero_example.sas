options pagesize=600 ls=80 center nodate;
title 'Simulated Heteroscedastic and Autocorrelated Data';
 legend1 position=(bottom left inside)
           across=1 cborder=red offset=(0,0)
           shape=symbol(3,1) label=none
           value=(height=.8);
   title2 'Prediction Intervals';
   symbol1 c=green v=- h=1;
   symbol2 c=red;
   symbol3 c=blue;
   symbol4 c=blue;
data a;
      ul = 0; ull = 0;
      do time = -10 to 120;
         s = 1 + (time >= 60 & time < 90);
         u = + 1.3 * ul - .5 * ull + s*rannor(12346);
         y = 10 + .5 * time + u;
         if time > 0 then output;
         ull = ul; ul = u;
         end;
   run;
   
   title "Heteroscedastic Autocorrelated Time Series";
   proc gplot data=a;
      symbol1 v=dot i=join;
      symbol2 v=none i=r;
      plot y * time = 1 y * time = 2 / overlay;
   run;
 proc autoreg data=a;
      model y = time / nlag=2 archtest dwprob;
      output out=r r=yresid;
   run;
*Heteroscedastic and GARCH Models;
   title2 'Heteroscedastic and GARCH Models';
    proc autoreg data=a;
      model y = time / nlag=2 garch=(q=1,p=1) maxit=50;
      output out=out cev=vhat;
   run;
 data out;
      set out;
      shat = sqrt( vhat );
   run;
   
   title2 "Predicted and Actual Standard Deviations";
   proc gplot data=out;
      plot s*time=1 shat*time=2 / overlay;
      symbol1 v=dot  i=none;
      symbol2 v=none i = join;
   run;

