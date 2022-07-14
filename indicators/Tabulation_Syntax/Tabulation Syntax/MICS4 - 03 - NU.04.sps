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
recode BF2 (1 = 1) (else = 0) into breastfed.
variable labels breastfed 'Child still being breastfed'.

* Note: Customize the definitions of exclusive and predominant breastfeeding.
* Exclusive breastfeeding.
compute exbf = 0.
 if (BF2 = 1 & (BF3 <> 1 & BF4 <> 1 & BF6 <> 1 & BF8 <> 1 & BF9 <> 1 & 
  BF12<> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) exbf = 1.
variable labels exbf "Exclusive breastfeeding".

* Predominant breastfeeding.
compute prbf = 0.
if (BF2 = 1 & (BF4 <> 1 & BF6 <> 1 & BF13 <> 1 & BF15 <> 1 & BF16 <> 1)) prbf = 1.
variable labels prbf "Predominant breastfeeding".

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

* Calculate midpoint of eacg age group.  Midpoint of first group (0-1.5 months = 0.75, 1.5-3.5 = 2.5, 3.5-5.5 = 4.5, etc.).
compute midpoint = 0.75.
if (age2 <> 1) midpoint = age2*2 - 1.5.
variable labels midpoint "Midpoint".

* Sum breastfeeding data by 2 month age groups.
aggregate
  /outfile='aggr.sav'
  /break=age2
  /midpoint = mean (midpoint)
  /children 'Number of children' = N
  /breastfed 'Children being breastfed' = sum(breastfed)
  /exbf 'Children being exclusive breastfed' = sum(exbf)
  /prbf 'Children being predominant breastfed' = sum(prbf).

* Open aggregated data file.
get file='aggr.sav'.

* get preceding (lag) and following (lead) values to use for smoothing with 3 group moving average.

sort cases by age2 (A).

compute lagc = lag(children,1).
compute lagbf = lag(breastfed,1).
compute lagexbf = lag(exbf,1).
compute lagprbf = lag(prbf,1).

sort cases by age2 (D).

compute leadc = lag(children,1).
compute leadbf = lag(breastfed,1).
compute leadexbf = lag(exbf,1).
compute leadprbf = lag(prbf,1).

sort cases by age2 (A).

* smooth by a three group moving average.

do if (age2 <> 1 and age2 <> 18).
+ compute chadj = (lagc + children + leadc)/3.
+ compute bfadj = (lagbf + breastfed + leadbf)/3.
+ compute exbfadj = (lagexbf + exbf + leadexbf)/3.
+ compute prbfadj = (lagprbf + prbf + leadprbf)/3.
else.
+ compute chadj = children.
+ compute bfadj = breastfed.
+ compute exbfadj = exbf.
+ compute prbfadj = prbf.
end if.
variable label chadj 'Number of children smoothed'.
variable label bfadj 'Number of children breastfed smoothed'.
variable label exbfadj 'Number of children exclusively breastfed smoothed'.
variable label prbfadj 'Number of children predominantly breastfed smoothed'.

* calculate percentages.
compute percbf = bfadj/chadj*100.
compute percexbf = exbfadj/chadj*100.
compute percprbf = prbfadj/chadj*100.
variable label percbf 'Proportion still breastfeeding'.
variable label percexbf 'Proportion exclusively breastfeeding'.
variable label percprbf 'Proportion predominantly breastfeeding'.

* Do the interpolation between points when percentage drop below 50% to calculate the median.
interpolate ind = percbf     med = medage_bf.
interpolate ind = percexbf med = medage_exbf.
interpolate ind = percprbf  med = medage_prbf.

variable label medage_bf "Median duration (in months) of any breastfeeding [1]".
variable label medage_exbf "Median duration (in months) of  exclusive breastfeeding".
variable label medage_prbf "Median duration (in months) of predominant breastfeeding".

*need to recode  lag(midpoint) = 0 for the first group.
*compute meanbf = percbf * (midpoint - lag(midpoint))/100.
*compute meanexbf = percexbf * (midpoint - lag(midpoint))/100.
*compute meanprbf = percprbf * (midpoint - lag(midpoint))/100.

* Mutiply proportion breastfeeding by width of agegroup (2 for all groups, expect the first which is 1.5) - summed later to give an overall mean.
do if (age2 <> 1).
+ compute meanbf = percbf * 2 / 100.
+ compute meanexbf = percexbf * 2 / 100.
+ compute meanprbf = percprbf * 2 / 100.
else.
+ compute meanbf = percbf * 1.5 / 100.
+ compute meanexbf = percexbf * 1.5 / 100.
+ compute meanprbf = percprbf * 1.5 / 100.
end if.

* Create working variable for the background characteristic being tabulated to include in the aggregate command.
compute !backvar = !backval.

* Save the working version - just for checking.
save outfile = 'aggr.sav'.

* Aggregate the data, mean used as its the only value for the median calculations, but sum used to sum all values for the means.
aggregate outfile = 'tmpresult.sav'
  /break=!backvar
  /medage_bf = mean(medage_bf)
  /medage_exbf = mean(medage_exbf)
  /medage_prbf = mean(medage_prbf)
  /mean_bf = sum (meanbf)
  /mean_exbf = sum (meanexbf)
  /mean_prbf = sum (meanprbf)
  /nch = sum (children).

* If this is the first characteristic for the table, then we are creating a new working file, 
  otherwise we will append to that file.
!if (!first = 1) !then
get file 'tmpresult.sav'.
save outfile='tmp.sav'.
!else 
get file 'tmp.sav'.
add files
  /file = *
  /file = 'tmpresult.sav'.
save outfile='tmp.sav'.
!ifend

!enddefine.

* --------------------------------------------------------------------------------------------------------- .

* Main routine that runs the median calculations for each of the background variables.
* Set the following:
* backvar to the name of the background variable.
* backval to the value for the category of interest of the background variable.
* first to 1 if this is the first background category in the table, 0 otherwise.

* Sex.
NU4median backvar = HL4 backval = 1 first = 1.
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
* Wealth index.
NU4median backvar = windex5 backval = 1.
NU4median backvar = windex5 backval = 2.
NU4median backvar = windex5 backval = 3.
NU4median backvar = windex5 backval = 4.
NU4median backvar = windex5 backval = 5.
* Ethnicity.
NU4median backvar = ethnicity backval = 1.
NU4median backvar = ethnicity backval = 2.
* Total.
NU4median backvar = total backval = 0.

*   --------------------------------------------------------------------------------------------------------- .

get file 'tmp.sav'.
* Duplicate the last record for the total and copy the mean variables into the median variables.
add files
  /file = *
  /file = 'tmpresult.sav'.
if (total = 0 and lag(total) = 0) total = 1.
do if (total = 1).
+ compute medage_bf = mean_bf.
+ compute medage_exbf = mean_exbf.
+ compute medage_prbf = mean_prbf.
end if.
compute layer = 0.

variable labels layer " ".
value labels layer 0 "Median duration (in months) of".
variable labels medage_bf "Any breastfeeding [1]".
variable labels medage_exbf "Exclusive breastfeeding".
variable labels medage_prbf "Predominant breastfeeding".

variable labels HL4 "Sex".
variable labels HH7 "Region".
variable labels HH6 "Area".
variable labels melevel "Mother's education".
variable labels windex5 "Wealth index quintile".
variable labels ethnicity "Ethnicity of household head".
variable labels nch 'Number of children age 0-35 months'.
variable labels total "".

value labels HL4 1 'Male' 2 'Female'.
value labels HH7
 1 'Region 1'
 2 'Region 2'
 3 'Region 3'
 4 'Region 4'.
value labels HH6 1 'Urban' 2 'Rural'.
value labels melevel 1 'None' 2 'Primary' 3 'Secondary+'.
value labels windex5 1 'Poorest' 2 'Second' 3 "Middle" 4 "Fourth" 5 "Richest".
value labels ethnicity 1 'Group 1' 2 'Group 2'.
value labels total 0 "Median" 1 "Mean for all children (0-35 months)".

* For labels in French uncomment commands bellow.

* value labels layer 0 "Durée moyenne (en mois) de".
* variable labels medage_bf "Allaitement [1]".
* variable labels medage_exbf "Allaitement exclusif".
* variable labels medage_prbf "Allaitement principal".

* variable labels HL4 "Sexe".
* variable labels HH7 "Région".
* variable labels HH6 "Milieu de résidence".
* variable labels melevel "Instruction de la mère".
* variable labels windex5 "Quintile du bien-être économique".
* variable labels ethnicity "Religion/Langue/Ethnie du chef de ménage".
* variable labels nch 'Number of children age 0-35 months'.
* variable labels total "".

*  value labels HL4 1 'Masculin' 2 'Féminin'.
*  value labels HH7
 1 'Région 1'
 2 'Région 2'
 3 'Région 3'
 4 'Région 4'.
* value labels HH6 1 'Urbain' 2 'Rural'.
* value labels melevel 1 'Aucune' 2 'Primaire' 3 'Supérieure+'.
* value labels windex5 1 'Le plus pauvre' 2 'Second' 3 "Moyen" 4 "Quatrième" 5 "Le plus riche".
* value labels ethnicity 1 'Groupe 1' 2 'Groupe 2'.
* value labels total 0 "Médiane" 1 "Moyenne pour tous les enfants (0-35 mois)".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = total layer display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c]
      by layer [c] > (medage_bf [s] [mean,f5.1] + medage_exbf [s] [mean,f5.1] + medage_prbf [s] [mean,f5.1]) + nch[s] [mean,f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Table NU.4: Duration of breastfeeding"
	"Median duration of any breastfeeding, exclusive breastfeeding, and predominant breastfeeding among children age 0-35 months, " + surveyname
  caption=
     "[1] MICS indicator 2.10".

* Ctables command in French.
*
ctables
  /vlabels variable = total layer display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c]
      by layer [c] > (medage_bf [s] [mean,f5.1] + medage_exbf [s] [mean,f5.1] + medage_prbf [s] [mean,f5.1]) + nch[s] [mean,f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
	"Tableau NU.4: Durée de l'allaitement au sein"
	"Durée médiane de l'allaitement au sein, exclusif et principal chez les enfants âgés de 0-35 mois, " + surveyname
  caption=
     "[1] Indicateur MICS 2.10".

new file.