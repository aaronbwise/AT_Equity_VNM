* Encoding: UTF-8.
* MICS6 SR.7.1M.

* v01 - 2017-09-27.
* v03 - 2020-04-09.  Table titles have been harmonised to overall tabplan. Labels in French and Spanish have been removed.

** Questions MWB15-MWB16-MWB17.


***.

include "surveyname.sps".

get file = 'mn.sav'.

include "CommonVarsMN.sps".

select if (MWM17 = 1).

weight by mnweight.
																
compute sameR = 0.
if (MWB15 = 95) sameR = 100.
variable labels sameR  "Never migrated".

do if (sameR = 0).
+ recode MWB15 (1 thru 4 = 2) (5 thru 9 = 3) (10 thru 94 = 4) (99 = 9) (else = 1) into MWB15r.
+ compute totCR = 1.
end if.

variable labels totCR "Number of men who ever migrated".

variable labels MWB15r "Percentage of men, by time of last move".
value labels MWB15r 
1 "Less than one year"
2 "1-4 years"
3 "5-9 years"
4 "10 years or more"
9 "Missing".

* Adjust labels to correspond to tab plan.
variable labels MWB16 "Percentage of men whose last migration was from:".
value labels MWB16
1 "City"
2 "Town"
3 "Rural area"
9 "Missing".

add value labels MWB17 99 "Missing".

compute numMen = 1.
variable labels numMen "Number of men".
value labels numMen 1 "".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".

* producing the layers in tables.
compute layer0 = 0.
value labels 
  layer0 0 "Years since most recent migration:".

compute layer1 = 0.
value labels 
  layer1 0 "Most recent migration was from:".
 
* Ctables command in English.
ctables
  /vlabels variables = layer0 layer1  MWB16 MWB17 display = none
  /table   total[c]
         + hh6 [c]
         + hh7 [c]
         + $mwage [c]
         + mwelevel [c]
         + mmstatus2 [c]
         + mdisability [c]
         + ethnicity[c]
         + windex5 [c]
   by
           layer0 [c] > (sameR [s] [mean '' f5.1] +
           MWB15r [c] [rowpct.totaln '' f5.1]) + 
           tot [s] [mean '' f5.1] +
           numMen[s][sum '' f5.0] +
           layer1 [c] > ( MWB16 [c] [rowpct.validn '' f5.1] + 
           tot [s] [mean '' f5.1] ) +
           layer1 [c] > (MWB17 [c] [rowpct.validn '' f5.1] )+ 
           tot [s] [mean '' f5.1]+ 
           totCR [s] [sum '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table SR.7.1M: Migratory status (men)"
    "Percent distribution of men age 15-49 years by migratory status and years since last migration, and percent distribution of men who migrated, by type and place of last residence, " + surveyname
 .		

new file.
