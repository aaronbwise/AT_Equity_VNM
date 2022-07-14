*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM HOUSEHOLD.

get file = 'hh.sav'.
sort cases by HH1 HH2.
subgroup.
select if (HH9 = 1).
compute hhweight = hhweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------------- Iodized salt consumption .

recode SI1 (6=0)  (1,2 = 0) (3 = 1) (else = sysmis) into iodized.
variable label iodized "Iodized salt consumption".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = iodized
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------------- Weight by household members.

compute hhweight = hhweight*HH11.

*------------------------------------------------------------------------------------------------------------------------- Use of improved drinking water sources.

compute improved = 0.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 14 or WS1 = 21 or WS1 = 31 or WS1 = 41 or WS1 = 51) improved = 1.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 14 or WS2 = 21 or WS2 = 31 or WS2 = 41 or WS1 = 51) and WS1 = 91) improved = 1.
variable label improved "Use of improved drinking water sources".

*------------------------------------------------------------------------------------------------------------------------- Use of improved sanitation.
recode WS8 (11,12,13,15,21,22,31 = 1) (else = 2) into type.

recode WS11 (sysmis = 0) (else = 1) into shared.
if (WS10 = 2) shared = 1.

compute imprsan = 0.
if (type = 1 and shared = 0) imprsan = 1.
variable labels imprsan "Use of improved sanitation".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = improved imprsan
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM HOUSEHOLD LISTING.

get file = 'hl.sav'.
subgroup.
compute hhweight = hhweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------------- Secondary school net attendance ratio (adjusted).
* select children who are of secondary school age; this definition is
* country-specific and should be changed to reflect the situation in your country.

do if (schage >= 12 and schage <= 17).
+ compute second  = 0.
+ if (ED6A >= 2 and ED6A <= 3) second =  1.
+ if (schage = 17 and ED4A = 2 and ED4B = 6 and ED5 = 2) second  = 1.
end if.
variable label second "Secondary school net attendance ratio (adjusted)".

*------------------------------------------------------------------------------------------------------------------------- Child labour.

if (HL6 >= 5 and HL6 <= 14) working = 0.
recode CL4 CL6 CL8  (98,99,sysmis = 0) .
if ((HL6 >= 5 and HL6 <= 11) and (CL3=1 or CL3=2 or CL5=1 or CL7=1 or (CL10 >= 28 and CL10 <= 95))) working = 1.
if ((HL6 >= 12 and HL6 <= 14) and ((CL4 + CL6 + CL8 >= 14 or (CL10 >= 28 and CL10 <=95)))) working = 1.
variable label working "Child labour".

*------------------------------------------------------------------------------------------------------------------------- Prevalence of children with at least one parent dead.

do if (HL6 <= 17).
+ compute orphan = 0.
+ if (HL11 = 2 or HL13 = 2) orphan = 1.
end if.
variable label orphan "Prevalence of children with at least one parent dead".

*------------------------------------------------------------------------------------------------------------------------- School attendance of orphans.

do if ((HL6 >= 10 and HL6 <= 14) and (HL11 = 2 and HL13 = 2)).
+ compute schoolo = 0.
+ if (ED5 = 1) schoolo = 1.
end if.
variable label  schoolo "School attendance of orphans".

*------------------------------------------------------------------------------------------------------------------------- School attendance of non-orphans.

do if ((HL6 >= 10 and HL6 <= 14) and (HL11 = 1 and HL13 = 1 and (HL12 <> 0 or HL14 <> 0))).
+ compute schoolno = 0.
+ if (ED5 = 1) schoolno = 1.
end if.
variable label  schoolno "School attendance of non-orphans".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = second working orphan schoolo schoolno
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.


*------------------------------------------------------------------------------------------------------------------------- For violant discipline weight by number of children 2-14 in the household.

get file = 'hh.sav'.
subgroup.
select if (HH9 = 1).
compute hhweight = hhweight*CD6*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------------- Child discipline.

do if (not sysmis(CD11)).
+ compute punish = 0.
+ if (CD14 = 1 or CD18 = 1) punish = 1.
+ if (CD13 = 1 or CD16 = 1 or CD17 = 1 or CD19 = 1 or CD20 = 1 or CD21 = 1) punish = 1.
end if.
variable label punish "Child discipline".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.
CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=hhweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = punish
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------------- Include variable needed for calcualtion of pregnant women sleeping under insecticide-treated nets (ITNs).
get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL10
  /rename HL1 = LN.

*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM WOMEN.

get file = 'wm.sav'.
sort cases by hh1 hh2 ln.
match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.
subgroup.
select if (WM7 = 1).
compute wmweight = wmweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------------- Pregnant women.

compute pregn = 0.
if (CP1 = 1) pregn = 1.
variable label pregn "Pregnant women".

*------------------------------------------------------------------------------------------------------------------------- Pregnant women sleeping under insecticide-treated nets (ITNs).

do if (CP1 = 1 and HL10 = 1).

+ compute itnwom = 0.
+ if (TN5 >=11 and TN5 <= 18) itnwom = 1.
+ if (TN5 >=21 and TN5 <= 28 and TN6 <12) itnwom = 1.
+ if ((TN5 >= 31 or TN5 = 98) and TN6 <12 and TN8 = 1) itnwom = 1.
+ if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) itnwom = 1.

end if.

variable label itnwom "Pregnant women sleeping under insecticide-treated nets (ITNs)".

*------------------------------------------------------------------------------------------------------------------------- Intermittent preventive treatment for malaria.

do if (MN2A = "A" or MN2B = "B" or MN2C = "C").
+ compute spmore = 0.
+ if (MN14A = "A" and MN16 >= 2 and MN16 < 97) spmore = 1.
end if.

variable label spmore "Intermittent preventive treatment for malaria".

*------------------------------------------------------------------------------------------------------------------------- Early childbearing.

do if (WB2 >=20 and WB2 <=24).
+ compute brth18 = 0.
+ if ((wdobfc - wdob)/12 < 18) brth18 = 1.
end if.
variable label brth18 "Early childbearing".

*------------------------------------------------------------------------------------------------------------------------- Contraceptive prevalence.

do if (mstatus = 1).
+ compute anymeth = 0.
+ if (CP2 = 1) anymeth = 1.
end if.
variable label anymeth "Contraceptive prevalence".

*------------------------------------------------------------------------------------------------------------------------- Unmet need.

* Select only married or in union women.
do if (mstatus = 1).

* Get the most effective method from the list (will be the first given).
+ compute method = 99.
+ if (CP3X = "X") method = 14.
+ if (CP3M = "M") method = 13.
+ if (CP3L = "L") method = 12.
+ if (CP3K = "K") method = 11.
+ if (CP3I = "I" or CP3J = "J") method = 9.
+ if (CP3H = "H") method = 8.
+ if (CP3G = "G") method = 7.
+ if (CP3F = "F") method = 6.
+ if (CP3E = "E") method = 5.
+ if (CP3D = "D") method = 4.
+ if (CP3C = "C") method = 3.
+ if (CP3B = "B") method = 2.
+ if (CP3A = "A") method = 1.

* If pregnant or state they are not using, set method to 0.
+ if (CP1 = 1 or CP2 = 2) method = 0.

* Current users of contraception.
+ compute usemeth = 0.
+ if (method <> 0) usemeth = 100.
+ variable label usemeth "Current use of contraception".

* Amenorrheic women.
+ compute amenor = 0.
+ if (CM13 = "Y" and CP1 <> 1 and MN23 = 2) amenor = 1.
+ variable label amenor "Postpartum amenorrheic women".

* Pregnant women.
+ compute preg = 0.
+ if (CP1 = 1) preg = 1.
+ variable label preg "Pregnant women".

* Continuously married for the past 5 years.
+ compute m5yrs = 0.
+ if (mstatus = 1 and MA7 = 1 and (wdoi - wdom) >= 60) m5yrs = 1.
+ variable label m5yrs "Continuously married for the past 5 years".

* No birth in the past 5 years.
+ compute nob5yrs = 0.
+ if (CM10 = 0 or (wdoi - wdoblc) >= 60) nob5yrs = 1.
+ variable label nob5yrs "No birth in past 5 years".

* Check for other fecund women.
do if (preg = 0 and amenor = 0).
+ compute fecund = 1.
+ if (UN13U = 4 or (UN13U = 3 and UN13N > 6) or (UN13U = 9 and UN13N>= 94 and UN13N<=96)) fecund = 0.
+ if (UN11B = "B" or UN11C = "C" or UN11D = "D" or UN11E="E") fecund = 0.
+ if (UN6 = 3 or (UN7U = 9 and UN7N = 94)) fecund = 0.
+ if (usemeth = 0 and nob5yrs = 1 and m5yrs = 1) fecund = 0.
end if.

* Met and unment need for spacing and limiting.
+ compute metspc = 0.
+ compute metlmt = 0.
+ compute met = 0.

+ compute space  = 0.
+ compute limit  = 0.
+ compute unmet = 0.

* Current users - calculate met need for spacing and limiting.
do if (usemeth = 100).
+ if (UN6 = 2) metlmt = 100.
+ if (method = 1 or method = 2) metlmt = 100.
+ if (UN6 = 3) metlmt = 100.
+ if (UN6 = 1 and UN7U = 9 and UN7N = 94) metlmt = 100.
+ if (UN6 = 1 and metlmt = 0) metspc = 100.
+ if (UN6 = 8 or UN6 = 9) metspc = 100.
* Total met need.
if (metspc = 100 or metlmt = 100) met = 100.
* Calculate unment need for spacing and limiting.
* Pregnant women.
else if (preg = 1).
+ if (UN3 = 1) space = 100.
+ if (UN3 = 2 and UN4 = 1) space = 100.  /* Added to allow for women changing their minds about the future.
+ if (UN3 = 2 and UN4 <> 1) limit = 100. 
+ if (UN3 = 9) space = 100.                     /* Assume missing is treated as a spacer.
* Amenorrheic women.
else if (amenor = 1).
+ if (DB2 = 1) space = 100.
+ if (DB2 = 2 and UN6 = 1) space = 100.  /* Added to allow for women changing their minds about the future.
+ if (DB2 = 2 and UN6 <> 1) limit = 100. 
+ if (DB2 = 9) space = 100.                     /* Assume missing is treated as a spacer.
* Other fecund women.
else if (fecund = 1).
+ if (UN7U = 1 and UN7N >= 24 and UN7N < 90)  space = 100.
+ if (UN7U = 2 and UN7N >= 2 and UN7N < 90)  space = 100.
+ if (UN7U = 9 and UN7N = 95) space = 100.
+ if (UN6 = 8) space = 100.
+ if (UN6 = 2) limit = 100.
end if.

* Total unmet need.
if (space = 100 or limit = 100) unmet = 1.

end if.

variable label unmet "Unmet need".

*------------------------------------------------------------------------------------------------------------------------- Antenatal care.

do if (CM13 = "Y").
+ compute ancskill = 0.
+ if (MN2A = "A" or MN2B = "B" or MN2C = "C") ancskill = 1.
end if.
variable label ancskill "Antenatal care coverage - at least once by skilled personnel".

*------------------------------------------------------------------------------------------------------------------------- Antenatal care - 4 + visits.

do if (CM13 = "Y").
+ compute novisits = 0.
+ if (MN3 >= 4 and MN3 < 97) novisits = 1.
end if.
variable label novisits "Antenatal care coverage - at least four times by any provider".

*------------------------------------------------------------------------------------------------------------------------- Skilled attendant at delivery.

do if (CM13 = "Y").
+ compute skilled = 0.
+ if (MN17A = "A" or MN17B = "B" or MN17C = "C") skilled = 1.
end if.
variable label skilled "Skilled attendant at delivery".

*------------------------------------------------------------------------------------------------------------------------- Institutional deliveries.

do if (CM13 = "Y").
+ compute instdlv = 0.
+ if ((MN18 >= 21 and MN18 <= 26) or (MN18 >= 31 and MN18 <= 36)) instdlv = 1.
end if.
variable label instdlv "Institutional deliveries".

*------------------------------------------------------------------------------------------------------------------------- Caesarean section.

do if (CM13 = "Y").
+ recode MN19 (1 = 1) (else = 0) into csection.
end if.
variable label csection "Caesarean section".

*------------------------------------------------------------------------------------------------------------------------- Literacy rate among young women.

do if (WB2 >= 15 and WB2 <= 24).
+ compute literate  = 0.
+ if (WB4 = 2 or WB4 = 3 or WB4 = 4 or WB4 = 5 or WB7 = 3) literate = 1.
end if.
variable label literate "Literacy rate among young women".

*------------------------------------------------------------------------------------------------------------------------- Marriage before age 18.

do if (WB2 >= 20 and WB2 <= 49).
+ compute agem18 = 0.
+ if (wagem < 18) agem18 = 1.
end if.
variable label agem18 "Marriage before age 18".

*------------------------------------------------------------------------------------------------------------------------- Polygyny.

do if (MA1 = 1 or MA1 = 2).
+ compute polyg  = 0.
+ if (MA3 = 1) polyg  = 1.
end if.
variable label polyg "Polygyny".

*------------------------------------------------------------------------------------------------------------------------- Prevalence of female genital mutilation/cutting (FGM/C) among women.

compute fgm = 0.
if (FG3 = 1) fgm = 1.
variable label fgm "Prevalence of female genital mutilation/cutting (FGM/C) among women".

*------------------------------------------------------------------------------------------------------------------------- Comprehensive knowledge about HIV prevention among young people.

do if (WB2 >= 15 and WB2 <=24).
+ compute comprey = 0.
+ if ((HA2 = 1 and HA4 = 1) and (HA5 = 2 and HA6 = 2 and HA7 = 1)) comprey = 1.
end if.
variable label comprey "Comprehensive knowledge about HIV prevention among young people".

*------------------------------------------------------------------------------------------------------------------------- Knowledge of mother-to-child transmission of HIV.

compute knowmtct = 0.
if (HA8A = 1 and HA8B = 1 and HA8C = 1) knowmtct = 1.
variable label knowmtct "Knowledge of mother-to-child transmission of HIV".

*------------------------------------------------------------------------------------------------------------------------- Accepting attitudes towards people living with HIV.

do if (HA1 = 1).
+ compute accept = 0.
+ if (HA9 = 1 and HA10 = 1 and HA11 = 2 and HA12 = 1) accept = 1.
end if.
variable label accept "Accepting attitudes towards people living with HIV".

*------------------------------------------------------------------------------------------------------------------------- Women who have been tested for HIV during last 12 months and who have been told the results.

compute tested = 0.
if ((HA23 = 1 and (HA17 = 1 or HA21 = 1)) or (HA25 = 1 and HA26 = 1)) tested = 1.
variable labels tested "Women who have been tested for HIV during last 12 months and who have been told the results".

*------------------------------------------------------------------------------------------------------------------------- Sexually active young women who have been tested for HIV and know the results.

do if ((wage = 1 or wage = 2) and SB1<> 0 and SB3U < 4).
+ compute tested12 = 0.
+ if (HA23 = 1 or HA25 = 1) tested12 = 100.

+ compute results = 0.
+ if (tested12 = 100 and (HA24 = 1  or  HA26 = 1)) results = 1.
end if.
variable label results "Sexually active young women who have been tested for HIV and know the results".

*------------------------------------------------------------------------------------------------------------------------- Sex before age 15 among young women .

do if (wage = 1 or wage = 2).
+ compute sex15 = 0.
+ if (SB1 <> 0 and SB1 < 15) sex15 = 1.
+ if (SB1 = 95 and wagem >= 4 and wagem < 15) sex15 = 1.
end if.
variable label sex15 "Sex before age 15 among young women".

*------------------------------------------------------------------------------------------------------------------------- Condom use with non-regular partners.

do if (SB1 <> 0 and SB3U >= 1 and SB3U <= 3).
+ compute nhpart = 0.
+ if (((SB5 >= 3 and SB5 <=6) or (SB10 >= 3 and SB10 <=6))) nhpart = 100.
end if.

variable label nhpart "Percentage who had sex with a non-marital, non-cohabiting partner in the last 12 months".

do if (nhpart = 100 and (wage = 1 or wage = 2)).
+ compute condom = 0.
+ if ((SB5 = 3 or SB5 = 4 or SB5 = 6) and SB4 = 1) condom = 1.
+ if ((SB10 = 3 or SB10 = 4 or SB10 = 6) and SB9 = 1) condom = 1.
end if.
variable label condom "Condom use with non-regular partners".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=wmweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = pregn itnwom spmore brth18 anymeth unmet ancskill novisits skilled instdlv csection literate agem18 polyg
		      fgm comprey knowmtct accept tested results sex15 condom
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

erase file = "tmp.sav".

*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM FEMALE GENITAL CUTTING DATA.

get file = 'fg.sav'.
subgroup.
compute wmweight = wmweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.

*------------------------------------------------------------------------------------------------------------------------- Prevalence of female genital mutilation/cutting (FGM/C) among girls.

compute fgmd = 0.
if (FG15 = 1) fgmd = 1.
variable label fgmd "Prevalence of female genital mutilation/cutting (FGM/C) among girls".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=wmweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = fgmd
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

*------------------------------------------------------------------------------------------------------------------------- Include variable needed for calcualtion of children sleeping under insecticide-treated nets (ITNs).
get file = 'hl.sav'.

sort cases by HH1 HH2 HL1.

save outfile = "tmp.sav"
  /keep HH1 HH2 HL1 HL10
  /rename HL1 = LN.

*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM CHILDRENS DATA.

get file = 'ch.sav'.
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

*------------------------------------------------------------------------------------------------------------------------- Underweight Prevalence.

do if (wazflag = 0).
+ recode WAZ2 (-2.00 thru hi = 0) (else = 1) into wa2.
else.
+ compute wa2 = 9.
end if.
if (wazflag ne 0)  wa2 = 9.

variable label wa2 "Underweight prevalence".
missing values wa2 (9).

*------------------------------------------------------------------------------------------------------------------------- Stunting Prevalence.

do if (hazflag = 0).
+ recode HAZ2 (-2.00 thru hi = 0) (else = 1) into ha2.
else.
+ compute ha2 = 9.
end if.
if (hazflag ne 0)  ha2 = 9.

variable label ha2 "Stunting prevalence".
missing values ha2 (9).

*------------------------------------------------------------------------------------------------------------------------- Wasting Prevalence.

do if (whzflag = 0).
+ recode WHZ2 (-2.00 thru hi = 0) (else = 1) into wh2.
else.
+ compute wh2 = 9.
end if.
if (whzflag ne 0)  wh2 = 9.

variable label wh2 "Wasting prevalence".
missing values wh2 (9).

*------------------------------------------------------------------------------------------------------------------------- Exclusive breastfeeding under 6 months.

do if (cage >= 0 and cage <= 5).
+ compute exbf5 = 0.
+ if (BF2 = 1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 & 
  BF12<> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) exbf5 = 1.
end if.
variable label exbf5 "Exclusive breastfeeding under 6 months".

*------------------------------------------------------------------------------------------------------------------------- Age-appropriate Breastfeeding.

do if (cage >= 0 and cage <= 23).
+ compute approp = 0.
+ if (cage >= 0 and cage <= 5 and (BF2 = 1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 & 
  BF12<> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1))) approp = 1.
+ if (cage >=6 and cage <=23 and BF2 = 1 and BF16 = 1) approp = 1.
end if.
variable label approp "Age-appropriate breastfeeding".

*------------------------------------------------------------------------------------------------------------------------- Immunizations.

include file = "MICS4 - 04 - CH.01 RECODE.sps".

*Please change the expression below to 18 and 29 months if you are calculating vaccinations tables CH.02 for children 18-29 months.

do if (cage >= 12 and cage <= 23).
+ recode bcg (1,2 = 1) (3 = 0) into bcg_r.
+ recode polio3 (1,2 = 1) (3 = 0) into polio3_r.
+ recode dpt3 (1,2 = 1) (3 = 0) into dpt3_r.
+ recode measles (1,2 = 1) (3 = 0) into meales_r.
+ recode hepb3 (1,2 = 1) (3 = 0) into hepb_r.
end if.
variable label bcg_r "Tuberculosis immunization coverage".
variable label polio3_r "Received polio immunization".
variable label dpt3_r "Received DPT immunization".
variable label meales_r "Received measles immunization".
variable label hepb_r "Received Hepatitis B immunization".

*------------------------------------------------------------------------------------------------------------------------- Antibiotic treatment of suspected pneumonia.
* Suspected pneumonia in the last 2 weeks.

compute ari  = 0.
if (CA7 = 1 and CA8 = 1 and (CA9 = 1 or CA9 = 3)) ari = 1.
variable label ari "Illness with cough in the previous 2 weeks".

do if (ari = 1).
+ compute anti = 0.
+ if (CA13A = "A" or CA13B = "B") anti = 1.
end if.
variable label anti "Antibiotic treatment of suspected pneumonia".

*------------------------------------------------------------------------------------------------------------------------- Received ORT or increased fluids, and continued feeding.
* Diarrhoea in last 2 weeks.

recode CA1 (1 = 1) (else = 0) into diarrhea.
variable label diarrhea "Diarrhoea in last two weeks".

do if (diarrhea = 1).
+ compute orifcf = 0.
+ if (((CA4A = 1 or CA4B = 1 or CA4C = 1 or CA4D = 1 or CA4E = 1) or CA2 = 4) and (CA3 = 2 or CA3 = 3 or CA3 = 4)) orifcf = 1.
end if.
variable label orifcf "Oral rehydration therapy with continued feeding".


*------------------------------------------------------------------------------------------------------------------------- Children under age 5 sleeping under insecticide-treated nets (ITNs).

do if (HL10 = 1).
+ compute trnet = 0.
+ if (TN5 >=11 and TN5 <= 18) trnet = 1.
+ if (TN5 >=21 and TN5 <= 28 and TN6 <12) trnet = 1.
+ if ((TN5 >= 31 or TN5 = 98) and TN6 <12 and TN8 = 1) trnet = 1.
+ if (TN5 >= 21 and TN5 <=98 and TN9 = 1 and TN10 < 12) trnet = 1.
end if.

variable label trnet "Children under age 5 sleeping under insecticide-treated nets (ITNs)".

*------------------------------------------------------------------------------------------------------------------------- Anti-malarial treatment of children under age 5.

recode ML1 (1 = 1) (else = 0) into fever.
variable label fever "Fever in last two weeks".

do if (fever = 1).
+ compute approp1 = 0.
+ if (ML6A = "A" or ML9A = "A") approp1 = 1.
+ if (ML6B = "B" or ML9B = "B") approp1 = 1.
+ if (ML6C = "C" or ML9C = "C") approp1 = 1.
+ if (ML6D = "D" or ML9D = "D") approp1 = 1.
+ if (ML6E = "E" or ML9E = "E") approp1 = 1.
+ if (ML6H = "H" or ML9H = "H") approp1 = 1.
+ compute okdrug = 0.
+ if (approp1 = 1 and ML11 >= 0 and ML11 <= 1) okdrug = 1.
end if.
variable label okdrug "Anti-malarial treatment of children under age 5".

*------------------------------------------------------------------------------------------------------------------------- Support for learning.

do if (cage>=36).
+ compute activity = 0.
+ if (EC7AA = "A" or EC7AB = "B" or EC7AX = "X") activity = activity + 1.
+ if (EC7BA = "A" or EC7BB = "B" or EC7BX = "X") activity = activity + 1.
+ if (EC7CA = "A" or EC7CB = "B" or EC7CX = "X") activity = activity + 1.
+ if (EC7DA = "A" or EC7DB = "B" or EC7DX = "X") activity = activity + 1.
+ if (EC7EA = "A" or EC7EB = "B" or EC7EX = "X") activity = activity + 1.
+ if (EC7FA = "A" or EC7FB = "B" or EC7FX = "X") activity = activity + 1.

+ compute activ4  = 0.
+ if (activity >= 4) activ4 = 1.

end if.
variable label activity "Mean number of activities household members engage in with the child".
variable label activ4 "Support for learning".

*------------------------------------------------------------------------------------------------------------------------- Attendance to early childhood education.

do if (cage >= 36 and cage <= 59).
+ recode EC5 (1 = 1) (else = 0) into ecep.
end if.
variable label ecep "Attendance to early childhood education".

*------------------------------------------------------------------------------------------------------------------------- Birth registration.

compute regist = 0.
if (BR1 = 1 or BR1 = 2 or BR2 = 1) regist = 1.
variable label regist "Birth registration".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=chweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = wa2 ha2 wh2 exbf5 approp bcg_r polio3_r dpt3_r meales_r hepB_r diarrhea ari fever orifcf anti trnet okdrug activ4 ecep regist
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

erase file = "tmp.sav".
*------------------------------------------------------------------------------------------------------------------------- VARIABLES FROM MEN.

get file = 'mn.sav'.
sort cases by hh1 hh2 ln.
match files 
  /file=*
  /table='tmp.sav'
  /by hh1 hh2 ln.
subgroup.
select if (MWM7 = 1).
compute mnweight = mnweight*1000000.
match files
  /file = *
  /table = 'pairs.sav'
  /by HH1.


*------------------------------------------------------------------------------------------------------------------------- Literacy rate among young men.

do if (MWB2 >= 15 and MWB2 <= 24).
+ compute mliterate  = 0.
+ if (MWB4 = 2 or MWB4 = 3 or MWB4 = 4 or MWB4 = 5 or MWB7 = 3) mliterate = 1.
end if.
variable label mliterate "Literacy rate among young men".

*------------------------------------------------------------------------------------------------------------------------- Marriage before age 18.

do if (MWB2 >= 20 and MWB2 <= 49).
+ compute magem18 = 0.
+ if (magem < 18) magem18 = 1.
end if.
variable label magem18 "Marriage before age 18".

*------------------------------------------------------------------------------------------------------------------------- Polygyny.

do if (MMA1 = 1 or MMA1 = 2).
+ compute mpolyg  = 0.
+ if (MMA3 = 1) mpolyg  = 1.
end if.
variable label mpolyg "Polygyny".

*------------------------------------------------------------------------------------------------------------------------- Comprehensive knowledge about HIV prevention among young men.

do if (MWB2 >= 15 and WMB2 <=24).
+ compute mcomprey = 0.
+ if ((MHA2 = 1 and MHA4 = 1) and (MHA5 = 2 and MHA6 = 2 and MHA7 = 1)) mcomprey = 1.
end if.
variable label mcomprey "Comprehensive knowledge about HIV prevention among young men".

*------------------------------------------------------------------------------------------------------------------------- Knowledge of mother-to-child transmission of HIV.

compute mknowmtct = 0.
if (MHA8A = 1 and MHA8B = 1 and MHA8C = 1) mknowmtct = 1.
variable label mknowmtct "Knowledge of mother-to-child transmission of HIV".

*------------------------------------------------------------------------------------------------------------------------- Accepting attitudes towards people living with HIV.

do if (MHA1 = 1).
+ compute maccept = 0.
+ if (MHA9 = 1 and MHA10 = 1 and MHA11 = 2 and MHA12 = 1) maccept = 1.
end if.
variable label maccept "Accepting attitudes towards people living with HIV".

*------------------------------------------------------------------------------------------------------------------------- Men who have been tested for HIV during last 12 months and who have been told the results.

compute mtested = 0.
if (MHA25 = 1 and MHA26 = 1) mtested = 1.
variable labels mtested "Men who have been tested for HIV during last 12 months and who have been told the results".

*------------------------------------------------------------------------------------------------------------------------- Sexually active young men who have been tested for HIV and know the results.

do if ((mage = 1 or mage = 2) and MSB1<> 0 and MSB3U < 4).
+ compute tested12 = 0.
+ if (MHA25 = 1) mtested12 = 100.

+ compute mresults = 0.
+ if (mtested12 = 100 and (MHA24 = 1  or  MHA26 = 1)) mresults = 1.
end if.
variable label mresults "Sexually active young men who have been tested for HIV and know the results".

*------------------------------------------------------------------------------------------------------------------------- Sex before age 15 among young men .

do if (mage = 1 or mage = 2).
+ compute msex15 = 0.
+ if (MSB1 <> 0 and MSB1 < 15) msex15 = 1.
+ if (MSB1 = 95 and magem >= 4 and magem < 15) msex15 = 1.
end if.
variable label msex15 "Sex before age 15 among young men".

*------------------------------------------------------------------------------------------------------------------------- Condom use with non-regular partners.

do if (MSB1 <> 0 and MSB3U >= 1 and MSB3U <= 3).
+ compute mnhpart = 0.
+ if (((MSB5 >= 3 and MSB5 <=6) or (MSB10 >= 3 and MSB10 <=6))) mnhpart = 100.
end if.

variable label mnhpart "Percentage who had sex with a non-marital, non-cohabiting partner in the last 12 months".

do if (mnhpart = 100 and (mage = 1 or mage = 2)).
+ compute mcondom = 0.
+ if ((MSB5 = 3 or MSB5 = 4 or SB5 = M6) and MSB4 = 1) mcondom = 1.
+ if ((MSB10 = 3 or MSB10 = 4 or MSB10 = 6) and MSB9 = 1) mcondom = 1.
end if.
variable label mcondom "Condom use with non-regular partners".

*------------------------------------------------------------------------------------------------------------------------- Male circumcision.

compute mcirc = 0.
if MMC1 = 1  mcirc = 1.
variable label mcirc "Male circumcision".

*------------------------------------------------------------------------------------------------------------------------- Calculate sampling errors.

CSPLAN ANALYSIS
 /PLAN FILE='micsplan.csplan'
 /PLANVARS ANALYSISWEIGHT=mnweight
 /DESIGN  STRATA= strat  CLUSTER= HH1
 /ESTIMATOR TYPE=WR.

* Complex Samples Descriptives.
CSDESCRIPTIVES
 /PLAN FILE = 'micsplan.csplan'
 /SUMMARY VARIABLES = mliterate magem18 mpolyg
		      mcomprey mknowmtct maccept mtested mresults msex15 mcondom mcirc
 /MEAN
 /STATISTICS SE CV COUNT POPSIZE DEFF DEFFSQRT
 /MISSING SCOPE = ANALYSIS CLASSMISSING = EXCLUDE.

erase file = "tmp.sav".


