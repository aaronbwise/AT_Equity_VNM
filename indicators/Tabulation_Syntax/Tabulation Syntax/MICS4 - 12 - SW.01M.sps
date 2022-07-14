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

recode MLS3 (1, 2 = 100) (else = 0) into famlife.
variable labels famlife "Family life".

recode MLS4 (1, 2 = 100) (else = 0) into friends.
variable labels friends "Friendships".

do if (MLS5 = 1).
+ recode MLS6 (1, 2 = 100) (else = 0) into school.
+ variable labels school "School".
end if.

do if (MLS7 <> 0).
+ recode LS7 (1, 2 = 100) (else = 0) into job.
+ variable labels job "Current job".
end if.

recode MLS8 (1, 2 = 100) (else = 0) into health.
variable labels health "Health".

recode MLS9 (1, 2 = 100) (else = 0) into livenv.
variable labels livenv "Living environment".

recode MLS10 (1, 2 = 100) (else = 0) into treat.
variable labels treat "Treatment by others".

recode MLS11 (1, 2 = 100) (else = 0) into look.
variable labels look "The way they look".

do if (MLS13 <> 0).
+ recode MLS13 (1, 2 = 100) (else = 0) into income.
+ variable labels income "Current income".
end if.

recode MLS5 (2 = 100) (else = 0) into noschool.
variable labels noschool "Are not currently attending school".	

recode MLS7 (0 = 100) (else = 0) into nojob.
variable labels nojob "Do not have a job".

recode MLS13 (0 = 100) (else = 0) into noincome.
variable labels noincome "Do not have any income".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men age 15-24 who are very or somewhat satisfied with selected domains:".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of men age 15-24 who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

ctables
  /vlabels variables =  total layer0 layer1 tot display = none
  /table mage [c] + hh7 [c] + hh6 [c] + mmstatus [c]  + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer0 [c] > (famlife [s] [mean,'',f5.1] + friends [s] [mean,'',f5.1] + school [s] [mean,'',f5.1] + job [s] [mean,'',f5.1] + 
		                 health [s] [mean,'',f5.1] + livenv [s] [mean,'',f5.1] + treat [s] [mean,'',f5.1]+ look  [s] [mean,'',f5.1] + income  [s] [mean,'',f5.1] ) +
                   layer1 [c] > (noschool [s] [mean,'',f5.1] + nojob [s] [mean,'',f5.1] + noincome[s] [mean,'',f5.1]) +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
	  "Table SW.1M: Domains of life satisfaction" 															
	  "Percentage of men age 15-24 years who are very or somewhat satisfied in selected domains, " + surveyname.				
							
new file.
