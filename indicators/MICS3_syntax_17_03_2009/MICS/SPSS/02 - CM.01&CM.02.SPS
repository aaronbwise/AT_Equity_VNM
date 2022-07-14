* Runs mortality for each background characteristic.

*Male.
Define subgroup ()
  '(Male)'
!enddefine.

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

*total children ever born.
compute ceb = 0.
if (CM3 = 1) ceb = ceb + CM4A.
if (CM5 = 1) ceb = ceb + CM6A.
if (CM7 = 1) ceb = ceb + CM8A.

*number of dead children.
do if (CM7 = 1).
+ compute deadkids = CM8A.
else.
+ compute deadkids = 0.
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

get file='c:\mics\spss\WM.sav'.
select if (WM7 = 1).

*total children ever born.
compute ceb = 0.
if (CM3 = 1) ceb = ceb + CM4B.
if (CM5 = 1) ceb = ceb + CM6B.
if (CM7 = 1) ceb = ceb + CM8B.

*number of dead children.
do if (CM7 = 1).
+ compute deadkids = CM8B.
else.
+ compute deadkids = 0.
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

get file='c:\mics\spss\WM.sav'.

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

get file='c:\mics\spss\WM.sav'.

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

get file='c:\mics\spss\WM.sav'.

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

get file='c:\mics\spss\WM.sav'.

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
*Region 5.
Define subgroup ()
  '(Region 5)'
!enddefine.

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HH7 = 5).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute HH7 = 5.

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

get file='c:\mics\spss\WM.sav'.

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

get file='c:\mics\spss\WM.sav'.

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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (melevel = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute melevel = 1.

aggregate outfile = 'tmp.sav'
  /break melevel
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (melevel = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute melevel = 2.

aggregate outfile = 'tmp.sav'
  /break melevel
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (melevel = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute melevel = 3.

aggregate outfile = 'tmp.sav'
  /break melevel
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (Wlthind5 = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute Wlthind5 = 1.

aggregate outfile = 'tmp.sav'
  /break Wlthind5
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (Wlthind5 = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute Wlthind5 = 2.

aggregate outfile = 'tmp.sav'
  /break Wlthind5
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (Wlthind5 = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute Wlthind5 = 3.

aggregate outfile = 'tmp.sav'
  /break Wlthind5
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (Wlthind5 = 4).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute Wlthind5 = 4.

aggregate outfile = 'tmp.sav'
  /break Wlthind5
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (Wlthind5 = 5).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute Wlthind5 = 5.

aggregate outfile = 'tmp.sav'
  /break Wlthind5
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HC1B = 1).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute egroup = 1.

aggregate outfile = 'tmp.sav'
  /break egroup
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

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HC1B = 2).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute egroup = 2.

aggregate outfile = 'tmp.sav'
  /break egroup
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
  '(Group 3)'
!enddefine.

get file='c:\mics\spss\WM.sav'.

select if (WM7 = 1).

compute filter_$ =  (HC1B = 3).
FILTER BY filter_$.
weight by wmweight.

* Set sex  1 = male, 2 = female, 3 = total.
compute qfivesex = 3.

* Execute the bulk of the qfive process.
include file = 'qfive setup.sps'.

* Calculate mean of 25-29 and 30-34 group from the North model.
select if (wage  = 3  or  wage  = 4).
compute egroup = 3.

aggregate outfile = 'tmp.sav'
  /break egroup
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

get file='c:\mics\spss\WM.sav'.

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

variable label imr 'Infant Mortality Rate*'.
variable label u5mr 'Under-five Mortality Rate**'.
variable label sex 'Sex'.
variable label hh7 'Region'.
variable label hh6 'Area'.
variable label melevel "Mother's education".
variable label Wlthind5 'Wealth index quintiles'.
variable label egroup 'Ethnicity/Language/Religion'.
variable label total 'Total'.


value label sex 1 'Male' 2 'Female'.
value label hh7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'
 5 'Region 5'.
value label hh6 1 'Urban' 2 'Rural'.
value label melevel 1 'None' 2 'Primary' 3 'Secondary+'.
value label wlthind5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value label egroup 1 'Group 1' 2 'Group 2' 3 'Group 3'.
value label total 1 'Total'.

Compute imrm = imr*1000.
Compute u5mrm = u5mr*1000.
variable label imrm 'Infant Mortality Rate*'.
variable label u5mrm "Under-five Mortality Rate**".

* Comment - table below commented out and replaced by custom table
table
  /observation = imrm u5mrm
  /table= sex +hh7+ hh6 +melevel+wlthind5+egroup+total  by imrm + u5mrm
  /statistics
    mean( imrm( F7.0 )'')
    mean( u5mrm( F7.0 ) '')
  /title
   "Table CM.1: Early child mortality" 
   "Infant and under-five mortality rates by background and demographic characteristics [BASED ON NORTH], Country, Year"
  /caption
       "* MICS indicator 2; MDG indicator 14" 
       "** MICS indicator 1; MDG indicator13".

CTABLES
  /MRSETS COUNTDUPLICATES=YES
  /FORMAT EMPTY=BLANK
  /TABLE sex[C]+hh7[C]+hh6[C]+melevel[C]+wlthind5[C]+egroup[C]+total[C] BY 
         imrm[S][MEAN,'',F7.0]+u5mrm[S][MEAN,'',F7.0]
  /CATEGORIES VAR=ALL EMPTY=EXCLUDE MISSING=EXCLUDE
  /SLABELS POSITION=COLUMN
  /TITLE TITLE="Table CM.1: Child mortality"
   "Infant and under-five mortality rates by background and demographic characteristics [BASED ON NORTH], Country, Year"
            CAPTION="* MICS indicator 2; MDG indicator 14"
                            "** MICS indicator 1; MDG indicator 13".

new file.
erase file='tmp.sav'.
erase file='tmp2.sav'.
erase file='tmpcmr.sav'.
erase file='tmpresult.sav'.
