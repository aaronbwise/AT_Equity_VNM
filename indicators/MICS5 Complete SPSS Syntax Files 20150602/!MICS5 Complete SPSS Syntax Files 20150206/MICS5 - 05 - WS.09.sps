* MICS5 WS-09.

* v01 - 2014-03-18.
* v02 - 2015-04-21.- Comment updated.

*Only households where the place for handwashing was observed by the interviewer (HW=1) and households with no specific place 
for handwashing (HW1 = 2) are included in the denominator of the indicator (HW1=3, 6, and 9 are excluded). 
*Households with water at place for handwashing (HW2=1) and soap or other cleansing agent at place for 
handwashing (HW3B=A, B, C, or D) are included in the numerator.

*In surveys where an additional category has been added (HW1=4) to capture a movable object (bucket, basin, container or kettle), 
this category should be included in the denominator of the indicator, as well as in the two columns where percentage of households 
with no specific place for handwashing in the dwelling, yard, or plot are shown. Categories HW1=2 and HW=4 may be split and 
shown if the prevalence of both is sought under these columns.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

* Select completed questionnaires.
select if (HH9 = 1).

weight by hhweight.

* Calculate total number of households.
compute numHouseholds = 1.
variable labels  numHouseholds "".
value labels numHouseholds 1 "Number of households".

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Percentage of households:".

* Households where the place for handwashing was observed by the interviewer (HW=1).
compute observed = 0.
if (HW1 = 1) observed = 100.
variable labels  observed "Where place for handwashing was observed".

*.. and households with no specific place for handwashing (HW1 = 2) are included in the denominator of the indicator. 
compute noplace = 0.
if (HW1 = 2) noplace = 100.
variable labels  noplace "With no specific place for handwashing in the dwelling, yard, or plot".

* Only households where the place for handwashing was observed by the interviewer (HW=1) and households with 
* no specific place for handwashing (HW1 = 2) are included in the denominator of the indicator. 
do if (observed = 100 or noplace = 100).
+ compute numHouseholdsObs = 1.

+ compute waterSoap = 9.
* Water is available and: Soap present.
+ if (HW2 = 1 and (HW3BA = "A" or HW3BB = "B" or HW3BC = "C")) waterSoap = 1.
* Water is available and: No soap: Ash, mud, or sand present.
+ if (HW2 = 1 and waterSoap = 9 and HW3BD = "D") waterSoap = 2.
* Water is available and: No soap: No other cleansing agent present.
+ if (HW2 = 1 and waterSoap = 9) waterSoap = 3.

* Water is not available and: Soap present.
+ if (HW2 <> 1 and (HW3BA = "A" or HW3BB = "B" or HW3BC = "C")) waterSoap = 4.
* Water is not available and: No soap: Ash, mud, or sand present.
+ if (HW2 <> 1 and waterSoap = 9 and HW3BD = "D") waterSoap = 5.
* Water is not available and: No soap: No other cleansing agent present.
+ if (HW2 <> 1 and waterSoap = 9) waterSoap = 6.

* No specific place for handwashing in the dwelling, yard, or plot.
+ if (noplace = 100) waterSoap = 7.

* Households with water at place for handwashing (HW2=1) and soap or other cleansing agent at place for handwashing (HW3B=A, B, C, or D) are included in the numerator.
+ compute ind45 = 0.
+ if (HW2 = 1 and (HW3BA = "A" or HW3BB = "B" or HW3BC = "C" or HW3BD = "D")) ind45 = 100.

end if.


variable labels  waterSoap " ".
value labels waterSoap
  1 "Place for handwashing observed: Water is available and: Soap present"
  2 "Place for handwashing observed: Water is available and: No soap: Ash, mud, or sand present"
  3 "Place for handwashing observed: Water is available and: No soap: No other cleansing agent present"
  4 "Place for handwashing observed: Water is not available and: Soap present"
  5 "Place for handwashing observed: Water is not available and: No soap: Ash, mud, or sand present"
  6 "Place for handwashing observed: Water is not available and: No soap: No other cleansing agent present"
  7 "No specific place for handwashing in the dwelling, yard, or plot"
  9 "Missing".

variable labels ind45 "Percentage of households with a specific place for handwashing where water and soap or other cleansing agent are present [1]".

* Make sure to include entire label in final table. As label exceeds 120 characters it had to be trunckated by removing > in the dwelling, yard, or plot<.
*  Number of households where place for handwashing was observed or with no specific place for handwashing in the dwelling, yard, or plot.
variable labels numHouseholdsObs "".
value labels numHouseholdsObs 1 "Number of households where place for handwashing was observed or with no specific place for handwashing".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute total100 = 100.
variable labels total100 "Total".
value labels total100 100 "".

ctables
  /vlabels variables =  layer1 numHouseholds total numHouseholdsObs waterSoap
         display = none
  /table   total [c]
         + hh7 [c]
         + hh6 [c]
         + helevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
          layer1 [c] > (observed [s] [mean,'',f5.1] + noplace [s] [mean,'',f5.1]) + numHouseholds [c] [count,'',f5.0]
         + waterSoap [c] [rowpct.validn,'',f5.1]
         + total100 [s] [mean,'',f5.1]
         + ind45  [s] [mean,'',f5.1]
         + numHouseholdsObs [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.9: Water and soap at place for handwashing"
    "Percentage of households where place for handwashing was observed, percentage with no specific place for handwashing, " +
    "and percent distribution of households by availability of water and soap at specific place for handwashing, " + surveyname
   caption=
     "[1] MICS indicator 4.5 - Place for handwashing".

new file.
