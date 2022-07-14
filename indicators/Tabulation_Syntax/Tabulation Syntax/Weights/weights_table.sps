get file = 'hh.sav'.

*		Choose the stratum definition that fits your sample.
* 		Strata defined by area and region.
* 		This assumes that in HH6 (Area), you have codes 1 and 2, in HH7 (Region) you have 1 to 4.
* 		To change: If you have n regions, change 4 below to n.
compute stratum = (hh6-1)*4 + hh7.
* 		If strata are defined only by region.
* 		compute stratum = HH7.
format stratum (F3.0).


compute clust = 1.
if (hh1 = lag(hh1,1)) clust = 0.
variable label clust "Clusters completed".

compute hhfnd = 0.
if (hh9 = 1 or hh9 = 2 or hh9 = 4 or hh9 = 7) hhfnd = 1.
variable label hhfnd "Cluster: households found".

compute hhcomp = 0.
if (hh9 = 1) hhcomp = 1.
variable label hhcomp "Cluster: households completed".

aggregate outfile = 'tmp.sav'
  /break   = stratum
  /stclust   = sum(clust)
  /sthhfnd   = sum(hhfnd)
  /sthhcomp  = sum(hhcomp)
  /sthh12    = sum(hh12)
  /sthh13    = sum(hh13)
  /sthh14    = sum(hh14)
  /sthh15    = sum(hh15).

sort cases by stratum.

match files
  /file = *
  /table = 'tmp.sav'
  /by stratum.

variable labels
  stratum "Stratum"
  /stclust   "Strata: clusters completed"
  /sthhfnd  "Strata: households found"
  /sthhcomp "Strata: households completed"
  /sthh12   "Strata: eligible women"
  /sthh13   "Strata: interviewed women"
  /hh13     "Cluster: interviewed women"
  /sthh14   "Strata: eligible children"
  /sthh15   "Strata: interviewed children"
  /hh15     "Cluster: interviewed children"
.

CTABLES
  /TABLE hh1[C] BY 
    stratum[S][MEAN,'',F5.0]
 + stclust[S][MEAN,'',F5.0]
 + sthhfnd[S][MEAN,'',F5.0]
 + sthhcomp[S][MEAN,'',F5.0]
 + hhcomp[S] [SUM,'',F5.0]
 + sthh12[S][MEAN,'',F5.0]
 + sthh13[S][MEAN,'',F5.0]
 + hh13[S][ SUM,'',F5.0]
 + sthh14[S][MEAN,'',F5.0]
 + sthh15[S][MEAN,'',F5.0]
 + hh15[S][ SUM,'',F5.0]
  /TITLE TITLE=
  "Weight Tabulation".

