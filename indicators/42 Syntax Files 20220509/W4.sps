* Encoding: windows-1252.
* CREATE QUINTILES, CHECK DISTRIBUTIONS AND ASSESS QUALITY.

* Check results.

* Weight by population.
use all.
compute hhmemwt = HH48 * hhweight.
weight by hhmemwt.
variable labels hhmemwt 'Household members weight'.

*	Histograms.
frequencies
  variables=ini1 urb1 rur1 com1 /format=notable
  /ntiles= 5
  /statistics=stddev minimum maximum semean mean median mode skewness seskew kurtosis sekurt
  /histogram  normal
  /order=analysis.
use all.
execute.

frequencies
  variables=ini1 urb1 rur1 com1 /format=notable
  /ntiles= 10
  /statistics=stddev minimum maximum semean mean median mode skewness seskew kurtosis sekurt
  /histogram  normal
  /order=analysis.
use all.
execute.

*Deciles:
*	Create initial (common) quintiles.
use all.
execute.
rank variables=ini1 (a) /ntiles (10) /print=no /ties=mean.

* 	Create urban quintiles.
use all.
filter by urban.
execute.
rank variables=urb1 (a) /ntiles (10) /print=no /ties=mean.

*	Create rural quintiles.
use all.
filter by rural.
execute.
rank variables=rur1 (a) /ntiles (10) /print=no /ties=mean.

*	Create combined quintiles.
use all.
execute.
rank variables=com1 (a) /ntiles (10) /print=no /ties=mean.

delete variables windex10 windex10u windex10r windex5 windex5u windex5r wscore wscoreu  wscorer .
rename variables (nini1 = windexini10) (urb1 = wscoreu) (nurb1 = windex10u) (rur1 = wscorer) (nrur1 = windex10r) (com1 = wscore) (ncom1 = windex10) .

recode windexini10 (1 thru 2 = 1) (3 thru 4 = 2) (5 thru 6 = 3) (7 thru 8 = 4) (9 thru 10 = 5) into windexini5.
recode windex10 (1 thru 2 = 1) (3 thru 4 = 2) (5 thru 6 = 3) (7 thru 8 = 4) (9 thru 10 = 5) into windex5.
recode windex10u (1 thru 2 = 1) (3 thru 4 = 2) (5 thru 6 = 3) (7 thru 8 = 4) (9 thru 10 = 5) into windex5u.
recode windex10r (1 thru 2 = 1) (3 thru 4 = 2) (5 thru 6 = 3) (7 thru 8 = 4) (9 thru 10 = 5) into windex5r. 

variable labels windexini5	"Initial (common) wealth index quintile".
variable labels windex5 	"Wealth index quintile".
variable labels windex5u 	"Urban wealth index quintile".
variable labels windex5r	 "Rural wealth index quintile".
variable labels windex10 	"Wealth index decile".
variable labels windex10u 	"Urban wealth index decile".
variable labels windex10r	 "Rural wealth index decile".

value labels windex10u windex10r windex10 windexini10
	1 '1st decile'    2 '2nd decile'    3 '3rd decile'    4 '4th decile'    5 '5th decile'
	6 '6th decile'    7 '7th decile'    8 '8th decile'    9 '9th decile'    10 '10th decile'.
value labels windex5u windex5r windex5 windexini5
	1 'Poorest' 	2 'Second'	3 'Middle'	4 'Fourth'	5 'Richest'.
formats windex5u windex5r windex5 windexini5 (f1.0).

*Labels in French.
 * variable labels windexini5	"Initial (common) Quintile du bien être".
 * variable labels windex5 	"Quintile du bien être".
 * variable labels windex5u 	"Quintile du bien être en milieu urbain".
 * variable labels windex5r	 "Quintile du bien être en milieu rural ".
 * variable labels windex10 	"Decile du bien être".
 * variable labels windex10u 	"Decile du bien être en milieu urbain".
 * variable labels windex10r	 "Decile du bien être en milieu rural ".
 * value labels windex5u windex5r windex5 windexini5
	1 'Le plus pauvre' 	2 'Second'  3 'Moyen'	4 'Quatrième'	5 'Le plus riche'.
* Distributions of urban-rural and regional populations to wealth quintiles.
ctables	/table (urban + rural + HH7 + national) [c] by windexini5 [c]  [rowpct 'Percent' f4.1 count 'Count' f5.0]
	/titles title = surveyname 
		"Distribution of urban, rural and regional populations to initial (common) wealth quintiles".
ctables	/table (urban + rural + HH7 + national) [c] by windex5 [c]  [rowpct 'Percent' f4.1 count 'Count' f5.0]
	/titles title = surveyname 
		"Distribution of urban, rural and regional populations to combined wealth quintiles".


* Comparison of initial and combined quintiles.
* National.
use all.
crosstabs 	/tables = windexini5 by windex5
	/statistics = kappa.
* Urban.
use all.
filter by urban.
crosstabs 	/tables = windexini5 by windex5
	/statistics = kappa.
* Rural.
use all.
filter by rural.
crosstabs 	/tables = windexini5 by windex5
	/statistics = kappa.

Use all.

* Average scores.
ctables	/table national [c] + HH6 [c] + HH7 [c]
	by (ini1 + wscoreu + wscorer + wscore) [s] [mean, 'Average scores',f7.5]
	/titles title= surveyname
		"Average wealth scores for initial (common), urban, rural and combined indexes - urban-rural areas and regions".

ctables 	/vlabels variables = wscore display = none
	/table hh7 [c] > wscore [s] [mean 'Average wealth score' f7.5 validn 'Count' f5.0]
	by hh6 [c]
	/categories variables = hh6 hh7 total = yes
	/titles title= surveyname
		"Average combined wealth scores for urban and rural areas within regions".

weight off.
weight by hhweight.


* Score heaping analysis.
*	Combined.
sort cases wscore (A).
compute com1heap = 100.
compute com1prev = lag (wscore).
create com1next = lead (wscore,1).
if (wscore = com1prev or wscore = com1next) com1heap=0.
if (HH46 ne 1 or sysmis(wscore)) com1heap=999.
missing values com1heap (999).
execute.

*	Initial.
sort cases ini1 (A).
compute ini1heap = 100.
compute ini1prev = lag (ini1).
create ini1next = lead (ini1,1).
if (ini1 = ini1prev or ini1 = ini1next) ini1heap=0.
if (HH46 ne 1 or sysmis(ini1)) ini1heap=999.
missing values ini1heap (999).
execute.

*	Urban.
sort cases wscoreu (A).
compute urb1heap = 100.
compute urb1prev = lag (wscoreu).
create urb1next = lead (wscoreu,1).
if (wscoreu = urb1prev or wscoreu = urb1next) urb1heap=0.
if (HH46 ne 1 or hh6 ne 1) urb1heap=999.
missing values urb1heap (999).
execute.

*	Rural.
sort cases wscorer (A).
compute rur1heap = 100.
compute rur1prev = lag (wscorer).
create rur1next = lead (wscorer,1).
if (wscorer = rur1prev or wscorer = rur1next) rur1heap=0.
if (HH46 ne 1 or hh6 ne 2) rur1heap=999.
missing values rur1heap (999).
execute.

variable labels
ini1heap	"Initial (common) factor scores"
urb1heap	"Urban factor scores"
rur1heap	"Rural factor scores"
com1heap	"Combined factor scores".

ctables 	/table (ini1heap + urb1heap + rur1heap + com1heap)  [s] [mean 'Percentage' f6.2 validn 'Count' f5.0]
	/titles title= surveyname
		"Percentage of households with unique factor scores".

* Summary statistics of variables by initial and combined wealth quintiles.
wqmeans1 	persroom @.
wqmeans1 	hc4@11 + hc4@12 + hc4@21 + hc4@22 + hc4@31 + hc4@32 + hc4@33 + hc4@34 + hc4@35 @.
wqmeans1 	hc5@11 + hc5@12 + hc5@13 +hc5@21+ hc5@22 + hc5@23 + hc5@24 + hc5@31 + hc5@32 + 
		hc5@33 + hc5@34 + hc5@35 + hc5@36 @.
wqmeans1 	hc6@11 + hc6@12 + hc6@13 + hc6@21 + hc6@22 +  hc6@23+ hc6@24 + hc6@25 + hc6@26 + 
		hc6@31 + hc6@32 + hc6@33 + hc6@34 + hc6@36 @.
wqmeans1 	hc7a@1 + hc7b@1 + hc7c@1 @.
wqmeans1 	hc8@1 + hc8@2 + hc8@3 @.
wqmeans1 	hc9a@1 + hc9b@1 + hc9c@1 @.
wqmeans1 	hc10a@1 + hc10b@1 + hc10c@1 + hc10d@1 + hc10e@1 + hc10f@1 + hc10g@1 @.
wqmeans1 	hc11@1 + hc12@1 + hc13@1 @.
wqmeans1 	hc16r @.
wqmeans1 	cow0 + cow1 + cow5 + cow10 @.
wqmeans1 	othercattle0 + othercattle1 + othercattle5 + othercattle10 @.
wqmeans1  horse0+  horse1 + horse5+  horse10 @.
wqmeans1 	goat0 + goat1 + goat10 + goat30 @. 
wqmeans1 	sheep0 + sheep1 + sheep10 + sheep30 @. 
wqmeans1 	chicken0 + chicken1 + chicken10 + chicken30 @. 
wqmeans1 	pig0 + pig1 + pig5 + pig10 @. 
wqmeans1 	otheranimal0 + otheranimal1 + otheranimal10 + otheranimal30 @.
wqmeans1 	eu1@01 + eu1@02 + eu1@03 + eu1@04 + eu1@05 + eu1@06 + eu1@07 + eu1@08 + eu1@09 + eu1@97 @.
wqmeans1 	eu1@070101 + eu1@070102 + eu1@070108 + eu1@070201 + eu1@070202 + eu1@070208 + eu1@070801 + eu1@070802 + eu1@070808 @.
wqmeans1 	eu1@080101 + eu1@080102 + eu1@080108 + eu1@080201 + eu1@080202 + eu1@080208 + eu1@080801 + eu1@080802 + eu1@080808 @.
wqmeans1 	eu4@01 + eu4@02 + eu4@03 + eu4@04 + eu4@05 + eu4@06 + eu4@07 + eu4@08 + eu4@09 + 
		eu4@10 + eu4@11 @.
wqmeans1  eu5@1 + eu5@2 + eu5@3 + eu5@4 + eu5@5 @.
wqmeans1  eu6@01 + eu6@02 + eu6@03 + eu6@04 + eu6@05 + eu6@06 + eu6@97 @.
wqmeans1 	eu6@0201+ eu6@0202 + eu6@0208 + eu6@0301+ eu6@0302 + eu6@0308 +eu6@0401+ eu6@0402 + eu6@0408 + 
                                    eu6@0501+ eu6@0502 + eu6@0508 @.
wqmeans1 	eu8@01 + eu8@02 + eu8@03 + eu8@04 + eu8@05 + eu8@06 + eu8@07 + eu8@08 + eu8@09 + 
		eu8@10 + eu8@11 + eu8@12 + eu8@13 + eu8@14 + eu8@15 + eu8@16 @.
wqmeans1 	eu9@01 + eu9@02 + eu9@03 + eu9@04 + eu9@05 + eu9@06 + eu9@07 + eu9@08 + eu9@09 + 
		eu9@10 + eu9@11 + eu9@12 + eu9@13 + eu9@97 @.
wqmeans1 	ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@72 + ws1@81 + ws1@91 + ws1@92 @.
wqmeans1 	watloc@1 + watloc@2 + watloc@3 + watloc@4 + watloc@5 @.
wqmeans1 	ws7@1 + ws7@2 @.
wqmeans1 	ws11@11 + ws11@12 + ws11@13 + ws11@14 + ws11@18 + ws11@21 + ws11@22 + ws11@23 + 
		ws11@31 + ws11@41 + ws11@51 + ws11@95 @.
wqmeans1 	ws14@1 + ws14@2 + ws14@3 @.
wqmeans1 	latshare + lathh1 + lathh2 @.	
wqmeans1 	hw2@1 + soap@1 @.
wqmeans1 	servant @.


* Summary statistics of variables by combined wealth quintiles in urban and rural areas.
wqmeans2 	persroom @.
wqmeans2 	hc4@11 + hc4@12 + hc4@21 + hc4@22 + hc4@31 + hc4@32 + hc4@33 + hc4@34 + hc4@35 @.
wqmeans2 	hc5@11 + hc5@12 + hc5@13 +hc5@21+ hc5@22 + hc5@23 + hc5@24 + hc5@31 + hc5@32 + 
		hc5@33 + hc5@34 + hc5@35 + hc5@36 @.
wqmeans2 	hc6@11 + hc6@12 + hc6@13 + hc6@21 + hc6@22 +  hc6@23+ hc6@24 + hc6@25 + hc6@26 + 
		hc6@31 + hc6@32 + hc6@33 + hc6@34 + hc6@36 @.
wqmeans2 	hc7a@1 + hc7b@1 + hc7c@1 @.
wqmeans2 	hc8@1 + hc8@2 + hc8@3 @.
wqmeans2 	hc9a@1 + hc9b@1 + hc9c@1 @.
wqmeans2 	hc10a@1 + hc10b@1 + hc10c@1 + hc10d@1 + hc10e@1 + hc10f@1 + hc10g@1 @.
wqmeans2 	hc11@1 + hc12@1 + hc13@1 @.
wqmeans2 	hc16r @.
wqmeans2 	cow0 + cow1 + cow5 + cow10 @.
wqmeans2 	othercattle0 + othercattle1 + othercattle5 + othercattle10 @.
wqmeans2  horse0+  horse1 + horse5+  horse10 @.
wqmeans2 	goat0 + goat1 + goat10 + goat30 @. 
wqmeans2 	sheep0 + sheep1 + sheep10 + sheep30 @. 
wqmeans2 	chicken0 + chicken1 + chicken10 + chicken30 @. 
wqmeans2 	pig0 + pig1 + pig5 + pig10 @. 
wqmeans2 	otheranimal0 + otheranimal1 + otheranimal10 + otheranimal30 @.
wqmeans2 	eu1@01 + eu1@02 + eu1@03 + eu1@04 + eu1@05 + eu1@06 + eu1@07 + eu1@08 + eu1@09 + eu1@97 @.
wqmeans2 	eu1@070101 + eu1@070102 + eu1@070108 + eu1@070201 + eu1@070202 + eu1@070208 + eu1@070801 + eu1@070802 + eu1@070808 @.
wqmeans2 	eu1@080101 + eu1@080102 + eu1@080108 + eu1@080201 + eu1@080202 + eu1@080208 + eu1@080801 + eu1@080802 + eu1@080808 @.
wqmeans2 	eu4@01 + eu4@02 + eu4@03 + eu4@04 + eu4@05 + eu4@06 + eu4@07 + eu4@08 + eu4@09 + 
		eu4@10 + eu4@11 @.
wqmeans2  eu5@1 + eu5@2 + eu5@3 + eu5@4 + eu5@5 @.
wqmeans2  eu6@01 + eu6@02 + eu6@03 + eu6@04 + eu6@05 + eu6@06 + eu6@97 @.
wqmeans2 	eu6@0201+ eu6@0202 + eu6@0208 + eu6@0301+ eu6@0302 + eu6@0308 +eu6@0401+ eu6@0402 + eu6@0408 + 
                                    eu6@0501+ eu6@0502 + eu6@0508 @.
wqmeans2 	eu8@01 + eu8@02 + eu8@03 + eu8@04 + eu8@05 + eu8@06 + eu8@07 + eu8@08 + eu8@09 + 
		eu8@10 + eu8@11 + eu8@12 + eu8@13 + eu8@14 + eu8@15 + eu8@16 @.
wqmeans2 	eu9@01 + eu9@02 + eu9@03 + eu9@04 + eu9@05 + eu9@06 + eu9@07 + eu9@08 + eu9@09 + 
		eu9@10 + eu9@11 + eu9@12 + eu9@13 + eu9@97 @.
wqmeans2 	ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@72 + ws1@81 + ws1@91 + ws1@92 @.
wqmeans2 	watloc@1 + watloc@2 + watloc@3 + watloc@4 + watloc@5 @.
wqmeans2 	ws7@1 + ws7@2 @.
wqmeans2 	ws11@11 + ws11@12 + ws11@13 + ws11@14 + ws11@18 + ws11@21 + ws11@22 + ws11@23 + 
		ws11@31 + ws11@41 + ws11@51 + ws11@95 @.
wqmeans2 	ws14@1 + ws14@2 + ws14@3 @.
wqmeans2 	latshare + lathh1 + lathh2 @.	
wqmeans2 	hw2@1 + soap@1 @.
wqmeans2 	servant @.


erase file = "temp.sav".

* 	Create the SPSS output.
output save outfile = "w4.spv".

* 	After reviewing the model make sure to close the output.
output close *.

