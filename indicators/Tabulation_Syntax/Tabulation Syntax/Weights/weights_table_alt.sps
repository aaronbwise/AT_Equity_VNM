get file = 'hh.sav'.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (HH6-1)*4 + HH7.
* Strata define by region.
* compute stratum = HH7.
format stratum (F3.0).

compute clust = 1.
if (hh1 = lag(hh1,1)) clust = 0.
variable label clust "Clusters completed".

compute hhfnd = 0.
if (hh9 = 1 or hh9 = 2 or hh9 = 4 or hh9 = 7) hhfnd = 1.
variable label hhfnd "Households found".

compute hhcomp = 0.
if (hh9 = 1) hhcomp = 1.
variable label hhcomp "Households completed".

variable labels
  hh12   "Eligible women"
  /hh13   "Interviewed women"
  /hh14   "Eligible children"
  /hh15   "Interviewed children"
.

CTABLES
  /TABLE stratum[C] BY 
    clust[S][SUM,'',F5.0]
 + hhfnd[S][SUM,'',F5.0]
 + hhcomp[S][SUM,'',F5.0]
 + hh12[S][SUM,'',F5.0]
 + hh13[S][SUM,'',F5.0]
 + hh14[S][SUM,'',F5.0]
 + hh15[S][SUM,'',F5.0]
  /TITLE TITLE=
  "Weight Tabulation".

