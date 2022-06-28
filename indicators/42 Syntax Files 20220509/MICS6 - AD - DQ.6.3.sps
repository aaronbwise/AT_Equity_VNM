* Encoding: UTF-8.

***.
* v02 - 2020-05-07. Subtitle has been edited. Labels in French and Spanish have been removed. Significant changes made in coding, towards creating exact table as per tab plan.

* This data quality table is only produced for surveys that have included a birth history.

include "surveyname.sps".

input program.
loop #i=0 to 30.
-  compute BH9N=#i.
-  end case.
- end loop.
end file.
end input program.

save outfile = "numDays.sav".

* Please note that the bh.sav file should be unimputed.
get file = 'bh.sav'.

weight by wmweight.

compute period = trunc((wdoi-BH4C)/60).
variable labels period "Number of years preceding the survey".
value labels period 0 '0-4' 1 '5-9' 2 '10-14' 3 '15-19'.

select if (BH9U = 1 and BH9N < 99 and period<=3).

if period = 0 tot30_0 = (BH9N<=31).
if period = 1 tot30_1 = (BH9N<=31).
if period = 2 tot30_2 = (BH9N<=31).
if period = 3 tot30_3 = (BH9N<=31).

compute total = 1.
compute tot1 = 1.
value labels tot1 1 "Total 0-30 days".
value labels BH9N 0 "0".
recode BH9N (0 thru 6=100)(7 thru hi=0) into neonat.
variable labels neonat "Percent early neonatal [A]".

aggregate
  /outfile="aggr0.sav"
  /break=BH9N 
  /tot30_0=n(tot30_0) 
  /tot30_1=n(tot30_1) 
  /tot30_2=n(tot30_2) 
  /tot30_3=n(tot30_3) 
  /tot1 = sum(tot1)
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

get file = "numDays.sav".
match files /file = *
/table = "aggr0.sav"
/by BH9N.

add files /file = *
/file = "aggr1.sav".

recode tot30_0 tot30_1 tot30_2 tot30_3 tot1 (sysmis=0) (else = copy).

if total = 1 tot30_0 = neonat..00.
if total = 1 tot30_1 = neonat.1.00.
if total = 1 tot30_2 = neonat.2.00.
if total = 1 tot30_3 = neonat.3.00.
if total = 1 tot1 = neonat.4.00.

compute layer = 0.
value labels layer 0 "Number of years preceding the survey".

variable labels tot1 "Total 0-30 days".
value labels total 1 "Percent early neonatal [A]".

* Ctables command in English.
ctables 
 /vlabels variable = bh9n layer tot30_0 tot30_1 tot30_2 tot30_3 tot1 display = none
 /table bh9n [c] by layer [c] > (tot30_0 [s] [sum,'0-4',f5.0] + tot30_1 [s] [sum,'5-9',f5.0] + tot30_2 [s] [sum,'10-14',f5.0] + tot30_2 [s] [sum,'15-19',f5.0]) + tot1 [s] [sum,'Total for the 20 years preceding the survey',f5.0] 
 /categories var = bh9n total = yes position = after label = "Total 0–30 days"
 /titles title=
   "Table DQ.6.3: Reporting of age at death in days" 
   "Distribution of reported deaths under age one month in age of death in days and the percentage of neonatal deaths reported to occur at ages 0–6 days, " +
   "by 5-year periods preceding the survey, as reported in the (imputed) birth histories of women age 15-49 years, " + surveyname
  corner="Age at death (in days)"
  caption=
	"[A] Deaths during the first 7 days (0-6), divided by deaths during the first month (0-30 days)".

* Ctables command in English.
ctables 
 /vlabels variable =  layer tot30_0 tot30_1 tot30_2 tot30_3 tot1 total display = none
 /table total [c] by layer [c] > (tot30_0 [s] [sum,'0-4',f5.1] + tot30_1 [s] [sum,'5-9',f5.1] + tot30_2 [s] [sum,'10-14',f5.1] + tot30_2 [s] [sum,'15-19',f5.1]) + tot1 [s] [sum,'Total for the 20 years preceding the survey',f5.1]
 /titles title=
   "Table DQ.6.3: Reporting of age at death in days" 
   "Distribution of deaths under age one month in reported age of death in days, and the percentage of neonatal deaths reported to occur at ages 0–6 days, " +
   "by 5-year periods preceding the survey, as reported in the (imputed) birth histories of women age 15-49 years, " + surveyname
  corner="Age at death (in days)"
  caption=
	"[A] Deaths during the first 7 days (0-6), divided by deaths during the first month (0-30 days)".

new file.

erase file = "aggr0.sav".
erase file = "aggr1.sav".
erase file = "aggr2.sav".
erase file = "numDays.sav".



