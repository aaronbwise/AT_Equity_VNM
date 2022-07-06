* CREATE QUINTILES, CHECK DISTRIBUTIONS AND ASSESS QUALITY.

* Check results.

* Weight by population.
use all.
compute hhmemwt = hh11 * hhweight.
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

*	Create initial (common) quintiles.
use all.
execute.
rank variables=ini1 (a) /ntiles (5) /print=no /ties=mean.

* 	Create urban quintiles.
use all.
filter by urban.
execute.
rank variables=urb1 (a) /ntiles (5) /print=no /ties=mean.

*	Create rural quintiles.
use all.
filter by rural.
execute.
rank variables=rur1 (a) /ntiles (5) /print=no /ties=mean.

*	Create combined quintiles.
use all.
execute.
rank variables=com1 (a) /ntiles (5) /print=no /ties=mean.

variable labels ncom1 	"Wealth index quintile".
variable labels nurb1 	"Urban wealth index quintile".
variable labels nrur1	 "Rural wealth index quintile".
variable labels nini1		"Initial (common) wealth index quintile".
value labels nurb1 nrur1 ncom1 nini1
	1 'Poorest' 	2 'Second'	3 'Middle'	4 'Fourth'	5 'Richest'.
formats nurb1 nrur1 ncom1 nini1 (f1.0).

* Distributions of urban-rural and regional populations to wealth quintiles.
ctables	/table (urban + rural + HH7 + national) [c] by nini1 [c]  [rowpct 'Percent' f4.1 count 'Count' f5.0]
	/titles title = surveyname 
		"Distribution of urban, rural and regional populations to initial (common) wealth quintiles".
ctables	/table (urban + rural + HH7 + national) [c] by ncom1 [c]  [rowpct 'Percent' f4.1 count 'Count' f5.0]
	/titles title = surveyname 
		"Distribution of urban, rural and regional populations to combined wealth quintiles".


* Comparison of initial and combined quintiles.
* National.
use all.
crosstabs 	/tables = nini1 by ncom1
	/statistics = kappa.
* Urban.
use all.
filter by urban.
crosstabs 	/tables = nini1 by ncom1
	/statistics = kappa.
* Rural.
use all.
filter by rural.
crosstabs 	/tables = nini1 by ncom1
	/statistics = kappa.

Use all.

* Average scores.
ctables	/table national [c] + hh6 [c] + HH7 [c]
	by (ini1 + urb1 + rur1 + com1) [s] [mean, 'Average scores',f7.5]
	/titles title= surveyname
		"Average wealth scores for initial (common), urban, rural and combined indexes - urban-rural areas and regions".

ctables 	/vlabels variables = com1 display = none
	/table hh7 [c] > com1 [s] [mean 'Average wealth score' f7.5 validn 'Count' f5.0]
	by hh6 [c]
	/categories variables = hh6 hh7 total = yes
	/titles title= surveyname
		"Average combined wealth scores for urban and rural areas within regions".

weight off.
weight by hhweight.


* Score heaping analysis.
*	Combined.
sort cases com1 (A).
compute com1heap = 100.
compute com1prev = lag (com1).
create com1next = lead (com1,1).
if (com1 = com1prev or com1 = com1next) com1heap=0.
if (hh9 ne 1 or sysmis(com1)) com1heap=999.
missing values com1heap (999).
execute.

*	Initial.
sort cases ini1 (A).
compute ini1heap = 100.
compute ini1prev = lag (ini1).
create ini1next = lead (ini1,1).
if (ini1 = ini1prev or ini1 = ini1next) ini1heap=0.
if (hh9 ne 1 or sysmis(ini1)) ini1heap=999.
missing values ini1heap (999).
execute.

*	Urban.
sort cases urb1 (A).
compute urb1heap = 100.
compute urb1prev = lag (urb1).
create urb1next = lead (urb1,1).
if (urb1 = urb1prev or urb1 = urb1next) urb1heap=0.
if (hh9 ne 1 or hh6 ne 1) urb1heap=999.
missing values urb1heap (999).
execute.

*	Rural.
sort cases rur1 (A).
compute rur1heap = 100.
compute rur1prev = lag (rur1).
create rur1next = lead (rur1,1).
if (rur1 = rur1prev or rur1 = rur1next) rur1heap=0.
if (hh9 ne 1 or hh6 ne 2) rur1heap=999.
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
wqmeans1 persroom @.
wqmeans1 hc3@11 + hc3@12 + hc3@21 + hc3@22 + hc3@31 + hc3@32 + hc3@33 + hc3@34 + hc3@35 +
         hc4@11 + hc4@12 + hc4@13 + hc4@21 + hc4@22 + hc4@23 + hc4@24 + hc4@31 + hc4@32 + 
		hc4@33 + hc4@34 + hc4@35 + hc4@36 + 
         hc5@11 + hc5@12 + hc5@13 + hc5@21 + hc5@22 + hc5@23 + hc5@24 + hc5@25 + hc5@26 +
		hc5@31 + hc5@32 + hc5@33 + hc5@34 + hc5@35 + hc5@36 @.
wqmeans1 hc6@01 + hc6@02 + hc6@03 + hc6@04 + hc6@05 + hc6@06 + hc6@07 + hc6@08 + hc6@09 + 
		hc6@10 + hc6@11 + hc6@95 @.
wqmeans1 hc8a@1 + hc8b@1 + hc8c@1 + hc8d@1 + hc8e@1 + hc8f@1 + 
         hc9a@1 + hc9b@1 + hc9c@1 + hc9d@1 + hc9e@1 + hc9f@1 + hc9g@1 + hc9h@1 @.
wqmeans1 hc10@1 + hc10@2 + hc10@6 @.
wqmeans1	hc12r + 
 cattle0 + cattle1 + cattle5 + cattle10 + 
 horse0 + horse1 + horse5 + horse10 + 
 goat0 + goat1 + goat10 + goat30 + 
 sheep0 + sheep1 + sheep10 + sheep30 + 
 chicken0 + chicken1 + chicken10 + chicken30 +  
 pig0 + pig1 + pig5 + pig10 @. 
wqmeans1 ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@81 + ws1@91 +
         watloc@1 + watloc@2 + watloc@3 + watloc@4 + latshare + lathh1 + lathh2 @.
wqmeans1 ws8@11 + ws8@12 + ws8@13 + ws8@14 + ws8@15 + ws8@21 + ws8@22 + ws8@23 + 
		ws8@31 + ws8@41 + ws8@51 + ws8@95 @.
wqmeans1 hw2@1 + soap@1 + servant + abroad @. 



* Summary statistics of variables by combined wealth quintiles in urban and rural areas.
wqmeans2 persroom @.
wqmeans2 hc3@11 + hc3@12 + hc3@21 + hc3@22 + hc3@31 + hc3@32 + hc3@33 + hc3@34 + hc3@35 +
         hc4@11 + hc4@12 + hc4@13 + hc4@21 + hc4@22 + hc4@23 + hc4@24 + hc4@31 + hc4@32 + 
		hc4@33 + hc4@34 + hc4@35 + hc4@36 + 
         hc5@11 + hc5@12 + hc5@13 + hc5@21 + hc5@22 + hc5@23 + hc5@24 + hc5@25 + hc5@26 +
		hc5@31 + hc5@32 + hc5@33 + hc5@34 + hc5@35 + hc5@36 @.
wqmeans2 hc6@01 + hc6@02 + hc6@03 + hc6@04 + hc6@05 + hc6@06 + hc6@07 + hc6@08 + hc6@09 + 
		hc6@10 + hc6@11 + hc6@95 @.
wqmeans2 hc8a@1 + hc8b@1 + hc8c@1 + hc8d@1 + hc8e@1 + hc8f@1 + 
         hc9a@1 + hc9b@1 + hc9c@1 + hc9d@1 + hc9e@1 + hc9f@1 + hc9g@1 + hc9h@1 @.
wqmeans2 hc10@1 + hc10@2 + hc10@6 @.
wqmeans2	hc12r + 
 cattle0 + cattle1 + cattle5 + cattle10 + 
 horse0 + horse1 + horse5 + horse10 + 
 goat0 + goat1 + goat10 + goat30 + 
 sheep0 + sheep1 + sheep10 + sheep30 + 
 chicken0 + chicken1 + chicken10 + chicken30 +  
 pig0 + pig1 + pig5 + pig10 @. 
wqmeans2 ws1@11 + ws1@12 + ws1@13 + ws1@14 + ws1@21 + ws1@31 + ws1@32 + 
		ws1@41 + ws1@42 + ws1@51 + ws1@61 + ws1@71 + ws1@81 + ws1@91 +
         watloc@1 + watloc@2 + watloc@3 + watloc@4 + latshare + lathh1 + lathh2 @.
wqmeans2 ws8@11 + ws8@12 + ws8@13 + ws8@14 + ws8@15 + ws8@21 + ws8@22 + ws8@23 + 
		ws8@31 + ws8@41 + ws8@51 + ws8@95 @.
wqmeans2 hw2@1 + soap@1 + servant + abroad @. 


erase file = "temp.sav".

* 	Create the SPSS output.
output save outfile = "w4.spv".

* 	After reviewing the model make sure to close the output.
output close *.

