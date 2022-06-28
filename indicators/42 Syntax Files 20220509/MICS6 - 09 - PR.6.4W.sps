* Encoding: windows-1252.
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = "wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

*********robbery*************.
compute layer1=0.
value labels layer1 0 "Percentage of women for whom last incident of robbery was reported to the police".

* Robbery in the last year.
do if (VT1 = 1 and VT2 = 1).
+ compute numwomen1 = 1.
*Reported robbery with no weapon: VT2=1 and VT6=2 and VT8=1 or 2.
+ compute robbery1 = 0.
+ if (VT2 = 1 and VT6 = 2 and (VT8 = 1 or VT8 = 2)) robbery1 = 100.
* Reported robbery with any weapon: VT2=1 and VT6=1 and VT8=1 or 2.
+ compute robbery2 = 0.
+ if (VT2 = 1 and VT6 = 1 and (VT8 = 1 or VT8 = 2)) robbery2 = 100.
* 3. Any robbery reported: VT2=1 and VT8=1 or 2. 
* Note that this includes those responding DK/Don't remember to whether weapon used (VT6=8).
+ compute robbery3 = 0.
+ if (VT2 = 1 and (VT8 = 1 or VT8 = 2)) robbery3 = 100. 
end if.
variable labels numWomen1 "Number of women experiencing robbery in the last year".
variable labels robbery1 "Robbery with no weapon".
variable labels robbery2 "Robbery with any weapon".
variable labels robbery3 "Any robbery".


*********assault*************.
compute layer2=0.
value labels layer2 0 "Percentage of women for whom last incident of assault was reported to the police".

do if (VT9 = 1 and VT10 = 1).
+ compute numwomen2 = 1.
*Reported assault with no weapon: VT10=1 and VT17=2 and VT19=1 or 2. 
+ compute assault1 = 0.
+ if (VT10 = 1 and VT17 = 2 and (VT19 = 1 or VT19 = 2)) assault1 = 100.
+ compute assault2 = 0.
*Reported assault with any weapon: VT10=1 and VT17=1 and VT19=1 or 2.
+ if (VT10 = 1 and VT17 = 1 and (VT19 = 1 or VT19 = 2)) assault2 = 100.
*Any assault reported: VT10=1 and VT19=1 or 2. Note that this includes those responding DK/Don't remember to whether weapon used. 
+ compute assault3 = 0.
+ if (VT10 = 1 and (VT19 = 1 or VT19 = 2)) assault3 = 100. 
end if.
variable labels numWomen2 "Number of women experiencing assault in the last year".
variable labels assault1 "Assault with no weapon".
variable labels assault2 "Assault with any weapon".	
variable labels assault3 "Any assault". 

* create bacground variable.
if (VT8 = 1 and VT2 = 1) or (VT19 = 1 and VT10 = 1) report1=1.
if (VT8 = 2 and VT2 = 1) or (VT19 = 2 and VT10 = 1) report2=2.

value labels report1
1 "Self"
2 "Other".
mrsets   /mcgroup name = $report   label = 'Party reporting crime'  variables = report1 report2.

* MICS indicator 15.2 is calculated as a composite of ""Any robbery reported"" and ""Any assault reported"". 
* It differs from standard computations, as the denominator is the sum of last incidences (VT2=1 + VT10=1). 
* The numerator is the sum of latest incidences reported: ((VT2=1 and VT8=1 or 2) + (VT10=1 and VT19=1 or 2)).".
recode VT2   (1 = 1) (else = 0) into VT2r.
recode VT10 (1 = 1) (else = 0) into VT10r.
compute numWomen3 = (VT2r = 1) + (VT10r = 1).
recode robbery3 (100 = 100) (else = 0) into robbery3r.
recode assault3 (100 = 100) (else = 0) into assault3r.
compute anyRobAssault= robbery3r + assault3r.

* Table Part 1.
* Ctables command in English.
ctables
  /vlabels variables = layer1 layer2  display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c] 
        + $wage [c]
        + welevel [c]
        + $report[c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
      layer1>(
       robbery1[s] [mean  f8.1]+
       robbery2[s] [mean  f8.1]+
       robbery3[s] [mean f8.1])+
       numWomen1[s][sum f8.0]+
      layer2>(
       assault1[s] [mean  f8.1]+
       assault2[s] [mean  f8.1]+
       assault3[s] [mean f8.1])+
       numWomen2[s][sum f8.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.4W: Reporting of robbery and assault in the last one year (women)"											
    "Percentage of women age 15-49 years who experienced robbery in the last year, by type of last robbery, percentage who experienced assault in the last 1 year, " +
     "by type of last assault, and percentage  whose last experience of either robbery or assault was reported to the police, " +surveyname
   caption =
    "[1] MICS indicator PR.13 - Crime reporting; SDG indicator 16.3.1"								
    "[A] This indicator is constructed using both last incidents of robbery and assault, as respondents may have experienced 1) no incident, 2) one last incident of either robbery or assault or 3) both robbery and assault.".

* agregate numberators and denominators for indicator calculations.

aggregate outfile = 'tmp1.sav'
  /break   = total
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp2.sav'
  /break   = hh6
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp3.sav'
  /break   = hh7
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp4.sav'
  /break   = welevel
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp5.sav'
  /break   = disability
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp6.sav'
  /break   = ethnicity
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp7.sav'
  /break   = windex5
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp8.sav'
  /break   = wageAux
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp9.sav'
  /break   = wageAux1
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp10.sav'
  /break   = wageAux2
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp11.sav'
  /break   = report1
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

aggregate outfile = 'tmp12.sav'
  /break   = report2
  /numDen  = sum(numWomen3)
  /numNom = sum(anyRobAssault).

get file = "tmp1.sav".
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'
  /file = 'tmp8.sav'
  /file = 'tmp9.sav'
  /file = 'tmp10.sav'
  /file = 'tmp11.sav'
  /file = 'tmp12.sav'.

value labels report1
1 "Self"
2 "Other".
mrsets   /mcgroup name = $report   label = 'Party reporting crime'  variables = report1 report2.	

mrsets
  /mcgroup name = $wage
           label = 'Age'
           variables = wageAux wageAux1 wageAux2. 

compute indPR13 = numNom / numDen.
variable labels indPR13 "Percentage of women for whom the last incident of physical violence of robbery and/or assault in the last year was reported to the police [1][A]".

variable labels numDen "Number of women experiencing physical violence of robbery or assault in the last year".


* Table 2.
* Ctables command in English.
ctables
  /table  total [c]
        + hh6 [c]
        + hh7 [c] 
        + $wage [c]
        + welevel [c]
        + $report[c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by   
       indPR13[s][mean f8.1] + numDen[s][sum f8.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table PR.6.4W: Reporting of robbery and assault in the last one year (women)"											
    "Percentage of women age 15-49 years who experienced robbery in the last year, by type of last robbery, percentage who experienced assault in the last 1 year, " +
     "by type of last assault, and percentage  whose last experience of either robbery or assault was reported to the police, " +surveyname
   caption =
    "[1] MICS indicator PR.13 - Crime reporting; SDG indicator 16.3.1"								
    "[A] This indicator is constructed using both last incidents of robbery and assault, as respondents may have experienced 1) no incident, 2) one last incident of either robbery or assault or 3) both robbery and assault.".

new file.

erase file "tmp1.sav".
erase file "tmp2.sav".
erase file "tmp3.sav".
erase file "tmp4.sav".
erase file "tmp5.sav".
erase file "tmp6.sav".
erase file "tmp7.sav".
erase file "tmp8.sav".
erase file "tmp9.sav".
erase file "tmp10.sav".
erase file "tmp11.sav".
erase file "tmp12.sav".

