* Encoding: windows-1252.
 * The percentage of women age 15-49 years who in the last 12 months have felt discriminated against or harassed is tabulated by frequency of basis for discrimination or 
    harassment using question VT22A through VT22X. A 'yes' to any of these questions is included in the numerator of MICS indicator 15.4.
***.
* v02 - 2020-04-21  Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file="wm.sav".

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

compute VT22ethnic = 0.
if (VT22A = 1) VT22ethnic = 100.
variable labels VT22ethnic "Ethnic or immigration origin".

compute VT22sex = 0.
if (VT22B = 1) VT22sex = 100.
variable labels VT22sex "Gender".

compute VT22sexual = 0.
if (VT22C = 1) VT22sexual = 100.
variable labels VT22sexual "Sexual orientation".

compute VT22age = 0.
if (VT22D = 1) VT22age = 100.
variable labels VT22age "Age".

compute VT22religion = 0.
if (VT22E = 1) VT22religion = 100.
variable labels VT22religion "Religion or belief".

compute VT22disability = 0.
if (VT22F = 1) VT22disability = 100.
variable labels VT22disability "Disability".

compute VT22other = 0.
if (VT22X = 1) VT22other = 100.
variable labels VT22other "Other reason".

compute any = 0.
if (VT22A = 1 or VT22B = 1 or VT22C = 1 or VT22D = 1 or VT22E = 1 or VT22F = 1 or VT22X = 1) any = 100.
variable labels any "Any reason [1]".

compute nodiscrimination = 0.
if (any = 0) nodiscrimination = 100.
variable labels nodiscrimination "Percentage of women who have not felt discriminated against or harassed in the last 12 months".

compute layer = 1.
value labels layer 1 "Percentage of women who in the last 12 months have felt discriminated against or harassed on the basis of: ".

compute numWomen = 1.
value labels numWomen 1 "Number of women".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer numWomen
           display = none
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + $wage [c]
         + welevel [c]
         + disability [c]
         + ethnicity [c]
         + windex5 [c]
   by
          layer [c] > (
            VT22ethnic [s] [mean '' f5.1]
          + VT22sex [s] [mean '' f5.1]
          + VT22sexual [s] [mean '' f5.1]
          + VT22age [s] [mean '' f5.1]
          + VT22religion [s] [mean '' f5.1]
          + VT22disability [s] [mean '' f5.1]
          + VT22other [s] [mean '' f5.1]
          + any [s] [mean '' f5.1] )
          + nodiscrimination [s] [mean '' f5.1]
        + numWomen [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.3.1W: Discrimination and harassment (women)"
  	 "Percentage of women age 15-49 years who in the past 12 months have felt discriminated against or harassed and those who have not felt discriminated against or harassed, " + surveyname
   caption=
     "[1] MICS indicator EQ.7 - Discrimination; SDG Indicators 10.3.1 & 16.b.1".

new file.
