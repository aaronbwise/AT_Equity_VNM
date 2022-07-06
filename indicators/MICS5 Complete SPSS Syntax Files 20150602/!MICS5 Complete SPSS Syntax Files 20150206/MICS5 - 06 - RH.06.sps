* MICS5 RH-06.

* v01 - 2014-03-19.
* v02 - 2014-04-22.
* include surveyname added.

* Women with an unmet need for contraception are women who are married or in a marital union who are fecund but are not using any method of 
  contraception, and report not wanting any more children (limiting) or wanting to delay the next child (spacing). 
* All women using contraception are considered to have met need. 
* The table is based on all women who are married or in a marital union; infecund women are included in the denominator, but are considered in 
  the met or unmet need categories. 

* Contraceptive users (women with met need) are further divided into the following two categories:
    (1) Met need for limiting includes women who are using a contraceptive method (CP2=1) and 
          (a) who want no more children (UN6=2), 
          (b) are using male or female sterilization (CP3=""A"" or ""B""), or 
          (c) declare themselves as infecund (UN6=3 or UN7=994)
    (2) Met need for spacing includes women who are using a contraceptive method (CP2=1) and 
          (a) who want to have another child (UN6=1) or 
          (b) undecided whether to have another child (UN6=8) . 

* Unmet need for spacing is defined as the percentage of currently women who are not using a method of contraception (CP2<>1) and
    (a) are pregnant (CP1=1) and say that the pregnancy was mistimed and would have wanted to wait (CP1=1 and UN3=1)
    (b) are postpartum amenorrheic (had a birth in last two years (CM13=“Y”) and is not currently pregnant (CP1<>1), 
        and whose menstrual period has not returned since the birth of the last child (MN23=2))) and say that the birth was mistimed: 
        would have wanted to wait (DB2=1)
    (c) are not pregnant and not postpartum amenorrheic and are fecund and say they want to wait two or more years for their next 
        birth (UN7>=2 years) OR
    (d) are not pregnant and not postpartum amenorrheic and are fecund and unsure whether they want another child (UN6=8) 

* For the estimation of postpartum amenorrheic women in cases data on last period are not available is constructed from information from the 
  time since last birth and last period: women are considered postpartum amenorrheic if 
    (a) last period is before last birth in last 5 years or 
    (b) if stated "before last birth" to the question on time since last period in the last 5 years .

* Unmet need for limiting is defined as the percentage of women who are not using a method of contraception (CP2<>1) and
    (a) are not pregnant and not postpartum amenorrheic and are fecund and say they do not want any more children (UN6=2), 
    (b) are pregnant (CP1=1) and say they didn't want to have a child (UN3=2), or
    (c) are postpartum amenorrheic and say that they didn't want the birth: (P/A and DB1=2).

* A woman is considered infecund if she is neither pregnant (CP1<>1) nor postpartum amenorrheic, and:
    (1) (a) has not had menstruation for at least six months, 
        (b) never menstruated, 
        (c) her last menstruation occurred before her last birth, or 
        (d) is in menopause or has had hysterectomy (UN13>6 months or UN13=994 or UN13=995 or UN13=996)
    (2) She declares that she has had hysterectomy, or that she has never menstruated or that she is menopausal, 
         or that she has been trying to get pregnant for 2 or more years without result in response to questions on why she thinks she is 
         not physically able to get pregnant at the time of survey (UN11=""B"" OR UN11=""C"" or UN11=""D"" or UN11=""E"")
    (3) She declares she cannot get pregnant when asked about desire for future birth (UN6 = 3 or UN7 = 994)
    (4) She has not had a birth in the preceding 5 years (WM6-CM12>5 years), never used contraception (CP2A<>1) and is currently married and 
        was continuously – not included - married during the last 5 + years (MA1=1 or 2 and MA7=1 and WM6-MA8>5 years or WB2-MA9>5).

* Percentage of demand satisfied is defined as the proportion of women currently married or in a marital union (MA1=1 or 2) 
  who are currently using contraception (CP2=1) of the total demand for contraception (total unmet need plus current contraceptive use).

***.

get file='wm.sav'.

include "surveyname.sps".

* Complete interviews only.
select if (WM7=1).

* Create unmet variable.
* First set it to system missing.
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
* ”Alternative” Box 1 when ever-use of contraception is missing.
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
recode unmet (1,2=1) (else=0) into unmettot.
variable labels unmettot "Unmet need for family planning".
value labels unmettot 1 "unmet need" 0  "no unmet need".
formats unmet unmettot (f1.0).

**TABULATE RESULTS.
weight by wmweight.

**married.
*use all.
*compute filter_$=(mstatus=1).
*filter by filter_$.
*frequencies unmet, unmettot.

**all women.
*use all.
*frequencies unmet, unmettot.

**sexually active unmarried.
* use all.
* compute filter_$=(mstatus<>1 & sexact=1).
* filter by filter_$.
*frequencies unmet, unmettot.

use all.
compute metspc = 100*(unmet=3).
compute metlmt = 100*(unmet=4).
compute met    = 100*(unmet=3 or unmet=4).
compute space  = 100*(unmet=1).
compute limit  = 100*(unmet=2).
compute unmetnd = 100*(unmet=1 or unmet=2).

variable labels metspc "For spacing".
variable labels metlmt "For limiting".
variable labels met "Total".

variable labels space "For spacing".
variable labels limit "For limiting".
variable labels unmetnd "Total [1]".

compute total = 1.
value labels total 1 "Number of women currently married or in union".

compute tot = 1.
value labels tot 1 'Total'.

* Percentage of demand satisfied.
do if (unmet >=1 and unmet <= 4).
+ compute satisf = 0.
+ if (unmet=3 or unmet=4) satisf = 100.
+ compute totneed = 1.
end if.

variable labels satisf "Percentage of demand for contraception satisfied".
value labels totneed 1 "Number of women currently married or in union with need for contraception".

compute lay1 = 0.
compute lay2 = 0.
value labels
  lay1 0 "Met need for contraception"
 /lay2 0 "Unmet need for contraception".

use all.
compute filter_$=(mstatus=1).
filter by filter_$.

ctables
  /vlabels variables=total totneed lay1 lay2 display=none
  /table  tot [c] + hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] by
  	lay1 [c] > (metspc [s] [mean,'',f5.1] + metlmt [s] [mean,'',f5.1] + met [s] [mean,'',f5.1]) +
  	lay2 [c] > (space [s] [mean,'',f5.1] + limit [s] [mean,'',f5.1] + unmetnd [s] [mean,'',f5.1]) +
                  total [c] [count,'',comma5.0] + satisf [s] [mean,'',f5.1] + totneed [c] [count,'',comma5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Table RH.6: Unmet need for contraception"
  		"Percentage of women age 15-49 years currently married or in union with an unmet need for "
		"family planning and percentage of demand for contraception satisfied, " + surveyname
  caption=
	"[1] MICS indicator 5.4; MDG indicator 5.6 - Unmet need".

																
new file.
