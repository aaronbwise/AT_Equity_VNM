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
!ifend

* Execute the bulk of the qfive TSFB process.
include file = 'qfive TSFB setup.sps'.

* Calculate mean of 0-4, 5-9 and average of 0-4 and 5-9 groups.

* Create output data for a particular model applicable for your country.
* For North: imrno and u5mrno.
* For South: imrso and u5mrso.
* For East: imrea and u5mrea.
* For West: imrwe and u5mrwe.

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
if (tsfb = 1 and model = "North" ) imr1                      = imrno.
if (tsfb = 1 and model = "North") u5mr1                    = u5mrno.
if (tsfb = 2 and model = "North") imr2                       = imrno.
if (tsfb = 2 and model = "North") u5mr2                    = u5mrno.
if ((tsfb = 1 or tsfb = 2) and model = "North") imr3     = imrno.
if ((tsfb = 1 or tsfb = 2) and model = "North") u5mr3  = u5mrno.
* Save reference date for subtitle.
if (tsfb = 1 and model = "North") ref1                       = refdateno.
if (tsfb = 2 and model = "North") ref2                       = refdateno.
if ((tsfb = 1 or tsfb = 2) and model = "North") ref3     = refdateno.

** South.
if (tsfb = 1 and model = "South" ) imr1                      = imrso.
if (tsfb = 1 and model = "South") u5mr1                    = u5mrso.
if (tsfb = 2 and model = "South") imr2                       = imrso.
if (tsfb = 2 and model = "South") u5mr2                    = u5mrso.
if ((tsfb = 1 or tsfb = 2) and model = "South") imr3     = imrso.
if ((tsfb = 1 or tsfb = 2) and model = "South") u5mr3  = u5mrso.
* Save reference date for subtitle.
if (tsfb = 1 and model = "South") ref1                       = refdateso.
if (tsfb = 2 and model = "South") ref2                       = refdateso.
if ((tsfb = 1 or tsfb = 2) and model = "South") ref3     = refdateso.

** East.
if (tsfb = 1 and model = "East" ) imr1                      = imrea.
if (tsfb = 1 and model = "East") u5mr1                    = u5mrea.
if (tsfb = 2 and model = "East") imr2                       = imrea.
if (tsfb = 2 and model = "East") u5mr2                    = u5mrea.
if ((tsfb = 1 or tsfb = 2) and model = "East") imr3     = imrea.
if ((tsfb = 1 or tsfb = 2) and model = "East") u5mr3  = u5mrea.
* Save reference date for subtitle.
if (tsfb = 1 and model = "East") ref1                       = refdateea.
if (tsfb = 2 and model = "East") ref2                       = refdateea.
if ((tsfb = 1 or tsfb = 2) and model = "East") ref3     = refdateea.

** West.
if (tsfb = 1 and model = "West" ) imr1                      = imrwe.
if (tsfb = 1 and model = "West") u5mr1                    = u5mrwe.
if (tsfb = 2 and model = "West") imr2                       = imrwe.
if (tsfb = 2 and model = "West") u5mr2                    = u5mrwe.
if ((tsfb = 1 or tsfb = 2) and model = "West") imr3     = imrwe.
if ((tsfb = 1 or tsfb = 2) and model = "West") u5mr3  = u5mrwe.
* Save reference date for subtitle.
if (tsfb = 1 and model = "West") ref1                       = refdatewe.
if (tsfb = 2 and model = "West") ref2                       = refdatewe.
if ((tsfb = 1 or tsfb = 2) and model = "West") ref3     = refdatewe.

aggregate outfile = 'tmp.sav'
  /break !backvar
  /imr0_4 = mean(imr1)
  /u5mr0_4 = mean(u5mr1)
  /imr5_9 = mean(imr2)
  /u5mr5_9 = mean(u5mr2)
  /imr0_9 = mean(imr3)
  /u5mr0_9 = mean(u5mr3)
  /ref0_4 = mean(ref1)
  /ref5_9 = mean(ref2)
  /ref0_9 = mean(ref3).
   
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
value labels ethnicity 1 'Ethnicity 1' 2 'Ethnicity 2' .

value labels total 1 ' '.

variable labels imr0_4 'Infant Mortality Rate [1]'.
variable labels u5mr0_4 "Under-five Mortality Rate [2]".
compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Based on TSFB group 0-4".

variable labels imr5_9 'Infant Mortality Rate [1]'.
variable labels u5mr5_9 "Under-five Mortality Rate [2]".
compute layer2 = 0.
variable labels layer2 " ".
value labels layer2 0 "Based on TSFB group 5-9".

variable labels imr0_9 'Infant Mortality Rate [1]'.
variable labels u5mr0_9 "Under-five Mortality Rate [2]".
compute layer3 = 0.
variable labels layer3 " ".
value labels layer3 0 "Based on the average of TSFB groups 0-4 and 5-9".

missing values imr0_4 u5mr0_4  imr5_9 u5mr5_9  imr0_9 u5mr0_9  (-999,999).

ctables
  /vlabels variables = layer1 layer2 layer3 display = none
  /format missing = "or"
  /table total [c] + sex [c] + hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] 
      by layer1 [c] > (imr0_4 [s] [mean,'',f7.0] + u5mr0_4 [s] [mean,'',f7.0]) +
           layer2 [c] > (imr5_9 [s] [mean,'',f7.0] + u5mr5_9 [s] [mean,'',f7.0]) +
           layer3 [c] > (imr0_9 [s] [mean,'',f7.0] + u5mr0_9 [s] [mean,'',f7.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title=
                 "Table CM.3: Infant and under-5 mortality rates by background characteristics"
                  "Indirect estimates of infant and under-five mortality rates by selected background characteristics, " +
                                                                "time since first birth version, [Model used] Model, "+ surveyname	
  caption=
	"[1] MICS indicator 1.2; MDG indicator 4.2 - Infant mortality rate"		
	"[2] MICS indicator 1.5; MDG indicator 4.1 - Under-five mortality rate"		
	"Rates based on TSFB group 0-4 refer to [insert calculated reference date from SPSS output]. "
	"Rates based on TSFB group 5-9 refer to [insert calculated reference date from SPSS output]. "
	"Rates based on TSFB group 0-9 refer to [insert calculated reference date from SPSS output]. "
	"The  [Name of model used for calculations] Model was assumed to approximate the age pattern of mortality in [insert name of country]."	
  "or: out of range of model life tables".

* Auxiliary text used to indicate model used and reference date.
* Information should be included in the subtitle above. 
* After first run and inserting information please make sure to comment out below text in final output.

variable labels ref0_4 "Rates based on TSFB group 0-4 refer to".
variable labels ref5_9 "Rates based on TSFB group 5-9 refer to".
variable labels ref0_9 "Rates based on TSFB group 0-9 refer to".

compute filter = (total = 1 and tsfb = 1).
filter by filter.

report 
  /format = automatic list
  /variables = model "Model used" .

filter off.
compute filter = (sysmis(ref0_4) = 0 and total = 1).
filter by filter.

report 
  /format = automatic list
  /variables = ref0_4 "Rates based on TSFB group 0-4 refer to" 
                    ref5_9 "Rates based on TSFB group 5-9 refer to" 
                    ref0_9 "Rates based on TSFB group 0-9 refer to" .

new file.

erase file='tmp.sav'.
erase file='tmp2.sav'.
erase file='tmpcmr.sav'.
erase file='tmpresult.sav'.