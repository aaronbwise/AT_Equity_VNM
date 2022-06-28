* Encoding: UTF-8.

***.
* v02 - 2020-04-14. Labels in French and Spanish have been removed.
***.

 * Median duration of any breastfeeding is calculated as the age in months when 50 percent of children age 0-35 months did not receive 
  breastmilk during the previous day. Median durations of exclusive and predominant breastfeeding are calculated the same way, but on a denominator of children age 0-23 months.

 * Median and mean durations are based on current status. The table is based only on living children at the time of survey.

 * The mean is calculated only for the total population, whereas median is presented for the total population as well as for background characteristics. For "Any 
  breastfeeding" a median at or above 36 months is rare but possible. This will not be automatically shown in the SPSS output. Please insert '>=36' manually where applicable.

 * For definitions of exclusive and predominant breastfeeding, see footnotes below Table TC.7.1.

***.
***************************  Median duration of any breastfeeding (children age 0-35 months).


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
select if (UF17 = 1).

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
include 'define/MICS6 - 07 - TC.sps' .

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
variable labels adjChildrenNo 'Number of children smoothed'.
variable labels adjBreastfed 'Number of children breastfed smoothed'.
variable labels adjExclusivelyBreastfed 'Number of children exclusively breastfed smoothed'.
variable labels adjPredominantlyBreastfed 'Number of children predominantly breastfed smoothed'.

* calculate percentages.

* exclusivelyBreastfed and predominantlyBreastfed are already multiplied by 100, in define\MICS6 - 06 - TC.sps .
compute percBreastfed = adjBreastfed/adjChildrenNo.
compute percExclusivelyBreastfed = adjExclusivelyBreastfed/adjChildrenNo.
compute percPredominantlyBreastfed = adjPredominantlyBreastfed/adjChildrenNo.
variable labels percBreastfed 'Proportion still breastfeeding'.
variable labels percExclusivelyBreastfed 'Proportion exclusively breastfeeding'.
variable labels percPredominantlyBreastfed 'Proportion predominantly breastfeeding'.

* Do the interpolation between points when percentage drop below 50% to calculate the median.
interpolate ind = percBreastfed     med = medianAgeBreastfed.
interpolate ind = percExclusivelyBreastfed med = medianAgeExclusivelyBreastfed.
interpolate ind = percPredominantlyBreastfed  med = medianAgePredominantlyBreastfed.

variable labels medianAgeBreastfed "Median duration (in months) of any breastfeeding [1]".
variable labels medianAgeExclusivelyBreastfed "Median duration (in months) of  exclusive breastfeeding".
variable labels medianAgePredominantlyBreastfed "Median duration (in months) of predominant breastfeeding".

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
NU4median backvar = HH7 backval = 5.
* Area.
NU4median backvar = HH6 backval = 1.
NU4median backvar = HH6 backval = 2.
* Mother's education level.
NU4median backvar = melevel backval = 0.
NU4median backvar = melevel backval = 1.
NU4median backvar = melevel backval = 2.
NU4median backvar = melevel backval = 3.
* Wealth index.
NU4median backvar = windex5 backval = 1.
NU4median backvar = windex5 backval = 2.
NU4median backvar = windex5 backval = 3.
NU4median backvar = windex5 backval = 4.
NU4median backvar = windex5 backval = 5.
* Ethnicity.
NU4median backvar = ethnicity backval = 1.
NU4median backvar = ethnicity backval = 2.
NU4median backvar = ethnicity backval = 3.
NU4median backvar = ethnicity backval = 6.
*Disability.
NU4median backvar = caretakerdis backval = 1.
NU4median backvar = caretakerdis backval = 2.

*   --------------------------------------------------------------------------------------------------------- .

* The first record is duplicated for the total so just to copy the mean variables into the median variables.
if (total = 0 and lag(total) = 0) total = 1.
do if (total = 1).
+ compute medianAgeBreastfed = meanBreastfed.
+ compute totalMean = 1 .
+ compute total=$sysmis .
end if.
compute layer = 0.

variable labels layer " ".
value labels layer 0 "Median duration (in months) of".
variable labels medianAgeBreastfed "Median duration (in months) of any breastfeeding [1]".

variable labels HL4 "Sex".
variable labels HH6 "Area".
variable labels HH7 "Region".
variable labels windex5 "Wealth index quintile".
variable labels ethnicity "Ethnicity of household head".
variable labels melevel "Mother's education".
variable labels childrenNo 'Number of children age 0-35 months'.
variable labels caretakerdis "Mother's functional difficulties [A]".
variable labels total "".

value labels HL4 1 'Male' 2 'Female'.
value labels HH7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'
 5 'Region 5'.

value labels HH6
1 "Urban"
2 "Rural".

value labels caretakerdis
1 "Has functional difficulty"
2 "Has no functional difficulty".

value labels ethnicity
1 "Group 1"
2 "Group 2"
3 "Group 3"
6 "Other".

value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels melevel 0 'Pre-primary or none' 1 'Primary' 2 'Lower secondary' 3 'Upper secondary+'.

value labels total 0 "Median" .
value labels totalMean 1 "Mean" .

* Ctables command in English.
ctables
  /vlabels variables = total layer totalMean
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + melevel [c]         
        + caretakerdis[c]
        + ethnicity [c]
        + windex5 [c]
         + totalMean [c]
   by
             medianAgeBreastfed [s] [mean,f5.1]
         + childrenNo[s] [mean,f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table TC.7.4: Duration of breastfeeding"
     "Median duration of any breastfeeding, exclusive breastfeeding, and predominant breastfeeding among children age 0-35 months, " + surveyname
   caption=
     "[1] MICS indicator TC.36 - Duration of breastfeeding"
     "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
  .

new file.

erase file = 'aggr.sav'.
erase file = 'tmp.sav'.
erase file = 'tmpresult.sav'.


***************************  Median duration of exclusive and predominent breastfeeding (children age 0-23 months).

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
select if (UF17 = 1).

* ... and children aged 0-23 months.
select if (cage >= 0 and cage <= 23).

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
include 'define/MICS6 - 07 - TC.sps' .

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
 12 '22 - 23'.

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

do if (age2 <> 1 and age2 <> 12).
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
variable labels adjChildrenNo 'Number of children smoothed'.
variable labels adjBreastfed 'Number of children breastfed smoothed'.
variable labels adjExclusivelyBreastfed 'Number of children exclusively breastfed smoothed'.
variable labels adjPredominantlyBreastfed 'Number of children predominantly breastfed smoothed'.

* calculate percentages.

* exclusivelyBreastfed and predominantlyBreastfed are already multiplied by 100, in define\MICS6 - 06 - TC.sps .
compute percBreastfed = adjBreastfed/adjChildrenNo.
compute percExclusivelyBreastfed = adjExclusivelyBreastfed/adjChildrenNo.
compute percPredominantlyBreastfed = adjPredominantlyBreastfed/adjChildrenNo.
variable labels percBreastfed 'Proportion still breastfeeding'.
variable labels percExclusivelyBreastfed 'Proportion exclusively breastfeeding'.
variable labels percPredominantlyBreastfed 'Proportion predominantly breastfeeding'.

* Do the interpolation between points when percentage drop below 50% to calculate the median.
interpolate ind = percBreastfed     med = medianAgeBreastfed.
interpolate ind = percExclusivelyBreastfed med = medianAgeExclusivelyBreastfed.
interpolate ind = percPredominantlyBreastfed  med = medianAgePredominantlyBreastfed.

variable labels medianAgeBreastfed "Median duration (in months) of any breastfeeding [1]".
variable labels medianAgeExclusivelyBreastfed "Median duration (in months) of  exclusive breastfeeding".
variable labels medianAgePredominantlyBreastfed "Median duration (in months) of predominant breastfeeding".

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
NU4median backvar = HH7 backval = 5.
* Area.
NU4median backvar = HH6 backval = 1.
NU4median backvar = HH6 backval = 2.
* Mother's education level.
NU4median backvar = melevel backval = 0.
NU4median backvar = melevel backval = 1.
NU4median backvar = melevel backval = 2.
NU4median backvar = melevel backval = 3.
* Wealth index.
NU4median backvar = windex5 backval = 1.
NU4median backvar = windex5 backval = 2.
NU4median backvar = windex5 backval = 3.
NU4median backvar = windex5 backval = 4.
NU4median backvar = windex5 backval = 5.
* Ethnicity.
NU4median backvar = ethnicity backval = 1.
NU4median backvar = ethnicity backval = 2.
NU4median backvar = ethnicity backval = 3.
NU4median backvar = ethnicity backval = 6.
*Disability.
NU4median backvar = caretakerdis backval = 1.
NU4median backvar = caretakerdis backval = 2.

*   --------------------------------------------------------------------------------------------------------- .

* The first record is duplicated for the total so just to copy the mean variables into the median variables.
if (total = 0 and lag(total) = 0) total = 1.
do if (total = 1).
+ compute medianAgeExclusivelyBreastfed = meanExclusivelyBreastfed.
+ compute medianAgePredominantlyBreastfed = meanPredominantlyBreastfed.
+ compute totalMean = 1 .
+ compute total=$sysmis .
end if.
compute layer = 0.

variable labels layer " ".
value labels layer 0 "Median duration (in months) of".
variable labels medianAgeExclusivelyBreastfed "Exclusive breastfeeding".
variable labels medianAgePredominantlyBreastfed "Predominant breastfeeding".

variable labels HL4 "Sex".
variable labels HH6 "Area".
variable labels HH7 "Region".
variable labels windex5 "Wealth index quintile".
variable labels ethnicity "Ethnicity of household head".
variable labels melevel "Mother's education".
variable labels childrenNo 'Number of children age 0-23 months'.
variable labels caretakerdis "Mother's functional difficulties [A]".
variable labels total "".

value labels HL4 1 'Male' 2 'Female'.
value labels HH7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'
 5 'Region 5'.

value labels HH6
1 "Urban"
2 "Rural".

value labels caretakerdis
1 "Has functional difficulty"
2 "Has no functional difficulty".

value labels ethnicity
1 "Group 1"
2 "Group 2"
3 "Group 3"
6 "Other".

value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels melevel 0 'Pre-primary or none' 1 'Primary' 2 'Lower secondary' 3 'Upper secondary+'.

value labels total 0 "Median" .
value labels totalMean 1 "Mean" .


* Ctables command in English.
ctables
  /vlabels variable = total layer totalMean display = none		 
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + melevel [c]         
         + caretakerdis [c]    
         + ethnicity [c]
         + windex5 [c]
         + totalMean [c]
   by
           layer [c] > (medianAgeExclusivelyBreastfed [s] [mean f5.1]							  
           + medianAgePredominantlyBreastfed [s] [mean f5.1] )
         + childrenNo [s] [mean f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table TC.7.4: Duration of breastfeeding"
     "Median duration of any breastfeeding among children age 0-35 months and median duration of exclusive breastfeeding and predominant breastfeeding among children age 0-23 months, " + surveyname
   caption=
     "[1] MICS indicator TC.36 - Duration of breastfeeding"
     "[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
  .

new file.

erase file = 'aggr.sav'.
erase file = 'tmp.sav'.
erase file = 'tmpresult.sav'.
