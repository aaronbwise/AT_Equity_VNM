* Encoding: windows-1252.
* Create new variable strat for paired clusters and save in a separate file.
* The program assumes that the sampling domains are urban and rural areas (HH6) within 6 regions (HH7).

oms
 /destination viewer = no
 /select all 
 /exceptif commands = ['CSDescriptives' 'Ctables'].

output close *.

define saveSheet(!positional !tokens(1))
output export 
/xlsx documentfile = "MICS6 - AppC - SE.xlsx"
sheet=!1
operation=MODIFYSHEET
/contents export = visible layers = printsetting modelviews = printsetting.
output close * .
!enddefine .

include 'surveyname.sps'. 

get file = "hh.sav".

include "MICS6 - AC - 02 Strata pairs.SPS".



* Do calculations for national total.
echo "Total sample".
define subgroupname ()
'(Total)'
!enddefine.
Define subgroup ()
Use all.
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Total Sample".

************************************.

* Do calculations for subgroups.
echo "Urban areas".
define subgroupname ()
'(Urban)'
!enddefine.
Define subgroup ()
select if (HH6 = 1).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Urban".

************************************.
echo "Rural areas".
define subgroupname ()
'(Rural)'
!enddefine.
Define subgroup ()
select if (HH6 = 2).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Rural".

************************************.

echo "Region 1".
define subgroupname ()
'(Region 1)'
!enddefine.
Define subgroup ()
select if (HH7 = 1).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 1".

************************************.

echo "Region 2".
define subgroupname ()
'(Region 2)'
!enddefine.
Define subgroup ()
select if (HH7 = 2).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 2".

************************************.

echo "Region 3".
define subgroupname ()
'(Region 3)'
!enddefine.
Define subgroup ()
select if (HH7 = 3).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 3".

************************************.

echo "Region 4".
define subgroupname ()
'(Region 4)'
!enddefine.
Define subgroup ()
select if (HH7 = 4).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 4".

************************************.

echo "Region 5".
define subgroupname ()
'(Region 5)'
!enddefine.
Define subgroup ()
select if (HH7 = 5).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 5".

************************************.

echo "Region 6".
define subgroupname ()
'(Region 6)'
!enddefine.
Define subgroup ()
select if (HH7 = 6).
!enddefine.

* Percentages SE estimates.
insert file = "MICS6 - AC - 03 Calculate.sps".

* Fertility estimates.
include 'MICS6 - AC - 06 - fert_b.sps'.	
include 'MICS6 - AC - 06 - fert_e.sps'.		 
include 'MICS6 - AC - 06 - fert_c.sps'.		

* Mortality estimates 5 yrs.
include 'MICS6 - AC - 05 - mort_D.sps'.
include 'MICS6 - AC - 05 - mort_E.sps'.
include 'MICS6 - AC - 05 - mort_C.sps'. 

savesheet "Region 6".


omsend.


