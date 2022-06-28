* Encoding: UTF-8.

***.
* v02 - 2020-04-14. The subtitle, last columns and note has been edited to present blank testing as unweighted results. Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Household.
get file = 'hh.sav'.

select if (HH46 = 1).

weight by hhweight.

compute wqtest = 0.
if (HH9 = 1) wqtest = 100.
variable labels wqtest "Selected for Water Quality Testing questionnaire".

compute hhtest = 0.
if (WQ31 = 1) hhtest = 100.
variable labels hhtest "With completed Water Quality Testing questionnaire".

compute hn = 1.
variable labels hn "".
value labels hn 1 "Number of households".

do if (HH9 = 1).

+compute hhtest1 = 0.
+if (WQ11=1 and (WQ26>=0 and WQ26<996)) hhtest1 = 100.
+variable labels hhtest1 "Household drinking water".

+compute hhtest2 = 0.
+if (WQ19=1 and (WQ27>=0 and WQ27<996)) hhtest2 = 100.
+variable labels hhtest2 "Source of drinking water".

+compute hhwqtest = 1.
+value labels hhwqtest 1 "Number of households selected for Water Quality Testing Questionnaire".

end if.

compute sblank = 0.
if (HH10 = 1) sblank = 1.
variable labels sblank "Number of households selected [A]".

do if sblank = 1.

+compute nblank = 0.
+if (WQ21 = 1) nblank = 1.
+variable labels nblank "Number completed".

+compute blank = 0.
+if (HH10=1 and WQ21=1 and (WQ29>0 and WQ29<996)) blank = 100.
+variable labels blank "Percentage positive".

end if.

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of households:".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Percentage of households with complete water quality test for:".

compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Blank tests (unweighted)".

* Ctables command in English.
ctables
  /vlabels variables =  layer layer1 layer2 hn hhwqtest
         display = none
   /table total [c] + hh6 [c] by 
    layer [c] > (wqtest [s] [mean '' f5.1] + hhtest [s] [mean '' f5.1]) + hn [c] [count '' f5.0] + 
    layer1 [c] > (hhtest1 [s] [mean '' f5.1] + hhtest2 [s][mean '' f5.1]) + hhwqtest [c] [count '' f5.0] + 
    layer2 [c] > (blank [s] [umean '' f5.1] + nblank [s] [usum '' f5.0] + sblank [s][usum '' f5.0])
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.3.2: Completeness and quality of information of water quality testing"
   "Percentage of households selected for and with complete water quality testing at household and source, and (unweighted) percentage of positive blank tests, " + surveyname
  caption = "[A] One blank test (a test of uncontaminated water) was performed in each cluster. For practical reasons, the blank test was assigned to first of the households selected for water quality testing."
  .

new file.	
