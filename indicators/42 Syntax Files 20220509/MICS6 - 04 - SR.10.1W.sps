* Encoding: windows-1252.
* MICS6 SR.9.3W.

* v01 - 2017-09-22.
* v02 - 2019-03-14.
* v03 - 2020-04-09. The subtitle has been edited. Labels in French and Spanish have been removed.

** Respondents who have never smoked cigarettes and never used any other tobacco products are: 
(TA1=2 or (TA1=2 and TA2=00)) and TA6=2 and TA10=2

** Patterns of use of tobacco products are defined as follows:
Cigarettes:
Ever users: TA2>00 and TA2<98
Users at any time during the last one month: (TA4>00 and TA4<98) or (TA5>00 and TA5<98)
Other smoked tobacco products:
Ever users: TA6=1
Users at any time during the last one month: TA9>00 and TA9<98
Smokeless tobacco products:
Ever users: TA10=1
Users at any time during the last one month: TA13>00 and TA13<98

** "Any tobacco product" refers to cigarettes, smoked tobacco products, and smokeless tobacco products.


***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* In order to obtain info that UF is in HH, we prepare tmp.sav.
get file = 'hh.sav'.
sort cases by hh1 hh2.

* save variable of the number of UFs in HH.
save outfile = 'tmp.sav'
    /keep = hh1 hh2 hh51.

* Open women dataset.
get file = 'wm.sav'.
sort cases by hh1 hh2 ln.

include "CommonVarsWM.sps".

* merge data.
match files
  /file = *
  /table = 'tmp.sav'
  /by hh1 hh2 .

* Select completed interviews.
select if (WM17 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Generate variable of UF existance in HH.
compute hh51 = 2 - (hh51 > 0) .
variable labels hh51 'Under-5s in the same household'.
value labels hh51
  1 'At least one'
  2 'None'.

* Generate numWomen variable.
compute numWomen = 1.
variable labels numWomen "Number of women".

* Generate indicators.

* Not users: (TA1=2 or (TA1=2 and TA2=00)) and TA6=2 and TA10=2.
compute nevsmoke = 0.
if ((TA1=2 or (TA1=1 and TA2=00)) and TA6=2 and TA10=2) nevsmoke = 100.
variable labels nevsmoke "Never smoked cigarettes or used other tobacco products".

* Ever ciggarets: Ever users: TA2>00 and TA2<98.
compute ecig = 0.
if (TA2 > 00 and TA2 < 97)  ecig = 100.

* Last month ciggarets: (TA4>00 and TA4<98) or (TA5>00 and TA5<98).
compute mcig = 0.
if ((TA4>00 and TA4<97) or (TA5>00 and TA5<97))  mcig = 100.

*Ever users other (smoked): TA6=1.
compute othprods = 0.
if (TA6 = 1)  othprods = 100.

* Last month other (smoked): TA9>00 and TA9<98.
compute mothprods = 0.
if (TA9>00 and TA9<97)  mothprods = 100.

*Ever users other (smokeless): TA10=1.
compute othprodless = 0.
if (TA10 = 1)  othprodless = 100.

* Last month other (smokeless): TA13>00 and TA13<98.
compute mothprodless = 0.
if (TA13>00 and TA13<97)  mothprodless = 100.

* Only cigarettes.
compute eonlycig = 0.
if (ecig = 100 and othprods <> 100 and othprodless <> 100) eonlycig = 100.
variable labels eonlycig "Only cigarettes".

* Cigarettes and other tobacco products.
compute ecigoth = 0.
if (ecig = 100 and (othprods = 100 or othprodless = 100)) ecigoth = 100.
variable labels ecigoth "Cigarettes and other tobacco products".

* Only other tobacco products.
compute eother = 0.
if (ecig = 0 and (othprods = 100 or othprodless = 100)) eother = 100.
variable labels eother "Only other tobacco products".

* Any tobacco product.
compute eany = 0.
if (ecig = 100 or othprods = 100 or othprodless = 100) eany = 100.
variable labels eany "Any tobacco product".

* Only cigarettes during last month.
compute monlycig = 0.
if (mcig = 100 and mothprods <> 100 and mothprodless <> 100 ) monlycig = 100.
variable labels monlycig "Only cigarettes".

* Cigarettes and other tobacco products during last month.
compute mcigoth = 0.
if (mcig = 100 and (mothprods = 100 or mothprodless = 100)) mcigoth = 100.
variable labels mcigoth "Cigarettes and other tobacco products".

* Only other tobacco products during last month.
compute mother = 0.
if (mcig = 0 and (mothprods = 100 or mothprodless = 100)) mother = 100.
variable labels mother "Only other tobacco products".

*Any tobacco product during last month.
compute many = 0.
if (mcig = 100 or mothprods = 100 or mothprodless = 100) many = 100.
variable labels many "Any tobacco product [1]".

*MICS indicator SR.14b, Percentage of women who did not use any smoked tobacco product in the last month: (TA1=2 or (TA1=1 and TA2=00) or TA3=2 or (TA4=00 and TA5=00)) AND (TA6=2 or TA7=2).
compute mnone = 0.
if ((TA1 = 2 or (TA1 = 1 and TA2 = 00) or TA3 = 2 or (TA4 = 00 and TA5 = 00)) and (TA6 = 2 or TA7 = 2)) mnone = 100.
variable labels mnone "Percentage of women who did not use any smoked tobacco product in the last month [2]".

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

* Ctables command in English.
ctables
  /vlabels variables =  layer0 layer1 total
           display = none
  /table  total [c]
        + hh6 [c]
        + hh7 [c]
        + $wage [c]
        + welevel [c]
        + hh51 [c]
        + disability [c]
        + ethnicity [c]
        + windex5 [c]
    by
          nevsmoke [s] [mean '' f5.1]
        + layer0 [c] > ( 
            eonlycig [s] [mean '' f5.1]
          + ecigoth [s] [mean '' f5.1]
          + eother [s] [mean '' f5.1]
          + eany[s] [mean '' f5.1] )
        + layer1 [c] > ( 
            monlycig [s] [mean '' f5.1]
          + mcigoth [s] [mean '' f5.1]
          + mother [s] [mean '' f5.1]
          + many [s] [mean '' f5.1] )
          + mnone[s] [mean '' f5.1]  
        + numWomen[s][sum '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table SR.10.1W: Current and ever use of tobacco (women)"
    "Percentage of women age 15-49 years who never used any tobacco product, percentage who ever used and currently use, by product, and percentage who currently do not use a smoked tobacco product, " + surveyname
   caption =
     "[1] MICS indicator SR.14a - Tobacco use; SDG indicator 3.a.1"											
     "[2] MICS indicator SR.14b - Non-smokers; SDG indicator 3.8.1"
.										

new file.

erase file = 'tmp.sav'.
