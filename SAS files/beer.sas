options linesize=75 pagesize=600 center;
title 'Wei Quarterly Beer Production Data';
title2 'Outlier Example';
data a; N=_N_;
input beer @@;
datalines;
36.14	44.60	44.15	35.72
36.19	44.63	46.95	36.90
39.66	49.72	44.49	56.54
41.44	49.07	48.98	39.59
44.29	50.09	48.42	41.39
46.11	53.44	53.00	42.52
44.61	55.18	52.24	41.66
47.84	54.27	52.31	42.03
;

data c; set a ; I12 = (N = 12); I27 = (N = 27);
*proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot beer*N=1;
run;

proc arima data=c;
/*  Look at the input series oil  */
    i var=beer(4) noprint ;
/*  Fit the model with b=0 r=0 s=1  */
	i var=beer(4) crosscor=(I12) noprint;
    e  q=(4)    input=((1)  I12) noint ;
run;
   
