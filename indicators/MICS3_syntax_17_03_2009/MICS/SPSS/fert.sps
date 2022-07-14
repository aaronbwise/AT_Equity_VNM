* Direct estimation of fertility.  Trevor Croft, January 3, 2007.

* Main program - calls.
*   fert_b.sps  for calculation of births.
*   fert_e.sps  for calculation of exposure.
*   fert_c.sps  for calculation of probabilities and rates, and final tables.


* National fertility estimates.

define subgroupname ()
'(Total)'
!enddefine.
define subgroup ()
use all.
!enddefine.

include 'fert_B.sps'.	* Tabulate births by age at birth and period.
include 'fert_E.sps'.	* Tabulate exposure by age group and period.
include 'fert_C.sps'.	* Calculate fertility rates.


* Duhuk, Arbil, Sulimania.

define subgroupname ()
'(Duhuk, Arbil, Sulimania)'
!enddefine.
define subgroup ()
select if (HH7 = 11 or HH7 = 13 or HH7 = 15).
!enddefine.

include 'fert_B.sps'.	* Tabulate births by age at birth and period.
include 'fert_E.sps'.	* Tabulate exposure by age group and period.
include 'fert_C.sps'.	* Calculate fertility rates.


* South/Central.

define subgroupname ()
'(South)'
!enddefine.
define subgroup ()
select if not (HH7 = 11 or HH7 = 13 or HH7 = 15).
!enddefine.

include 'fert_B.sps'.	* Tabulate births by age at birth and period.
include 'fert_E.sps'.	* Tabulate exposure by age group and period.
include 'fert_C.sps'.	* Calculate fertility rates.


