* Encoding: UTF-8.
* Sort according to sampling domains and cluster within domains.
* The program assumes that the sampling domains are existing variables in the datasets.
* If this is not the case, please make sure to create "stratum" variable before running the "Sampling errors" SPSS syntax files.

sort cases stratum HH1.

* Compute stratum variable as pairs of clusters within same domains.
compute strat = 1.
compute strpair = 0.
do if (stratum <> lag(stratum)).
+ compute strat = lag(strat)+1.
+ compute strpair = 0.
else if (HH1 = lag(HH1)).
+ compute strat = lag(strat).
+ compute strpair = lag(strpair).
else if (lag(strpair) = 0).
+ compute strat = lag(strat).
+ compute strpair = 1.
else.
+ compute strat = lag(strat)+1.
+ compute strpair = 0.
end if.

* Sort in reverse order of cluster to check for single clusters in a domain.
sort cases stratum HH1 (D).

* Recode single clusters in a domain into the prior stratum group.
do if (sysmis(lag(stratum)) or stratum <> lag(stratum)).
+ do if (strpair = 0).
+   compute strat = strat - 1.
+ end if.
else if (HH1 = lag(HH1)).
+ compute strat = lag(strat).
end if.

* Re-sort according to sampling domains and cluster within domains.
sort cases stratum HH1.

* Drop strpair variable.
delete variables strpair.

aggregate outfile = "pairs.sav"
   /Break = stratum HH1 strat
   /NumHH=N.

get file = "pairs.sav".
sort cases hh1.
save outfile = "pairs.sav".
