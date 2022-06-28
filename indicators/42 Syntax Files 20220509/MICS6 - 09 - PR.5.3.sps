* Encoding: UTF-8.
***.
* v02 - 2020-04-14. variable label "welevel" has been updated. Labels in French and Spanish have been removed.
***.

include "surveyname.sps".
get file ="wm.sav".
sort cases by HH1 HH2 LN.

select if FG2 >= 2.

*adding new codes to FG24 and FG24A as they are not asked to the women who never heard FGM.
compute FG24=4.
save outfile = "fgtemp.sav"
  /keep HH1 HH2 LN  FG1 FG2 FG3 FG4 FG5 FG6 FG7 FG8 FG9 FG10 FG24 WAGEM MSTATUS .

new file. 

get file ="wm.sav".
sort cases by HH1 HH2 LN.

select if FG1 = 1 or FG2 = 1.

save outfile = "fgtemp1.sav"
  /keep HH1 HH2 LN FG2 FG24 WAGEM MSTATUS 
  /rename FG2=FG2X FG24=FG24X.

new file. 

get file ="bh.sav".

sort cases by HH1 HH2 LN BH0.
match files
  /file = *
  /table = 'fgtemp.sav'
  /by HH1 HH2 LN.

compute FGLN=$sysmis.
rename variables BH6= FG15.
compute FG17=2.
compute FG18=$sysmis.
compute FG19=$sysmis.
compute FG20=$sysmis.
compute FG21=$sysmis.
compute FG22 =$sysmis.

select if FG2 >= 2 and BH3 = 2 and BH5 = 1.

save outfile "fgtemp2.sav".
new file. 

get file = "fg.sav".
sort cases by HH1 HH2 LN.

match files
  /file = *
  /table = 'fgtemp1.sav'
  /by HH1 HH2 LN.

add files file = * /file = "fgtemp2.sav".

* select  daughters age 0-14 years .
select if (FG15>= 0 and FG15 <= 14).

weight by wmweight.

compute anyFgm = 0 .
if (FG17 = 1) anyFgm = 100 .
variable labels anyFgm "Percentage of daughters who had any form of FGM [1]" .

do if (FG17 = 1) .
+ compute fgmType = 4 .
+ if (FG19 = 1) fgmType = 1 .
+ if (FG20 = 1) fgmType = 2 .
+ if (FG21 = 1) fgmType = 3 .
end if .
variable labels fgmType "Percent distribution of daughters age 0-14 years who had FGM:".
value labels fgmType
  1 "Had flesh removed"
  2 "Were nicked"
  3 "Were sewn closed"
  4 "Form of FGM/C not determined" .

if (FG17 = 1) numFgm = 1 .
value labels numFgm 1 "Number of daughters age 0-14 years who had FGM" .

compute numWomen = 1 .
value labels numWomen 1 "Number of daughters age 0-14 years" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute motherFgm = 1.
if (FG3 = 1) motherFgm = 2.
variable labels motherFgm "Mother's FGM experience".
value labels motherFgm
  1 "No FGM/C"
  2 "Had FGM/C".

if FG24X>0 FG24=FG24X.
if FG24AX>0 FG24A=FG24AX.
recode FG24 (3,8=8) (else = copy).
variable labels FG24 "Mother's approval for FGM".
value labels FG24
  1 "Continued"
  2 "Discontinued"
  3 "Depends/DK"
  4 "Never heard of FGM"
  9 "Missing".

recode FG15
  (0 thru 4 = 1)
  (5 thru 9 = 2)
  (10 thru 14 = 3)
  (else = 9) into ageDaughter .
variable labels ageDaughter "Age".
value labels ageDaughter
  1 "0-4"
  2 "5-9"
  3 "10-14"
  9 "DK/Missing".

variable labels welevel "Mother's education" .
variable labels disability "Mother's functional difficulties (age 18-49 years)" .

* Ctables command in English.
ctables
  /vlabels variables = numWomen numFgm
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + ageDaughter [c]
        + welevel [c]
        + motherFgm [c]
        + FG24 [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
   by
 	       anyFgm [s] [mean '' f5.1]
         + numWomen [c] [count '' f5.0]
         + fgmType [c] [rowpct.validn '' f5.1]
         + numFgm [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables=fgmType total=yes
  /slabels position=column visible = no
  /titles title=
     "Table PR.5.3: Female genital mutilation (FGM) among girls"
	 "Percentage of daughters age 0-14 years to women age 15-49 years by FGM status and percent distribution of daughters who had FGM by type of FGM, " + surveyname
   caption =
     "[1] MICS indicator PR.11 - Prevalence of FGM among girls"
     "na: not applicable".
  .

new file.

erase file "fgtemp.sav".
erase file "fgtemp1.sav".
erase file "fgtemp2.sav".

