include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

select if (wage = 1 or wage = 2).

weight by wmweight.	

* Create marital status with separate groups for ever married married.
recode mstatus (1, 2 = 1) (3 = 2) (else = 9).
variable label mstatus "Marital status".
value label mstatus
	1 "Ever married/in union"
                  2 "Never married/in union"
	9 "Missing".
								
compute total = 1.
variable label total "".
value label total 1 "Number of women age 15-24 years".

* The life satisfaction indicator is not calculated if responses other than 1 to 5 have been given for more than 4 questions used for the calculation of the indicator. 
* Respondents who are not attending school and who do not have a job are considerd to have missing responses in these domains.
recode LS3 (1 thru 5 = 1) (else = sysmis) into factor1.
recode LS4 (1 thru 5 = 1) (else = sysmis) into factor2.
recode LS6 (1 thru 5 = 1) (else = sysmis) into factor3.
recode LS7 (1 thru 5 = 1) (else = sysmis) into factor4.
recode LS8 (1 thru 5 = 1) (else = sysmis) into factor5.
recode LS9 (1 thru 5 = 1) (else = sysmis) into factor6.
recode LS10 (1 thru 5 = 1) (else = sysmis) into factor7.
recode LS11 (1 thru 5 = 1) (else = sysmis) into factor8.
count includ = factor1 factor2 factor3 factor4 factor5 factor6 factor7 factor8 (1).

recode LS3 (0,8,9 = sysmis) (else = copy) into ind1.
recode LS4 (0,8,9 = sysmis) (else = copy) into ind2.
recode LS6 (0,8,9 = sysmis) (else = copy) into ind3.
recode LS7 (0,8,9 = sysmis) (else = copy) into ind4.
recode LS8 (0,8,9 = sysmis) (else = copy) into ind5.
recode LS9 (0,8,9 = sysmis) (else = copy) into ind6.
recode LS10 (0,8,9 = sysmis) (else = copy) into ind7.
recode LS11 (0,8,9 = sysmis) (else = copy) into ind8.

recode LS3 (1, 2 = 1) (else = 0) into ls1.
recode LS4 (1, 2 = 1) (else = 0) into ls2.
recode LS6 (1, 2 = 1) (else = 0) into ls3.
recode LS7 (1, 2 = 1) (else = 0) into ls4.
recode LS8 (1, 2 = 1) (else = 0) into ls5.
recode LS9 (1, 2 = 1) (else = 0) into ls6.
recode LS10 (1, 2 = 1) (else = 0) into ls7.
recode LS11 (1, 2 = 1) (else = 0) into ls8.
count lscount = ls1 ls2 ls3 ls4 ls5 ls6 ls7 ls8 (1).

do if (includ >= 4).

+ compute lifesat = 0.
+ if (lscount = includ) lifesat = 100.

variable label lifesat "Percentage of women with life satisfaction [1]".
					
compute lsscore = mean (ind1, ind2, ind3, ind4, ind5, ind6, ind7, ind8).
variable label lsscore "Average life satisfaction score".

end if.

compute missingls = 0.
if (includ < 4) missingls = 100.
variable label missingls "Missing / Cannot be calculated".

do if (LS13 <> 0 and includ >= 4).
+ compute  income = 0.
+ if ((LS13 = 1 or LS13 = 2) and lifesat = 100) income = 100.
+ variable label income "Women with life satisfaction who are very or somewhat satisfied with their income".
end if.

compute misincom = 0.
if (includ < 4 or LS13 = 0) misincom = 100.
variable label misincom "No income / Cannot be calculated".

recode LS2 (1, 2 = 100) (else = 0) into happy.
variable label happy "Percentage who are very or somewhat happy [2]".	

compute tot = 1.
variable label tot "".
value label tot 1 "Total".				

ctables
  /vlabels variables =  total tot
         display = none
  /table wage [c] + hh7 [c] + hh6 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   lifesat [s] [mean,'',f5.1] + lsscore [s] [mean,'',f5.1] + missingls [s] [mean,'',f5.1] + income [s] [mean,'',f5.1] + misincom [s] [mean,'',f5.1] + happy [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
	"Table SW.2: Life satisfaction and happiness" 															
	"Percentage of women age 15-24 years who are very or somewhat satisfied with their family life, "
	"friendships, school, current job, health, living environment, treatment by others, and the way they look, "
	"the average life satisfaction score, percentage of women with life satisfaction who are also very or somewhat satisfied with their income, 	"
	"and percentage of women age 15-24 years who are very or somewhat happy, " + surveyname
  caption = 
	"[1] MICS Indicator SW.1"						
	"[2] MICS indicator SW.2".						
							
				
							
new file.
