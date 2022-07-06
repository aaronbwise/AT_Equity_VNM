* Sort according to sampling domains (urban/rural within region) and cluster within domains.
* The program assumes that the sampling domains are urban and rural areas (HH6) within 4 regions (HH7).

sort cases HH7 HH6 HH1.

* Compute stratum variable as pairs of clusters within same domains.
compute strat = 1.
compute strpair = 0.
do if (HH7 <> lag(HH7) or HH6 <> lag(HH6)).
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
sort cases HH7 HH6 HH1 (D).

* Recode single clusters in a domain into the prior stratum group.
do if (sysmis(lag(HH7)) or HH7 <> lag(HH7) or HH6 <> lag(HH6)).
+ do if (strpair = 0).
+   compute strat = strat - 1.
+ end if.
else if (HH1 = lag(HH1)).
+ compute strat = lag(strat).
end if.

* Re-sort according to sampling domains (urban/rural within region) and cluster within domains.
sort cases HH7 HH6 HH1.

* Drop strpair variable.
delete variables strpair.