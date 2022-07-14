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

* Select household population of children under 5.
select if (hl6 <= 4).

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
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp1.sav"
  /break   = HH7
  /ttch  = sum(total).

* For each area separately.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp2.sav"
  /break   = HH6
  /ttch  = sum(total).

* For each category of hh head education separately.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp3.sav"
  /break   = helevel
  /ttch  = sum(total).

* For each household size category separately.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp4.sav"
  /break   = memnum
  /ttch  = sum(total).

* For each wealth index quintile separately.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp5.sav"
  /break   = windex5
  /ttch  = sum(total).

* For each ethnicity category separately.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp6.sav"
  /break   = ethnicity
  /ttch  = sum(total).

* For overall country.
* Aggregate the hl data file to calculate the total number of children under 5.
aggregate outfile ="tmp8.sav"
  /break   = tot
  /ttch  = sum(total).

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

variable labels ttch "Household population of under-5 children".

save outfile 'tmp1.sav'
  /rename (windex5 = windex5c).

* Open household members data file.
get file="hl.sav".
sort cases by hh1 hh2 hl1.

* Calculate number of household members for each household.
aggregate 
  /outfile = * mode = addvariables
  /break = HH1 HH2
  /hl1_max = max(HL1).

recode hl1_max (1 thru 3 = 1) (4 thru 6 = 2 ) (7 thru hi = 3) into memnum.
variable labels memnum "Household size".
value labels memnum 1 "1-3" 2 "4-6" 3 "7+".

* Save a temporary file with the information needed for merging with the ch data: cluster and household number, line number, education of hh head, household size, wealth and weight.
save outfile ="tmp1cc.sav"
 /keep HH1 HH2 HL1 helevel memnum windex5 hhweight
 /rename (HL1=LN) (windex5 = windex5c).

* Open children data file.
get file="ch.sav".

* Sort cases by cluster number, household number and child's line number.
sort cases by hh1 hh2 ln.

* Add the household member data a ch data.
match files 
 /file=*
 /table='tmp1cc.sav'
 /by hh1 hh2 ln.

* Weight the data by the household weight.
weight by hhweight.

*  Give value 1 to each interviewed child 0-4.
compute  tt04i = 0.
if (UF9 = 1)  tt04i = 1.

* Total variable.
compute totc = 1.

* Total variable.
compute tot = 1.

* For each region separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp1c.sav"
  /break   = HH7
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For each area separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp2c.sav"
  /break   = HH6
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For each categoty of education of hh head separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp3c.sav"
  /break   = helevel
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For each household size category separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp4c.sav"
  /break   = memnum
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For each wealth index quintile separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp5c.sav"
  /break   = windex5c
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For each etnicity category separately.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp6c.sav"
  /break   = ethnicity
  /totc  = sum(totc)
  /totci = sum( tt04i).

* For overall country.
* Aggregate the ch data file to calculate the total number of children under 5 and the total number of children interviewed.
aggregate outfile ="tmp8c.sav"
  /break   = tot
  /totc  = sum(totc)
  /totci = sum( tt04i).

* Add this summary information together in one data file.
get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp1c.sav'
  /file = 'tmp2c.sav'
  /file = 'tmp3c.sav'
  /file = 'tmp4c.sav'
  /file = 'tmp5c.sav'
  /file = 'tmp6c.sav'
  /file = 'tmp8c.sav'.

save outfile = 'tmp.sav'.

variable labels totci "Interviewed under-5 children".

* Compute response rates for children. 
compute pelig = (totci/totc)*100.
variable labels pelig "Percent of eligible under-5s with completed under-5 questionnaires (Completion rates)".

* Total variable.
variable labels totc "Household population of under-5 children".

* Total variable.
variable labels tot "Total".
value labels tot 1 " ".

* Ctables command for the tabulation in newer versions of SPSS.
ctables
  /table HH7 [c] + HH6 [c] + memnum[c] + helevel [c] + windex5c [c] + ethnicity [c] +  tot [c] BY 
            ttch [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1]  + totci [s] [sum,'Number',f5.0,tablepct.sum,'Percent',f5.1] + pelig [s] [mean,'',f5.1]            
  /categories var = all empty =exclude missing = exclude
  /slabels position = column visable = no
  /titles title=
  "Table DQ.5: Completion rates for under-5 questionnaires by socio-economic characteristics of households"
   "Household population of under-5 children, under-5 questionnaires completed, and percentage of under-5 children for whom interviews were completed,  " +
   "by selected socio-economic characteristics of the household, " + surveyname.

new file.

* Erase temporary files.
erase file 'tmp1.sav'.
erase file 'tmp1cc.sav'.
erase file 'tmp2.sav'.
erase file 'tmp3.sav'.
erase file 'tmp4.sav'.
erase file 'tmp5.sav'.
erase file 'tmp6.sav'.
erase file 'tmp8.sav'.
erase file 'tmp1c.sav'.
erase file 'tmp2c.sav'.
erase file 'tmp3c.sav'.
erase file 'tmp4c.sav'.
erase file 'tmp5c.sav'.
erase file 'tmp6c.sav'.
erase file 'tmp8c.sav'.