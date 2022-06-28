* Encoding: UTF-8.
***.

* v02 - 2019-08-27. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.

get file='wm.sav'.

include "CommonVarsWM.sps".

* definitions of contraceptiveMethod .
include 'define\MICS6 - 06 - TM.sps' .

include "surveyname.sps".

* Complete interviews only.
select if (WM17=1).

* Create unmet variable.
* First set it to system missing.
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
if (sysmis(unmet) & mstatus<>1 & sexact<>1) unmet=97 .

**DETERMINE FECUNDITY - GROUP 4.
**Boxes 1-4 only apply to women who are not pregnant and not PPA<24 months.
do if (sysmis(unmet) & CP1<>1 & pregPPA24<>1).
+ compute infec=0.

**Box 1 - applicable only to currently married.
* married 5+ years ago, no children in past 5 years, never used contraception.
+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & CP3<>1) infec=1 .
* ”Alternative” Box 1 when ever-use of contraception is missing.
*+ if (mstatus=1 & wdoi-wdom>=60 & (sysmis(tsinceb) | tsinceb>=60) & (UN12E='E' or UN12H='H')) infec=1 .

**Box 2.
* declared infecund on future desires for children.
+ if (UN7=3 or UN8N=94) infec=1.

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

compute total = 1.
value labels total 1 "Number of sexually active [A] women currently unmarried or not in union".

compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

* Percentage of demand satisfied.
do if (unmet >=1 and unmet <= 4).
+ compute satisf = 0.
+ if (unmet=3 or unmet=4) satisf = 100.
+ compute satisfM = 0.
+ if (unmet=3 or unmet=4) and (contraceptiveMethod >= 1 and contraceptiveMethod <= 11) satisfM = 100.
+ compute totneed = 1.
end if.

variable labels satisf "Any method".
variable labels satisfM "Modern methods".
value labels totneed 1 "Number of sexually active [A] women currently unmarried or not in union with need for family planning".
compute lay1 = 0.
compute lay2 = 0.
compute lay3 = 0.
compute lay4 = 0.
value labels
  lay1 0 "Met need for family planning (currently using contraception)"
 /lay2 0 "Unmet need for family planning"
 /lay3 0 "Total demand for family planning"
 /lay4 0 "Percentage of demand for family planning satisfied with:".

use all.
compute filter_$=(mstatus<>1 and sexact=1).
filter by filter_$.

ctables
  /vlabels variables=total totneed lay1 lay2 lay3 lay4 display=none
  /table  tot [c] 
         + HH6 [c]
         + hh7 [c]
         + $wage [c]
         + welevel [c]
         + disability [c]
         + ethnicity[c]
         + windex5 [c]     by
 	lay2 [c] > (space [s] [mean '' f5.1] + limit [s] [mean '' f5.1] + unmetnd [s] [mean '' f5.1]) +
  	lay1 [c] > (metspc [s] [mean '' f5.1] + metlmt [s] [mean '' f5.1] + met [s] [mean '' f5.1]) +
  	lay3 [c] > (totspc [s] [mean '' f5.1] + totlmt [s] [mean '' f5.1] + totdem [s] [mean '' f5.1]) +
                  total [c] [count '' comma5.0] + 
                  lay4 [c] > (satisf [s] [mean '' f5.1] + satisfm [s] [mean '' f5.1] )+ totneed [c] [count '' comma5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels visible=no
  /titles title=
    "Table TM.3.4: Need and demand for family planning (currently unmarried/not in union)"
  		"Percentage of sexually active women age 15-49 years who are currently unmarried or not in union with unmet and met need for family planning, " +
                                     "total demand for family planning, and, among women with need for family planning, percentage of demand satisfied by method of contraception,  " + surveyname
  caption=
	"[A] >>Sexually active<< is defined as having had sex within the last 30 days.".																	
	
new file.