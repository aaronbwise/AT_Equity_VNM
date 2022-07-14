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

recode LS3 (1, 2 = 100) (else = 0) into famlife.
variable label famlife "Family life".

recode LS4 (1, 2 = 100) (else = 0) into friends.
variable label friends "Friendships".

do if (LS5 = 1).
+ recode LS6 (1, 2 = 100) (else = 0) into school.
+ variable label school "School".
end if.

do if (LS7 <> 0).
+ recode LS7 (1, 2 = 100) (else = 0) into job.
+ variable label job "Current job".
end if.

recode LS8 (1, 2 = 100) (else = 0) into health.
variable label health "Health".

recode LS9 (1, 2 = 100) (else = 0) into livenv.
variable label livenv "Living environment".

recode LS10 (1, 2 = 100) (else = 0) into treat.
variable label treat "Treatment by others".

recode LS11 (1, 2 = 100) (else = 0) into look.
variable label look "The way they look".

do if (LS13 <> 0).
+ recode LS13 (1, 2 = 100) (else = 0) into income.
+ variable label income "Current income".
end if.

recode LS5 (2 = 100) (else = 0) into noschool.
variable label noschool "Are not currently attending school".	

recode LS7 (0 = 100) (else = 0) into nojob.
variable label nojob "Do not have a job".

recode LS13 (0 = 100) (else = 0) into noincome.
variable label noincome "Do not have any income".

compute layer0 = 0.
variable label layer0 "".
value label layer0 0 "Percentage of women age 15-24 who are very or somewhat satisfied with selected domains:".

compute layer1 = 0.
variable label layer1 "".
value label layer1 0 "Percentage of women age 15-24 who:".

compute tot = 1.
variable label tot "".
value label tot 1 "Total".

ctables
  /vlabels variables =  total layer0 layer1 tot
         display = none
  /table wage [c] + hh7 [c] + hh6 [c] + mstatus [c]  + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer0 [c] > (famlife [s] [mean,'',f5.1] + friends [s] [mean,'',f5.1] + school [s] [mean,'',f5.1] + job [s] [mean,'',f5.1] + 
		health [s] [mean,'',f5.1] + livenv [s] [mean,'',f5.1] + treat [s] [mean,'',f5.1]+ look  [s] [mean,'',f5.1] + income  [s] [mean,'',f5.1] ) +
                   layer1 [c] > (noschool [s] [mean,'',f5.1] + nojob [s] [mean,'',f5.1] + noincome[s] [mean,'',f5.1]) +
                   total[c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
	"Table SW.1: Domains of life satisfaction" 															
	"Percentage of women age 15-24 years who are very or somewhat satisfied in selected domains, " + surveyname.				
							
new file.
