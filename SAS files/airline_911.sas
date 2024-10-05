options linesize=75 pagesize=600 center;
title 'Wei Airline Data 1/1995 - 3/2002';
title2 'Intervention Example';
data a; N=_N_;
input volume @@;
datalines;
40878	38746	47103	45282	45961	48561	49883	51443	43480	46651	44712	45068
41689	43390	51410	48335	50856	51317	52778	54377	45403	49473	44585	48935
44850	43133	53305	49461	50856	52925	55366	55868	46826	50216	47190	49134
44705	43742	53050	52255	52692	54702	55841	56546	47356	52024	49461	50483	
45972	45101	55402	53256	53334	56457	59881	58424	49816	54684	52754	50874
46242	48160	58459	55800	57976	60787	62404	61098	51954	56322	54738	52212
49390	47951	58824	56357	56677	59515	61969	62654	34365	43895	44442	45316
42947	42727	53553
;

data c; set a ; Int = (N >= 81); new = 10000*Int + 40000;
*proc print;run;
*proc means;
symbol1 c=red i=join v=star;
symbol2 c=green v=plus;
symbol3 c=blue i=join v=none;
proc gplot; plot volume*N=1 new*N=3 /overlay ;
run;

*Note The following is incomplete you will need to build the model;
proc arima data=c;
/*  Look at the input series oil  */
    i var=volume(1 12) noprint;
/*  Fit the model with b=0 r=0 s=1  */
	i var=volume(1 12) crosscor=(Int(1 12)) noprint  ;
    e  q=(1)(12)    input=( (1  3) Int) noint ;
run;
   
quit;