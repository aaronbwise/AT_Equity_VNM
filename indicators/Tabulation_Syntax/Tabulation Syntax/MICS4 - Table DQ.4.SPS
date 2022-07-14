* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household members data file.
get files="hl.sav".

* Calculate number of household members for each household.
aggregate 
  /outfile = * mode = addvariables
  /break = HH1 HH2
  /hl1_max = max(HL1).

recode hl1_max (1 thru 3 = 1) (4 thru 6 = 2 ) (7 thru hi = 3) into memnum.
variable labels memnum "Household size".
value labels memnum 1 "1-3" 2 "4-6" 3 "7+".

* Select household population of women age 15-49.
select if (hl6 >= 15 and hl6 <= 49 and hl4 = 2).

* Weight the data by the household weight.
weight by hhweight.

* Total variable.
compute tot = 1.
variable labels tot "Total".
value labels tot 1 " ".

* Total variable.
compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* For each region separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp1.sav"
  /break   = HH7
  /ttwm  = sum(total).

* For each area separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp2.sav"
  /break   = HH6
  /ttwm  = sum(total).

* For each household size category separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp3.sav"
  /break   = memnum
  /ttwm  = sum(total).

* For each category of household head education separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp4.sav"
  /break   = helevel
  /ttwm  = sum(total).

* For each wealth index quintile separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp5.sav"
  /break   = windex5
  /ttwm  = sum(total).

* For each ethnicity category separately.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp6.sav"
  /break   = ethnicity
  /ttwm  = sum(total).

* For overall country.
* Aggregate the hl data file to calculate the sum of women 15-49.
aggregate outfile ="tmp8.sav"
  /break   = tot
  /ttwm  = sum(total).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp8.sav'.

variable labels ttwm "Household population of women age 15-49 years".

save outfile = 'tmp1.sav'
  /rename (windex5 = windex5w).

* Open household members data file.
get file="hl.sav".
sort cases HH1 HH2 HL1.

* Calculate number of household members for each household.
aggregate 
  /outfile = * mode = addvariables
  /break = HH1 HH2
  /hl1_max = max(HL1).

recode hl1_max (1 thru 3 = 1) (4 thru 6 = 2 ) (7 thru hi = 3) into memnum.
variable labels memnum "Household size".
value labels memnum 1 "1-3" 2 "4-6" 3 "7+".

* Save a temporary file with the information needed for merging with the women data: cluster and household number, line number, education of hh head, household size, wealth index and weight.
save outfile ="tmp1c.sav"
 /keep HH1 HH2 HL1 helevel memnum windex5 hhweight
 /rename (HL1=LN) (windex5 = windex5w).

* Open women data file.
get file="wm.sav".

* Sort cases by cluster number, household number and women line number.
sort cases by hh1 hh2 ln.

* Add the household member data a wm data.
match files 
 /file=*
 /table='tmp1c.sav'
 /by hh1 hh2 ln.

* Weight the data by the household weight.
weight by hhweight.

*  Give value 1 to each interviewed women 15-49.
compute tt1549i = 0.
if (WM7 = 1) tt1549i = 1.

* Total variable.
compute totw = 1.

* Total variable.
compute tot = 1.

* For each region separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp1w.sav"
  /break   = HH7
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For each area separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp2w.sav"
  /break   = HH6
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For each category of hh head education separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp3w.sav"
  /break   = helevel
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For each household size category separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp4w.sav"
  /break   = memnum
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For each wealth index quintile separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp5w.sav"
  /break   = windex5w
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For each ethnicity category separately.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp6w.sav"
  /break   = ethnicity
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* For overall country.
* Aggregate the wm data file to calculate the total number of women 15-49 and the total number of women interviewed.
aggregate outfile ="tmp8w.sav"
  /break   = tot
  /totw  = sum(totw)
  /totwi = sum(tt1549i).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp1w.sav'
  /file = 'tmp2w.sav'
  /file = 'tmp3w.sav'
  /file = 'tmp4w.sav'
  /file = 'tmp5w.sav'
  /file = 'tmp6w.sav'
  /file = 'tmp8w.sav'.

save outfile = 'tmp1.sav'.

variable labels totwi "Interviewed women age 15-49 years".

* Compute response rates for Women. 
compute pelig = (totwi/totw)*100.
variable labels pelig "Percent of eligible women interviewed (Completion rates)".

* Total variable.
variable labels totw "Household population of women age 15-49 years".

* Total variable.
variable labels tot "Total".
value labels tot 1 " ".


* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /table HH7 [c] + HH6 [c] + memnum[c] + helevel [c] + windex5w [c] + ethnicity [c] + tot [c] BY 
             ttwm [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1]  + totwi [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + pelig [s] [mean,'',f5.1]            
  /categories var = all empty =exclude missing = exclude
  /slabels position = column visable = no
  /titles title=
  "Table DQ.4: Women's completion rates by socio-economic characteristics of households"
  "Household population of women age 15-49, interviewed women age 15-49, and percentage of eligible women who were interviewed, " +
  "by selected social and economic characteristics of the household, " + surveyname.

new file.

* Erase temporary files.
erase file 'tmp1.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.
erase file 'tmp5.sav'.
erase file 'tmp6.sav'.
erase file 'tmp8.sav'.
erase file 'tmp1w.sav'.
erase file 'tmp2w.sav'.
erase file 'tmp3w.sav'.
erase file 'tmp4w.sav'.
erase file 'tmp5w.sav'.
erase file 'tmp6w.sav'.
erase file 'tmp8w.sav'.

