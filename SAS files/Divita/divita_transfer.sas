options linesize=75 pagesize=600 center;
title 'Divita Data';
title2 'Intervention Example';
data c; set sasuser.divita; N=_N_;new_consumer=consumer*5;run;
*date of interest;
/*
Important Dates in Textile and Apparel Trade

January 1, 1995: The World Trade Organization (WTO) established.
The Agreement on Textiles and Clothing (ATC) replaces the 
Multi-fiber Act (MFA) for the 10- year phase out of quotas. 
Stage 1 of the phase-out begins and quota growth levels increase by 16%.

July 1997: Asian financial crisis was a financial crisis that 
started in Thailand, and affected currencies, stock markets, 
and other asset prices of several Asian countries. As a result, 
the U.S. textile market is flooded with cheap textile imports from Asia.

January 1, 1998: Stage 2; additional products integrated; 
quota growth levels increased by an additional 17%.

Fall 2001: The U.S. was officially declared to be in a 
recession that had begun in of that year. 

September 11, 2001: The terrorist attacks on the World 
Trade Center in New York City further hurt the slowing economy 
by causing a significant reduction in consumer spending. 
In the month of September 2001, U.S. retail sales dropped 2.4% 

December 11, 2001: China is admitted to the WTO.

January 1, 2002: Stage 3; additional products integrated; 
quota growth levels increased by an additional 18%.

February 15, 2002: Despite vocal protests from representatives 
from textile-producing states, the government agreed to allow 
Pakistan to increase its apparel exports to the U.S. by 
11 to 13 percent over each of the next three years as a 
reward for the country's assistance on the war on terror.

January 1, 2005: Full integration of textiles and apparel 
into mainstream trade rules (final elimination of quotas). 
Quota growth levels increased b

*/
*data c; *set a ; *Int = (N >= 130); *new = 2*Int + 22;
*proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot department*N=1 new_consumer*N=3  /overlay ;
run;
proc arima data=c;
/*  Look at the input series oil  */
    i var=department(1,12) noprint;
    e q=(2,12) noint noprint;
/*  Fit the model with b=0 r=0 s=1  */
	i var=consumer(1,12) crosscor=(department(1,12)) noprint ;
    e q=(2,3,9)(12)  input=( (6 ) department) noint noprint ;
	f out=b lead=24 id=n noprint; 
run;
data new;set b;if n >= 200;
symbol1 i=none  v=star; 
   symbol2 i=join  v=circle; 
   symbol3 i=join  v=none l=3; 
   proc gplot data=new; 
      plot consumer * n = 1 forecast * n = 2 
           l95 * n = 3 u95 * n = 3 / 
           overlay; *haxis= '1jan58'd to '1jan62'd by year; 
   run;


   title2 'Autoreg Analysis';
   proc autoreg data=c;
   model consumer = department/dw=4 dwprob nlag=1
method=ml archtest garch=(p=2) maxit=50;run;
   output out=p p=yhat pm=ytrend 
                   lcl=lcl ucl=ucl; 
run;
proc gplot data=p; where n>150;
      plot consumer*n=1 yhat*n=2 
           lcl*n=3 ucl*n=3 / 
           overlay; 
      symbol1 v=star i=none; 
      symbol2 v=circle i=join; 
      symbol3 v=none i=join; 
   run;
