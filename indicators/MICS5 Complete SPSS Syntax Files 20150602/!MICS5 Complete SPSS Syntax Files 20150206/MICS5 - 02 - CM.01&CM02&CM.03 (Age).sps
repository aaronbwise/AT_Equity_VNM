* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Recreates CEB, CDEAD and CSURV for one sex only - used for Male and Female estimates.
define recodeforsex (sexval = !tokens(1) ).

compute sex = !sexval.

*total children surviving and children dead.
compute csurv = 0.
compute cdead = 0.
!if (!sexval=1) !then
if (CM4 = 1) csurv = csurv + CM5A.
if (CM6 = 1) csurv = csurv + CM7A.
if (CM8 = 1) cdead = CM9A.
!else
if (CM4 = 1) csurv = csurv + CM5B.
if (CM6 = 1) csurv = csurv + CM7B.
if (CM8 = 1) cdead = CM9B.
!ifend

*total children ever born.
compute ceb = csurv + cdead.

!enddefine.

* Sets up and run the qfive routine for one background characteristic.
define qfiverun (backvar = !tokens(1) / backval = !tokens(1)).

* Open data file.
get file='WM.sav'.

* Select only complete interviews.
select if (WM7 = 1).

* Calculate mean age of maternity.
compute agem = trunc((wdobfc-wdob)/12).

* Calculate meadian survey month and year.
aggregate
 /outfile = * mode = addvariables
 /wdoi_med = median (WDOI)
 /meanage = mean (agem).
 
compute syear = 1900+trunc (wdoi_med/12).
compute smonth = wdoi_med - (syear-1900)*12 .

* For sex background variable, recreate CEB ,CSURV and CDEAD.
!if (!backvar=sex) !then
recodeforsex sexval=!backval.
!ifend

* For total, add a total variable to dataset.
!if (!backvar=total) !then
compute !backvar=!backval.
!ifend

* Filter on selected variable.
compute filter_$ =  (!backvar = !backval).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
!if (!backvar=sex) !then
compute qfivesex = !backval.
!else
compute qfivesex = 3.
!ifend.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group.
select if (wage  = 3  or  wage  = 4).
compute !backvar = !backval.

* Create output data for a particular model applicable for your country (currently imrXX and u5mrXX).
* For North use imrno and u5mrno.
* For South use imrso and u5mrso.
* For East use imrea and u5mrea.
* For West use imrwe and u5mrwe.

* Choose model to be used.
string model (a10).
* Create output data for a particular model applicable for your country (currently ModelXX).
* For North use "North".
* For South use "South".
* For East use "East".
* For West use "West".
compute model = "ModelXX".

compute !backvar = !backval.
** North.
if (model = "North" ) imr1                    = imrno.
if (model = "North") u5mr1                  = u5mrno.
* Save reference date for subtitle.
if (model = "North") ref1                      = refdateno.

** South.
if (model = "South" ) imr1                    = imrso.
if (model = "South") u5mr1                  = u5mrso.
* Save reference date for subtitle.
if (model = "South") ref1                      = refdateso.

** East.
if (model = "East" ) imr1                    = imrea.
if (model = "East") u5mr1                  = u5mrea.
* Save reference date for subtitle.
if (model = "East") ref1                      = refdateea.

** West.
if (model = "West" ) imr1                    = imrwe.
if (model = "West") u5mr1                  = u5mrwe.
* Save reference date for subtitle.
if (model = "West") ref1                      = refdatewe.


aggregate outfile = 'tmp.sav'
  /break !backvar
  /imr = mean(imr1)
  /u5mr = mean(u5mr1)
  /ref = mean(ref1).

* add results to a file of results by characteristics.
get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.

!enddefine.

erase file='tmpresult.sav'.

* Runs mortality for each background characteristic.
* Modifications must be made in qfive setup.sps as well.

*Total.
Define subgroup ()
  '(Total)'
!enddefine.
qfiverun backvar=total backval=1.

*Sex.
Define subgroup ()
  '(Male)'
!enddefine.
qfiverun backvar=sex backval=1.
Define subgroup ()
  '(Female)'
!enddefine.
qfiverun backvar=sex backval=2.

*Regions.
Define subgroup ()
  '(Region 1)'
!enddefine.
qfiverun backvar=HH7 backval=1.
Define subgroup ()
  '(Region 2)'
!enddefine.
qfiverun backvar=HH7 backval=2.
Define subgroup ()
  '(Region 3)'
!enddefine.
qfiverun backvar=HH7 backval=3.
Define subgroup ()
  '(Region 4)'
!enddefine.
qfiverun backvar=HH7 backval=4.

*Residence.
Define subgroup ()
  '(Urban)'
!enddefine.
qfiverun backvar=HH6 backval=1.
Define subgroup ()
  '(Rural)'
!enddefine.
qfiverun backvar=HH6 backval=2.


*Mother's education.
Define subgroup ()
  '(No education)'
!enddefine.
qfiverun backvar=welevel backval=1.
Define subgroup ()
  '(Primary)'
!enddefine.
qfiverun backvar=welevel backval=2.
Define subgroup ()
  '(Secondary +)'
!enddefine.
qfiverun backvar=welevel backval=3.

*Wealth index quintiles.
Define subgroup ()
  '(Poorest)'
!enddefine.
qfiverun backvar=windex5 backval=1.
Define subgroup ()
  '(Second)'
!enddefine.
qfiverun backvar=windex5 backval=2.
Define subgroup ()
  '(Middle)'
!enddefine.
qfiverun backvar=windex5 backval=3.
Define subgroup ()
  '(Fourth)'
!enddefine.
qfiverun backvar=windex5 backval=4.
Define subgroup ()
  '(Richest)'
!enddefine.
qfiverun backvar=windex5 backval=5.

*Ethnicity group.
Define subgroup ()
  '(Ethnicity 1)'
!enddefine.
qfiverun backvar=ethnicity backval=1.

Define subgroup ()
  '(Ethnicity 2)'
!enddefine.
qfiverun backvar=ethnicity backval=2.


*----------------------------------------------------------------.

variable labels imr 'Infant Mortality Rate [1]'.
variable labels u5mr 'Under-five Mortality Rate [2]'.
variable labels sex 'Sex'.
variable labels hh7 'Region'.
variable labels hh6 'Area'.
variable labels welevel "Mother's education".
variable labels windex5 'Wealth index quintiles'.
variable labels ethnicity 'Ethnicity of household head'.
variable labels total 'Total'.

value labels sex 1 'Male' 2 'Female'.
value labels hh7 1 'Region 1' 2 'Region 2' 3 'Region 3' 4 'Region 4'.
value labels hh6 1 'Urban' 2 'Rural'.
value labels welevel 1 'None' 2 'Primary' 3 'Secondary +'.
value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 'Ethnicity 1'  2 'Ethnicity 2'.

value labels total 1 ' '.

missing values imr u5mr  (-999,999).

ctables
  /format missing = "or" 
  /table total [c] + sex [c] + hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] 
      by imr [s] [mean,'',f7.0] + u5mr [s] [mean,'',f7.0]
  /categories var=all empty=exclude missing=exclude
  /titles title=
                 "Table CM.3: Infant and under-5 mortality rates by background characteristics"
                  "Indirect estimates of infant and under-five mortality rates by selected background characteristics, age version, [Model used] Model, "+ surveyname	
  caption=
	"[1] MICS indicator 1.2; MDG indicator 4.2 - Infant mortality rate"		
	"[2] MICS indicator 1.5; MDG indicator 4.1 - Under-five mortality rate"		
	"Rates refer to [insert calculated reference date from SPSS output]. "
	"The  [Name of model used for calculations] Model was assumed to approximate the age pattern of mortality in [insert name of country]."	
  "or: out of range of model life tables".

* Auxiliary text used to indicate model used and reference date.
* Information should be included in the subtitle above. 
* After first run and inserting information please make sure to comment out below text in final output.

variable labels ref "Rates refer to".

compute filter = (total = 1 and wage = 3).
filter by filter.

report 
  /format = automatic list
  /variables = model "Model used" .

filter off.
compute filter = (sysmis(ref) = 0 and total = 1).
filter by filter.

report 
  /format = automatic list
  /variables = ref "Rates refer to" 
.

new file.

erase file='tmp.sav'.
erase file='tmp2.sav'.
erase file='tmpcmr.sav'.
erase file='tmpresult.sav'.
