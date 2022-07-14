*create a weights file for each unit of analysis.
get file = 'weights.sav'.

format hhweight wmweight chweight (f9.6).
variable label hhweight "Household sample weight".
variable label wmweight "Women's sample weight".
variable label chweight "Children's sample weight".

sort cases by stratum.

save outfile = 'hhwgt.sav'
  /keep stratum HHWEIGHT.

save outfile = 'hlwgt.sav'
  /keep stratum HHWEIGHT.

save outfile = 'wmwgt.sav'
  /keep stratum WMWEIGHT.

save outfile = 'chwgt.sav'
  /keep stratum CHWEIGHT.

*add household weights to the household file.
get file = 'hh.sav'.

delete var hhweight.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (HH6-1)*4 + HH7.
* Strata define by region.
* compute stratum = HH7.

sort cases by stratum.

match files
  /file = *
  /table = 'hhwgt.sav'
  /by stratum.

if (HH9 <> 1) HHWEIGHT = 0.

save outfile = 'hh.sav'.

*add household weights to the household listing file.
get file = 'hl.sav'.

delete var hhweight.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (HH6-1)*4 + HH7.
* Strata define by region
* compute stratum = HH7.

sort cases by stratum.

match files
  /file = *
  /table = 'hlwgt.sav'
  /by stratum.

save outfile = 'hl.sav'.

*add women's weights to the women file.
get file = 'wm.sav'.

delete var wmweight.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (HH6-1)*4 + HH7.
* Strata define by region
* compute stratum = HH7.

sort cases by stratum.

match files
  /file = *
  /table = 'wmwgt.sav'
  /by stratum.

if (WM7 <> 1) WMWEIGHT = 0.

save outfile = 'wm.sav'.

*add children's weights to the children file.
get file = 'ch.sav'.

delete var chweight.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (HH6-1)*4 + HH7.
* Strata define by region
* compute stratum = HH7.

sort cases by stratum.

match files
  /file = *
  /table = 'chwgt.sav'
  /by stratum.

if (UF9 <> 1) CHWEIGHT = 0.

save outfile = 'ch.sav'.

*delete working files.
new file.
erase file = 'hhwgt.sav'.
erase file = 'hlwgt.sav'.
erase file = 'wmwgt.sav'.
erase file = 'chwgt.sav'.
