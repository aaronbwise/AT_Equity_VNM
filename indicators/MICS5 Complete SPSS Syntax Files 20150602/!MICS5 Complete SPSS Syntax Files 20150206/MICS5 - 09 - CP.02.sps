* MICS5 CP-02.

* v02 - 2014-04-07.
* v03 - 2014-04-21.
* variable SL6 changed to correct SL1 (total number of children).
* line 45 /keep hh1 hh2 sl9b hl4 ed7 melevel changed to:  /keep hh1 hh2 sl9b hl4 ed5 melevel.

* Random selection of one child age 1-17 years per household is carried out during fieldwork for administering the child labour and/or
  child discipline modules .
* The child labour module is administered for children age 5-17 from among those randomly selected .

* To account for the random selection, the household sample weight is multiplied by the total number of children age 1-17 in each household;
  this weight is used when producing this table.

* Economic activity is defined as any yes '1' to the four types of activities listed in
    CL2A-CL2D.

* The methodology of the MICS indicator of Child Labour uses three age-specific thresholds for the number of hours a
  child can perform economic activity without it being classified as child labour. The number of hours are established in CL4.
* A child that performed economic activities during the last week for more than the age-specific number of hours is classified as in
  child labour:
    i)   age  5-11: 1 hour or more
    ii)  age 12-14: 14 hours or more
    iii) age 15-17: 43 hours or more

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
  /keep hh1 hh2 sl9b hl4 ed5 melevel.

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
* multiply number of children 1-17 in the interviewed hh with the household weight.
compute tmpw = hhweight * SL1.

weight by tmpw.

* calculate total number of hh with at least one child age 1 - 17 weighted in order to properly normalize weights.
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

* definitions of econcomic activity variables  (ea1more, ea14less, ea14more, ea43less, ea43more) .
include 'define\MICS5 - 09 - CP.sps' .

variable labels
   ea1more  "Percentage of children age 5-11 years involved in economic activity for at least one hour"
  /ea14less "Economic activity less than 14 hours"
  /ea14more "Economic activity for 14 hours or more" 
  /ea43less "Economic activity less than 43 hours"
  /ea43more "Economic activity for 43 hours or more" .

compute layerPercentage12_14 = numChildren12_14 . 
compute layerPercentage15_17 = numChildren15_17 . 

value labels
   numChildren5_11      1 "Number of children age 5-11 years"
  /numChildren12_14     1 "Number of children age 12-14 years"
  /numChildren15_17     1 "Number of children age 15-17 years"
  /layerPercentage12_14 1 "Percentage of children age 12-14 years involved in:"
  /layerPercentage15_17 1 "Percentage of children age 15-17 years involved in:" .

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /format missing = "na" 
  /vlabels variables = numChildren5_11 numChildren12_14 numChildren15_17 layerPercentage12_14 layerPercentage15_17
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
           ea1more[s] [mean '' f5.1]
         + numChildren5_11 [c] [count '' f5.0]
         + layerPercentage12_14 [c] > (
             ea14less [s] [mean '' f5.1]
           + ea14more [s] [mean '' f5.1] )
         + numChildren12_14 [c] [count '' f5.0]
         + layerPercentage15_17 [c] > (
             ea43less [s] [mean '' f5.1]
           + ea43more [s] [mean '' f5.1] )
         + numChildren15_17 [c] [count '' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table CP.2: Children's involvement in economic activities"
  	 "Percentage of children by involvement in economic activities during the last week, according to age groups, " + surveyname
   caption=
     "[a] Children age 15 or higher at the time of the interview whose mothers were not living in the household"
      "na: not applicable".

new file.
erase file ='tmp.sav' .
