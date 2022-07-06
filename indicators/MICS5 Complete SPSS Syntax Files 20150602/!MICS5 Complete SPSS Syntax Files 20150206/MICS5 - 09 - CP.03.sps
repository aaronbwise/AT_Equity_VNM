* MICS5 CP-03.

* v02 - 2014-04-07.
* v03 - 2014-04-21.
* variable SL6 changed to correct SL1 (total number of children).
* line 46 /keep hh1 hh2 sl9b hl4 ed7 melevel changed to:  /keep hh1 hh2 sl9b hl4 ed5 melevel.


* Random selection of one child age 1-17 years per household is carried out during fieldwork for administering the child labour and/or
  child discipline modules .
* The child labour module is administered for children age 5-17 from among those randomly selected .

* To account for the random selection, the household sample weight is multiplied by the total number of children age 1-17 in each household;
  this weight is used when producing this table.

* Household chores are defined as any yes '1' to the eight types of activities listed in
   CL8 and CL10A-CL10G .

* The methodology of the MICS indicator of Child Labour uses two age-specific thresholds for the number of hours a child can perform household
  chores without it being classified as child labour.
* The number of hours are established in CL4.

* A child that performed household chores during the last week for more than the age-specific number of hours is classified as in child labour:
    i)  age 5-11 and age 12-14: 28 hour or more
    ii) age 15-17: 43 hours or more

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
  /keep hh1 hh2 sl9b hl4 ed5 melevel  .

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

* definitions of econcomic activity variables  (hhc28less, hhc28more, hhc43less, hhc43more) .
include 'define\MICS5 - 09 - CP.sps' .

variable labels
   hhc28less "Household chores less than 28 hours"
  /hhc28more "Household chores for 28 hours or more"
  /hhc43less "Household chores less than 43 hours"
  /hhc43more "Household chores for 43 hours or more" .


if (SL9C<=11) numChildren5_11 = 1 .
if (any(SL9C, 12, 13, 14)) numChildren12_14 = 1 .
if (any(SL9C, 15, 16, 17)) numChildren15_17 = 1 .

compute layerPercent5_11 = numChildren5_11 .
compute layerPercent12_14 = numChildren12_14 .
compute layerPercent15_17 = numChildren15_17 .

value labels
   numChildren5_11   1 "Number of children age 5-11 years"
  /numChildren12_14  1 "Number of children age 12-14 years"
  /numChildren15_17  1 "Number of children age 15-17 years"
  /layerPercent5_11  1 "Percentage of children age 5-11 years involved in:"
  /layerPercent12_14 1 "Percentage of children age 12-14 years involved in:"
  /layerPercent15_17 1 "Percentage of children age 15-17 years involved in:"
  .


compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numChildren5_11 numChildren12_14 numChildren15_17 layerPercent5_11 layerPercent12_14 layerPercent15_17
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + schoolAttendance [c]
         + melevel[c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerPercent5_11 [c] > (
             hhc28less[s] [mean '' f5.1]
           + hhc28more[s] [mean '' f5.1] )
         + numChildren5_11 [c] [count '' f5.0]
         + layerPercent12_14 [c] > (
             hhc28less[s] [mean '' f5.1]
           + hhc28more[s] [mean '' f5.1] )
         + numChildren12_14 [c] [count '' f5.0]
         + layerPercent15_17 [c] > (
             hhc43less[s] [mean '' f5.1]
           + hhc43more[s] [mean '' f5.1] )
         + numChildren15_17 [c] [count '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table CP.3: Children's involvement in household chores"
  	 "Percentage of children by involvement in household chores during the last week, according to age groups, " + surveyname
   caption=
     "[a] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
     "na: not applicable" .


new file.
erase file ='tmp.sav' .
