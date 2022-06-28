* Encoding: UTF-8.
* RUN PCAs, REGRESSIONS AND COMPUTE COMBINED WEALTH SCORES.


* National.
define commonvars ()
persroom
hc4@11 hc4@12 hc4@21 hc4@22 hc4@31 hc4@32 hc4@33 hc4@34 hc4@35
hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
hc6@11 hc6@12 hc6@13 hc6@21 hc6@22 hc6@23 hc6@24 hc6@25 hc6@26 hc6@31 hc6@32 hc6@33 hc6@34 hc6@35 hc6@36
hc7a@1 hc7b@1 hc7c@1
hc8@1 hc8@2 hc8@3
hc9a@1 hc9b@1 hc9c@1
hc10a@1 hc10b@1 hc10c@1 hc10d@1 hc10e@1 hc10f@1 hc10g@1
hc11@1 hc12@1 hc13@1
hc16r
hc19@1
eu1@01 eu1@02 eu1@03 eu1@04 eu1@05 eu1@06 eu1@07 eu1@08 eu1@09 eu1@97
eu1@070101 eu1@070102 eu1@070108 eu1@070201 eu1@070202 eu1@070208 eu1@070801 eu1@070802 eu1@070808
eu1@080101 eu1@080102 eu1@080108 eu1@080201 eu1@080202 eu1@080208 eu1@080801 eu1@080802 eu1@080808
eu4@01 eu4@02 eu4@03 eu4@04 eu4@05 eu4@06 eu4@07 eu4@08 eu4@09 eu4@10 eu4@11
eu5@1 eu5@2 eu5@3 eu5@4 eu5@5
eu6@01 eu6@02 eu6@03 eu6@04 eu6@05 eu6@06 eu6@97
eu6@0201 eu6@0202 eu6@0208 eu6@0301 eu6@0302 eu6@0308 eu6@0401 eu6@0402 eu6@0408 eu6@0501 eu6@0502 eu6@0508
eu8@01 eu8@02 eu8@03 eu8@04 eu8@05 eu8@06 eu8@07 eu8@08 eu8@09 eu8@10 eu8@11 eu8@12 eu8@13 eu8@14 eu8@15 eu8@16
eu9@01 eu9@02 eu9@03 eu9@04 eu9@05 eu9@06 eu9@07 eu9@08 eu9@09 eu9@10 eu9@11 eu9@12 eu9@13 eu9@97
ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@72 ws1@81 ws1@91 ws1@92
watloc@1 watloc@2 watloc@3 watloc@4 watloc@5
ws7@1 ws7@2
ws11@11 ws11@12 ws11@13 ws11@14 ws11@18 ws11@21 ws11@22 ws11@23 ws11@31 ws11@41 ws11@51 ws11@95
ws14@1 ws14@2 ws14@3
latshare lathh1 lathh2		
hw2@1 soap@1
servant
!enddefine. 
* Deleted variables with sums less than 2: 
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded:  
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected:
*note: Animal ownership is taken out from national as a standard practice: 
cow0 cow1 cow5 cow10
othercattle0 othercattle1 othercattle5 othercattle10
horse0 horse1 horse5 horse10
goat0 goat1 goat10 goat30 
sheep0 sheep1 sheep10 sheep30 
chicken0 chicken1 chicken10 chicken30 
pig0 pig1 pig5 pig10 
otheranimal0 otheranimal1 otheranimal10 otheranimal30. 
.

* Urban.
define urbanvars ()
persroom
hc4@11 hc4@12 hc4@21 hc4@22 hc4@31 hc4@32 hc4@33 hc4@34 hc4@35
hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
hc6@11 hc6@12 hc6@13 hc6@21 hc6@22 hc6@23 hc6@24 hc6@25 hc6@26 hc6@31 hc6@32 hc6@33 hc6@34 hc6@35 hc6@36
hc7a@1 hc7b@1 hc7c@1
hc8@1 hc8@2 hc8@3
hc9a@1 hc9b@1 hc9c@1
hc10a@1 hc10b@1 hc10c@1 hc10d@1 hc10e@1 hc10f@1 hc10g@1
hc11@1 hc12@1 hc13@1
hc16r
cow0 cow1 cow5 cow10
othercattle0 othercattle1 othercattle5 othercattle10
horse0 horse1 horse5 horse10
goat0 goat1 goat10 goat30 
sheep0 sheep1 sheep10 sheep30 
chicken0 chicken1 chicken10 chicken30 
pig0 pig1 pig5 pig10 
otheranimal0 otheranimal1 otheranimal10 otheranimal30
hc19@1
eu1@01 eu1@02 eu1@03 eu1@04 eu1@05 eu1@06 eu1@07 eu1@08 eu1@09 eu1@97
eu1@070101 eu1@070102 eu1@070108 eu1@070201 eu1@070202 eu1@070208 eu1@070801 eu1@070802 eu1@070808
eu1@080101 eu1@080102 eu1@080108 eu1@080201 eu1@080202 eu1@080208 eu1@080801 eu1@080802 eu1@080808
eu4@01 eu4@02 eu4@03 eu4@04 eu4@05 eu4@06 eu4@07 eu4@08 eu4@09 eu4@10 eu4@11
eu5@1 eu5@2 eu5@3 eu5@4 eu5@5
eu6@01 eu6@02 eu6@03 eu6@04 eu6@05 eu6@06 eu6@97
eu6@0201 eu6@0202 eu6@0208 eu6@0301 eu6@0302 eu6@0308 eu6@0401 eu6@0402 eu6@0408 eu6@0501 eu6@0502 eu6@0508
eu8@01 eu8@02 eu8@03 eu8@04 eu8@05 eu8@06 eu8@07 eu8@08 eu8@09 eu8@10 eu8@11 eu8@12 eu8@13 eu8@14 eu8@15 eu8@16
eu9@01 eu9@02 eu9@03 eu9@04 eu9@05 eu9@06 eu9@07 eu9@08 eu9@09 eu9@10 eu9@11 eu9@12 eu9@13 eu9@97
ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@72 ws1@81 ws1@91 ws1@92
watloc@1 watloc@2 watloc@3 watloc@4 watloc@5
ws7@1 ws7@2
ws11@11 ws11@12 ws11@13 ws11@14 ws11@18 ws11@21 ws11@22 ws11@23 ws11@31 ws11@41 ws11@51 ws11@95
ws14@1 ws14@2 ws14@3
latshare lathh1 lathh2		
hw2@1 soap@1
servant
!enddefine.
* Deleted variables with sums less than 2: 
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded: 
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected:
.

* Rural.
define ruralvars ()
persroom
hc4@11 hc4@12 hc4@21 hc4@22 hc4@31 hc4@32 hc4@33 hc4@34 hc4@35
hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
hc6@11 hc6@12 hc6@13 hc6@21 hc6@22 hc6@23 hc6@24 hc6@25 hc6@26 hc6@31 hc6@32 hc6@33 hc6@34 hc6@35 hc6@36
hc7a@1 hc7b@1 hc7c@1
hc8@1 hc8@2 hc8@3
hc9a@1 hc9b@1 hc9c@1
hc10a@1 hc10b@1 hc10c@1 hc10d@1 hc10e@1 hc10f@1 hc10g@1
hc11@1 hc12@1 hc13@1
hc16r
cow0 cow1 cow5 cow10
othercattle0 othercattle1 othercattle5 othercattle10
horse0 horse1 horse5 horse10
goat0 goat1 goat10 goat30 
sheep0 sheep1 sheep10 sheep30 
chicken0 chicken1 chicken10 chicken30 
pig0 pig1 pig5 pig10 
otheranimal0 otheranimal1 otheranimal10 otheranimal30
hc19@1
eu1@01 eu1@02 eu1@03 eu1@04 eu1@05 eu1@06 eu1@07 eu1@08 eu1@09 eu1@97
eu1@070101 eu1@070102 eu1@070108 eu1@070201 eu1@070202 eu1@070208 eu1@070801 eu1@070802 eu1@070808
eu1@080101 eu1@080102 eu1@080108 eu1@080201 eu1@080202 eu1@080208 eu1@080801 eu1@080802 eu1@080808
eu4@01 eu4@02 eu4@03 eu4@04 eu4@05 eu4@06 eu4@07 eu4@08 eu4@09 eu4@10 eu4@11
eu5@1 eu5@2 eu5@3 eu5@4 eu5@5
eu6@01 eu6@02 eu6@03 eu6@04 eu6@05 eu6@06 eu6@97
eu6@0201 eu6@0202 eu6@0208 eu6@0301 eu6@0302 eu6@0308 eu6@0401 eu6@0402 eu6@0408 eu6@0501 eu6@0502 eu6@0508
eu8@01 eu8@02 eu8@03 eu8@04 eu8@05 eu8@06 eu8@07 eu8@08 eu8@09 eu8@10 eu8@11 eu8@12 eu8@13 eu8@14 eu8@15 eu8@16
eu9@01 eu9@02 eu9@03 eu9@04 eu9@05 eu9@06 eu9@07 eu9@08 eu9@09 eu9@10 eu9@11 eu9@12 eu9@13 eu9@97
ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@72 ws1@81 ws1@91 ws1@92
watloc@1 watloc@2 watloc@3 watloc@4 watloc@5
ws7@1 ws7@2
ws11@11 ws11@12 ws11@13 ws11@14 ws11@18 ws11@21 ws11@22 ws11@23 ws11@31 ws11@41 ws11@51 ws11@95
ws14@1 ws14@2 ws14@3
latshare lathh1 lathh2		
hw2@1 soap@1
servant
!enddefine.
* Deleted variables with sums less than 2:
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded: 
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected: 
.

delete variables urb1 rur1 ini1.

use all.
factor
	/variables commonvars
	/missing meansub /analysis commonvars /print univariate initial correlation extraction fscore
	/criteria factors(1) iterate(25) /extraction pc 	/rotation norotate 	 
	/save reg(all ini)
	/method=correlation.

use all.
filter by urban.
execute.
factor
	/variables urbanvars
	/missing meansub /analysis urbanvars /print univariate initial correlation extraction fscore
	/criteria factors(1) iterate(25) /extraction pc 	/rotation norotate
	/save reg(all urb)
	/method=correlation.

use all.
filter by rural.
execute.
factor
	/variables ruralvars
	/missing meansub /analysis ruralvars /print univariate initial correlation extraction fscore
	/criteria factors(1) iterate(25) /extraction pc 	/rotation norotate
	/save reg(all rur)
	/method=correlation.


* Regressions.

use all.

variable labels ini1 	"Initial wealth score".
variable labels urb1 	"Urban wealth score".
variable labels rur1 	"Rural wealth score".

* Urban.
use all.
filter by urban.
execute.

regression
  /missing listwise
  /statistics coeff outs r anova /criteria=pin(.05) pout(.10) /noorigin 
  /dependent ini1 /method=enter urb1.

* Rural.
use all.
filter by rural.
execute.

regression
  /missing listwise
  /statistics coeff outs r anova /criteria=pin(.05) pout(.10) /noorigin 
  /dependent ini1 /method=enter rur1.

* Caution!
* Run the syntax up to this line first, in order to calculate constants and coefficients 
* from regression results needed for combined wealth score.

output save outfile = "w3.spv".

*	Calculate combined wealth scores.
compute com1 = 0.
variable labels com1 "Combined wealth score".
formats com1 (f11.5).
* Replace "constant_urban", "constant_rural" "urban_wealth_score" and "rural_wealth_score" in the two lines below
* with the constants and coefficients from regression results.
* Regression results are presented in the column B in the "Coefficients" tables in the active w3.spv output file, 
* separatly for urban and rural. 
if (urban = 1) com1 = constant_urban + (urban_wealth_score * urb1).
if (rural = 1) com1 = constant_rural + (rural_wealth_score * rur1).
execute.

* 	Close the output.
output close *.

