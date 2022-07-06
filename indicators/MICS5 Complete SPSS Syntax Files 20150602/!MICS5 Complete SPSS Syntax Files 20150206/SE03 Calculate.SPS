* MICS5 SE03 Calculate.

* v03 - 2014-04-13.

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM HOUSEHOLD.
get file = 'hh.sav'.
subgroup.
select if (HH9 = 1).
compute hhweightHH11 = HH11*hhweight * 1000000 .
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.
  
*----------------------------------------------------------------------------------------- Use of improved drinking water sources.
include "define/MICS5 - 05 - WS.sps" .

*** MICS indicator 4.1; MDG indicator 7.8 - Use of improved drinking water sources .
recode drinkingWater (1 = copy) (else = 0) into improvedWater .
variable labels improvedWater "Use of improved drinking water sources" .

*----------------------------------------------------------------------------------------- Use of improved sanitation.
*** MICS indicator 4.3; MDG indicator 7.9 - Use of improved sanitation .
compute improvedSanitation = 0.
if (toiletType = 1 and sharedToilet = 0) improvedSanitation = 1 .
variable labels improvedSanitation "Use of improved sanitation".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT= hhweightHH11
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = improvedWater improvedSanitation
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

include 'define/MICS5 - 08 - ED.sps' .

*-----------------------------------------------------------------------------------------Primary school net attendance ratio (adjusted)
*** MICS indicator 7.4; MDG indicator 2.1 - Primary school net attendance ratio (adjusted) .
do if (schage >= primarySchoolEntryAge and schage <= primarySchoolCompletionAge).
+ compute primary  = 0.
+ if (ED6A >= 1 and ED6A <= 2) primary =  1.
+ if (schage = primarySchoolCompletionAge and ED4A = 1 and ED4B = primarySchoolGrades and ED5 = 2) primary  = 1.
end if.
variable labels primary "Primary school net attendance ratio (adjusted)" . 


*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = primary
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.







*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM WOMEN.

get file = 'wm.sav'.
sort cases by hh1 hh2 ln.
subgroup.
select if (WM7 = 1).
compute wmweight = wmweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*** Infant mortality rate.
*** Under five mortality rate.
*** Adolescent birth rate.
*** Contraceptive prevalence.
*** Unmet need.
*** Antenatal care coverage (1+ times, skilled provider).
*** Antenatal care coverage (4+ times, any provider).
*** Skilled attendant at delivery.
*** Maternal mortality ratio.
*** Literacy rate (young women).
*** Knowledge about HIV prevention (young women).
*** Condom use with non-regular partners.
*** Note that mortality SEs can only be calculated for results based on birth history with the existing and separate SPSS syntax.
*** Also note that SEs for the maternal mortality ratio and adolescent birth rate can be calculated only through the separate CS Pro application.


include 'define\MICS5 - 06 - RH.sps' .
*----------------------------------------------------------------------------------------- Contraceptive prevalence rate .
*** MICS indicator 5.3; MDG indicator 5.3 - Contraceptive prevalence rate .
do if  (mstatus = 1).
+ compute anyMethod = 0 .
+ if (contraceptiveMethod >= 1 and contraceptiveMethod <= 99) anyMethod = 1 .
end if.
variable labels anyMethod "Contraceptive prevalence rate" .

*----------------------------------------------------------------------------------------- Unmet need .
*** MICS indicator 5.4; MDG indicator 5.6 - Unmet need .
recode mstatus (else=sysmis) into unmet.

** CONTRACEPTIVE USERS - GROUP 1.
do if (sysmis(unmet) & CP2=1).
* using to space - all contraceptive users, except those below.
+ compute unmet=3.
* using to limit if sterilized (male or female sterilization CP3A = A or CP3B = B), wants no more (UN6 = 2), or declared infecund (UN6 = 3 or UN7N = 94).
+ if (CP3A='A' or CP3B='B' or UN6=2 or UN6 = 3 or UN7N = 94) unmet=4.
end if.

** PREGNANT or POSTPARTUM AMENORRHEIC (PPA) WOMEN - GROUP 2.
* Determine who should be in Group 2.
* generate time since last birth.
compute tsinceb=wdoi-wdoblc.

* generate time since last period in months from UN13.
do if (UN13N>=00 & UN13N<=90).
if (UN13U = 1) tsincep=trunc(UN13N/30).
if (UN13U = 2) tsincep=trunc(UN13N/4.3).
if (UN13U = 3) tsincep=UN13N.
if (UN13U = 4) tsincep=UN13N*12.
end if.
* initialize pregnant or postpartum amenorrheic (PPA) women.
compute pregPPA=0.
if (CP1=1 | MN23=2) pregPPA=1.
* For women with missing data or "period not returned" on date of last menstrual period, use information from time since last period.
do if (MN23=9).
*   if last period is before last birth in last 5 years.
+ if (not sysmis(tsinceb) & not sysmis(tsincep) & tsincep>tsinceb & tsinceb<60) pregPPA=1.
*   if said "before last birth" to time since last period in the last 5 years.
+ if (not sysmis(tsinceb) & UN13N=95 & tsinceb<60) pregPPA=1.
end if.

* select only women who are pregnant or PPA for <24 months.
compute pregPPA24=0.
if (CP1=1 | (pregPPA=1 & tsinceb<24)) pregPPA24=1.

* Classify wantedness of current preg.nancy/last birth.
* current pregnancy.
do if (CP1=1).
+ compute wantedlast=UN2.
+ if (UN2=2 and UN3<>9) wantedlast=UN3+1.
+ if (UN2=2 and UN3=9) wantedlast=9.
else.
* last birth.
+ compute wantedlast=DB1.
+ if (DB1=2 and DB2<>9) wantedlast=DB2+1.
+ if (DB1=2 and DB2=9) wantedlast=9.
end if.
if (sysmis(wantedlast)) wantedlast = 9.

variable labels wantedlast "Wantedness of current pregnancy or last birth".
value labels wantedlast 1 "Then" 2 "Later" 3 "Not at all".
formats wantedlast (f1.0).

* Unmet need status of pregnant women or women PPA for <24 months.
do if (sysmis(unmet) & pregPPA24=1).
* no unmet need if wanted current pregnancy/last birth then/at that time.
+ if (wantedlast=1) unmet=7.
* unmet need for spacing if wanted current pregnancy/last birth later.
+ if (wantedlast=2) unmet=1.
* unmet need for limiting if wanted current pregnancy/last birth not at all.
+ if (wantedlast=3) unmet=2.
*missing=missing.
+ if	(wantedlast=9 | sysmis(wantedlast)) unmet=99.
end if.

**NO NEED FOR UNMARRIED WOMEN WHO ARE NOT SEXUALLY ACTIVE.
* determine if sexually active in last 30 days.
compute sexact=0.
if (SB3U = 1 and SB3N <= 30) sexact=1.
if (SB3U = 2 and SB3N <= 4) sexact=1.
variable labels sexact "Sexually active in last 30 days".
value labels sexact 1 "Yes" 2 "No".
formats sexact (f1.0).

if (sysmis(unmet) & mstatus<>1 & sexact<>1) unmet=97 .

**DETERMINE FECUNDITY - GROUP 4.
**Boxes 1-4 only apply to women who are not pregnant and not PPA<24 months.
do if (sysmis(unmet) & CP1<>1 & pregPPA24<>1).
+ compute infec=0.

**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception.
+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & CP2A<>1) infec=1 .
* 'Alternative' Box 1 when ever-use of contraception is missing.
*+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & (UN11E='E' or UN11H='H')) infec=1 .

**Box 2.
* declared infecund on future desires for children.
+ if (UN6=3 or UN7N=94) infec=1.

**Box 3.
*menopausal/hysterectomy.
+ if (UN11B='B' or UN11D='D') infec=1.
*never menstruated - only if no birth in last 5 years.
+ if (UN11C='C' and (sysmis(tsinceb) or tsinceb>=60)) infec=1.

**Box 4.
* Time since last period is >=6 months and not PPA.
+ if (not sysmis(tsincep) & tsincep>=6 & pregPPA<>1) infec=1.

**Box 5.
* menopause/hysterectomy on time since last period.
+ if (UN13N=94) infec=1.
* never menstruated on time since last period, unless had a birth in the last 5 years.
+ if (UN13N=96 & (sysmis(tsinceb) | tsinceb>=60)) infec=1.

**Box 6.
* time since last birth>= 60 months and last period was before last birth.
+ if (UN13N=95 & not sysmis(tsinceb) & tsinceb>=60) infec=1.
* Never had a birth, but last period reported as before last birth - assume code should have been 994 or 996.
+ if (UN13N=95 & sysmis(tsinceb)) infec=1.

**INFECUND - GROUP 3.
+ if (infec=1) unmet=9.

**FECUND WOMEN - GROUP 4.
+ do if sysmis(unmet).
* wants within 2 years or wants soon.
+   if (UN6=1 & UN7U=1 & UN7N<24) unmet=7.
+   if (UN6=1 & UN7U=2 & UN7N<2) unmet=7.
+   if (UN6=1 & UN7N=93) unmet=7.
* wants in 2+ years, wants after marriage, wants undecided timing, or unsure if wants.
+   if (UN6=1 & sysmis(unmet) & UN7N<=90) unmet=1.
+   if (UN6=1 & UN7N=95) unmet=1.
*   if (UN6=1 & UN7N=96) unmet=1.
+   if (UN6=1 & UN7N=98) unmet=1.
+   if (UN6=8) unmet=1.
* wants no more.
+   if (UN6=2) unmet=2.
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
do if (mstatus = 1).
+ recode unmet (1,2=1) (else=0) into unmetnd.
end if.
variable labels unmetnd "Unmet need".

*----------------------------------------------------------------------------------------- Antenatal care coverage .
*** MICS indicator 5.5a; MDG indicator 5.5 - Antenatal care coverage (1+ times, skilled provider).
do if (CM13 = "Y" or CM13 = "O" or CM13 = "S").
+ compute skilledPersonnel = 0.
+ if (any(anc, 11, 12, 13)) skilledPersonnel = 1.
end if.
variable labels skilledPersonnel "Antenatal care coverage (1+ times, skilled provider)".

*** MICS indicator 5.5b; MDG indicator 5.5 - Antenatal care coverage .
do if (CM13 = "Y" or CM13 = "O" or CM13 = "S").
+ compute antenatalCare = 0 .
+ if (MN3 >= 4 and MN3 <= 90) antenatalCare = 1 .
end if.
variable labels antenatalCare "Antenatal care coverage (4+ times, any provider)" .

*----------------------------------------------------------------------------------------- Skilled attendant at delivery .
*** MICS indicator 5.7; MDG indicator 5.2 - Skilled attendant at delivery .
do if (CM13 = "Y" or CM13 = "O" or CM13 = "S").
+ compute skilledAttendant = 0 .
+ if (MN17A = "A" or MN17B = "B") skilledAttendant = 1 .
end if.
variable labels skilledAttendant "Skilled attendant at delivery" .

*----------------------------------------------------------------------------------------- Literacy rate among young women .
*** MICS indicator 7.1; MDG indicator 2.3 - Literacy rate among young women .
do if (wage = 1 or wage = 2).
+ compute literate  = 0.
+ if (WB4 = 2 or WB4 = 3 or WB7 = 3) literate = 1.
end if.
variable labels literate "Literacy rate (young women)".

*----------------------------------------------------------------------------------------- Knowledge about HIV prevention among young women .
*** MICS indicator 9.1; MDG indicator 6.3 - Knowledge about HIV prevention among young women .
include 'define\MICS5 - 10 - HA.sps' .
do if (any(wage, 1, 2) ).
+ compute compknow = 0.
+ if (comprehensiveKnowledge = 100) compknow = 1.
end if.
variable labels compknow "Knowledge about HIV prevention (young women)" .

*----------------------------------------------------------------------------------------- Condom use with non-regular partners .
*** MICS indicator 9.15 - Condom use with non-regular partners .
do if (any(wage, 1, 2) and (SB5 > 2 or SB10 > 2)) .
+ compute usedCondomNonMarital = 0 .
+ if ((SB4 = 1 and SB5 > 2) or
      (SB9 = 1 and SB10 > 2)   ) usedCondomNonMarital = 1 .
end if .
variable labels usedCondomNonMarital "Condom use with non-regular partners" .

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=wmweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = anyMethod unmetnd skilledPersonnel antenatalCare skilledAttendant literate compknow usedCondomNonMarital
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE .

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM MEN.

get file = 'mn.sav'.
sort cases by hh1 hh2 ln.
subgroup.
select if (MWM7 = 1).
compute mnweight = mnweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1 .

*----------------------------------------------------------------------------------------- Literacy rate among young men.
*** MICS indicator 7.1; MDG indicator 2.3 - Literacy rate among young men .
do if (mwage = 1 or mwage = 2).
+ compute literate  = 0.
+ if (MWB4 = 2 or MWB4 = 3 or MWB7 = 3) literate = 1.
end if.
variable labels literate "Literacy rate (young men)".

*----------------------------------------------------------------------------------------- Knowledge about HIV prevention among young men.
*** MICS indicator 9.1; MDG indicator 6.3 - Knowledge about HIV prevention among young men .
include 'define\MICS5 - 10 - HA.M.sps' .
do if (any(mwage, 1, 2) ).
+ compute compknow = 0.
+ if (comprehensiveKnowledge = 100) compknow = 1.
end if.
variable labels compknow "Knowledge about HIV prevention (young men)" .

*----------------------------------------------------------------------------------------- Condom use with non-regular partners (young men).
*** MICS indicator 9.15 - Condom use with non-regular partners .
do if (any(mwage, 1, 2) and (MSB5 > 2 or MSB10 > 2)) .
+ compute usedCondomNonMarital = 0 .
+ if ((MSB4 = 1 and MSB5 > 2) or
      (MSB9 = 1 and MSB10 > 2)   ) usedCondomNonMarital = 1 .
end if .
variable labels usedCondomNonMarital "Condom use with non-regular partners" .

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=mnweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = literate compknow usedCondomNonMarital
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------ VARIABLES FROM CHILDREN'S DATA.

get file = 'hl.sav'.
sort cases by HH1 HH2 HL1.
* create tmp file to check if child slept in the hh last night.
save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL6A
  /rename HL1 = LN.

get file = 'ch.sav'.
sort cases by HH1 HH2 LN.
match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.
subgroup.
select if (UF9 = 1).
compute chweight = chweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*----------------------------------------------------------------------------------------- Underweight Prevalence.
*** MICS indicator 2.1a and MDG indicator 1.8 - Underweight prevalence (moderate and severe) .
*** MICS indicator 2.1b - Underweight prevalence (severe) .

do if (wazflag = 0).
+ recode WAZ2 (sysmis=sysmis) (-2.00 thru hi = 0) (else = 1) into wa2sd.
+ recode WAZ2 (sysmis=sysmis) (-3.00 thru hi = 0) (else = 1) into wa3sd.
else.
+ compute wa2sd = $SYSMIS.
+ compute wa3sd = $SYSMIS.
end if.
variable labels wa2sd "Underweight prevalence (moderate and severe)".
variable labels wa3sd "Underweight prevalence (severe)".

*----------------------------------------------------------------------------------------- Children under age 5 sleeping under insecticide-treated nets (ITNs).
*** MICS indicator 3.18; MDG indicator 6.7 - Children under age 5 sleeping under insecticide-treated nets (ITNs).
do if (HL6A = 1).
+ compute trnet = 0.
+ if (TN5 >=11 and TN5 <= 18) trnet = 1.
+ if (TN5 >=21 and TN5 <= 28 and TN6 <12) trnet = 1.
+ if ((TN5 >= 36 or TN5 = 98) and TN6 <12 and TN8 = 1) trnet = 1.
+ if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) trnet = 1.
end if.

variable labels trnet "Children under age 5 who slept under an ITN".

*----------------------------------------------------------------------------------------- Anti-malarial treatment of children under age 5.
*** MICS indicator 3.22; MDG indicator 6.8 - Anti-malarial treatment of children under age 5.
* Number of children with fever during the last two weeks: CA6A=1.
recode CA6AA (1 = 1) (else = 0) into fever.
variable labels fever "Fever in last two weeks".

* Children given any anti-malarial are: CA13=A-H.
do if (fever = 1).
+ compute okDrug = 0.
+ if (CA13A = "A" or CA13B = "B" or CA13C ="C" or CA13D = "D" or CA13E = "E" or CA13H = "H") okDrug = 1.
end if.
variable labels okDrug "Anti-malarial treatment of children under age 5".

*------------------------------------------------------------------------------------------------------------------ Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=chweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = wa2sd wa3sd trnet okDrug
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.
