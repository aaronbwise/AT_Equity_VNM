get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (UF11 < 3).

recode CA13 (1,2 = 100) (else = 0) into stools.
variable label stools "Proportion of children whose stools are disposed of "+
  "safely *".

compute total  = 1.
value label total 1 "".
variable label total "Number of children aged 0-2 years".

tables
  /format = zero
  /observation = stools
  /ftotal = tot1 "Total" 
  /table = HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
	  CA13 + tot1 + stools + total 
  /statistics
    cpct(CA13 (f5.1) '':HH7 HH6 melevel wlthind5 HC1B)
    mean(stools (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table EN.6: Disposal of child's faeces"
		"Percent distribution of children aged 0-2 years according to place of "+
		"disposal of child's faeces, and the percentage of children aged 0-2 "+
		"years whose stools are disposed of safely, Country, Year"
  /caption
    "* MICS indicator 14".

new file.
