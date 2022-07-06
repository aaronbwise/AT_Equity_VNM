* Updated 4/13/2015.
* weight by wmweight added to the syntax.

*v02 - 2014-04-28.
* added tmp2.sav file for correct calculation of Total row.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (wm7 = 1).

weight by wmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Total".

compute women  = 1.
value labels women 1 "".

recode CM5A (sysmis = 0) (else = copy).
recode CM5B (sysmis = 0) (else = copy).
recode CM7A (sysmis = 0) (else = copy).
recode CM7B (sysmis = 0) (else = copy).
recode CM9A (sysmis = 0) (else = copy).
recode CM9B (sysmis = 0) (else = copy).

compute soneb = CM5A + CM7A + CM9A.
variable labels soneb "Number of sons ever born".

compute doteb = CM5B + CM7B + CM9B.
variable labels doteb "Number of daughters ever born".

compute sonlv = CM5A + CM7A.
variable labels sonlv "Number of sons living".

compute dotlv = CM5B + CM7B.
variable labels dotlv "Number of daughters living".

compute sondead = CM9A.
variable labels sondead "Number of deceased sons".

compute dotdead = CM9B.
variable labels dotdead "Number of deceased daughters".

aggregate outfile = 'tmp1.sav'
  /break = wage
  /s1   = sum(soneb)
  /d1   = sum(doteb)
  /s2   = sum(sonlv)
  /d2  = sum(dotlv)
  /s3   = sum(sondead)
  /d3   = sum(dotdead)
  /twomen = sum(women).

aggregate outfile = 'tmp2.sav'
  /break   = total
  /s1   = sum(soneb)
  /d1   = sum(doteb)
  /s2   = sum(sonlv)
  /d2  = sum(dotlv)
  /s3   = sum(sondead)
  /d3   = sum(dotdead)
  /twomen = sum(women).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'.

compute ratio1 = s1/d1.
variable labels ratio1 "Sex ratio at birth".

compute ratio2 = s2/d2.
variable labels ratio2 "Sex ratio".

compute ratio3 = s3/d3.
variable labels ratio3 "Sex ratio".

variable labels s1 "Sons".
variable labels d1 "Daughters".

variable labels s2 "Sons".
variable labels d2 "Daughters".

variable labels s3 "Sons".
variable labels d3 "Daughters".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Children Ever Born".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Children Living".

compute layer3 = 0.
variable labels layer3 "".
value labels layer3 0 "Children Deceased".

variable labels twomen "Number of women".

ctables
  /vlabels variables = layer1 layer2 layer3 total display = none
  /table total [c] + wage [c] by 
	layer1 [c] > (s1[s][sum,'',f5.0] + d1[s][sum,'',f5.0] + ratio1 [s] [mean,'',f5.2]) +
 	layer2 [c] > (s2[s][sum,'',f5.0] + d2[s][sum,'',f5.0] + ratio2 [s] [mean,'',f5.2]) +
 	layer3 [c] > (s3[s][sum,'',f5.0] + d3[s][sum,'',f5.0] + ratio3 [s] [mean,'',f5.2]) +
                  twomen [s][sum,'',f5.0]  
  /slabels visible = no
  /titles title="Table DQ.23: Sex ratio at birth among children ever born and living"  
                   "Sex ratio (number of males per 100 females) among children ever born (at birth), children living, and deceased children, by age of women, " + surveyname.
													
new file.

erase file = "tmp1.sav".
erase file = "tmp2.sav".



