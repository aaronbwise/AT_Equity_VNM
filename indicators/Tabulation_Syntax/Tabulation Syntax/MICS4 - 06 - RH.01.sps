* Direct estimation of fertility. 

* Main program - calls.
*  MICS4 - 06 - fert_b.sps  for calculation of births.
*  MICS4 - 06 - fert_e.sps  for calculation of exposure.
*  MICS4 - 06 - fert_c.sps  for calculation of probabilities and rates, and final tables.

include "surveyname.sps".

* National fertility estimates.
define subgroupname ()
'(Total)'
!enddefine.
define subgroup ()
use all.
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.	
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Region 1.

define subgroupname ()
'(Region 1)'
!enddefine.
define subgroup ()
select if (HH7 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.	 
include 'MICS4 - 06 - fert_e.sps'.	 
include 'MICS4 - 06 - fert_c.sps'.	 

* Region 2.

define subgroupname ()
'(Region 2)'
!enddefine.
define subgroup ()
select if (HH7 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 


* Region 3.

define subgroupname ()
'(Region 3)'
!enddefine.
define subgroup ()
select if (HH7 = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 


* Region 4.

define subgroupname ()
'(Region 4)'
!enddefine.
define subgroup ()
select if (HH7 = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		


* Urban.

define subgroupname ()
'(Urban)'
!enddefine.
define subgroup ()
select if (HH6 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Rural.

define subgroupname ()
'(Rural)'
!enddefine.
define subgroup ()
select if (HH6 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 


* Mother's education: None.

define subgroupname ()
'(Mothers education None)'
!enddefine.
define subgroup ()
select if (welevel = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Mother's education: Primary.

define subgroupname ()
'(Mothers education Primary)'
!enddefine.
define subgroup ()
select if (welevel = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Mother's education: Secondary +.

define subgroupname ()
'(Mothers education Secondary +)'
!enddefine.
define subgroup ()
select if (welevel = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Wealth index quintile: Poorest.

define subgroupname ()
'(Poorest)'
!enddefine.
define subgroup ()
select if (windex5 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Wealth index quintile: Second.

define subgroupname ()
'(Second)'
!enddefine.
define subgroup ()
select if (windex5 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Wealth index quintile: Middle.

define subgroupname ()
'(Middle)'
!enddefine.
define subgroup ()
select if (windex5 = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		 
include 'MICS4 - 06 - fert_e.sps'.		 
include 'MICS4 - 06 - fert_c.sps'.		 

* Wealth index quintile: Fourth.

define subgroupname ()
'(Fourth)'
!enddefine.
define subgroup ()
select if (windex5 = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		
include 'MICS4 - 06 - fert_e.sps'.		
include 'MICS4 - 06 - fert_c.sps'.		

* Wealth index quintile: Richest.

define subgroupname ()
'(Richest)'
!enddefine.
define subgroup ()
select if (windex5 = 5).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		
include 'MICS4 - 06 - fert_e.sps'.		
include 'MICS4 - 06 - fert_c.sps'.		

* Ethnicity of household head: Group 1.

define subgroupname ()
'(Group 1)'
!enddefine.
define subgroup ()
select if (ethnicity = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		
include 'MICS4 - 06 - fert_e.sps'.		
include 'MICS4 - 06 - fert_c.sps'.		

* Ethnicity of household head: Group 2.

define subgroupname ()
'(Group 1)'
!enddefine.
define subgroup ()
select if (ethnicity = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS4 - 06 - fert_b.sps'.		
include 'MICS4 - 06 - fert_e.sps'.		
include 'MICS4 - 06 - fert_c.sps'.
