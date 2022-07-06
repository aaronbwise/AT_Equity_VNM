* MICS5 NU-03.

* v02 - 2014-03-05.
* v03 - 2014-07-18.
* Ctables title corrected.
* v04 - 2014-07-20.
* order of values of place of delivery changed in line with the latest tab plan.
* v05 - 2014-08-19.
* variable label everBreastfed changed to "Percentage who were ever breastfed[1]".


* Children who were ever breastfed: MN24.

* Children who started breastfeeding within one hour of birth: MN25=000 (immediately) or
  MN25=100 (within 1 hour).

* Children who started breastfeeding within one day of birth: MN25=000 (immediately) or
  (MN25 >= 100 and MN25 <= 123). Includes children who started breastfeeding within one hour of birth.

* Children who received a prelactealFeedteal feed are those who received something other than breast
  milk during the first three days of life (MN26=1).

* The table is based on responses of women in the Questionnaire for Individual Women on their
  last-born children in the 2 years preceding the survey.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O" or CM13 = "S").

* Calculate months since last birth IF last birth in last two years.
compute monthsSinceLastBirth = wdoi - wdoblc.
variable labels monthsSinceLastBirth "Months since last birth".

*Create a recoded months variable since last birth.
recode monthsSinceLastBirth (0 thru 11 = 1) (12 thru 24 = 2) into monthsSinceLastBirthGroups.
variable labels monthsSinceLastBirthGroups "Months since last birth".
value labels monthsSinceLastBirthGroups 1 "0-11 months" 2 "12-23 months".

compute everBreastfed = 0.
if (MN24 = 1) everBreastfed = 100.
variable labels everBreastfed "Percentage who were ever breastfed [1]".

compute layer = 1.
value labels layer 1 "Percentage who were first breastfed:".

compute within1hour = 0.
if ((MN25U = 1 and MN25N = 0) or MN25U  = 0) within1hour = 100.
variable labels within1hour "Within one hour of birth [2]".

compute within1day = 0.
if (MN25U = 0 or MN25U = 1) within1day = 100.
variable labels within1day "Within one day of birth".

compute prelactealFeed = 0.
if (MN26 = 1) prelactealFeed = 100.
variable labels prelactealFeed "Percentage who received a prelacteal feed".

compute numChildren = 1.
value labels numChildren 1 "Number of last live-born children in the last two years".

compute anc = 0.
if (MN17A = "A") anc = 11.
if (anc = 0 and MN17B = "B") anc = 12.
if (anc = 0 and MN17C = "C") anc = 13.
if (anc = 0 and MN17F = "F") anc = 21.
if (anc = 0 and MN17G = "G") anc = 22.
if (anc = 0 and MN17H = "H") anc = 23.
if (anc = 0 and MN17X = "X") anc = 96.
if (anc = 0 and MN17A = "?") anc = 97.
variable labels anc "Person assisting delivery".
value labels anc
  11 "Doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  21 "Traditional birth attendant"
  22 "Community health worker"
  23 "Relative / Friend"
  96 "Other"
  97 "Missing".

compute skilled = 9.
if (anc = 11 or anc = 12 or anc = 13) skilled = 1.
if (anc = 21) skilled = 2.
if (anc = 22 or anc = 23 or anc = 96) skilled = 3.
variable labels skilled "Assistance at delivery".
value labels skilled
  1 "Skilled attendant"
  2 "Traditional birth attendant"
  3 "Other"
  9 "No one/Missing".

*Home
	Respondent’s home	11
	Other home		12
Public sector
	Government hospital	21
	Government clinic / health centre	22
	Government health post	23
	Other public (specify)	26
Private Medical Sector
	Private hospital	31
	Private clinic	32
	Private maternity home	33
	Other private medical (specify)	36
Other (specify)	96
.

compute deliveryPlace = 0.
if (MN18 >= 21 and MN18 <= 26) deliveryPlace = 11.
if (MN18 >= 31 and MN18 <= 36) deliveryPlace = 12.
if (MN18 = 11 or MN18 = 12) deliveryPlace = 13.
if (MN18 = 96) deliveryPlace = 96.
if (MN18 = 98 or MN18 = 99) deliveryPlace = 98.
variable labels deliveryPlace "Place of delivery".
value labels deliveryPlace
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "Missing/DK".
  
recode deliveryPlace (13=1) (11,12=2)  (96,98=5) into place1 .
recode deliveryPlace (11=3) (12=4) into place2 .
value labels place1 place2
  1 'Home'
  2 'Health facility'
  3 '   Public'
  4 '   Private'
  5 'Other/DK/Missing' .
mrsets 
  /mcgroup name=$deliveryPlace label='Place of delivery' variables=place1 place2.

compute total = 1.
value labels total 1 " ".
variable labels total "Total".

variable labels welevel "Mother’s education".
* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = numChildren layer
           display = none
  /table  total [c]
        + hh7 [c]
        + hh6 [c]
        + monthsSinceLastBirthGroups [c]
        + skilled [c]
        + $deliveryPlace [c]
        + welevel [c]
        + windex5 [c]
        + ethnicity [c]
   by
          everBreastfed[s][mean,'',f5.1]
        + layer [c] > (
            within1hour[s][mean,'',f5.1]
          + within1day[s][mean,'',f5.1] )
        + prelactealFeed[s][mean,'',f5.1]
        + numChildren[c][count,'',f5.0]
  /slabels visable = no
  /categories var=all empty=exclude missing=exclude
  /titles title=
        "Table NU.3: Initial breastfeeding"
        "Percentage of last live-born children in the last two years who were ever breastfed, " +
     "breastfed within one hour of birth, and within one day of birth,   " +
     "and percentage who received a prelacteal feed, " + surveyname
  caption=
        "[1] MICS indicator 2.5 - Children ever breastfed"
        "[2] MICS indicator 2.6 - Early initiation of breastfeeding" .


new file.
