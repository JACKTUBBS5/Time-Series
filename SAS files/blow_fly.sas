options linesize=75 pagesize=600 center;
title 'Wei Blowfly Data';
title2 'Outlier Example';
data a; N=_N_;
input count @@;
datalines;
1676 3075 3815 4639 4424 2784 5860 5781 4897 3920 3835 3618
3050 3772 3517 3350 3018 2625 2412 2221 2619 3203 2706 2717
2175 1628 2388 3677 3156 4272 3771 4955 5584 3891 3501 4436
4369 3394 3869 2922 1843 2837 4690 5119 5838 5389 4993 4446
4651 4243 4620 4849 3664 3016 2881 3821 4300 4168 5448 5477
8579 7533 6884 4127 5546 6316 6650 6304 4842 4352 3215 2652
2330 3123 3955 4494 4780 5753 5555 5712 4786 4066
;

data c; set a ; Int = (N >= 81); new = 10000*Int + 40000;
*proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot count*N=1;
run;

proc arima data=c;
/*  Look at the input series oil  */
    i var=volume;
/*  Fit the model with b=0 r=0 s=1  */
	i var=volume crosscor=(Int) noprint ;
    e      input=(  Int) noint ;
run;
   
