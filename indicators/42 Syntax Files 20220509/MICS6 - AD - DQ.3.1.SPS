* Encoding: windows-1252.

***.
* v02 - 2020-04-14. Table has been updated to reflect the change in salt test kits. Labels in French and Spanish have been removed.
***.

 * Salt was tested only once if the (first) result indicated reaction: SA1=5.
 * If salt tested with no reaction (SA1=1), a second test was conducted:
- 2nd test with reaction: SA2=5
- 2nd test with no reaction: SA2=1

 * Salt was not tested if no salt in household: SA1=4
Or for any other reason: SA1=6 or SA2>5

 * In mid-2019, improved salt test kits became available for use in surveys. If the improved kits (with only reaction/no reaction result) were used iodised salt, there is no need for customisation of syntax. 
 * If the previous kits were used (with 0/0-15/15+ result), customisation is necessary. Please see below code and comment/uncomment relevant parts in this case.

 * Note if the survey tested for both iodate and iodide, the table and syntax should be customised to include all four tests.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Household.
get file = 'hh.sav'.

select if (HH46 = 1).

weight by hhweight.

***New version of salt test kits, currently active and used of caluclation of variables test1 test2 and test3. Comment out this part if old version of salt test kits was used in your survey.
************************************************************************.
* Salt was tested only once if the (first) result indicated reaction: SA1=5.
compute test1 = 0.
if (SA1 = 5) test1 = 100.
variable labels test1 "1st test: Iodised".

* If salt tested with no reaction (SA1=1), a second test was conducted:
* 2nd test with reaction: SA2=5.
compute test2 = 0.
if (SA1=1 and SA2=5) test2 = 100.
variable labels test2 "2nd test: Iodised".

*2nd test with no reaction: SA2=1.
compute test3 = 0.
if (SA1=1 and SA2=1) test3 = 100.
variable labels test3 "2nd test: Not iodised".
************************************************************************.

************************************************************************.
* Uncomment this part if old version of salt test kits was used.
 * compute test1 = 0.
 * if (SA1 = 2 or SA1 = 3) test1 = 100.
 * variable labels test1 "1st test >0 PPM".

 * compute test2 = 0.
 * if (SA2 = 2 or SA2 = 3) test2 = 100.
 * variable labels test2 "2nd test >0 PPM".

 * compute test3 = 0.
 * if (SA2 = 1) test3 = 100.
 * variable labels test3 "2nd test 0 PPM".
*************************************************************************.

*Salt was not tested if no salt in household: SA1=4.
compute nosalt = 0.
if (SA1 = 4) nosalt = 100.
variable labels nosalt "No salt in household".

*Or for any other reason: SA1=6 or SA2>5.
compute other = 0.
if (SA1 = 6 or SA2 > 5) other = 100.
variable labels other "Other [A]".

compute hn = 1.
variable labels hn "".
value labels hn 1 "Number of households".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 1 "".

compute layer = 0.
variable labels layer " ".
value labels layer 0 "Salt was tested".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Salt was not tested, by reason".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables =  hn layer layer1
         display = none
   /table total [c] + hh6 [c] + hh7 [c] + windex5 [c] by 
    layer [c] > (test1 [s] [mean '' f5.1] + test2 [s] [mean '' f5.1] + test3 [s] [mean '' f5.1]) +
    layer1 [c] > (nosalt [s] [mean '' f5.1] + other [s] [mean '' f5.1]) + tot1 [s] [mean '' f5.1] + hn [c] [count '' f5.0]  
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table DQ.3.1: Completeness of salt iodisation testing"
   "Percent distribution of households by completion of test for salt iodisation, " + surveyname
  caption = "[A] Includes those tests indicating 0 PPM in first test where a second test was not performed".			

new file.	
