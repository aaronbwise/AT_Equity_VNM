* Encoding: UTF-8.
* MICS6 SE03 Calculate.

* v01 - 2018-04-30.
* v02 - 2020-04-16. Few changes made in line with the latest version of the tabulation plan.

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM HOUSEHOLD.
get file = 'hh.sav'.
subgroup.
select if (HH46 = 1).
compute hhweight48 = hh48 * hhweight * 1000000 .
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

* Access to electricity.
* Use of basic drinking water services.
* Handwashing facility with water and soap.
* Use of basic sanitation services.
* Safe disposal in situ of excreta from on-site sanitation facilities.

*----------------------------------------------------------------------------------------- Access to electricity (SR.2.1).
recode hc8 (1, 2 = 1) (else = 0) into electricity. 
variable labels electricity "Access to electricity".

*----------------------------------------------------------------------------------------- Use of basic drinking water services.
* include definition of drinking water and sanitation facilities.
include "define/MICS6 - 10 - WS.sps".

recode WS4
  (0 = 2)
  (1 thru 30 = 2)
  (31 thru 990 = 3)
  (998, 999 = 9) into time.

* Water on premises.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        time = 1.

compute	INDWS2=0.
if (drinkingwater =1 and time <=2) INDWS2=1.
variable labels INDWS2 "Use of basic drinking water service".

*----------------------------------------------------------------------------------------- Handwashing facility with water and soap.
do if (HW1 < 5).
+ compute indWS7 = 0.
+ if (HW2 = 1 and (HW7A = "A" or HW7B = "B")) indWS7 = 1.
end if.
variable labels indWS7 "Handwashing facility with water and soap".

*----------------------------------------------------------------------------------------- Use of improved sanitation facilities.
compute improvepercent=0.
if toiletType=1 improvepercent=1.
variable labels improvepercent "Use of improved sanitation facilities".

*----------------------------------------------------------------------------------------- Use of basic sanitation services.
compute basicToilet  = 0 .
if (toiletType = 1 and sharedToilet = 0) basicToilet  = 1.
variable labels basicToilet "Use of basic sanitation services".

*----------------------------------------------------------------------------------------- Safe disposal in situ of excreta from on-site sanitation facilities.
recode WS11 (12 = 1) (13, 21, 22, 31 = 2) (else=0) into onsite. 
variable labels onsite "Type of onsite sanitation facility".
value labels onsite 1 "Flush to septic tank" 2 "Latrines and other improved".

compute safedisposal=0.
if ((onsite=1 and WS13 = 1) or (onsite=1 and WS13 = 3) or (onsite=1 and WS13 = 8) or (onsite=2 and WS13 = 1) or  (onsite=2 and WS13 = 3) or (onsite=2 and WS13 = 8)) safedisposal=1.
variable labels safedisposal "Removal of excreta for treatment off-site".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT= hhweight48
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = electricity INDWS2 indWS7 improvepercent basicToilet safedisposal
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM HL and HH.
get file= 'hl.sav'.

do if ((HL6>=5 and HL6<=24) and (ED10A>=1 and ED10A<8)).
+ compute EDsupport=0.
+ if (ED12=1 or ED14=1) EDsupport=1.
end if.

aggregate outfile = 'EDsupport.sav'
  /break   = HH1 HH2
  /nEDsupport  = sum(EDsupport).

new file.

get file = 'hh.sav'.
select if (HH46  = 1).
subgroup.
compute hhweight48 = hh48 * hhweight * 1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

match files
  /file = *
  /table = 'EDsupport.sav'
  /by HH1 HH2.

compute anybenefits=0.
if (ST4U$1=1 and ST4N$1<=3) or (ST4U$2=1 and ST4N$2<=3) or (ST4U$3=1 and ST4N$3<=3) or (ST4U$4=1 and ST4N$4<=3) or (ST4U$5=1 and ST4N$5<=3) or nEDsupport>0 anybenefits=1.
variable labels anybenefits "Population covered by social transfers".

*------------------------------------------------------------------------------------------------------------------Primary reliance on clean fuels and technologies for cooking, space heating and lighting.
compute primarycooking=0.
if ((any (EU1, 1, 2, 3, 4, 5, 97) ) or (EU1=6 and EU4=1)) primarycooking=1.
variable labels primarycooking "Primary reliance on clean fuels and technologies for cooking".

compute primaryheating=0.
if (EU6=1 or EU6=97 or (any (EU8, 1, 2, 3, 4, 5, 6) )) primaryheating=1.
variable labels primaryheating "Primary reliance on clean fuels and technologies for space heating".

compute primarylight= 0. 
if any(EU9, 1, 2, 3, 4, 5, 97)  primarylight = 1.
variable labels primarylight "Primary reliance on clean fuels and technologies for lighting".

compute primaryall=0.
if (primarycooking=1 and primaryheating=1 and primarylight = 1) primaryall=1.
variable labels primaryall  "Primary reliance on clean fuels and technologies for cooking, space heating and lighting".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT= hhweight48
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = primaryall anybenefits
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM WATER QUALITY.
get file = 'hh.sav'.
subgroup.
select if (WQ31 = 1).
compute wqsweightHH48=wqsweight*HH48*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*----------------------------------------------------------------------------------------- Use of safely managed drinking water services.
* include definition of drinking  water and sanitation facilities.
include "define/MICS6 - 10 - WS.sps" .

compute EC_100_S = $sysmis.
if (WQ27 <997 and WQ27 >= 100)  EC_100_S = 101.
if (WQ27 <101 or WQ27 >=997 ) EC_100_S = WQ27. 

recode EC_100_S (0=0) (1 thru 10=1) (11 thru 100=2) (101 = 3) (102 thru highest=9) into Risk_S.
variable labels Risk_S "Risk level based on number of E. coli per 100 mL".
value labels Risk_S 0 "Low (<1 per 100 mL)" 1 "Moderate (1-10 per 100 mL)" 2 "High (11-100 per 100 mL)" 3 "Very high (>100 per 100 mL)" 9 "DK/Missing". 

compute  WithoutEC_S=0.
if Risk_S = 0 WithoutEC_S=100.
variable labels WithoutEC_S "Without E. coli in drinking water source".

*sufficient water.
compute sufficentwater=0.
if WS7= 2 sufficentwater=100.
variable labels sufficentwater "With drinking water available in sufficient quantities".

* Water on premises.
compute wpremises = 0.
if ( any(WS1, 11, 12) or
     any(WS2, 11, 12) or
     any(WS3, 1, 2) )        wpremises = 100.
variable labels wpremises "Drinking water accessible on premises".

do if Risk_S<=3.
+compute indSDG611 = 0.
+if (drinkingWater = 1 and WithoutEC_S = 100 and sufficentwater = 100 and wpremises = 100) indSDG611=1.
end if.
variable labels indSDG611 "Use of safely managed drinking water services".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT= wqsweightHH48
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = indSDG611
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM HOUSEHOLD LISTING.
get file = 'hl.sav'.
subgroup.
compute hhweight = hhweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------ Participation rate in organised learning (adjusted).
include "define/MICS6 - 08 - LN.sps".

do if (schage = primarySchoolEntryAge - 1).
+compute attendance = 0.
+if (ED10a = 0 or ED10a = 1) attendance = 1.
end if.
variable labels attendance "Participation rate in organised learning (adjusted)".

*------------------------------------------------------------------------------------------------------------------ Completion rate (Primary).
include 'define/MICS6 - 08 - LN.sps' .

compute numberLastP = 0.
if (schage >= primarySchoolCompletionAge + 3 and schage <= primarySchoolCompletionAge + 5) numberLastP = 1.
do if numberLastP = 1.
+ compute primarySchoolCompletionRate = 0.
+ if  (ED5A > 1 and ED5A < 8) or (ED5A=1 and ED5B = primarySchoolGrades and ED6=1) primarySchoolCompletionRate  = 1.
end if.

variable labels primarySchoolCompletionRate "Completion rate (Primary)".

*------------------------------------------------------------------------------------------------------------------ Completion rate (Lower secondary).
* Lower secondary.
compute numberLastLS = 0.
if (schage >= LowSecSchoolCompletionAge + 3 and schage <= LowSecSchoolCompletionAge + 5) numberLastLS = 1.
do if numberLastLS = 1.
+ compute LowSecCompletionRate = 0.
+ if  (ED5A > 2 and ED5A < 8) or (ED5A=2 and ED5B = LowSecSchoolGrades and ED6=1) LowSecCompletionRate  = 1.
end if.

variable labels LowSecCompletionRate "Completion rate (Lower secondary)".

*------------------------------------------------------------------------------------------------------------------ Completion rate (Upper secondary).
* Upper secondary.
compute numberLastUS = 0.
if (schage >= UpSecSchoolCompletionAge + 3 and schage <= UpSecSchoolCompletionAge + 5) numberLastUS = 1.
do if numberLastUS = 1.
+ compute UpSecCompletionRate = 0.
+ if  numberLastUS = 1 and ((ED5A > 3 and ED5A < 8) or (ED5A=3 and ED5B = UpSecSchoolGrades and ED6=1)) UpSecCompletionRate  = 1.
end if.

variable labels UpSecCompletionRate "Completion rate (Upper secondary)".

*------------------------------------------------------------------------------------------------------------------ Population slept under an ITN.
do if (HL7 = 1).
+compute itn = 0.
+if (TN5 >=11 and TN5 <= 18) itn = 1.
end if.
variable labels  itn "Population slept under an ITN".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES =  itn attendance primarySchoolCompletionRate LowSecCompletionRate UpSecCompletionRate 
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM WOMEN.
get file = 'wm.sav'.
sort cases by hh1 hh2 ln.
subgroup.
select if (WM17 = 1).
compute wmweight = wmweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*** Ownership of mobile phone (women).
*** Use of internet during the last 3 months (women).
*** ICT skills (women).
*** Use of tobacco (women).

*** Note that mortality SEs can only be calculated for results based on birth history with the existing and separate SPSS syntax.
*** Also note that SEs for the maternal mortality ratio and adolescent birth rate can be calculated only through the separate CS Pro application.

*----------------------------------------------------------------------------------------- Ownership of mobile phone (women) .
recode MT11 (1 = 1) (else = 0) into mobile.
variable labels mobile "Ownership of mobile phone (women)".

*----------------------------------------------------------------------------------------- Use of internet (women) .
recode MT10 (1, 2, 3 = 1) (else = 0) into int3.
variable labels int3 "Use of internet during the last 3 months (women)".

*----------------------------------------------------------------------------------------- ICT skills (women) .
compute ICTskills = 0.
if (MT6A = 1 or MT6B = 1 or MT6C = 1 or MT6D = 1 or MT6E = 1 or MT6F = 1 or MT6G = 1 or MT6H = 1 or MT6I = 1) ICTskills = 1.
variable labels ICTskills "ICT skills (women)".

*----------------------------------------------------------------------------------------- Use of tobacco (women) .
if ((TA4>00 and TA4<97) or (TA5>00 and TA5<97))  mcig = 100.
if (TA9>00 and TA9<97)  mothprods = 100.
if (TA13>00 and TA13<97)  mothprodless = 100.

compute tobacco = 0.
if (mcig = 100 or mothprods = 100 or mothprodless = 100) tobacco = 1.
variable labels tobacco "Use of tobacco (women)".

*----------------------------------------------------------------------------------------- Contraceptive prevalence rate.
include 'define\MICS6 - 06 - TM.sps' .

do if  (mstatus = 1).
+ compute anyMethod = 0 .
+ if (contraceptiveMethod >= 1 and contraceptiveMethod <= 99) anyMethod = 1 .
end if.
variable labels anyMethod "Contraceptive prevalence rate" .

*----------------------------------------------------------------------------------------- Need for family planning satisfied with modern contraception.
recode mstatus (else=sysmis) into unmet.

** CONTRACEPTIVE USERS - GROUP 1.
do if (sysmis(unmet) & CP2=1).
* using to space - all contraceptive users, except those below.
+ compute unmet=3.
* using to limit if sterilized (male or female sterilization CP4A = A or CP4B = B), wants no more (UN7 = 2), or declared infecund (UN7 = 3 or UN8N = 94).
+ if (CP4A='A' or CP4B='B' or UN7=2 or UN7 = 3 or UN8N = 94) unmet=4.
end if.

** PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2.
* Determine who should be in Group 2.
* generate time since last birth.
compute tsinceb=wdoi-wdoblc.

* generate time since last period in months from UN14.
do if (UN14N>=00 & UN14N<=90).
if (UN14U = 1) tsincep=trunc(UN14N/30).
if (UN14U = 2) tsincep=trunc(UN14N/4.3).
if (UN14U = 3) tsincep=UN14N.
if (UN14U = 4) tsincep=UN14N*12.
end if.
* initialize pregnant or postpartum amenorrheic (PPA) women.
compute pregPPA=0.
if (CP1=1 | MN35=2) pregPPA=1.
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period.
do if (MN35=9).
*   if last period is before last birth in last 5 years.
+ if (not sysmis(tsinceb) & not sysmis(tsincep) & tsincep>tsinceb & tsinceb<60) pregPPA=1.
*   if said "before last birth" to time since last period in the last 5 years.
+ if (not sysmis(tsinceb) & UN14N=94 & tsinceb<60) pregPPA=1.
end if.

* select only women who are pregnant or PPA for <24 months.
compute pregPPA24=0.
if (CP1=1 | (pregPPA=1 & tsinceb<24)) pregPPA24=1.

* Classify wantedness of current preg.nancy/last birth.
* current pregnancy.
do if (CP1=1).
+ compute wantedlast=UN2.
+ if (UN2=2 and UN4<>9) wantedlast=UN4+1.
+ if (UN2=2 and UN4=9) wantedlast=9.
else.
* last birth.
+ compute wantedlast=DB2.
+ if (DB2=2 and DB4<>9) wantedlast=DB4+1.
+ if (DB2=2 and DB4=9) wantedlast=9.
end if.
if (sysmis(wantedlast)) wantedlast = 9.

* Unmet need status of pregnant women or women PPA for <24 months.
do if (sysmis(unmet) & pregPPA24=1).
* no unmet need if wanted current pregnancy/last birth then/at that time.
+ if (wantedlast=1) unmet=7.
* unmet need for spacing if wanted current pregnancy/last birth later.
+ if (wantedlast=2) unmet=1.
* unmet need for limiting if wanted current pregnancy/last birth not at all.
+ if (wantedlast=3) unmet=2.
*missing=missing.
+ if (wantedlast=9 | sysmis(wantedlast)) unmet=99.
end if.

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE.
if (sysmis(unmet) & mstatus<>1 & sexact<>1) unmet=97 .

**DETERMINE FECUNDITY - GROUP 4.
**Boxes 1-4 only apply to women who are not pregnant and not PPA<24 months.
do if (sysmis(unmet) & CP1<>1 & pregPPA24<>1).
+ compute infec=0.

**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception.
+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & CP3<>1) infec=1 .
*+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & (UN12E='E' or UN12H='H')) infec=1 .

**Box 2.
* declared infecund on future desires for children.
+ if (UN7=3 or UN8N=93) infec=1.

**Box 3.
*menopausal/hysterectomy.
+ if (UN12B='B' or UN12D='D') infec=1.
*never menstruated - only if no birth in last 5 years.
+ if (UN12C='C' and (sysmis(tsinceb) or tsinceb>=60)) infec=1.

**Box 4.
* Time since last period is >=6 months and not PPA.
+ if (not sysmis(tsincep) & tsincep>=6 & pregPPA<>1) infec=1.

**Box 5.
* menopause/hysterectomy on time since last period.
+ if (UN14N=93) infec=1.
* never menstruated on time since last period, unless had a birth in the last 5 years.
+ if (UN14N=95 & (sysmis(tsinceb) | tsinceb>=60)) infec=1.

**Box 6.
* time since last birth>= 60 months and last period was before last birth.
+ if (UN14N=94 & not sysmis(tsinceb) & tsinceb>=60) infec=1.
* Never had a birth, but last period reported as before last birth - assume code should have been 994 or 996.
+ if (UN14N=94 & sysmis(tsinceb)) infec=1.

**INFECUND - GROUP 3.
+ if (infec=1) unmet=9.

**FECUND WOMEN - GROUP 4.
+ do if sysmis(unmet).
* wants within 2 years or wants soon.
+   if (UN7=1 & UN8U=1 & UN8N<24) unmet=7.
+   if (UN7=1 & UN8U=2 & UN8N<2) unmet=7.
+   if (UN7=1 & UN8N=93) unmet=7.
* wants in 2+ years, wants after marriage, wants undecided timing, or unsure if wants.
+   if (UN7=1 & sysmis(unmet) & UN8N<=90) unmet=1.
+   if (UN7=1 & UN8N=95) unmet=1.
*   if (UN7=1 & UN8N=96) unmet=1.
+   if (UN7=1 & UN8N=98) unmet=1.
+   if (UN7=8) unmet=1.
* wants no more.
+   if (UN7=2) unmet=2.
+ end if.

** End of code for women who are not pregnant and not PPA<24 months.
end if.

recode unmet(sysmis=99).
value labels unmet
  1 "unmet need for spacing"
  2 "unmet need for limiting"
  3 "using for spacing"
  4 "using for limiting"
  7 "no unmet need"
  9 "infecund or menopausal"
  97 "not sexually active"
  98 "unmarried - EM sample or no data"
  99 "missing".
recode unmet (1,2=1) (else=0) into unmettot.
variable labels unmettot "Unmet need for family planning".
value labels unmettot 1 "unmet need" 0  "no unmet need".
formats unmet unmettot (f1.0).

use all.
compute metspc = 100*(unmet=3).
compute metlmt = 100*(unmet=4).
compute met    = 100*(unmet=3 or unmet=4).
compute space  = 100*(unmet=1).
compute limit  = 100*(unmet=2).
compute unmetnd = 100*(unmet=1 or unmet=2).
compute totspc = 100*(unmet = 3 or unmet = 1).
compute totlmt = 100*(unmet = 4 or unmet = 2).
compute totdem = 100*(unmet = 1 or unmet = 2 or unmet = 3 or unmet = 4).

variable labels metspc "For spacing births".
variable labels metlmt "For limiting births".
variable labels met "Total".

variable labels space "For spacing births".
variable labels limit "For limiting births".
variable labels unmetnd "Total".

variable labels totspc "For spacing births".
variable labels totlmt "For limiting births".
variable labels totdem "Total".

* Percentage of demand satisfied.
do if (unmet >=1 and unmet <= 4).
+ compute satisf = 0.
+ if (unmet=3 or unmet=4) satisf = 100.
+ compute satisfM = 0.
+ if (unmet=3 or unmet=4) and (contraceptiveMethod >= 1 and contraceptiveMethod <= 11) satisfM = 100.
+ compute totneed = 1.
end if.

do if (mstatus = 1) and (unmet >=1 and unmet <= 4).
+ recode satisfM (100=1) (else=0) into satisfMw.
end if.
variable labels satisfMw "Need for family planning satisfied with modern contraception".

*----------------------------------------------------------------------------------------- Antenatal care coverage (4+).
do if (CM17 = 1)..
+ compute antenatalCare = 0 .
+ if (MN5 >= 4 and MN5 <= 90) antenatalCare = 1 .
end if.
variable labels antenatalCare "Antenatal care coverage (at least four times by any provider)" .

*----------------------------------------------------------------------------------------- Skilled attendant at delivery.
do if (CM17 = 1)..
+ compute skilledAttendantw = 0 .
+ if any(personAtDelivery, 11, 12, 13) skilledAttendantw = 1.
end if.
variable labels skilledAttendantw "Skilled attendant at delivery" .

*-----------------------------------------------------------------------------------------   
*Child marriage (before age 15).
*Child marriage (before age 18).
do if (WB4 >= 20 and WB4 <= 24).
+compute before15 = 0.
+if (WAGEM < 15) before15 = 1.
end if.

do if (WB4 >= 20 and WB4 <= 24).
+ compute before18 = 0.
+ if (WAGEM < 18) before18 = 1.
end if.

variable labels 
    before15  "Child marriage (before age 15, women age 20-24)" 
   /before18  "Child marriage (before age 18, women age 20-24)" .

*-----------------------------------------------------------------------------------------  Prevalence of FGM among women.
compute anyFgm = 0 .
if (FG3 = 1) anyFgm = 1 .
variable labels anyFgm "Prevalence of FGM among women".

*----------------------------------------------------------------------------------------- Safety  (women).
recode vt20 vt21(9=sysmis).
compute vt20safe=0.
if any(vt20,1,2) vt20safe=1.
variable labels vt20safe "Safety (women)".

*----------------------------------------------------------------------------------------- Discrimination (women).
compute anydiscrimination = 0.
if (VT22A = 1 or VT22B = 1 or VT22C = 1 or VT22D = 1 or VT22E = 1 or VT22F = 1 or VT22X = 1) anydiscrimination = 1.
variable labels anydiscrimination "Discrimination (women)".
    
*----------------------------------------------------------------------------------------- Overall life satisfaction index (women age 15-24).
do if (wage <=2).
+recode LS2 (99 = sysmis) (else = copy) into lifesat .
end if.
variable labels lifesat "Overall life satisfaction index (women age 15-24; scale of 0-10)".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=wmweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = mobile int3 ICTskills tobacco anyMethod satisfMw antenatalCare skilledAttendantw before15 before18 anyFgm vt20safe anydiscrimination lifesat
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE .

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM MEN.
get file = 'mn.sav'.
sort cases by hh1 hh2 ln.
subgroup.
select if (MWM17 = 1).
compute mnweight = mnweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1 .

*** Ownership of mobile phone (men).
*** Use of internet during the last 3 months (men).
*** ICT skills (men).
*** Use of tobacco (men).

*----------------------------------------------------------------------------------------- Ownership of mobile phone (men) .
recode MMT11 (1 = 1) (else = 0) into mmobile.
variable labels mmobile "Ownership of mobile phone (men)".

*----------------------------------------------------------------------------------------- Use of internet (men) .
recode MMT10 (1, 2, 3 = 1) (else = 0) into mint3.
variable labels mint3 "Use of internet during the last 3 months (men)".

*----------------------------------------------------------------------------------------- ICT skills (men) .
compute mICTskills = 0.
if (MMT6A = 1 or MMT6B = 1 or MMT6C = 1 or MMT6D = 1 or MMT6E = 1 or MMT6F = 1 or MMT6G = 1 or MMT6H = 1 or MMT6I = 1) mICTskills = 1.
variable labels mICTskills "ICT skills (men)".

*----------------------------------------------------------------------------------------- Use of tobacco (men) .
if ((MTA4>00 and MTA4<97) or (MTA5>00 and MTA5<97))  mcig = 100.
if (MTA9>00 and MTA9<97)  mothprods = 100.
if (MTA13>00 and MTA13<97)  mothprodless = 100.

compute mtobacco = 0.
if (mcig = 100 or mothprods = 100 or mothprodless = 100) mtobacco = 1.
variable labels mtobacco "Use of tobacco (men)".

*----------------------------------------------------------------------------------------- Safety (men) .
recode mvt20 mvt21(9=sysmis).
compute mvt20safe=0.
if any(mvt20,1,2) mvt20safe=1.
variable labels mvt20safe "Safety (men)".
 
*----------------------------------------------------------------------------------------- Discrimination (men) .
compute manydiscrimination = 0.
if (MVT22A = 1 or MVT22B = 1 or MVT22C = 1 or MVT22D = 1 or MVT22E = 1 or MVT22F = 1 or MVT22X = 1) manydiscrimination = 1.
variable labels manydiscrimination "Discrimination (men)".

*----------------------------------------------------------------------------------------- Overall life satisfaction index (men age 15-24).
do if (mwage <=2).
+recode MLS2 (99 = sysmis) (else = copy) into maverageladder1524 .
end if.
variable labels maverageladder1524 "Overall life satisfaction index (men age 15-24; scale 0-10)".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.
CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=mnweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = mmobile mint3 mICTskills mtobacco mvt20safe manydiscrimination maverageladder1524
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM CHILDREN UNDER 5'S DATA.
get file = 'hl.sav'.
sort cases by HH1 HH2 HL1.
* create tmp file to check if child slept in the hh last night.
save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL7
  /rename HL1 = LN.

get file = 'ch.sav'.
sort cases by HH1 HH2 LN.
match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.
subgroup.
select if (UF17 = 1).
compute chweight = chweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*----------------------------------------------------------------------------------------- Birth registration.
compute birthRegistrated = 0.
if (BR1 = 1 or BR1 = 2 or BR2 = 1) birthRegistrated = 1.
variable labels birthRegistrated "Birth registration".

*----------------------------------------------------------------------------------------- 
*Diphtheria, pertussis and tetanus (DPT) immunization coverage.
*Pneumococcal (Conjugate) immunization coverage.
*Measles immunization coverage.
include file = "MICS6 - 07 - TC - RECODE.sps".

do if (cage >= 12 and cage <= 23).
+ recode penta3 (1,2 = 1) (else = 0) into penta3_r.
+ recode pneumo3 (1,2 = 1) (else = 0) into pneumo3_r.
+ recode measles (1,2 = 1) (else = 0) into measles_r.
end if.

variable labels penta3_r "Diphtheria, pertussis and tetanus (DPT) immunization coverage".
variable labels pneumo3_r "Pneumococcal (Conjugate) immunization coverage".
variable labels measles_r "Measles immunization coverage".

*----------------------------------------------------------------------------------------- Exclusive breastfeeding under 6 months.
include 'define/MICS6 - 07 - TC.sps' .
do if (cage >= 0 and cage <= 5).
+ compute eBreastfed = 0.
+ if exclusivelyBreastfed = 100 eBreastfed = 1.
end if.
variable labels eBreastfed "Exclusive breastfeeding under 6 months".

*----------------------------------------------------------------------------------------- Exclusive breastfeeding under 6 months.
compute ari  = 0.
if (CA16 = 1 and CA17 = 1 and (CA18 =1 or CA18 = 3)) ari = 100.
variable labels  ari "Had suspected pneumonia in the last two weeks".

do if (ari = 100).
+ compute hf = 0.
+ if (CA21A = "A" or CA21B = "B" or CA21C = "C" or CA21D = "D" or CA21E = "E" or CA21H = "H" or CA21I = "I" or CA21J = "J" or CA21L = "L" or CA21M = "M" or CA21O = "O") hf = 1.
end if.
variable labels hf "Care-seeking for children with acute respiratory infection (ARI) symptoms".

*----------------------------------------------------------------------------------------- 
*Stunting prevalence (moderate and severe).
*Wasting prevalence (moderate and severe).
*Overweight prevalence (moderate and severe).
do if (hazflag = 0).
+ recode HAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 1) into ha2sd.
else.
+ compute ha2sd = $SYSMIS.
end if.

do if (whzflag = 0).
+ recode WHZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 1) into wh2sd.
+ recode WHZ2 (sysmis=sysmis) (lo thru +2.00 = 0) (else = 1) into wh2sdAbove.
else.
+ compute wh2sd = $SYSMIS.
+ compute wh2sdAbove = $SYSMIS.
end if.

variable labels ha2sd "Stunting prevalence (moderate and severe)".
variable labels wh2sd "Wasting prevalence (moderate and severe)".
variable labels wh2sdAbove "Overweight prevalence (moderate and severe)".

*----------------------------------------------------------------------------------------- Early child development index.
* Select children 36+ months old.
do if (cage >= 36).
+recode EC6 (1 = 100) (else = 0).
+recode EC7 (1 = 100) (else = 0).
+recode EC8 (1 = 100) (else = 0).
+count langcog = EC8 EC7 EC6 (100).
+recode langcog (2,3 = 100) (0,1 = 0) into langcog2.

+recode EC9  (1 = 100) (else = 0).
+recode EC10 (2 = 100) (else = 0).
+count physical = EC10 EC9 (100).
+recode physical (1,2 = 100) (0 = 0) into physical2.

+recode EC13 (1 = 100) (else = 0).
+recode EC14 (2 = 100) (else = 0).
+recode EC15 (2 = 100) (else = 0).
+count socemo = EC15 EC14 EC13 (100).
+recode socemo (2,3 = 100) (0,1 = 0) into socemo2.

+recode EC11 (1 = 100) (else = 0).
+recode EC12 (1 = 100) (else = 0).
+count learn = EC12 EC11 (100).
+recode learn (1,2 = 100) (0 = 0) into learn2.
+count develop = langcog2 physical2 socemo2 learn2 (100).

+recode develop (3,4 = 1) (0,1,2 = 0)  into target.
end if.

variable labels target "Early child development index".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=chweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES =  penta3_r  pneumo3_r  measles_r eBreastfed hf ha2sd wh2sd wh2sdAbove target birthRegistrated
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM CHILDREN 5-17'S DATA.
get file = 'fs.sav'.
subgroup.
select if (FS17 = 1).
compute fsweight = fsweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------ Children with foundational reading and number skills (reading).
do if FL28 = 1 and ( CB3>=7 and CB3 <=14) and (CB8A = 1 and (CB8B = 2 or CB8B = 3)).

+compute target = 0.
+if (FL20A < 99 and FL20B < 99) target = FL20A - FL20B.

* Replace 72 below with total number of words in your survey.
+compute readCorrect = 0.
+if (target >= 0.9 * 72) readCorrect = 100.

+compute aLiteral = 0.
+if (FL22A=1 and FL22B=1 and FL22C=1) aLiteral = 100.

+compute aInferential = 0.
+if (FL22D=1 and FL22E=1) aInferential = 100.

+compute readingSkill = 0.
+if (readCorrect = 100 and aLiteral = 100 and aInferential = 100) readingSkill = 1.

end if.
variable labels readingSkill "Children with foundational reading and number skills (reading, attending grade 2/3)".

*------------------------------------------------------------------------------------------------------------------ Children with foundational reading and number skills (numeracy).
do if FL28 = 1 and ( CB3>=7 and CB3 <=14) and (CB8A = 1 and (CB8B = 2 or CB8B = 3)).

+count numberReadTarget = FL23A FL23B FL23C FL23D FL23E FL23F (1).
+compute numberRead = 0.
+if (numberReadTarget = 6) numberRead = 100.

+compute numberDiscr  = 0.
*+if (FL24A = "7" and FL24B = "24" and FL24C = "58" and FL24D = "67" and FL24E = "154" ) numberDiscr = 100.
+if (FL24A = 1 and FL24B = 1 and FL24C = 1  and FL24D = 1 and FL24E = 1) numberDiscr = 100.

+compute numberAdd  = 0.
*+if (FL25A = "5" and FL25B = "14" and FL25C = "10" and FL25D = "19" and FL25E = "36") numberAdd = 100.
+if (FL25A = 1 and FL25B = 1 and FL25C = 1 and FL25D = 1 and FL25E =1) numberAdd = 100.

+compute numberPattern = 0.
*+if (FL27A = "8" and FL27B = "16" and FL27C = "30" and FL27D = "8" and FL27E = "14") numberPattern = 100.
+if (FL27A = 1 and FL27B = 1 and FL27C = 1  and FL27D = 1 and FL27E = 1) numberPattern = 100.

+compute numSkill = 0.
+if (numberRead = 100 and numberDiscr = 100 and numberAdd = 100 and numberPattern = 100) numSkill = 1.

end if.
variable labels numSkill "Children with foundational reading and number skills (numeracy, attending grade 2/3)".

*------------------------------------------------------------------------------------------------------------------ Child labour.
include 'define\MICS6 - 09 - PR.sps' .
recode childLabor (100=1) (else=0). 
variable labels childLabor "Child labour".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=fsweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = readingSkill numSkill childLabor
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM CHILDREN 0-17'S DATA.
get file = "fs.sav".
sort cases hh1 hh2 fs3.
 	
if (any(FCF6, 3, 4)) seeing=100.
if (any(FCF8, 3, 4)) hearing=100.
if ((any(FCF10, 3, 4)) or (any(FCF11, 3, 4)) or (any(FCF14, 3, 4)) or (any(FCF15, 3, 4))) walking=100.
if (any(FCF16, 3, 4)) selfcare=100.
if ((any(FCF17, 3, 4)) or (any(FCF18, 3, 4))) communication=100.
if (any(FCF19, 3, 4)) learning=100.
if (any(FCF20, 3, 4)) remembering=100.. 
if (any(FCF21, 3, 4)) concentrating=100.
if (any(FCF22, 3, 4)) accepting=100.
if (any(FCF23, 3, 4)) behaviour=100.
if (any(FCF24, 3, 4)) makingfriends=100.
if FCF25=1 anxiety=100.
if FCF26=1 depression=100.

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or selfcare=100 or communication=100 or learning=100 or remembering=100 or 
    concentrating=100 or accepting=100 or behaviour=100 or makingfriends=100 or anxiety=100 or depression=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 5-17 years with functional difficulty in at least one domain".

rename variables 
 FS17 = result
 FCD2A = CD2A
 FCD2B = CD2B
 FCD2C = CD2C
 FCD2D = CD2D
 FCD2E = CD2E
 FCD2F = CD2F
 FCD2G = CD2G
 FCD2H = CD2H
 FCD2I = CD2I
 FCD2J = CD2J
 FCD2K = CD2K
 FCD3 = CD2
 CB3 = age
 fsweight = hweight
.
save outfile = "tmpfs.sav"/keep  HH1 HH2 LN HH6 HH7 CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD2 age anyfuncdifficulty hweight result.

get file = "ch.sav".
sort cases by hh1 hh2 ln.
if (any(UCF7, 3, 4)) seeing=100.
if (any(UCF9, 3, 4)) hearing=100.
if ((any(UCF11, 3, 4)) or (any(UCF12, 3, 4)) or (any(UCF13, 3, 4))) walking=100. 
if (any(UCF14, 3, 4)) finemotor=100.
if ((any(UCF15, 3, 4)) or (any(UCF16, 3, 4))) communication=100.
if (any(UCF17, 3, 4)) learning=100.
if (any(UCF18, 3, 4)) playing=100.
if (UCF19 =5) behaviour=100.

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or finemotor=100 or communication=100 or learning=100 or playing=100 or behaviour=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 2-4 years with functional difficulty in at least one domain".

rename variables 
 UF17 = result
 UCD2A = CD2A
 UCD2B = CD2B
 UCD2C = CD2C
 UCD2D = CD2D
 UCD2E = CD2E
 UCD2F = CD2F
 UCD2G = CD2G
 UCD2H = CD2H
 UCD2I = CD2I
 UCD2J = CD2J
 UCD2K = CD2K
 UCD3 = CD2
 UB2 = age
 chweight = hweight
.

save outfile = "tmpch.sav"/keep hh1 hh2 HH6 HH7 ln CD2A CD2B CD2C CD2D CD2E CD2F CD2G  CD2H CD2I CD2J CD2K CD2 age anyfuncdifficulty hweight result.

get file = "tmpch.sav".
add files file = * /file = "tmpfs.sav".
sort cases by hh1 hh2 ln.
subgroup.
select if (result = 1).
compute hweight = hweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

weight by hweight.

*------------------------------------------------------------------------------------------------------------------ Violent discipline.
do if (age >=1 and age <= 14).
+compute anyViolent = 0 .
+if (any(1, CD2C, CD2D, CD2F, CD2G, CD2H, CD2I, CD2J, CD2K)) anyViolent = 1 .
end if.
variable labels anyViolent "Violent discipline".

*------------------------------------------------------------------------------------------------------------------ Children with functional difficulty .
do if (age >= 2 and age <= 17).
+compute anyfuncdifficultyx=0.
+if anyfuncdifficulty =100  anyfuncdifficultyx= 1.
end if.
variable labels anyfuncdifficultyx "Children with functional difficulty".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = anyViolent anyfuncdifficultyx
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

