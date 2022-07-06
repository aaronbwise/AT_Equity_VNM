* MICS5 CP-04.

* v02 - 2014-04-07.
* v03 - 2014-04-21.
* The two column headers labelled “Above the age specific threshold” have been changed to “At or above the age specific threshold”.
* The background characteristics have been reordered to match other CP tables.
* variable SL6 changed to correct SL1 (total number of children).
*  line  /keep hh1 hh2 sl9b HL4 ED7 melevel  changed to /keep hh1 hh2 sl9b HL4 ED5 melevel  .


* Random selection of one child age 1-17 years per household is carried out during fieldwork for administering the child labour and/or
  child discipline modules.
* The child labour module is administered for children age 5-17 from among those randomly selected.

* To account for the random selection, the household sample weight is multiplied by the total number of children age 1-17 in each household;
  this weight is used when producing this table.

* The numerator to estimate the percentage of children age 5-17 years in child labour includes children 5-17 years of age that were involved
  during the week preceding the survey in economic activities or household chores at or above the age specific tresholds (see Tables CP.2 and CP.3),
  or were working under hazardous conditions (Response ""1"" to any of the following: CL5, CL6, CL7A, CL7B, CL7C, CL7D, CL7E, CL7F).

* The background variable of School attendance must be taken out of the child labour tables
   (CP.2, CP.3, and CP.4)
  if a significant proportion of the fieldwork was conducted during the break between school years, as otherwise the results would be biased .

* MICS standard questionnaires are designed to establish mother's/caretaker's education for all children up to and including
  age 14 at the time of interview (see List of Household Members, Household Questionaire).
* The category "Cannot be determined" includes children who were age 15 or higher at the time of the interview whose mothers were not
  living in the household. For such cases, information on their primary caretakers is not collected - therefore the educational status
  of the mother or the caretaker cannot be determined .

***.


include "surveyname.sps".

get file = 'hl.sav'.
sort cases by hh1 hh2 hl1 .
save outfile = 'tmp.sav'
  /rename (HL1 = SL9B)
  /keep hh1 hh2 sl9b HL4 ED5 melevel  .

get file = 'hh.sav' .
select if (not sysmis(SL9B)) .
sort cases by hh1 hh2 sl9b.

match files
  /file = *
  /table = "tmp.sav"
  /by HH1 HH2 SL9B
  .

* calculate total number of children age 1 - 17 unweighted in order to properly normalize weights.
aggregate 
  /outfile = * mode = addvariables
  /totunw = sum (SL1).

* compute temporary weight needed for normalization process.
compute tmpw = hhweight * SL1.

weight by tmpw.

* calculate total number of hh with at least one child age 1 - 17 unweighted in order to properly normalize weights.
aggregate 
  /outfile = * mode = addvariables
  /totw = N (SL1).

compute slweight = tmpw*totunw/totw.

weight by slweight.

select if (SL9C >= 5 and SL9C <= 17).

add value labels melevel
  5 'Cannot be determined [a]'.

recode ED5 (1 = 1) (else = 2) into schoolAttendance.
variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Yes" 2 "No" .

* definitions of econcomic activity, hh choreas and working at hazardous conditions variables  .
include 'define\MICS5 - 09 - CP.sps' .

variable labels
   eaLess "Below the  age specific threshold"
  /eaMore "At or above the age specific threshold"
  /hhcLess "Below the age specific threshold"
  /hhcMore "At or above the age specific threshold"
  /hazardConditions "Children working under hazardous conditions"
  /childLabor "Total child labour [1]" .

compute layerEA = 1 .
compute layerHHC = 1 .
compute numChildren = 1 .

value labels
   layerEA   1 "Children involved in economic activities for a total number of hours during last week:"
  /layerHHC  1 "Children involved in household chores for a total number of hours during last week:"
  /numChildren 1 "Number of children age 5-17 years"
  .

recode SL9C (5 thru 11 = 1) (12 thru 14 = 2) (15 thru 17 = 3) into ageGroup .
variable labels ageGroup "Age" .
value labels ageGroup
1 "5-11"
2 "12-14"  
  3 "15-17".
formats ageGroup (f1.0).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numChildren layerEA layerHHC
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + ageGroup [c]
         + schoolAttendance [c]
         + melevel[c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerEA [c] > (
             ealess[s] [mean '' f5.1]
           + eaMore[s] [mean '' f5.1] )
         + layerHHC [c] > (
             hhcLess[s] [mean '' f5.1]
           + hhcMore[s] [mean '' f5.1] )
         + hazardConditions [s] [mean '' f5.1]
         + childLabor [s] [mean '' f5.1]
         + numChildren [c] [count '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table CP.4: Child labour"
  	 "Percentage of children age 5-17 years by involvement in economic activities or household chores during the last week, percentage " +
     "working under hazardous conditions during the last week, and percentage engaged in child labour during the last week, " + surveyname
   caption=
     "[1] MICS indicator 8.2 - Child labour"
     "[a] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
  .

new file.
erase file ='tmp.sav' .
