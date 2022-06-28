* Encoding: windows-1252.
 * The percentage of men age 15-49 years who in the last 12 months have felt discriminated against or harassed is tabulated by frequency of basis for discrimination or 
 harassment using question MMVT22A through MMVT22X. A 'yes' to any of these questions is included in the numerator of MICS indicator 15.4.
***.
* v02 - 2020-04-21  Labels in French and Spanish have been removed.
***.

include "surveyname.sps".

get file="mn.sav".

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.

compute MVT22ethnic = 0.
if (MVT22A = 1) MVT22ethnic = 100.
variable labels MVT22ethnic "Ethnic or immigration origin".

compute MVT22sex = 0.
if (MVT22B = 1) MVT22sex = 100.
variable labels MVT22sex "Gender".

compute MVT22sexual = 0.
if (MVT22C = 1) MVT22sexual = 100.
variable labels MVT22sexual "Sexual orientation".

compute MVT22age = 0.
if (MVT22D = 1) MVT22age = 100.
variable labels MVT22age "Age".

compute MVT22religion = 0.
if (MVT22E = 1) MVT22religion = 100.
variable labels MVT22religion "Religion or belief".

compute MVT22disability = 0.
if (MVT22F = 1) MVT22disability = 100.
variable labels MVT22disability "Disability".

compute MVT22other = 0.
if (MVT22X = 1) MVT22other = 100.
variable labels MVT22other "Other reason".

compute any = 0.
if (MVT22A = 1 or MVT22B = 1 or MVT22C = 1 or MVT22D = 1 or MVT22E = 1 or MVT22F = 1 or MVT22X = 1) any = 100.
variable labels any "Any reason [1]".

compute nodiscrimination = 0.
if (any = 0) nodiscrimination = 100.
variable labels nodiscrimination "Percentage of men who have not felt discriminated against or harassed in the last 12 months".

compute layer = 1.
value labels layer 1 "Percentage of men who in the last 12 months have felt discriminated against or harassed on the basis of:".

compute numMen = 1.
value labels numMen 1 "Number of men".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer numMen
           display = none
  /table  total [c]
         + HH6 [c]
         + HH7 [c]
         + $mwage [c]
         + mwelevel [c]
         + mdisability [c]
         + ethnicity [c]
         + windex5 [c]
   by
          layer [c] > (
            MVT22ethnic [s] [mean '' f5.1]
          + MVT22sex [s] [mean '' f5.1]
          + MVT22sexual [s] [mean '' f5.1]
          + MVT22age [s] [mean '' f5.1]
          + MVT22religion [s] [mean '' f5.1]
          + MVT22disability [s] [mean '' f5.1]
          + MVT22other [s] [mean '' f5.1]
          + any [s] [mean '' f5.1] )
          + nodiscrimination [s] [mean '' f5.1]
        + numMen [c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table EQ.3.1M: Discrimination and harassment (men)"
     "Percentage of men age 15-49 years who in the past 12 months have felt discriminated against or harassed and those who have not felt discriminated against or harassed, " + surveyname
   caption=
     "[1] MICS indicator EQ.7 - Discrimination; SDG Indicators 10.3.1 & 16.b.1"
  .

new file.
