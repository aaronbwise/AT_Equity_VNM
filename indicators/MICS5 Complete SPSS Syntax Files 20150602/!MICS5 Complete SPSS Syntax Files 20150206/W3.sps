* RUN PCAs, REGRESSIONS AND COMPUTE COMBINED WEALTH SCORES.

* PCA.

 
* National.
define commonvars ()
  persroom
 	hc3@11 hc3@12 hc3@21 hc3@22 hc3@31 hc3@32 hc3@33 hc3@34 hc3@35
 	hc4@11 hc4@12 hc4@13 hc4@21 hc4@22 hc4@23 hc4@24 hc4@31 hc4@32 
		hc4@33 hc4@34 hc4@35 hc4@36
 	hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@25 hc5@26
		hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
  hc6@01 hc6@02 hc6@03 hc6@04 hc6@05 hc6@06 hc6@07 hc6@08 hc6@09 
		 hc6@10 hc6@11 hc6@95
  hc8a@1 hc8b@1 hc8c@1 hc8d@1 hc8e@1 hc8f@1
  hc9a@1 hc9b@1 hc9c@1 hc9d@1 hc9e@1 hc9f@1 hc9g@1 hc9h@1
 	hc10@1 hc10@2 hc10@6
	 hc12r 
  cattle0 cattle1 cattle5 cattle10 
  horse0 horse1 horse5 horse10 
  goat0 goat1 goat10 goat30 
  sheep0 sheep1 sheep10 sheep30 
  chicken0 chicken1 chicken10 chicken30  
  pig0 pig1 pig5 pig10
	 hc15@1
  ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 
		 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@81 ws1@91
  watloc@1 watloc@2 watloc@3 watloc@4
	 latshare lathh1 lathh2
  ws8@11 ws8@12 ws8@13 ws8@14 ws8@15 ws8@21 ws8@22 ws8@23 
		 ws8@31 ws8@41 ws8@51 ws8@95
 	hw2@1 soap@1
	 servant abroad
!enddefine.
* Deleted variables with sums less than 2: .
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded:
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected: .

* Urban.
define urbanvars ()
  persroom
 	hc3@11 hc3@12 hc3@21 hc3@22 hc3@31 hc3@32 hc3@33 hc3@34 hc3@35
 	hc4@11 hc4@12 hc4@13 hc4@21 hc4@22 hc4@23 hc4@24 hc4@31 hc4@32 
		hc4@33 hc4@34 hc4@35 hc4@36
 	hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@25 hc5@26
		hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
  hc6@01 hc6@02 hc6@03 hc6@04 hc6@05 hc6@06 hc6@07 hc6@08 hc6@09 
		 hc6@10 hc6@11 hc6@95
  hc8a@1 hc8b@1 hc8c@1 hc8d@1 hc8e@1 hc8f@1
  hc9a@1 hc9b@1 hc9c@1 hc9d@1 hc9e@1 hc9f@1 hc9g@1 hc9h@1
 	hc10@1 hc10@2 hc10@6
	 hc12r 
  cattle0 cattle1 cattle5 cattle10 
  horse0 horse1 horse5 horse10 
  goat0 goat1 goat10 goat30 
  sheep0 sheep1 sheep10 sheep30 
  chicken0 chicken1 chicken10 chicken30  
  pig0 pig1 pig5 pig10
	 hc15@1
  ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 
		 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@81 ws1@91
  watloc@1 watloc@2 watloc@3 watloc@4
	 latshare lathh1 lathh2
  ws8@11 ws8@12 ws8@13 ws8@14 ws8@15 ws8@21 ws8@22 ws8@23 
		 ws8@31 ws8@41 ws8@51 ws8@95
 	hw2@1 soap@1
	 servant abroad
!enddefine.
* Deleted variables with sums less than 2: .
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded:
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected: .

* Rural.
define ruralvars ()
  persroom
 	hc3@11 hc3@12 hc3@21 hc3@22 hc3@31 hc3@32 hc3@33 hc3@34 hc3@35
 	hc4@11 hc4@12 hc4@13 hc4@21 hc4@22 hc4@23 hc4@24 hc4@31 hc4@32 
		hc4@33 hc4@34 hc4@35 hc4@36
 	hc5@11 hc5@12 hc5@13 hc5@21 hc5@22 hc5@23 hc5@24 hc5@25 hc5@26
		hc5@31 hc5@32 hc5@33 hc5@34 hc5@35 hc5@36
  hc6@01 hc6@02 hc6@03 hc6@04 hc6@05 hc6@06 hc6@07 hc6@08 hc6@09 
		 hc6@10 hc6@11 hc6@95
  hc8a@1 hc8b@1 hc8c@1 hc8d@1 hc8e@1 hc8f@1
  hc9a@1 hc9b@1 hc9c@1 hc9d@1 hc9e@1 hc9f@1 hc9g@1 hc9h@1
 	hc10@1 hc10@2 hc10@6
	 hc12r 
  cattle0 cattle1 cattle5 cattle10 
  horse0 horse1 horse5 horse10 
  goat0 goat1 goat10 goat30 
  sheep0 sheep1 sheep10 sheep30 
  chicken0 chicken1 chicken10 chicken30  
  pig0 pig1 pig5 pig10
	 hc15@1
  ws1@11 ws1@12 ws1@13 ws1@14 ws1@21 ws1@31 ws1@32 
		 ws1@41 ws1@42 ws1@51 ws1@61 ws1@71 ws1@81 ws1@91
  watloc@1 watloc@2 watloc@3 watloc@4
	 latshare lathh1 lathh2
  ws8@11 ws8@12 ws8@13 ws8@14 ws8@15 ws8@21 ws8@22 ws8@23 
		 ws8@31 ws8@41 ws8@51 ws8@95
 	hw2@1 soap@1
	 servant abroad
!enddefine.
* Deleted variables with sums less than 2: .
* Take out lathh1 and lathh2 (if the total proportion of shared facilities, latshare, is low), or latshare (if there are 
		significant proportions of households in lathh1 and lathh2). Indicate what you have taken out below
		Variable(s) excluded:
* Deleted variables after studying the PCA results, take out from the list below any variables which seem to be correlated with the 
		model in a way contrary to what is theoretically expected: .

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

