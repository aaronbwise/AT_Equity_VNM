get file = 'hh.sav'.

*** Choose the stratum definition that fits your sample ***.
* Strata defined by area and region.
* ASSUMPTIONS: HH6 in 1 to 2, HH7 in 1 to 4.
* CHANGES: If you have n regions, change 4 below to n.
compute stratum = (hh6-1)*4 + hh7.
* Strata define by region.
* compute stratum = HH7.
format stratum (F3.0).

compute clust = 1.
if (hh1 = lag(hh1,1)) clust = 0.
variable label clust "Clusters completed".

compute hhfnd = 0.
if (hh9 <> 4) hhfnd = 1.
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
  stclust   "Strata: clusters completed"
  /sthhfnd  "Strata: households found"
  /sthhcomp "Strata: households completed"
  /sthh12   "Strata: eligible women"
  /sthh13   "Strata: interviewed women"
  /hh13     "Cluster: interviewed women"
  /sthh14   "Strata: eligible children"
  /sthh15   "Strata: interviewed children"
  /hh15     "Cluster: interviewed children"
.

tables
  /observation = stclust sthhfnd sthhcomp hhcomp sthh12 sthh13 hh13 sthh14 sthh15 hh15
  /tables = hh1 by stclust + sthhfnd + sthhcomp + hhcomp + sthh12 + sthh13 + hh13 + sthh14 + sthh15 + hh15
  /statistics
    mean(stclust (F5.0) '')
    mean(sthhfnd (F5.0) '')
    mean(sthhcomp (F5.0) '')
    sum(hhcomp (F5.0) '')
    mean(sthh12 (F5.0) '')
    mean(sthh13 (F5.0) '')
    sum(hh13 (F5.0) '')
    mean(sthh14 (F5.0) '')
    mean(sthh15 (F5.0) '')
    sum(hh15 (F5.0) '')
  /title
    "Weight Tabulation".
