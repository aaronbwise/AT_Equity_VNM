* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Runs mortality for each background characteristic.
* Modifications must be made in qfive setup.sps as well.

*Male.
Define subgroup ()
  '(Male)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

*total children ever born.
compute ceb = 0.
if (CM4 = 1) ceb = ceb + CM5A.
if (CM6 = 1) ceb = ceb + CM7A.
if (CM8 = 1) ceb = ceb + CM9A.

*total children surviving.
compute csurv = 0.
if (CM4 = 1) csurv = csurv + CM5A.
if (CM6 = 1) csurv = csurv + CM7A.

*number of dead children.
do if (CM8 = 1).
+ compute cdead = CM9A.
else.
+ compute cdead = 0.
end if.

weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 1.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute sex = 1.

aggregate outfile = 'tmpresult.sav'
  /break sex
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).


*----------------------------------------------------------------.
*Female.
Define subgroup ()
  '(Female)'
!enddefine.

get file='WM.sav'.
select if (WM7 = 1).

*total children ever born.
compute ceb = 0.
if (CM4 = 1) ceb = ceb + CM5B.
if (CM6 = 1) ceb = ceb + CM7B.
if (CM8 = 1) ceb = ceb + CM9B.

*total children surviving.
compute csurv = 0.
if (CM4 = 1) csurv = csurv + CM5B.
if (CM6 = 1) csurv = csurv + CM7B.

*number of dead children.
do if (CM8 = 1).
+ compute cdead = CM9B.
else.
+ compute cdead = 0.
end if.

weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 2.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute sex = 2.

aggregate outfile = 'tmp.sav'
  /break sex
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Region 1.
Define subgroup ()
  '(Region 1)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH7 = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute HH7 = 1.

aggregate outfile = 'tmp.sav'
  /break HH7
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Region 2.
Define subgroup ()
  '(Region 2)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH7 = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute HH7 = 2.

aggregate outfile = 'tmp.sav'
  /break HH7
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Region 3.
Define subgroup ()
  '(Region 3)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH7 = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute HH7 = 3.

aggregate outfile = 'tmp.sav'
  /break HH7
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Region 4.
Define subgroup ()
  '(Region 4)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH7 = 4).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute HH7 = 4.

aggregate outfile = 'tmp.sav'
  /break HH7
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Urban.
Define subgroup ()
  '(Urban)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH6 = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute hh6 = 1.

aggregate outfile = 'tmp.sav'
  /break hh6
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.

*----------------------------------------------------------------.
*Rural.
Define subgroup ()
  '(Rural)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH6 = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute hh6 = 2.

aggregate outfile = 'tmp.sav'
  /break hh6
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Mother's education.
Define subgroup ()
  '(No education)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (welevel = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute welevel = 1.

aggregate outfile = 'tmp.sav'
  /break welevel
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Mother's education .
Define subgroup ()
  '(Primary)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (welevel = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute welevel = 2.

aggregate outfile = 'tmp.sav'
  /break welevel
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Mother's education.
Define subgroup ()
  '(Secondary +)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (welevel = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute welevel = 3.

aggregate outfile = 'tmp.sav'
  /break welevel
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Wealth index quintiles.
Define subgroup ()
  '(Poorest)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (windex5 = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute windex5 = 1.

aggregate outfile = 'tmp.sav'
  /break windex5
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Wealth index quintiles..
Define subgroup ()
  '(Second)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (windex5 = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute windex5 = 2.

aggregate outfile = 'tmp.sav'
  /break windex5
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Wealth index quintiles.
Define subgroup ()
  '(Middle)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (windex5 = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute windex5 = 3.

aggregate outfile = 'tmp.sav'
  /break windex5
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.



*----------------------------------------------------------------.
*Wealth index quintiles.
Define subgroup ()
  '(Fourth)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (windex5 = 4).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute windex5 = 4.

aggregate outfile = 'tmp.sav'
  /break windex5
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Wealth index quintiles.
Define subgroup ()
  '(Richest)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (windex5 = 5).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute windex5 = 5.

aggregate outfile = 'tmp.sav'
  /break windex5
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Ethnicity group.
Define subgroup ()
  '(Group 1)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (ethnicity = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute ethnicity = 1.

aggregate outfile = 'tmp.sav'
  /break ethnicity
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.


*----------------------------------------------------------------.
*Ethnicity group.
Define subgroup ()
  '(Group 2)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (ethnicity = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute ethnicity = 2.

aggregate outfile = 'tmp.sav'
  /break ethnicity
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.
save outfile='tmpresult.sav'.

*----------------------------------------------------------------.
*Total.
Define subgroup ()
  '(Total)'
!enddefine.

get file='WM.sav'.

select if (WM7 = 1).

weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute total = 1.

aggregate outfile = 'tmp.sav'
  /break total
  /imr = mean(imrno)
  /u5mr = mean(u5mrno).

get file 'tmpresult.sav'.
add files
  /file = *
  /file = 'tmp.sav'.

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
value labels hh7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'.
value labels hh6 1 'Urban' 2 'Rural'.
value labels welevel 1 'None' 2 'Primary' 3 'Secondary+'.
value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 'Group 1' 2 'Group 2'.
value labels total 1 ' '.

compute imrm = imr*1000.
compute u5mrm = u5mr*1000.
variable labels imrm 'Infant Mortality Rate [1]'.
variable labels u5mrm "Under-five Mortality Rate [2]".

* For labels in French uncomment commands bellow.
*variable labels
  imr 'Taux de mortalité infantile [1]'
  /u5mr 'Taux de mortalité infanto-juvénile [2]'
  /sex 'Sexe'
  /hh7 'Région'
  /hh6 'Milieu de résidence'
  /welevel "Instruction de la mère"
  /windex5 'Quintile du bien être économique'
  /ethnicity 'Religion/Langue/Ethnie du chef de ménage'.

* value labels sex 1 'Masculin' 2 'Féminin'.
* value labels hh7
 1 'Région 1'
 2 'Région 2'
 3 'Région 3'
 4 'Région 4'.
* value labels hh6 1 'Urbain' 2 'Rural'.
* value labels welevel 1 'Aucune' 2 'Primaire' 3 'Secondaire+'.
* value labels windex5 1 'Le plus pauvre' 2 'Second' 3 "Moyen" 4 "Quatrième" 5 "Le plus riche".
* value labels ethnicity 1 'Groupe 1' 2 'Groupe 2'.

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table sex [c] + hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + total [c] 
      by imrm [s] [mean,'',f7.0] + u5mrm [s] [mean,'',f7.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
                 "Table CM.2: Child mortality" 
                  "Infant and under-five mortality rates, [Model used] Model, "+ surveyname
  caption= 
           "[1] MICS indicator 1.2; MDG indicator 4.2" 
           "[2] MICS indicator 1.1; MDG indicator 4.1"
           "Rates refer to [insert calculated reference date from SPSS output], [Name of model used for calculations] "
           "Model was assumed to approximate the age pattern of mortality in [name of country]".

* Ctables command in French.
*
ctables
  /table sex [c] + hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + total [c] 
      by imrm [s] [mean,'',f7.0] + u5mrm [s] [mean,'',f7.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
                 "Tableau CM.2: Mortalité des enfants" 
                  "Taux de mortalité infantile et infanto-juvénile [Modèle utilisé] Modèle" + surveyname
  caption= 
           "[1] Indicateur MICS 1.2; Indicateur OMD 4.2" 
           "[2] Indicateur MICS 1.1; Indicateur OMD 4.1"
           "Le taux renvoie à [insérer la date de référence à partir du output SPSS], "
           "le modèle [Nom du modèle utilisé pour les calculs] a été adopté pour établir "
           "de manière approximative la répartition par âge de la mortalité au/en [nom du pays]".

new file.

erase file='tmp.sav'.
erase file='tmp2.sav'.
erase file='tmpcmr.sav'.
erase file='tmpresult.sav'.
