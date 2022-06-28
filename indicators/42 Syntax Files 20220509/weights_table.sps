* Encoding: UTF-8.
cd "C:\MICS6\SPSS".

get file = "hh.sav".

*		If stratum variable is not already part of your hh.sav dataset, .
* 		The example below  shows how to calculate stratum variable, if stratum is defined as combination of area (HH6) and region (HH7).
* 		This assumes that in HH6 (Area), you have codes 1 and 2, in HH7 (Region) you have 1 to 4.
* 		To change: If you have n regions, change 4 below to n.
* 		If strata are defined only by region.
* 		compute stratum = HH7.
* compute stratum = (HH6-1)*n + HH7.
compute stratum = (HH6-1)*4 + HH7.
formats stratum (f3.0).

compute clust = 1.
if (HH1 = lag(HH1,1)) clust = 0.
variable labels clust "Clusters completed".

compute hhfnd = 0.
if (HH46 = 1 or HH46 = 2 or HH46 = 4 or HH46 = 7) hhfnd = 1.
variable labels hhfnd "Cluster: households found".

compute hhcomp = 0.
if (HH46 = 1) hhcomp = 1.
variable labels hhcomp "Completed households ".

compute hh52a = 0.
if (HH52 > 0) hh52a = 1.
variable labels hh52a "Number of households with an eligible child age 5-17 years".

compute hheligWQ = 0.
if (HH9 = 1 and hhfnd = 1) hheligWQ = 1.
variable labels hheligWQ "Eligible households selected for WQT in the stratum".

compute hhcompHHWQ = 0.
if (WQ11 = 1) hhcompHHWQ = 1.
variable labels hhcompHHWQ "Households with completed HH WQTs".

compute hhcompSWQ = 0.
if (WQ19 = 1) hhcompSWQ = 1.
variable labels hhcompSWQ "Households with completed source WQTs".

aggregate outfile = "tmp.sav"
  /break = stratum
  /stclust = sum(clust)
  /sthhfnd = sum(hhfnd)
  /sthhcomp = sum(hhcomp)
  /sthh49 = sum(HH49)
  /sthh53 = sum(HH53)
  /sthh51 = sum(HH51)
  /sthh55 = sum(HH55)
  /sthh52 = sum(hh52a)
  /sthh56 = sum(HH56)
  /sthh50 = sum(HH50a)
  /sthh54 = sum(HH54)
  /sthheligWQ = sum(hheligWQ)
  /sthhcompHHWQ = sum(hhcompHHWQ)
  /sthhcompSWQ = sum(hhcompSWQ).

sort cases by stratum.

match files
  /file = *
  /table = "tmp.sav"
  /by stratum.


variable labels
  stratum "Stratum"
  stclust "Number of clusters completed in the stratum"
  sthhfnd "Number of eligible households selected in the stratum"
  sthhcomp "Number of households with complete interviews in the stratum	"
  hhcomp "Number of households with complete interviews in the cluster"
  sthh49 "Number of eligible women in the stratum"
  sthh53 "Number of eligible women with complete interviews in the stratum"
  hh53 "Number of eligible women with a complete interview in the clustern"
  sthh51 "Number of eligible children under 5 in the stratum"
  sthh55 "Number of eligible children under 5 with complete interviews in the stratum"
  hh55 "Number of eligible children under 5 with complete interviews in the cluster"
  sthh52 "Number of households with an eligible child age 5-17 years in the stratum"
  sthh56 "Number of households with complete interview for child age 5-17 years in the stratum"
  hh56 "Number of households with complete interview for child age 5-17 years in the cluster"
  sthh50 "Number of eligible men in the stratum"
  sthh54 "Number of eligible men with complete interviews in the stratum"
  hh54 "Number of eligible men with complete interviews in the cluster"
  sthheligWQ "Number of eligible households selected in  stratum for water quality testing"
  sthhcompHHWQ "Number of household water quality tests completed in the stratum"
  hhcompHHWQ "Number of household water quality tests completed in the cluster"
  sthhcompSWQ "Number of source water quality tests completed in the stratum"
  hhcompSWQ "Number of source water quality tests completed in the cluster".

ctables
  /table HH1 [c] by 
    stratum [s][mean "" f5.0]
 + stclust [s][mean "" f5.0]
 + sthhfnd [s][mean "" f5.0]
 + sthhcomp [s][mean "" f5.0]
 + hhcomp [s][sum "" f5.0]
 + sthh49 [s][mean "" f5.0]
 + sthh53 [s][mean "" f5.0]
 + hh53 [s][sum "" f5.0]
 + sthh51 [s][mean "" f5.0]
 + sthh55 [s][mean "" f5.0]
 + hh55 [s][sum "" f5.0]
 + sthh52 [s][mean "" f5.0]
 + sthh56 [s][mean "" f5.0]
 + hh56 [s][sum "" f5.0]
 + sthh50 [s][mean "" f5.0]
 + sthh54 [s][mean "" f5.0]
 + hh54 [s][sum "" f5.0]
 + sthheligWQ [s][mean "" f5.0]
 + sthhcompHHWQ [s][mean "" f5.0]
 + hhcompHHWQ [s][sum "" f5.0]
 + sthhcompSWQ [s][mean "" f5.0]
 + hhcompSWQ [s][sum "" f5.0]
  /titles title = "TEMPLATE FOR SAMPLE WEIGHTS CALCULATION (STANDARD)".

new file.

*erase the working files.
 erase file = "tmp.sav".