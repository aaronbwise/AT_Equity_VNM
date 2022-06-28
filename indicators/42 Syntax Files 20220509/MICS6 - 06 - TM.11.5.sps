* Encoding: windows-1252.
 * "Women who received antenatal care from a health care professional during the last pregnancy (MN3=’A’ or MN3=’B’ or MN3=’C’).

 * Women who received HIV counselling includes those who were given information about (a) babies getting HIV from their mother, (b) things that can be done to prevent contracting
    HIV, and (c) getting tested for HIV. All three should be 'Yes': HA13[A]=1 and HA13[B]=1 and HA13[C]=1.

 * Women who were offered a test (HA13[D]=1), were tested (HA14=1), and received the results (HA15=1) during antenatal care form the numerator of MICS indicator 9.8.

 * The last result column relating to post-test counselling, requires the woman to have been offered a test (HA13[D]=1), accepting the test (HA14=1), receiving the results (HA15=1) and 
    receiving post-test counselling (HA16=1).

 * The denominator of the table includes all women with a live birth in the last 2 years, including those who have not heard of AIDS (HA1=2). "							
										

***.
* v02. 2019-03-14.
* v03 - 2020-04-26. In note A, changed "counseling" to "counselling". Labels in French and Spanish have been removed.

include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

*select women that gave birth in two years preceeding the survey (five in case of sierra leone).
select if (CM17 = 1).

include 'define\MICS6 - 06 - TM.sps' .

* Women who received antenatal care during the last pregnancy.
variable labels skilledPersonnel "Received antenatal care from a health care professional for the pregnancy of the most recent live birth".
		
* Women who received HIV counselling .
compute hivCounselling = 0.
if (HA13A = 1 and HA13B = 1 and HA13C = 1) hivCounselling = 100.
variable labels hivCounselling "Received HIV counselling during antenatal care [1] [A]".

* Women who were offered a test (HA13D=1) and were tested (HA14=1), .
compute hivTest = 0.
if (HA13D = 1 and HA14 = 1) hivTest = 100.
variable labels hivTest "Were offered an HIV test and were tested for HIV during antenatal care".

* and received the results (HA15=1) during antenatal care form the numerator of MICS indicator 9.8.
compute hivResult = 0.
if (hivTest = 100 and HA15 = 1) hivResult = 100.
variable labels hivResult "Were offered an HIV test and were tested for HIV during antenatal care, and received the results [2]".

* Combine receipt of HIV counseling and testing coverage.
compute hivCounselingResult = 0.
if (hivCounselling = 100 and hivResult = 100) hivCounselingResult = 100.
variable labels hivCounselingResult "Received HIV counseling, were offered an HIV test, accepted and received the results".

* Combine testing coverage and post-test counseling.
compute allFour = 0.
if (hivResult = 100 and HA16 = 1) allFour = 100.
variable labels allFour "Were offered an HIV test, accepted and received the results, and received post-test health information or counselling related to HIV [3]".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of women who:".

compute numWomen = 1.
variable labels numWomen "".
value labels numWomen 1 "Number of women with a live birth in the last 2 years".

* ctables command in English.
ctables
  /vlabels variables =  numWomen layer1  total
           display = none
  /table   total [c]
         + HH6 [c]
         + HH7 [c]
         + $wagez [c]
         + welevel [c]
         + mstatus2 [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
         layer1 [c] > (
             skilledPersonnel  [s] [mean '' f5.1]
           + hivCounselling [s] [mean '' f5.1]
           + hivTest [s] [mean '' f5.1]
           + hivResult [s] [mean '' f5.1]
           + hivCounselingResult [s] [mean '' f5.1]
           + allFour [s] [mean '' f5.1])
         + numWomen [c] [count '' f5.0]
  /categories variables = all empty = exclude missing = exclude
  /slabels visible = no
  /titles title=
    "Table TM.11.5: HIV counselling and testing during antenatal care"
    "Percentage of women age 15-49 with a live birth in the last 2 years who received antenatal care from a health professional during the pregnancy of the most recent birth, " +
    "percentage who received HIV counselling, percentage who were offered and tested for HIV, percentage who were offered, tested and received the results of the HIV test, " +
    "percentage who received counselling and were offered, accepted and received the results of the HIV test, " +
    "and percentage who were offered, accepted and received the results of the HIV test and received post-test health information or counselling," + surveyname
   caption =
    "[1] MICS indicator TM.35a - HIV counselling during antenatal care (counseling on HIV)"
    "[2] MICS indicator TM.36 - HIV testing during antenatal care"
    "[3] MICS indicator TM.35b - HIV counselling during antenatal care (information or counseling on HIV after receiving the HIV test results)"
    "[A] In this context, counselling means that someone talked with the respondent about all three of the following topics: 1) babies getting the HIV from their mother, 2) preventing HIV, and 3) getting tested for HIV."					
  .

new file.
