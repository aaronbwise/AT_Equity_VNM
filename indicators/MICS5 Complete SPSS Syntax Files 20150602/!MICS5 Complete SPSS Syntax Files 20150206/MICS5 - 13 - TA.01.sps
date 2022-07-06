* MICS5 TA-01.

* REMARK: criteria <97 is used instead of <98 from tab plan in order to exclude inconsistent cases.

* v01 - 2013-06-22.

* Respondents who have never smoked cigarettes and never used any other tobacco products are:
     (TA1=2 or (TA1=1 and TA2=00)) and TA6=2 and TA10=2

* Patterns of use of tobacco products are defined as follows:
    Cigarettes:
       Ever users:
           TA2>00 and TA2<98
       Users at any time during the last one month:
           (TA4>00 and TA4<98) or (TA5>00 and TA5<98) .

*   Other smoked tobacco products:
       Ever users:
           TA6=1
       Users at any time during the last one month:
           TA9>00 and TA9<98 .

*   Smokeless tobacco products:
       Ever users:
           TA10=1
       Users at any time during the last one month:
           TA13>00 and TA13<98 .

* "Any tobacco product"" refers to cigarettes, smoked tobacco products, and smokeless
   tobacco products.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* In order to obtain info that UF is in HH, we prepare tmp.sav.
get file = 'hh.sav'.

* save variable of the number of UFs in HH.
save outfile = 'tmp.sav'
    /keep = hh1 hh2 hh14.

* Open women dataset.
get file = 'wm.sav'.

* merge data.
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 .

* Select completed interviews.
select if (WM7 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate variable of UF existance in HH.
compute hh14 = 2 - (hh14 > 0) .
variable labels hh14 'Under-5s in the same household'.
value labels hh14
  1 'At least one'
  2 'None'.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "Number of women age 15-49 years".

* Generate indicators.

* Not users.
compute nevsmoke = 0.
if ((TA1=2 or (TA1=1 and TA2=00)) and TA6=2 and TA10=2) nevsmoke = 100.
variable labels nevsmoke "Never smoked cigarettes or used other tobacco products".

* Ever ciggarets.
compute ecig = 0.
if (TA2 > 00 and TA2 < 97)  ecig = 100.

* Ever other (smoked & non smoked).
compute eothprod = 0.
if (TA6 = 1 or TA10 = 1)  eothprod = 100.

* Only cigarettes.
compute eonlycig = 0.
if (ecig = 100 and eothprod <> 100) eonlycig = 100.
variable labels eonlycig "Only cigarettes".

* Cigarettes and other tobacco products.
compute ecigoth = 0.
if (ecig = 100 and eothprod = 100) ecigoth = 100.
variable labels ecigoth "Cigarettes and other tobacco products".

* Only other tobacco products.
compute eother = 0.
if (ecig = 0 and eothprod = 100) eother = 100.
variable labels eother "Only other tobacco products".

* Any tobacco product.
compute eany = 0.
if (ecig = 100 or eothprod = 100) eany = 100.
variable labels eany "Any tobacco product".




* Last month ciggarets.
compute mcig = 0.
if ((TA4>00 and TA4<97) or (TA5>00 and TA5<97))  mcig = 100.

* Last month other (smoked & non smoked).
compute mothprod = 0.
if ((TA9>00 and TA9<97) or (TA13>00 and TA13<97))  mothprod = 100.

* Only cigarettes during last month.
compute monlycig = 0.
if (mcig = 100 and mothprod <> 100) monlycig = 100.
variable labels monlycig "Only cigarettes".

* Cigarettes and other tobacco products during last month.
compute mcigoth = 0.
if (mcig = 100 and mothprod = 100) mcigoth = 100.
variable labels mcigoth "Cigarettes and other tobacco products".

* Only other tobacco products during last month.
compute mother = 0.
if (mcig = 0 and mothprod = 100) mother = 100.
variable labels mother "Only other tobacco products".

*Any tobacco product during last month.
compute many = 0.
if (mcig = 100 or mothprod = 100) many = 100.
variable labels many "Any tobacco product [1]".




* Generate levels-heading rows in table .

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Ever users".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Users of tobacco products at any time during the last one month".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

ctables
  /vlabels variables =  layer0 layer1 total
           display = none
  /table  total [c]
        + wage [c]
        + hh7 [c]
        + hh6 [c]
        + welevel [c]
        + hh14 [c]
        + windex5 [c]
        + ethnicity [c]
    by
          nevsmoke [s] [mean,'',f5.1]
        + layer0 [c] > ( 
            eonlycig [s] [mean,'',f5.1]
          + ecigoth [s] [mean,'',f5.1]
          + eother [s] [mean,'',f5.1]
          + eany[s] [mean,'',f5.1] )
        + layer1 [c] > ( 
            monlycig [s] [mean,'',f5.1]
          + mcigoth [s] [mean,'',f5.1]
          + mother [s] [mean,'',f5.1]
          + many[s] [mean,'',f5.1] )
        + numWomen[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
    "Table TA.1: Current and ever use of tobacco (women)"
    "Percentage of women age 15-49 years by pattern of use of tobacco" + surveyname
   caption =
    "[1] MICS indicator 12.1 - Tobacco use".

new file.

erase file = 'tmp.sav'.
