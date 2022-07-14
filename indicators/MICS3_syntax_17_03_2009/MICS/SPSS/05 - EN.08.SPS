get file = 'hl.sav'.

* select those in urban area; add capital city if it is not all urban.
select if (HH6 = 1).

weight by hhweight.

compute formal = 100.
if (HC15B = 1 or HC15CA = 'A' or HC15CB = 'B' or HC15D = 1) formal = 0.
variable label formal "Household does not have formal documentation for the residence".

recode HC15F (2 = 100) (else = 0) into eviction.
variable label eviction "Respondent feels there is a risk of eviction".

compute security = 0.
if (formal = 100 or eviction = 100) security = 100.
variable label security "Household does not have security of tenure *".

compute evicted = 0.
if (HC15G = 1) evicted = 100.
variable label evicted "Household members evicted from any dwelling prior 5 years".

compute total = 1.
value label total 1 "".
variable label total "Numbers of households members"

tables
  /format = zero
  /observation = formal eviction security evicted
  /ftotal = tot1 "Total" 
  /table = HH7 + HH6 + helevel + wlthind5 + HC1B + tot1 by 
	  formal + eviction + security + evicted + total
  /statistics
    mean(formal (f5.1) '')
    mean(eviction (f5.1) '')
    mean(security (f5.1) '')
    mean(evicted (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table EN.8: Security of tenure"
		"Percentage of household members living in households in urban areas (or "+
		"in capital city) which lack formal documentation for their residencce "+
		"in the dwelling or who feel at risk of eviction from the dwelling, "
    "and the percentage of respondents who have been evicted from their home "+
		"in the 5 years preceding the survey, Country, Year"
  /caption
    "* MICS Indicator 93".

new file.