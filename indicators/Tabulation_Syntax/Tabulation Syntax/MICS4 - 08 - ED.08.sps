include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Make a new category for mother's education level for children over 17 years. 
* Refer to the existing melevel categories and create new one.
recode melevel (sysmis = 6) (else = copy).
value label melevel 
1 "None"
2 "Primary"
3 "Secondary"
4 "Higher"
5 "Not in the household"
6 "Cannot be determined".

* the following code assumes that the primary school entry age is 6 and graduation age is 11 AND 
* secondary school entry age is 12 and graduation 17.
* change these values to reflect the situation in your country.

compute minprim = 6.
compute maxprim = 11.
compute minsec = 12.
compute maxsec = 17.

compute total = 1.
variable label total "".
value label total 1 "Total".

compute boysp  = 0.
if (HL4 = 1 and schage >= minprim and schage <= maxprim ) boysp = 1.
variable label boysp "Number of primary school age boys".

compute narbp = 0.
if (HL4 = 1 and schage >= minprim and schage <= maxprim and ED5 = 1 and (ED6A >= 1 and ED6A <= 2)) narbp = 1.
if (HL4 = 1 and schage = maxprim and ED4A = 1 and ED4B = 6 and ED5 =  2) narbp  = 1.
variable label narbp "Number of primary school age boys attending primary school".

compute girlsp = 0.
if (HL4 = 2 and schage >= minprim and schage <= maxprim) girlsp = 1.
variable label girlsp "Number of primary school age girls".

compute narfp = 0.
if (HL4 = 2 and schage >= minprim and schage <= maxprim and ED5 = 1 and (ED6A >= 1 and ED6A <= 2)) narfp = 1.
if (HL4 = 2 and schage = maxprim and ED4A = 1 and ED4B = 6 and ED5 =  2) narfp  = 1.
variable label narfp "Number of primary school age girls attending primary school".

compute boyss = 0.
if (HL4 = 1 and schage >= minsec and schage <= maxsec) boyss = 1.
variable label boyss "Number of secondary school age boys".
compute narbs = 0.

if (HL4 = 1 and schage >= minsec and schage <= maxsec and ED5 =1 and (ED6A >= 2 and ED6A <= 3)) narbs = 1.
if (HL4 = 1 and schage = maxsec and ED4A = 2 and ED4B = 6 and ED5 = 2) narbs = 1.
variable label narbs "Number of secondary school age boys attending secondary school".

compute girlss = 0.
if (HL4 = 2 and schage >= minsec and schage <= maxsec) girlss = 1.
variable label girlss "Number of secondary school age girls".
compute narfs  = 0.

if (HL4 = 2 and schage >= minsec and schage <= maxsec and ED5 =1 and (ED6A >= 2 and ED6A <= 3)) narfs =  1.
if (HL4 = 2 and schage = maxsec and ED4A = 2 and ED4B = 6 and ED5 = 2) narfs = 1.
variable label narfs "Number of secondary school age girls attending secondary school".

aggregate outfile = 'tmp1.sav'
  /break   = HL4
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp2.sav'
  /break   = HH7
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp3.sav'
  /break   = HH6
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp4.sav'
  /break   = melevel
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp5.sav'
  /break   = windex5
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp6.sav'
  /break   = ethnicity
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

aggregate outfile = 'tmp7.sav'
  /break   = total
  /nboysp  = sum(boysp)
  /nnarbp  = sum(narbp)
  /ngirlsp = sum(girlsp)
  /nnarfp  = sum(narfp)
  /nboyss  = sum(boyss)
  /nnarbs  = sum(narbs)
  /ngirlss = sum(girlss)
  /nnarfs  = sum(narfs).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

if (ngirlsp > 0) pgirls = (nnarfp/ngirlsp)*100.
variable label pgirls "Primary school adjusted net attendance ratio (NAR), girls".

if (nboysp > 0) pboys = (nnarbp/nboysp)*100.
variable label pboys "Primary school adjusted net attendance ratio (NAR), boys".

if (pboys > 0) ratio1 = (pgirls/pboys).
variable label ratio1 "Gender parity index (GPI) for primary school adjusted NAR [1]".

if (ngirlss > 0) sgirls = (nnarfs/ngirlss)*100.
variable label sgirls "Secondary school adjusted net attendance ratio (NAR), girls".

if (nboyss > 0) sboys = (nnarbs/nboyss)*100.
variable label sboys "Secondary school adjusted net attendance ratio (NAR), boys".

if (sboys > 0) ratio2 = (sgirls/sboys).
variable label ratio2 "Gender parity index (GPI) for  secondary school adjusted NAR [2]".

* For labels in French uncomment commands bellow.

* variable label pgirls " Ratio net de fréquentation (RNF) ajusté de l'école primaire, filles".
* variable label pboys "Ratio net de fréquentation (RNF) ajusté de l'école primaire, garçons".
* variable label ratio1 "Indice de parité entre les sexes (IPS) pour le RNF ajusté de l'école primaire [1]".
* variable label sgirls "Ratio net de fréquentation (RNF) ajusté de l'école secondaire, filles".
* variable label sboys "Ratio net de fréquentation (RNF) ajusté de l'école secondaire, garçons".
* variable label ratio2 " Indice de parité entre les sexes (IPS) pour le RNF ajusté de l'école secondaire [2]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = total
    display = none
  /table hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              pgirls [s] [mean,'',f5.1] +  pboys [s] [mean,'',f5.1] + ratio1 [s] [mean,'',f5.2] +
              sgirls [s] [mean,'',f5.1] +  sboys [s] [mean,'',f5.1] + ratio2 [s] [mean,'',f5.2] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
     "Table ED.8: Education gender parity"
		"Ratio of adjusted net attendance ratios of girls to boys, in primary and secondary school, " + surveyname
  caption=
    "[1] MICS indicator 7.9; MDG indicator 3.1"
    "[2] MICS indicator 7.10; MDG indicator 3.1".

* Ctables command in French.
*
ctables
   /vlabels variables = total
    display = none
  /table hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              pgirls [s] [mean,'',f5.1] +  pboys [s] [mean,'',f5.1] + ratio1 [s] [mean,'',f5.2] +
              sgirls [s] [mean,'',f5.1] +  sboys [s] [mean,'',f5.1] + ratio2 [s] [mean,'',f5.2] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
     "Tableau ED.8: Parité entre les sexes en matière d'éducation"
		"Ratio net de fréquentation ajusté, ratios filles-garçons, à l'école primaire et secondaire, " + surveyname
  caption=
    "[1] MICS indicator 7.9; MDG indicator 3.1"
    "[2] MICS indicator 7.10; MDG indicator 3.1".	

new file.
*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
