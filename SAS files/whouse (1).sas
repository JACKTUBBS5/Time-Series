options linesize=75 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';
title 'WEI House starts_sales example';

data sales; set ldata.sales; run;
/*
N=_N_;
input  sales @@;
datalines;
38 44 53 49 54 57 51 58 48 44 42 37
42 43 53 49 49 40 40 36 29 31 26 23
29 32 41 44 49 47 46 47 43 45 34 31
35 43 46 46 43 41 44 47 41 40 32 32
34 40 43 42 43 44 39 40 33 32 31 28
34 29 36 42 43 44 44 48 45 44 40 37
45 49 62 62 58 59 64 62 50 52 50 44
51 56 60 65 64 63 63 72 61 65 51 47
54 58 66 63 64 60 53 52 44 40 36 28
36 42 53 53 55 48 47 43 39 33 30 23
29 33 44 54 56 51 51 53 45 45 44 38
;
run;
data ldata.sales; set sales; run;
run;
*/
data starts; set ldata.starts; run;
/*
N=_N_;
input starts @@;
datalines;
52.1  47.2  82.1 100.9  98.4  97.4  96.5  88.8
 80.9  85.8  72.3  61.2  46.7  50.4  83.2  94.3
 84.7  79.8  69.1  69.3  59.4  53.5  50.2  37.9
 40.2  40.3  66.6  79.8  87.3  87.6  82.3  83.7
 78.2  81.7  69.1  47.0  45.2  55.4  79.3  97.9
 86.8  81.4  86.4  82.5  80.1  85.6  64.8  53.8
 51.3  47.9  71.9  84.9  91.3  82.7  73.5  69.5
 71.5  68.0  55.1  42.8  33.4  41.4  61.9  73.8
 74.8  83.0  75.5  77.3  75.9  79.4  67.4  69.0
 54.9  58.3  91.6 116.0 115.6 116.9 107.7 111.7
102.1 102.9  92.9  80.4  76.2  76.3 111.4 119.8
135.2 131.9 119.1 131.3 120.5 116.9  97.4  73.2
 77.1  73.6 105.1 120.4 131.6 114.8 114.7 106.8
 84.5  86.0  70.5  46.8  43.3  57.6  56.9 102.2
 96.3  99.3  90.7  79.8  73.4  69.5  57.9  41.0
 39.8  39.9  62.5  77.8  92.8  90.3  92.8  90.7
 84.5  93.8  71.6  55.7
;
run;
data ldata.starts; set starts; run;
*/
run;
data c; merge sales starts; by N;

*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green i=join v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot starts*N=1 sales*N=2 /overlay;
run;
data b;set c;run;

* Fit Box-Cox model, output results to output data sets; 
title2 'Check for normality';
title3 'starts';
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=c; 
model boxcox(starts / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=trans; 
run; 
title3 'sales';
ods output boxcox=b details=d; 
ods exclude boxcox; 

proc transreg details data=c; 
model boxcox(sales / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=trans; 
run; 


title2 'Intervention for Starts';
title3 '';
proc arima data=c;
/*  Look at the input series ads  */
    i var=sales(1,12) ;
/*  Fit a model to the input series ads  */
    e   q=(1,12)  noint;
/*  Crosscorrelation of prewhitened series  */
    i var=starts(1,12) crosscor=(sales(1,12)) ;
/*  Fit the model with b=1 r=0 s=0  */
    e    p=1 q=(12) input=(1$  sales) noint;
 *	e    p=1 q=(12) input=(1$ (1) sales) noint;
    f    lead=24 back=12  id=N out=out1;
    f    lead=12 id=N out=out2;
	run;
proc gplot data=out1; where n > 100;
   plot starts*n=1 forecast*n=2/overlay;
   run;
proc gplot data=out2; where n > 100;
   plot starts*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;
run;
