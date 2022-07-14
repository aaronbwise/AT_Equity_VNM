include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

select if (mage = 1 or mage = 2).

weight by mmweight.	

* Create marital status with separate groups for ever married married.
recode mmstatus (1, 2 = 1) (3 = 2) (else = 9).
variable labels mmstatus "Marital status".
value labels mmstatus
	1 "Ever married/in union"
 2 "Never married/in union"
	9 "Missing".
								
compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-24 years".

recode MLS14 (1 = 100) (else = 0) into improve.
variable labels improve "Improved during the last one year".

recode MLS15 (1 = 100) (else = 0) into better1yr.
variable labels better1yr "Will get better after one year".

compute lifeiprv = 0.
if (improve = 100 and better1yr = 100) lifeiprv = 100.
variable labels lifeiprv "Both [1]".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men who think that their life".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables =  total layer0 tot display = none
  /table mage [c] + hh7 [c] + hh6 [c] + mmstatus [c]  + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer0 [c] > (improve [s] [mean,'',f5.1] + better1yr [s] [mean,'',f5.1] + lifeiprv [s] [mean,'',f5.1]) +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
	  "Table SW.3: Perception of a better life" 															
	  "Percentage of women age 15-24 years who think that their lives improved during the last one year " +
   "and and those who expect that their lives will get better after one year, " + surveyname
  caption = 
	  "[1] MICS indicator SW.3".			

new file.
