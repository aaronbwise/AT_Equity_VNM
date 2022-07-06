* Direct estimation of mortality.

* Main program - calls.
*   MICS5 - 02 - mort_D.sps  for calculation of deaths.
*   MICS5 - 02 - mort_E.sps  for calculation of exposure.
*   MICS5 - 02 - mort_C.sps  for calculation of probabilities and rates, and final tables.

* National mortality estimates.

define subgroupname ()
'(Total)'
!enddefine.
define subgroup ()
use all.
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.	
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Region 1.

define subgroupname ()
'(Region 1)'
!enddefine.
define subgroup ()
select if (HH7 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.	 
include 'MICS5 - 02 - mort_E.sps'.	 
include 'MICS5 - 02 - mort_C.sps'.	 


* Region 2.

define subgroupname ()
'(Region 2)'
!enddefine.
define subgroup ()
select if (HH7 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 


* Region 3.

define subgroupname ()
'(Region 3)'
!enddefine.
define subgroup ()
select if (HH7 = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 


* Region 4.

define subgroupname ()
'(Region 4)'
!enddefine.
define subgroup ()
select if (HH7 = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		


* Urban.

define subgroupname ()
'(Urban)'
!enddefine.
define subgroup ()
select if (HH6 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Rural.

define subgroupname ()
'(Rural)'
!enddefine.
define subgroup ()
select if (HH6 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 


* Mother's education: None.

define subgroupname ()
'(Mothers education None)'
!enddefine.
define subgroup ()
select if (welevel = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Mother's education: Primary.

define subgroupname ()
'(Mothers education Primary)'
!enddefine.
define subgroup ()
select if (welevel = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Mother's education: Secondary +.

define subgroupname ()
'(Mothers education Secondary +)'
!enddefine.
define subgroup ()
select if (welevel = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Wealth index quintile: Poorest.

define subgroupname ()
'(Poorest)'
!enddefine.
define subgroup ()
select if (windex5 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Wealth index quintile: Second.

define subgroupname ()
'(Second)'
!enddefine.
define subgroup ()
select if (windex5 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Wealth index quintile: Middle.

define subgroupname ()
'(Middle)'
!enddefine.
define subgroup ()
select if (windex5 = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		 
include 'MICS5 - 02 - mort_E.sps'.		 
include 'MICS5 - 02 - mort_C.sps'.		 

* Wealth index quintile: Fourth.

define subgroupname ()
'(Fourth)'
!enddefine.
define subgroup ()
select if (windex5 = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.		

* Wealth index quintile: Richest.

define subgroupname ()
'(Richest)'
!enddefine.
define subgroup ()
select if (windex5 = 5).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.		

* Ethnicity of household head: Group 1.

define subgroupname ()
'(Group 1)'
!enddefine.
define subgroup ()
select if (ethnicity = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.		

* Ethnicity of household head: Group 2.

define subgroupname ()
'(Group 1)'
!enddefine.
define subgroup ()
select if (ethnicity = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Sex of child: Male.

define subgroupname ()
'(Sex of child: Male)'
!enddefine.
define subgroup ()
select if (BH3 = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Sex of child: Male.

define subgroupname ()
'(Sex of child: Female)'
!enddefine.
define subgroup ()
select if (BH3 = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Mother's age at birth: Less than 20.

define subgroupname ()
'(Mothers age at birth: Less than 20)'
!enddefine.
define subgroup ()
select if (magebrt = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Mother's age at birth: 20-34.

define subgroupname ()
'(Mothers age at birth: 20-34)'
!enddefine.
define subgroup ()
select if (magebrt = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Mother's age at birth: 35-49.

define subgroupname ()
'(Mothers age at birth: 35-49)'
!enddefine.
define subgroup ()
select if (magebrt = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Birth order: 1.

define subgroupname ()
'(Birth order: 1)'
!enddefine.
define subgroup ()
select if (brthord = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Birth order: 2-3.

define subgroupname ()
'(Birth order: 2-3)'
!enddefine.
define subgroup ()
select if (brthord = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Birth order: 4-6.

define subgroupname ()
'(Birth order: 4-6)'
!enddefine.
define subgroup ()
select if (brthord = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Birth order: 7+.

define subgroupname ()
'(Birth order: 7+)'
!enddefine.
define subgroup ()
select if (brthord = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Previous birth interval: < 2 years.

define subgroupname ()
'(Previous birth interval: < 2 years.)'
!enddefine.
define subgroup ()
select if (brthint = 1).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Previous birth interval: 2 years.

define subgroupname ()
'(Previous birth interval: 2 years.)'
!enddefine.
define subgroup ()
select if (brthint = 2).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Previous birth interval: 3 years.

define subgroupname ()
'(Previous birth interval: 3 years.)'
!enddefine.
define subgroup ()
select if (brthint = 3).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.

* Previous birth interval: 4 + years.

define subgroupname ()
'(Previous birth interval: 4 + years.)'
!enddefine.
define subgroup ()
select if (brthint = 4).
!enddefine.

include 'surveyname.sps'. 
include 'MICS5 - 02 - mort_D.sps'.		
include 'MICS5 - 02 - mort_E.sps'.		
include 'MICS5 - 02 - mort_C.sps'.
