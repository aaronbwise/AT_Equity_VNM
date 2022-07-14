* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (wm7 = 1).

compute tot = 1.
variable label tot "Number of women".
value label tot 1 "".

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
  /total = sum (tot).

get file = 'tmp1.sav'.

compute ratio1 = s1/d1.
variable label ratio1 "Sex ratio".

compute ratio2 = s2/d2.
variable label ratio2 "Sex ratio".

compute ratio3 = s3/d3.
variable label ratio3 "Sex ratio".

variable labels s1 "Number of sons ever born".
variable labels d1 "Number of daughters ever born".

variable labels s2 "Number of sons living".
variable labels d2 "Number of daughters living".

variable labels s3 "Number of deceased sons".
variable labels d3 "Number of deceased daughters".

compute layer1 = 0.
variable label layer1 "".
value label layer1 0 "Children Ever Born".

compute layer2 = 0.
variable label layer2 "".
value label layer2 0 "Children Living".

compute layer3 = 0.
variable label layer3 "".
value label layer3 0 "Children Deceased".

variable label total "Number of women".
value label total 1 "".

ctables
  /vlabels variables = layer1 layer2 layer3 display = none
  /table wage [c] by 
	layer1 [c] > (s1[s][sum,'',f5.0] + d1[s][sum,'',f5.0] + ratio1 [s] [mean,'',f5.2]) +
 	layer2 [c] > (s2[s][sum,'',f5.0] + d2[s][sum,'',f5.0] + ratio2 [s] [mean,'',f5.2]) +
 	layer3 [c] > (s3[s][sum,'',f5.0] + d3[s][sum,'',f5.0] + ratio3 [s] [mean,'',f5.2]) +
                  total [s][sum,'',f5.0]  
  /categories var=wage total = yes empty=exclude 
  /slabels visible = no
  /titles title="Table DQ.16: Sex ratio at birth among children ever born and living"  
                   "Sex ratio (number of males per 100 females) among children ever born (at birth), children living, and deceased children, by age of women, " + surveyname.

COMMENT -- End CTABLES command.

new file.

erase file = "tmp1.sav".



