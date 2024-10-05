options pagesize=600 ls=80 center nodate;
title 'Simulated linear model with autocorrelated errors';
 legend1 position=(bottom left inside)
           across=1 cborder=red offset=(0,0)
           shape=symbol(3,1) label=none
           value=(height=.8);
   symbol1 c=green v=- h=1;
   symbol2 c=red;
   symbol3 c=blue;
   symbol4 c=blue;
data a;
      ul = 0; ull = 0;
      do time = -10 to 36;
         u = + 1.3 * ul - .5 * ull + 2*rannor(12346);
         y = 10 + .5 * time + u;
         if time > 0 then output;
         ull = ul; ul = u;
         end;
   run;
title2 "Autocorrelated Time Series";
   proc gplot data=a;
      symbol1 v=dot i=join;
      symbol2 v=none i=r;
      plot y * time = 1 y * time = 2 / overlay;
   run;


   proc reg data=a;
      model y=time;
 *     plot y*time / cframe=ligr;
      plot rstudent.*obs.;
*           / vref= -1.714 1.714 cvref=blue lvref=1
             HREF=0 to 30 by 5 cHREF=red  cframe=ligr;
   run;

  
   title2 'Prediction Intervals';
  

   proc reg data=a;
      model y=time / noprint;
      plot y*time / pred nostat mse aic bic
           caxis=red ctext=blue cframe=ligr 
           legend=legend1 modellab='         ';
   run;
*ordinary least squares;
   title2 'Ordinary Least Squares';
    proc autoreg data=a;
      model y = time;
   run;
*Autoregressive errors;
   title2 'Autoregressive Error Structure';
    proc autoreg data=a;
      model y = time / nlag=2 method=ml;
   run;
*Predicted Values;
    title2 "Predictions for Autocorrelation Model";
   proc autoreg data=a;
      model y = time / nlag=2 method=ml;
      output out=p p=yhat pm=trendhat;
   run;

   proc gplot data=p;
      symbol1 v=star i=none;
      symbol2 v=circle i=join;
      symbol3 v=none i=join;
      plot y * time = 1 yhat * time = 2
           trendhat * time = 3 / overlay ;
   run;
*Forecasting Autoregressive error Models;
   title2 "Forecasting Autocorrelated Time Series";
   data b;
      y = .;
      do time = 37 to 46; output; end;
   run;
   data b; merge a b; by time; run;

   proc autoreg data=b;
      model y = time / nlag=2 method=ml;
      output out=p p=yhat pm=ytrend
                   lcl=lcl ucl=ucl;
   run;
   proc gplot data=p;
      plot y*time=1 yhat*time=2 ytrend*time=3
           lcl*time=3 ucl*time=3 /
           overlay HREF=36.5;
      where time >= 16;
      symbol1 v=star i=none;
      symbol2 v=circle i=join;
      symbol3 v=none i=join;
   run;
*Testing for Auotregressive Errors;
   title2 'Testing for Autoregressive Errors';
 proc autoreg data=a;
      model y = time/dw=4 dwprob;
   run;