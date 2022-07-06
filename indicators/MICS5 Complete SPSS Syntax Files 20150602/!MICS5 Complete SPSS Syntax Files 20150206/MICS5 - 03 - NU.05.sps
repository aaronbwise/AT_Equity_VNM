* MICS5 NU-05.

* v02 - 2014-03-13.
* v03 - 2014-04-29.
* added value "Higher" to variable "Education".

* Median duration of any breastfeeding is calculated as the age in months when 50 percent of children age 0-35 months
  did not receive breastmilk during the previous day.
* Median durations of exclusive and predominant breastfeeding are calculated the same way.

* Median and mean durations are based on current status.
* The table is based only on living children at the time of survey.

* The mean is calculated only for the total population, whereas median is presented for the total population as well as for background characteristics.

* For definitions of exclusive and predominant breastfeeding, see footnotes below Table NU_3.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* --------------------------------------------------------------------------------------------------------- .

* Define interpolation for median - used for ever breastfed, exclusive breastfeeding and predominant breastfeeding.
define interpolate ( ind = !tokens(1) / med = !tokens(1) ).

* calculation of median - interpolate between groups where percentage drops below 50 percent.
do if (age2 <> 1 & !ind <= 50 and lag(!ind) > 50).
+ compute !med = lag(midpoint) + ( ( lag(!ind) - 50 ) / ( lag(!ind) - !ind ) ) * ( midpoint - lag(midpoint)  ).

* percentage is below 50 in the first group (if percentage is 0 in first group, then ignore - no median calculated).
else if (age2 = 1 and !ind > 0 and !ind <= 50).
+ compute !med = ( 50 / ( 100 - !ind ) ) * 0.75.

end if.
!enddefine.

* --------------------------------------------------------------------------------------------------------- .

* Define calculations needed for median - used several times in main body of program.
define NU4median(backvar = !tokens(1) /backval = !tokens(1) / first = !tokens(1) !default(0) )

* open the child's file.
get file='ch.sav'.

* Select completed interviews ...
select if (UF9 = 1).

* ... and children aged 0-35 months.
select if (cage >= 0 and cage <= 35).

* filter by background characteristic.
compute total = 0.
compute filter_$ =  (!backvar = !backval).
filter by filter_$.

* weight the data by the children's weight.
weight by chweight.

* Recode breastfeeding variables into dichotomous variables.
recode BD3 (1 = 100) (else = 0) into breastfed.
variable labels breastfed 'Child still being breastfed'.

* include definition of solidSemiSoft, exclusivelyBreastfed and predominantlyBreastfed .
include 'define/MICS5 - 03 - NU.sps' .

* Compute age in 2 months groups.
compute age2 = trunc(cage/2)+1.
variable labels age2 'Age'.
value labels age2
  1 '0 - 1'
  2 '2 - 3'
  3 '4 - 5'
  4 '6 - 7'
  5 '8 - 9'
  6 '10 - 11'
  7 '12 - 13'
  8 '14 - 15'
  9 '16 - 17'
 10 '18 - 19'
 11 '20 - 21'
 12 '22 - 23'
 13 '24 - 25'
 14 '26 - 27'
 15 '28 - 29'
 16 '30 - 31'
 17 '32 - 33'
 18 '34 - 35'.

* Calculate midpoint of each age group.  Midpoint of first group (0-1.5 months = 0.75, 1.5-3.5 = 2.5, 3.5-5.5 = 4.5, etc.).
compute midpoint = 0.75.
if (age2 <> 1) midpoint = age2*2 - 1.5.
variable labels midpoint "Midpoint".

* Sum breastfeeding data by 2 month age groups.
aggregate
  /outfile='aggr.sav'
  /break=age2
  /midpoint = mean (midpoint)
  /childrenNo 'Number of children' = N
  /breastfed 'Children being breastfed' = sum(breastfed)
  /exclusivelyBreastfed 'Children being exclusive breastfed' = sum(exclusivelyBreastfed)
  /predominantlyBreastfed 'Children being predominant breastfed' = sum(predominantlyBreastfed).

* Open aggregated data file.
get file='aggr.sav'.

* get preceding (lag) and following (lead) values to use for smoothing with 3 group moving average.

sort cases by age2 (A).

compute lagChildrenNo = lag(childrenNo,1).
compute lagBreastfed = lag(breastfed,1).
compute lagExclusivelyBreastfed = lag(exclusivelyBreastfed,1).
compute lagPredominantlyBreastfed = lag(predominantlyBreastfed,1).

sort cases by age2 (D).

compute leadChildrenNo = lag(childrenNo,1).
compute leadBreastfed = lag(breastfed,1).
compute leadExclusivelyBreastfed = lag(exclusivelyBreastfed,1).
compute leadPredominantlyBreastfed = lag(predominantlyBreastfed,1).

sort cases by age2 (A).

* smooth by a three group moving average.

do if (age2 <> 1 and age2 <> 18).
+ compute adjChildrenNo = (lagChildrenNo + childrenNo + leadChildrenNo)/3.
+ compute adjBreastfed = (lagBreastfed + breastfed + leadBreastfed)/3.
+ compute adjExclusivelyBreastfed = (lagExclusivelyBreastfed + exclusivelyBreastfed + leadExclusivelyBreastfed)/3.
+ compute adjPredominantlyBreastfed = (lagPredominantlyBreastfed + predominantlyBreastfed + leadPredominantlyBreastfed)/3.
else.
+ compute adjChildrenNo = childrenNo.
+ compute adjBreastfed = breastfed.
+ compute adjExclusivelyBreastfed = exclusivelyBreastfed.
+ compute adjPredominantlyBreastfed = predominantlyBreastfed.
end if.
variable label adjChildrenNo 'Number of children smoothed'.
variable label adjBreastfed 'Number of children breastfed smoothed'.
variable label adjExclusivelyBreastfed 'Number of children exclusively breastfed smoothed'.
variable label adjPredominantlyBreastfed 'Number of children predominantly breastfed smoothed'.

* calculate percentages.

* exclusivelyBreastfed and predominantlyBreastfed are already multiplied by 100, in define\MICS5 - 03 - NU.sps .
compute percBreastfed = adjBreastfed/adjChildrenNo.
compute percExclusivelyBreastfed = adjExclusivelyBreastfed/adjChildrenNo.
compute percPredominantlyBreastfed = adjPredominantlyBreastfed/adjChildrenNo.
variable label percBreastfed 'Proportion still breastfeeding'.
variable label percExclusivelyBreastfed 'Proportion exclusively breastfeeding'.
variable label percPredominantlyBreastfed 'Proportion predominantly breastfeeding'.

* Do the interpolation between points when percentage drop below 50% to calculate the median.
interpolate ind = percBreastfed     med = medianAgeBreastfed.
interpolate ind = percExclusivelyBreastfed med = medianAgeExclusivelyBreastfed.
interpolate ind = percPredominantlyBreastfed  med = medianAgePredominantlyBreastfed.

variable label medianAgeBreastfed "Median duration (in months) of any breastfeeding [1]".
variable label medianAgeExclusivelyBreastfed "Median duration (in months) of  exclusive breastfeeding".
variable label medianAgePredominantlyBreastfed "Median duration (in months) of predominant breastfeeding".

*need to recode  lag(midpoint) = 0 for the first group.
*compute meanBreastfed = percBreastfed * (midpoint - lag(midpoint))/100.
*compute meanExclusivelyBreastfed = percExclusivelyBreastfed * (midpoint - lag(midpoint))/100.
*compute meanPredominantlyBreastfed = percPredominantlyBreastfed * (midpoint - lag(midpoint))/100.

* Mutiply proportion breastfeeding by width of agegroup (2 for all groups, expect the first which is 1.5) - summed later to give an overall mean.
do if (age2 <> 1).
+ compute meanBreastfed = percBreastfed * 2 / 100.
+ compute meanExclusivelyBreastfed = percExclusivelyBreastfed * 2 / 100.
+ compute meanPredominantlyBreastfed = percPredominantlyBreastfed * 2 / 100.
else.
+ compute meanBreastfed = percBreastfed * 1.5 / 100.
+ compute meanExclusivelyBreastfed = percExclusivelyBreastfed * 1.5 / 100.
+ compute meanPredominantlyBreastfed = percPredominantlyBreastfed * 1.5 / 100.
end if.

* Create working variable for the background characteristic being tabulated to include in the aggregate command.
compute !backvar = !backval.

* Save the working version - just for checking.
save outfile = 'aggr.sav'.

* Aggregate the data, mean used as its the only value for the median calculations, but sum used to sum all values for the means.
aggregate outfile = 'tmpresult.sav'
  /break=!backvar
  /medianAgeBreastfed = mean(medianAgeBreastfed)
  /medianAgeExclusivelyBreastfed = mean(medianAgeExclusivelyBreastfed)
  /medianAgePredominantlyBreastfed = mean(medianAgePredominantlyBreastfed)
  /meanBreastfed = sum (meanBreastfed)
  /meanExclusivelyBreastfed = sum (meanExclusivelyBreastfed)
  /meanPredominantlyBreastfed = sum (meanPredominantlyBreastfed)
  /childrenNo = sum (childrenNo).

* If this is the first characteristic for the table, then we are creating a new working file,
  otherwise we will append to that file.

* Duplicate the first results for total in order to display mean values in the table also .
!if (!first = 1) !then
get file 'tmpresult.sav'.
save outfile='tmp.sav'.
!ifend
get file 'tmp.sav'.
add files
  /file = *
  /file = 'tmpresult.sav'.
save outfile='tmp.sav'.


!enddefine.

* --------------------------------------------------------------------------------------------------------- .

* Main routine that runs the median calculations for each of the background variables.
* Set the following:
* backvar to the name of the background variable.
* backval to the value for the category of interest of the background variable.
* first to 1 if this is the first background category in the table, 0 otherwise.

* Total.
NU4median backvar = total backval = 0 first= 1.
* Sex.
NU4median backvar = HL4 backval = 1.
NU4median backvar = HL4 backval = 2.
* Region.
NU4median backvar = HH7 backval = 1.
NU4median backvar = HH7 backval = 2.
NU4median backvar = HH7 backval = 3.
NU4median backvar = HH7 backval = 4.
* Area.
NU4median backvar = HH6 backval = 1.
NU4median backvar = HH6 backval = 2.
* Mother's education level.
NU4median backvar = melevel backval = 1.
NU4median backvar = melevel backval = 2.
NU4median backvar = melevel backval = 3.
NU4median backvar = melevel backval = 4.
* Wealth index.
NU4median backvar = windex5 backval = 1.
NU4median backvar = windex5 backval = 2.
NU4median backvar = windex5 backval = 3.
NU4median backvar = windex5 backval = 4.
NU4median backvar = windex5 backval = 5.
* Ethnicity.
NU4median backvar = ethnicity backval = 1.
NU4median backvar = ethnicity backval = 2.


*   --------------------------------------------------------------------------------------------------------- .

* The first record is duplicated for the total so just to copy the mean variables into the median variables.
if (total = 0 and lag(total) = 0) total = 1.
do if (total = 1).
+ compute medianAgeBreastfed = meanBreastfed.
+ compute medianAgeExclusivelyBreastfed = meanExclusivelyBreastfed.
+ compute medianAgePredominantlyBreastfed = meanPredominantlyBreastfed.
+ compute totalMean = 1 .
+ compute total=$sysmis .
end if.
compute layer = 0.

variable labels layer " ".
value labels layer 0 "Median duration (in months) of".
variable labels medianAgeBreastfed "Any breastfeeding [1]".
variable labels medianAgeExclusivelyBreastfed "Exclusive breastfeeding".
variable labels medianAgePredominantlyBreastfed "Predominant breastfeeding".

variable labels HL4 "Sex".
variable labels HH7 "Region".
variable labels HH6 "Area".
variable labels melevel "Mother's education".
variable labels windex5 "Wealth index quintile".
variable labels ethnicity "Ethnicity of household head".
variable labels childrenNo 'Number of children age 0-35 months'.
variable labels total "".

value labels HL4 1 'Male' 2 'Female'.
value labels HH7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'.
value labels HH6 1 'Urban' 2 'Rural'.
value labels melevel 1 'None' 2 'Primary' 3 'Secondary' 4 'Higher'.

value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 'Group 1' 2 'Group 2'.
value labels total 0 "Median" .
value labels totalMean 1 "Mean" .

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = total layer totalMean
           display = none
  /table   total [c]
         + hl4 [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
         + totalMean [c]
   by
           layer [c] > (
             medianAgeBreastfed [s] [mean,f5.1]
           + medianAgeExclusivelyBreastfed [s] [mean,f5.1]
           + medianAgePredominantlyBreastfed [s] [mean,f5.1] )
         + childrenNo[s] [mean,f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table NU.5: Duration of breastfeeding"
     "Median duration of any breastfeeding, exclusive breastfeeding, and predominant breastfeeding among children age 0-35 months, " + surveyname
   caption=
     "[1] MICS indicator 2.11 - Duration of breastfeeding"
  .

new file.

erase file = 'aggr.sav'.
erase file = 'tmp.sav'.
erase file = 'tmpresult.sav'.
