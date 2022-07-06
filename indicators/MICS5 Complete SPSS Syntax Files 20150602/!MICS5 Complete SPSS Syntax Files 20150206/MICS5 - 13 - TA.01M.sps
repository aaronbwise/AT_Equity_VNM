* MICS5 TA-01M.

* REMARK: criteria <97 is used instead of <98 from tab plan.

* v01 - 2013-06-22.

* Respondents who have never smoked cigarettes and never used any other tobacco products are:
     (MTA1=2 or (MTA1=1 and MTA2=00)) and MTA6=2 and MTA10=2

* Patterns of use of tobacco products are defined as follows:
    Cigarettes:
       Ever users:
           MTA2>00 and MTA2<98
       Users at any time during the last one month:
           (MTA4>00 and MTA4<98) or (MTA5>00 and MTA5<98) .

*   Other smoked tobacco products:
       Ever users:
           MTA6=1
       Users at any time during the last one month:
           MTA9>00 and MTA9<98 .

*   Smokeless tobacco products:
       Ever users:
           MTA10=1
       Users at any time during the last one month:
           MTA13>00 and MTA13<98 .

* "Any tobacco product"" refers to cigarettes, smoked tobacco products, and smokeless
   tobacco products.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* In order to obtain info that UF is in HH, we prepare tmp.sav.
get file = 'hh.sav'.

* save variable of the nuber of UFs in HH.
save outfile = 'tmp.sav'
    /keep = hh1 hh2 hh14.

* Open men dataset.
get file = 'mn.sav'.

sort cases by hh1 hh2.

* merge data.
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 .

* Select completed interviews.
select if (MWM7 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Generate variable of UF existance in HH.
compute hh14 = 2 - (hh14 > 0) .
variable labels hh14 'Under-5s in the same household'.
value labels hh14
  1 'At least one'
  2 'None'.

* Generate total variable.
compute numMen = 1.
variable labels numMen "Number of men age 15-49 years".

* Generate indicators.

* Not users.
compute nevsmoke = 0.
if ((MTA1=2 or (MTA1=1 and MTA2=00)) and MTA6=2 and MTA10=2) nevsmoke = 100.
variable labels nevsmoke "Never smoked cigarettes or used other tobacco products".

* Ever ciggarets.
compute ecig = 0.
if (MTA2 > 00 and MTA2 < 97)  ecig = 100.

* Ever other (smoked & non smoked).
compute eothprod = 0.
if (MTA6 = 1 or MTA10 = 1)  eothprod = 100.

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
if ((MTA4>00 and MTA4<97) or (MTA5>00 and MTA5<97))  mcig = 100.

* Last month other (smoked & non smoked).
compute mothprod = 0.
if ((MTA9>00 and MTA9<97) or (MTA13>00 and MTA13<97))  mothprod = 100.

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
  /vlabels variables = layer0 layer1 total
           display = none
  /table   total [c]
         + mwage [c]
         + hh7 [c]
         + hh6 [c]
         + mwelevel [c]
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
         + numMen [s] [sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
     "Table TA.1M: Current and ever use of tobacco (men)"
     "Percentage of men age 15-49 years by pattern of use of tobacco, " + surveyname
   caption =
     "[1] MICS indicator 12.1 - Tobacco use [M]"
  .

new file.

erase file = 'tmp.sav'.
