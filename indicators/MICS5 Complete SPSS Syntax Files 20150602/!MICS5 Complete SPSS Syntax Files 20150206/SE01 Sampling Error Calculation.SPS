* Create new variable strat for paired clusters and save in a separate file.
* The program assumes that the sampling domains are urban and rural areas (HH6) within 6 regions (HH7).

get file = "hh.sav".

include "se02 strata pairs.sps".

* Break variables HH7 and HH6 should be changed, if needed, to reflect your sampling domains.
Aggregate outfile = "pairs.sav"
   /Break = HH7 HH6 HH1 strat
   /NumHH=N.

get file = "pairs.sav".
sort cases hh1.
save outfile = "pairs.sav".

* Do calculations for national total.
echo "Total sample".
Define subgroup ()
Use all.
!enddefine.
include "se03 calculate.sps".

* Do calculations for subgroups.
echo "Urban areas".
Define subgroup ()
select if (HH6 = 1).
!enddefine.
include "se03 calculate.sps".

echo "Rural areas".
Define subgroup ()
select if (HH6 = 2).
!enddefine.
include "se03 calculate.sps".

echo "Region 1".
Define subgroup ()
select if (HH7 = 1).
!enddefine.
include "se03 calculate.sps".

echo "Region 2".
Define subgroup ()
select if (HH7 = 2).
!enddefine.
include "se03 calculate.sps".

echo "Region 3".
Define subgroup ()
select if (HH7 = 3).
!enddefine.
include "se03 calculate.sps".

echo "Region 4".
Define subgroup ()
select if (HH7 = 4).
!enddefine.
include "se03 calculate.sps".

echo "Region 5".
Define subgroup ()
select if (HH7 = 5).
!enddefine.
include "se03 calculate.sps".

echo "Region 6".
Define subgroup ()
select if (HH7 = 6).
!enddefine.
include "se03 calculate.sps".

erase file 'micsplan.csplan'.
erase file 'pairs.sav'.
