options linesize=75 pagesize=600 center;
libname ldata '/home/jacktubbs/my_shared_file_links/jacktubbs/Example/Time_series';

title 'Wei SunSpot Data';
data a; set ldata.sunspot; run;
title2 'Adjusted count';
/*
data ldata.sunspot; set a; run;
data a; N=_N_;
input count @@;
datalines;
  5     11     16    23    36    58     29    20    10       8 
     3      0      0     2    11    27     47    63    60      39  
    28     26     22    11    21    40     78   122   103      73 
    47     35     11     5    16    34     70    81   111     101 
    73     40     20    16     5    11     22    40    60    80.9
  83.4   47.7   47.8  30.9  12.2   9.6   10.2  32.4   47.6     54 
  62.9   85.9   61.2  45.1  36.4  20.9   11.4  37.8   69.8  106.1 
 100.8   81.6   66.5  34.8  30.6     7   19.8  92.5  154.4  125.9 
  84.8   68.1   38.5  22.8  10.2  24.1   82.9   132  130.9  118.1
  89.9   66.6     60  46.9    41  21.3     16   6.4    4.1    6.8 
  14.5     34     45  43.1  47.5  42.2   28.1  10.1    8.1    2.5
     0    1.4      5  12.2  13.9  35.4   45.8  41.1   30.1   23.9 
  15.6    6.6      4   1.8   8.5  16.6   36.3  49.6   64.2     67  
  70.9   47.8   27.5   8.5  13.2  56.9  121.5 138.3  103.2   85.7  
  64.6   36.7   24.2  10.7    15  40.1   61.5  98.5  124.7   96.3
  66.6   64.5   54.1    39  20.6   6.7    4.3  22.7   54.8   93.8 
  95.8   77.2   59.1    44    47  30.5   16.3   7.3   37.6     74 
   139  111.2  101.6  66.2  44.7    17   11.3  12.4    3.4      6  
  32.3   54.3   59.7  63.7  63.5  52.2   25.4  13.1    6.8    6.3
   7.1   35.6     73  85.1    78    64   41.8  26.2   26.7   12.1
   9.5    2.7      5  24.4    42  63.5   53.8    62   48.5   43.9 
  18.6    5.7    3.6   1.4   9.6  47.4   57.1 103.9   80.6   63.6
  37.6   26.1   14.2   5.8  16.7  44.3   63.9   69    77.8   64.9   
  35.7   21.2   11.1   5.7   8.7  36.1   79.7  114   109.6   88.8
  67.8   47.5   30.6  16.3   9.6  33.2   92.6 151.6  136.3  134.7 
  83.9   69.4   31.5  13.9   4.4  38    141.7 190.2  184.8  159  
 112.3   53.9   37.5  27.9  10.2  15.1   47    93.8  105.9  105.5 
 104.5   66.6   68.9  38    34.5  15.5  12.6   27.5   92.5  155.4
 154.6  140.4  115.9  66.6  45.9  17.9  13.4   29.4  100.2  157.6 
 142.6  145.7   94.3  54.6  29.9  17.5   8.6   21.5   64.3   93.3  
 119.6  111.0 
;
run;
*/
data c; set a ; new_count = count + 2; run;
title2 'Check Normality';

* Fit Box-Cox model, output results to output data sets; 

ods output boxcox=b details=d; 
*ods exclude boxcox; 

proc transreg details data=c; 
model boxcox(new_count / convenient lambda=-2 to 2 by 0.01) = identity(N); 
output out=tran_sun; 
run; 

/*
data c; set c; scount=sqrt(count);run;
*proc print;run;
data sasuser.sunspot; set c;run;
*proc means;
*/
symbol1 c=red i=join v=star;
symbol2 c=green i=join v=plus;
symbol3 c=blue i=join;* v=circle;
proc gplot data=tran_sun; plot Tnew_count*TN=1;
run;
*/;

proc arima data=tran_sun;
/*  Look at the input series oil  */
    i var=Tnew_count(1 11);
    e  p=( 11 ) q=(2 3 5 6 9 10 11) noint ;run;
    
  *  e  p=( 1 3 5 6) q=(2  8 10 11 ) noint noprint;run;
    f    lead=66   id=N noprint out=out1;
    f    lead=110 back=55 id=N noprint out=out2;
run;


proc gplot data=out1; where n > 200;
   plot Tnew_count*n=1 forecast*n=2/overlay;
   run;
proc gplot data=out2; where n > 200;
   plot Tnew_count*n=1 forecast*n=2 l95*n=3 u95*n=3/overlay;
   run;
quit;

/*
proc statespace data=c out=out lead=10 cancorr; 
      var scount(1,11); 
      id n; 
   run;
    proc print data=out;where n > 250;run;
proc gplot data=out; 
      plot   for1*N=2   scount*N=1 / overlay;
where n > 250; 
   run;
   data new; merge out1 out; by n; keep n forecast scount  for1 ;run;
   proc gplot data=new; 
      plot   for2*N=2 forecast*n=3  starts*N=1 / overlay;
where n > 250; 
   run;
   proc print data=new; where n>250;run;
   quit;
