* Encoding: UTF-8.

***.
* v02 - 2020-07-22. Subtitle has been edited. Labels in French and Spanish have been removed. Significant changes made in coding, towards creating exact table as per tab plan.

* This data quality table is only produced for surveys that have included a birth history.


include "surveyname.sps".

input program.
loop #i=0 to 23.
-  compute BH9N=#i.
-  end case.
- end loop.
end file.
end input program.

save outfile = "numMonths.sav".

get file = 'bh.sav'.

weight by wmweight.

compute period = trunc((wdoi-BH4C)/60).
variable labels period "Number of years preceding the survey".
value labels period 0 '0-4' 1 '5-9' 2 '10-14' 3 '15-19'.

select if (((BH9U <= 2 and BH9N < 99) or (BH9U=3 and BH9N=1)) and period<=3).

if (BH9U=1) BH9N=0.
* In rare cases when age at death is reported as 1 year, transform into 12 months. 
* Please first crosstab variables BH9U and BH9N to check if such cases exist by uncommenting line below.
*crosstabs BH9U by BH9N.
if (BH9U=3 and BH9N=1) BH9N = 12.

if period = 0 tot_0 = 1.
if period = 1 tot_1 = 1.
if period = 2 tot_2 = 1.
if period = 3 tot_3 = 1.

compute tot1 = 1.
compute total = 1.

if period = 0 tot11_0 = (BH9N<=11 and BH9U<=2).
if period = 1 tot11_1 = (BH9N<=11 and BH9U<=2).
if period = 2 tot11_2 = (BH9N<=11 and BH9U<=2).
if period = 3 tot11_3 = (BH9N<=11 and BH9U<=2).
compute tot11 = (BH9N<=11 and BH9U<=2).

recode BH9N (0=100)(1 thru 11=0)(else=sysmis) into neonat.
variable labels neonat "Percent neonatal [B]".

add value labels bh9n 0 "0 [A]".

aggregate
  /outfile="aggr0.sav"
  /break=BH9N 
  /tot_0=n(tot_0) 
  /tot_1=n(tot_1) 
  /tot_2=n(tot_2) 
  /tot_3=n(tot_3) 
  /tot1 = n(tot1)
.

aggregate
  /outfile="aggr11.sav"
  /break= 
  /tot_0=sum(tot11_0) 
  /tot_1=sum(tot11_1) 
  /tot_2=sum(tot11_2) 
  /tot_3=sum(tot11_3) 
  /tot1 = sum(tot11)
.

aggregate
  /outfile="aggr1.sav"
  /break= period 
  /neonat=mean(neonat).

aggregate
  /outfile="aggr2.sav"
  /break= total 
  /neonat=mean(neonat).

get file = "aggr1.sav".
add files /file=* /file = "aggr2.sav".
if total = 1 period = 4.
casestovars /index=period.

save outfile = "aggr1.sav".

get file = "numMonths.sav".
match files /file = *
/table = "aggr0.sav"
/by BH9N.
add files /file=* /file ="aggr11.sav".
recode BH9N (sysmis = 97)(else=copy).
add files /file = * /file = "aggr1.sav".

recode tot_0 tot_1 tot_2 tot_3 tot1 (sysmis=0) (else = copy).

if total = 1 tot_0 = neonat..00.
if total = 1 tot_1 = neonat.1.00.
if total = 1 tot_2 = neonat.2.00.
if total = 1 tot_3 = neonat.3.00.
if total = 1 tot1 = neonat.4.00.

compute layer = 0.
value labels layer 0 "Number of years preceding the survey".

value labels BH9N 0 "0 [A]".
value labels BH9N 97 "Total 0–11 months".
value labels total 1 "Percent neonatal [B]".

* Ctables command in English.
ctables
 /vlabels variable = bh9n layer tot_0 tot_1 tot_2 tot_3 tot1 display = none
 /table bh9n [c] by layer [c] > (tot_0 [s] [sum,'0-4',f5.0] + tot_1 [s] [sum,'5-9',f5.0] + tot_2 [s] [sum,'10-14',f5.0] + tot_2 [s] [sum,'15-19',f5.0]) + tot1 [s] [sum,'Total for the 20 years preceding the survey',f5.0] 
 /titles title=
    "Table DQ.6.4: Reporting of age at death in months" 
      "Distribution of reported deaths under age 2 years in age at death in months and the percentage of infant deaths reported to occur at age under one month, " +
     "by 5-year periods preceding the survey, as reported in the (imputed) birth histories of women age 15-49 years, " + surveyname
  corner="Age at death (in months)"
  caption=
                   "[A] Includes deaths under one month reported in days"
	 "[B] Deaths under one month, divided by deaths under one year".

* Ctables command in English.
ctables
 /vlabels variable = bh9n layer tot_0 tot_1 tot_2 tot_3 tot1 total display = none
 /table total [c] by layer [c] > (tot_0 [s] [sum,'0-4',f5.1] + tot_1 [s] [sum,'5-9',f5.1] + tot_2 [s] [sum,'10-14',f5.1] + tot_2 [s] [sum,'15-19',f5.1]) + tot1 [s] [sum,'Total for the 20 years preceding the survey',f5.1]
 /titles title=
    "Table DQ.6.4: Reporting of age at death in months" 
      "Distribution of reported deaths under age 2 years in age at death in months and the percentage of infant deaths reported to occur at age under one month, " +
     "by 5-year periods preceding the survey, as reported in the (imputed) birth histories of women age 15-49 years, " + surveyname
  corner="Age at death (in months)"
  caption=
                   "[A] Includes deaths under one month reported in days"
	 "[B] Deaths under one month, divided by deaths under one year".

new file.

erase file = "aggr0.sav".
erase file = "aggr1.sav".
erase file = "aggr11.sav".
erase file = "aggr2.sav".
erase file = "numMonths.sav".
