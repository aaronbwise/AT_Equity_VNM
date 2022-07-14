* Direct estimation of mortality.  Trevor Croft, Sept 1, 2006.

* Main program - calls.
*   mort_d.sps  for calculation of deaths.
*   mort_e.sps  for calculation of exposure.
*   mort_c.sps  for calculation of probabilities and rates, and final tables.


* National mortality estimates.

define subgroupname ()
'(Total)'
!enddefine.
define subgroup ()
use all.
!enddefine.

include 'mort_D.sps'.	* Tabulate deaths by age at death and period.
include 'mort_E.sps'.	* Tabulate exposure by age group and period.
include 'mort_C.sps'.	* Calculate mortality rates.


* Duhuk, Arbil, Sulimania.

define subgroupname ()
'(Duhuk, Arbil, Sulimania)'
!enddefine.
define subgroup ()
select if (HH7 = 11 or HH7 = 13 or HH7 = 15).
!enddefine.

include 'mort_D.sps'.	* Tabulate deaths by age at death and period.
include 'mort_E.sps'.	* Tabulate exposure by age group and period.
include 'mort_C.sps'.	* Calculate mortality rates.


* South/Central.

define subgroupname ()
'(South)'
!enddefine.
define subgroup ()
select if not (HH7 = 11 or HH7 = 13 or HH7 = 15).
!enddefine.

include 'mort_D.sps'.	* Tabulate deaths by age at death and period.
include 'mort_E.sps'.	* Tabulate exposure by age group and period.
include 'mort_C.sps'.	* Calculate mortality rates.


