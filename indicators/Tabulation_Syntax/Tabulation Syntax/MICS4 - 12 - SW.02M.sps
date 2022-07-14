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

* The life satisfaction indicator is not calculated if responses other than 1 to 5 have been given for more than 4 questions used for the calculation of the indicator. 
* Respondents who are not attending school and who do not have a job are considerd to have missing responses in these domains.
recode MLS3 (1 thru 5 = 1) (else = sysmis) into factor1.
recode MLS4 (1 thru 5 = 1) (else = sysmis) into factor2.
recode MLS6 (1 thru 5 = 1) (else = sysmis) into factor3.
recode MLS7 (1 thru 5 = 1) (else = sysmis) into factor4.
recode MLS8 (1 thru 5 = 1) (else = sysmis) into factor5.
recode MLS9 (1 thru 5 = 1) (else = sysmis) into factor6.
recode MLS10 (1 thru 5 = 1) (else = sysmis) into factor7.
recode MLS11 (1 thru 5 = 1) (else = sysmis) into factor8.
count includ = factor1 factor2 factor3 factor4 factor5 factor6 factor7 factor8 (1).

recode MLS3 (0,8,9 = sysmis) (else = copy) into ind1.
recode MLS4 (0,8,9 = sysmis) (else = copy) into ind2.
recode MLS6 (0,8,9 = sysmis) (else = copy) into ind3.
recode MLS7 (0,8,9 = sysmis) (else = copy) into ind4.
recode MLS8 (0,8,9 = sysmis) (else = copy) into ind5.
recode MLS9 (0,8,9 = sysmis) (else = copy) into ind6.
recode MLS10 (0,8,9 = sysmis) (else = copy) into ind7.
recode MLS11 (0,8,9 = sysmis) (else = copy) into ind8.

recode MLS3 (1, 2 = 1) (else = 0) into ls1.
recode MLS4 (1, 2 = 1) (else = 0) into ls2.
recode MLS6 (1, 2 = 1) (else = 0) into ls3.
recode MLS7 (1, 2 = 1) (else = 0) into ls4.
recode MLS8 (1, 2 = 1) (else = 0) into ls5.
recode MLS9 (1, 2 = 1) (else = 0) into ls6.
recode MLS10 (1, 2 = 1) (else = 0) into ls7.
recode MLS11 (1, 2 = 1) (else = 0) into ls8.
count lscount = ls1 ls2 ls3 ls4 ls5 ls6 ls7 ls8 (1).

do if (includ >= 4).

+ compute lifesat = 0.
+ if (lscount = includ) lifesat = 100.

variable labels lifesat "Percentage of women with life satisfaction [1]".
					
compute lsscore = mean (ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8).
variable labels lsscore "Average life satisfaction score".

end if.

compute missingls = 0.
if (includ < 4) missingls = 100.
variable labels missingls "Missing / Cannot be calculated".

do if (MLS13 <> 0 and includ >= 4).
+ compute  income = 0.
+ if ((MLS13 = 1 or MLS13 = 2) and lifesat = 100) income = 100.
+ variable labels income "Men with life satisfaction who are very or somewhat satisfied with their income".
end if.

compute misincom = 0.
if (includ < 4 or MLS13 = 0) misincom = 100.
variable labels misincom "No income / Cannot be calculated".

recode MLS2 (1, 2 = 100) (else = 0) into happy.
variable labels happy "Percentage who are very or somewhat happy [2]".	

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".				

ctables
  /vlabels variables = total tot display = none
  /table mage [c] + hh7 [c] + hh6 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   lifesat [s] [mean,'',f5.1] + lsscore [s] [mean,'',f5.1] + missingls [s] [mean,'',f5.1] + income [s] [mean,'',f5.1] + misincom [s] [mean,'',f5.1] + happy [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
	  "Table SW.2M: Life satisfaction and happiness" 															
	  "Percentage of men age 15-24 years who are very or somewhat satisfied with their family life, "
	  "friendships, school, current job, health, living environment, treatment by others, and the way they look, "
	  "the average life satisfaction score, percentage of men with life satisfaction who are also very or somewhat satisfied with their income, 	"
	  "and percentage of men age 15-24 years who are very or somewhat happy, " + surveyname
  caption = 
	  "[1] MICS Indicator SW.1"						
	  "[2] MICS indicator SW.2".						

new file.
