* MICS5 HA-09 .

* v02 - 2014-04-02.
* v03 - 2014-04-22.
*The wording in column C has been replaced by “Percentage of children whose parents are still alive and who are living with at least one parent (non-orphans)”.
* The wording in column G has been replaced by “Percentage of children whose parents are still alive, who are living with at least one parent (non-orphans), and who are attending school”.


* Orphans: Children whose mother and father have died (HL11=2 and HL13=2).
* Non-orphans: Children whose parents are alive and who are living with at least one parent: (HL11=1 and HL13=1) and (HL12>00 or HL14>00).

* Orphans attending attendingSchool: (ED5=1).
* The denominator is all orphaned children.

* Non-orphans attending attendingSchool: (ED5=1).
* The denominator is all non-orphaned children.

***.


include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

select if (HL6 >= 10 and HL6 <= 14).

compute total  = 1.
variable labels total "".
value labels total 1 "Total".

compute numChildren = 1 .

compute orphanChildren = 0.
compute nonOrphanChildren = 0.
if (HL11 = 2 and HL13 = 2)  orphanChildren = 100.
if (HL11 = 1 and HL13 = 1 and (HL12 > 0 or HL14 > 0))  nonOrphanChildren = 100.

if (orphanChildren = 100) numOrphanChildren = 1.
if (nonOrphanChildren = 100) numNonOrphanChildren = 1.

do if (orphanChildren = 100).
+ compute orphanChildrenAtSchool = 0.
+ if (ED5 = 1) orphanChildrenAtSchool = 100.
end if.

do if (nonOrphanChildren = 100).
+ compute nonOrphanChildrenAtSchool = 0.
+ if (ED5 = 1) nonOrphanChildrenAtSchool = 100.
end if.

aggregate outfile = 'tmp1.sav'
  /break total
  /orphanChildren     = mean(orphanChildren)
  /nonOrphanChildren  = mean(nonOrphanChildren)
  /numChildren        = sum(numChildren)
  /orphanChildrenAtSchool     = mean(orphanChildrenAtSchool)
  /numOrphanChildren          = sum(numOrphanChildren)
  /nonOrphanChildrenAtSchool  = mean(nonOrphanChildrenAtSchool)
  /numNonOrphanChildren       = sum(numNonOrphanChildren)  .

aggregate outfile = 'tmp2.sav'
  /break HL4
  /orphanChildren     = mean(orphanChildren)
  /nonOrphanChildren  = mean(nonOrphanChildren)
  /numChildren        = sum(numChildren)
  /orphanChildrenAtSchool     = mean(orphanChildrenAtSchool)
  /numOrphanChildren          = sum(numOrphanChildren)
  /nonOrphanChildrenAtSchool  = mean(nonOrphanChildrenAtSchool)
  /numNonOrphanChildren       = sum(numNonOrphanChildren)  .

aggregate outfile = 'tmp3.sav'
  /break HH6
  /orphanChildren     = mean(orphanChildren)
  /nonOrphanChildren  = mean(nonOrphanChildren)
  /numChildren        = sum(numChildren)
  /orphanChildrenAtSchool     = mean(orphanChildrenAtSchool)
  /numOrphanChildren          = sum(numOrphanChildren)
  /nonOrphanChildrenAtSchool  = mean(nonOrphanChildrenAtSchool)
  /numNonOrphanChildren       = sum(numNonOrphanChildren)  .

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'.

compute ratio1 = orphanChildrenAtSchool / nonOrphanChildrenAtSchool.

variable labels orphanChildren "Percentage of children whose mother and father have died (orphans)"
  /nonOrphanChildren           "Percentage of children whose parents are still alive and who are living with at least one parent (non-orphans)"
  /numChildren                 "Number of children age 10-14 years"
  /orphanChildrenAtSchool      "Percentage of children whose mother and father have died (orphans) and are attending school"
  /numOrphanChildren           "Total number of orphan children age 10-14 years"
  /nonOrphanChildrenAtSchool   "Percentage of children whose parents are still alive, who are living with at least one parent (non-orphans), and who are attending school"
  /numNonOrphanChildren        "Total number of non-orphan children age 10-14 years" 
  /ratio1                      "Orphans to non-orphans school attendance ratio [1]" .


* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
   by
           orphanChildren [s] [mean,'',f5.1]
         + nonOrphanChildren [s] [mean,'',f5.1]
         + numChildren [s] [sum,'',f5.0]
         + orphanChildrenAtSchool [s] [mean,'',f5.1]
         + numOrphanChildren [s] [sum,'',f5.0]
         + nonOrphanChildrenAtSchool [s] [mean,'',f5.1]
         + numNonOrphanChildren [s] [sum,'',f5.0]
         + ratio1 [s] [mean,'',f5.2]
  /categories var = all empty = exclude missing = exclude
  /slabels visible = no
  /title title=
    "Table HA.9: School attendance of orphans and non-orphans"
    "School attendance of children age 10-14 years by orphanhood, " + surveyname
  caption=
    "[1] MICS indicator 9.16; MDG indicator 6.4 - Ratio of school attendance of orphans to school attendance of non-orphans"
    "See Table CP.14 for further overall results related to children's living arrangements and orphanhood"
  .

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
