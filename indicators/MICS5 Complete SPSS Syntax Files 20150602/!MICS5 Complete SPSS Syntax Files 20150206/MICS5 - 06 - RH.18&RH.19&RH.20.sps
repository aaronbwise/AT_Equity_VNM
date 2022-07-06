* v02 2015-04-15.
* Table RH.19: The results-row has changed to just “Survey name”.
* Note a has been changed to “The probability of dying between exact ages 15 and 50 per 1,000.”

* DQ tables produced weighted. "(unweighted)" removed from sub-titles.


* Define the period to use, the upper limit (months preceding the interview), and the lower limit.
define periodlen ().
* To use 7 years durations.
compute period = 7.
compute kmax = 1.
compute kmin = 12*period.
compute totexp = kmin-kmax+1.
!enddefine.

* Get the name of the survey.
include "surveyname.sps".

* Open the women's data file.
get file = 'wm.sav'.
dataset name wm.

* Select complete interviews.
select if (WM7 = 1).

* weight the data with the women's file weight.
weight by wmweight.

* Compute a variable used for totals in the tables.
compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Produce an age distribution of the women for later use for age adjusted estimates.
dataset declare agedis.
aggregate
  /outfile='agedis'
  /break=WAGE
  /Nwomen=N.

* Sum the women and add the sum to all cases.
dataset activate agedis.
aggregate
  /outfile=* mode=addvariables
  /break=
  /Tot_women=sum(Nwomen).

* Calculate the proportion of the women in each age group.
compute propagegrp = Nwomen/Tot_women.
execute.

* Now go back to the women's data file to produce mean number of siblings (including respondent) and sex ratio of siblings (excluding respondent).
dataset activate wm.
* First calculate any entry for the total.
compute xage=9.
dataset declare sibs1.
aggregate
  /outfile='sibs1'
  /break=xage
  /MM1=mean(MM1).
* Now do the same by age group.
dataset declare sibs.
compute xage = wage.
aggregate
  /outfile='sibs'
  /break=xage
  /MM1=mean(MM1).
* Activate this file of siblings and combine into one file.
dataset activate sibs.
add files
  /file=*
  /file='sibs1'.


* now back to the women's data file again.
dataset activate wm.

* Set up the period length and related variables.
periodlen.

* Calculate exposure for fertility rate - split into 3 groups to allow for up to 10 year rates (each woman may have been exposed in up to 3 age groups).
* calculate age group and exposure in the age group.  age groups coded 3-9 here and adjusted later.
compute higcm = wdoi - kmax.
compute higage = trunc( (higcm - wdob) / 60 ).
compute higexp = higcm - wdob - higage*60 + 1.
if (higexp > 60) higexp = 60.
if (higexp > totexp) higexp = totexp.
compute midage = higage-1.
compute midexp = totexp - higexp.
if (midexp > 60) midexp = 60.
if (midexp > totexp) midexp = totexp.
compute lowage = midage-1.
compute lowexp = totexp - higexp - midexp.

* Tally exposure by age group for each of the 3 sets of exposure.
use all.
compute zage = higage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp1.
aggregate
  /outfile='exp1'
  /break=zage
  /higexp=sum(higexp).

use all.
compute zage = midage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp2.
aggregate
  /outfile='exp2'
  /break=zage
  /midexp=sum(midexp).

use all.
compute zage = lowage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp3.
aggregate
  /outfile='exp3'
  /break=zage
  /lowexp=sum(lowexp).


* Calculate births for fertility rate.

* Open the births data file and close the women's data file (we are done with that).
get file='bh.sav'.
dataset name bh.
dataset close wm.

* Set up the period length and related variables.
periodlen.

* Calculate age group of each birth and select only those in the period of interest and in the age groups of interest.
use all.
compute zage = trunc( (BH4C - wdob) / 60 ) - 2.
compute filter_$ = (BH4C >= wdoi-kmin and BH4C <= wdoi-kmax and zage>=1 and zage<=7).
execute.
filter by filter_$.

* Weight the data with the women's weight.
weight by wmweight.

* Tally the births by age group.
dataset declare births.
aggregate
  /outfile='births'
  /break=zage
  /births=N.

* Open the births and attach the exposure variables.
dataset activate births.
match files
  /file=*
  /table='exp1'
  /table='exp2'
  /table='exp3'
  /table='agedis'
  /rename (wage=zage)
  /by zage.

* recode the empty cells for exposure to 0.
if (sysmis(lowexp)) lowexp = 0.
if (sysmis(midexp)) midexp = 0.
* Calculate total exposure and the age specific fertilty rates.
compute totexp = (higexp+midexp+lowexp)/12.
compute asfr = births/totexp.
compute asfr_adj = asfr * propagegrp.

* Close all the datasets that are no longer needed, including the bh file.
dataset close exp1.
dataset close exp2.
dataset close exp3.
dataset close bh.

* end of fertility and sibship analysis prior to MMR.

* ---------------------------------------------------------------------------------------------------- .

* Now open the maternal mortality module.
get file = 'mm.sav'.
dataset name mm.

* Set up the period length and related variables.
periodlen.


** Table DQ.27.
* Select only those with sex given.
select if (MM5 = 1 or MM5 = 2).

* Compute each of the rows to be tabulated, label them and then tabulate the data.
compute c8_0 = 0.
recode MM6 (1,2=copy)(else=3) into c8_1.
do if (MM6 = 1).
+ compute c8_2 = 0.
+ compute c8_3 = (MM7 >= 98).
else if (MM6 = 2).
+ compute c8_4 = 0.
+ compute c8_5 = (MM9 >= 98) + 2*(MM8 >= 98).
end if.
value labels
  c8_0 0 "Survival status of siblings: Total"
 /c8_1 1 "Survival status of siblings: Living" 2 "Survival status of siblings: Dead" 3 "Survival status of siblings: DK/Missing"
 /c8_2 0 "Age of living siblings: Total"
 /c8_3 0 "Age of living siblings: Reported" 1 "Age of living siblings: DK/Missing"
 /c8_4 0 "Age at death and years since death for siblings who have died: Total"
 /c8_5 0 "Both reported" 1 "Only years since death reported" 2 "Only age at death reported" 3 "DK/Missing both".

value labels MM5 2 "Sisters" 1 "Brothers".

ctables
  /vlabels variables=c8_0 c8_1 c8_2 c8_3 c8_4 c8_5 MM5
    display=none
  /table (c8_1 + c8_0 + c8_3 + c8_2 + c8_5 + c8_4) [c][count 'Number' comma5.0, colpct 'Percent' F5.1] by MM5
    [c]
  /categories variables=MM5 [2, 1] empty=exclude total=yes label = "All siblings" position=after
  /titles
    title='DQ.27: Completeness of information on siblings' ''
    'Completeness of information on the survival status of (all) siblings and age of living siblings reported by interviewed women, ' +
    'and age at death and years since death of siblings who have died,  ' +surveyname.



** Table DQ.28.
use all.

* Calculate all maternal deaths that are in the period of interest and were to women aged 15-49 at the time of death.
compute ad = trunc((MM8C-MM7C)/12).
compute filter_$ = (MM5 = 2 & MM6 = 2 & ad >= 15 & ad <= 49 & MM8C >= wdoi - kmin & MM8C <= wdoi - kmax).
filter by filter_$.
* See if the death was maternal.
compute deathnc = 0.
if (MM10=9 or MM11=9 or MM12=9) deathnc = 100.
compute tot=0.

* tabulate the data.
ctables
  /vlabels variables=deathnc
    display=none
  /table deathnc [s][mean 'Deaths that could not be classified as maternal or non-maternal' f5.1, count 'Total number of sisters who died at  ages 15-49' comma5.0]
  /slabels position=row
  /titles
    title='DQ.27w Working table.  Completeness of information for dead sisters' ''
    'Percentage of sisters who died at ages 15-49 with information missing on whether or not the death was maternal, ' + surveyname
    caption='Note: Restricted to sisters who died during the seven years preceding the survey.'.


* Now produce the counts of siblings by sex for the sex ratios data quality table.
use all.
* Weight the data.
weight by wmweight.
* count number of women 15-49.
compute nwmn = 0.
if (mmln = 1) nwmn = 1.
* Produce the counts for all ages combined (xage = 9) by sex.
compute xage = 9.
compute male=(MM5=1).
compute female=(MM5=2).
dataset declare sibsex1.
aggregate
  /outfile='sibsex1'
  /break=xage
  /male=sum(male)
  /female=sum(female)
  /nwomen = sum(nwmn).

* Produce the counts for each age group by sex.
compute xage = trunc((wdoi-wdob)/60)-2.
compute male=(MM5=1).
compute female=(MM5=2).
dataset declare sibsex.
aggregate
  /outfile='sibsex'
  /break=xage
  /male=sum(male)
  /female=sum(female)
  /nwomen = sum(nwmn).

* Switch to the aggregated data and add the all ages results to those by age group.
dataset activate sibsex.
add files
  /file=*
  /file='sibsex1'.

* Calculate the sex ratio for each age group and the total.
compute sexratio = male/female.

* Add in the sibshio size data (by age group) in preparation for tabulating.
match files
  file=*
 /table='sibs'
 /by xage.

recode xage (9 = 0) (else = copy) into xage1.
* Label the age groups.
variable labels xage1 "Age".
value labels xage1 1 '15-19' 2 '20-24' 3 '25-29' 4 '30-34' 5 '35-39' 6 '40-44' 7 '45-49' 0 'Total'.

* tabulate the mean sibship size and the sex ratios by age group and for all age groups.
ctables
  /vlabels variables= mm1 sexratio nwomen
    display=none
  /table xage1 by MM1 [s][mean 'Mean sibship size[a]' f5.1] + sexratio [s][mean 'Sex ratio of siblings at birth [b]' f5.2] + nwomen[s][mean'Number of women age 15-49 years',f5.0]
  /slabels position=column
  /titles
    title='DQ.28: Sibship size and sex ratio of siblings' ''
    'Mean sibship size and sex ratio of siblings at birth, ' + surveyname
    caption='[a] Includes the respondent'
                '[b] Excludes the respondent'.

	


dataset activate mm.
dataset close sibs.
dataset close sibs1.
dataset close sibsex.
dataset close sibsex1.

* end of data quality tables prior to MMR.

* ---------------------------------------------------------------------------------------------------- .

* Activate the maternal mortality data again and close down the data files we don't need any more.
dataset activate mm.

* weight the data.
weight by wmweight.
use all.

* Set up the period length and related variables.
periodlen.

* Calculate exposure for maternal mortality rate.
* Calculate the upper limits.
compute higcm = wdoi - kmax.
compute lowcm = wdoi - kmin.
* If died before upper limit set higcm to month before dying (avoids overcounting 1 month).
if (MM6 = 2 & MM8C-1 < higcm) higcm = MM8C-1.
* Check for lowcm before date of birth.
if (lowcm < MM7C) lowcm = MM7C.
* calculate total exposure and upper age group.
compute totexp = higcm - lowcm + 1.
if (totexp < 0) totexp = 0.
compute higage = trunc( (higcm - MM7C) / 60 ).
* Initialize flags for adult male, adult female, and maternal deaths.
compute adm = 0.
compute adf = 0.
compute md = 0.
* For dead siblings, if died between 15 and 49 then set the flags for adult male, adult female and maternal deaths.
do if (MM6 = 2 & higage >= 3 & higage <= 9 & MM8C >= wdoi-kmin & MM8C <= wdoi-kmax).
+ if (MM5 = 1) adm = 1.
+ if (MM5 = 2) adf = 1.
+ if (MM5 = 2 & (MM10 = 1 or MM11 = 1 or MM12 = 1)) md = 1.
end if.

* Tally deaths by age group for adult male, adult female, and maternal deaths, by age group (from 15-49).
use all.
compute zage = higage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare deaths.
aggregate
  /outfile='deaths'
  /break=zage
  /adm=sum(adm)
  /adf=sum(adf)
  /md=sum(md).


* Calculate exposure for mortality rates - split into 3 groups to allow for up to 10 year rates (each sibling may have been exposed in up to 3 age groups).
* calculate age group and exposure in the age group.  age groups coded 3-9 here and adjusted later.
use all.
compute higexp = higcm - MM7C - higage*60 + 1.
if (higexp < 0) higexp = 0.
if (higexp > 60) higexp = 60.
if (higexp > totexp) higexp = totexp.
compute midage = higage-1.
compute midexp = totexp - higexp.
if (midexp > 60) midexp = 60.
if (midexp > totexp) midexp = totexp.
compute lowage = midage-1.
compute lowexp = totexp - higexp - midexp.

* If the sibling is male, set separate variables male exposure and reset the female variables.
do if (MM5=1).
+ compute mhigexp = higexp.
+ compute mmidexp = midexp.
+ compute mlowexp = lowexp.
+ compute higexp = 0.
+ compute midexp = 0.
+ compute lowexp = 0.
else.
+ compute mhigexp = 0.
+ compute mmidexp = 0.
+ compute mlowexp = 0.
end if.


* Report out for checking exposure.
formats totexp higcm lowcm higage midage lowage zage higexp midexp lowexp mhigexp mmidexp mlowexp (f4.0).

*summarize
  /tables=MM5 MM6 MM7 MM8 MM9 WDOI MM7C MM8C totexp higcm lowcm higage midage lowage zage higexp midexp lowexp mhigexp mmidexp mlowexp
  /format=validlist nocasenum nototal limit=100
  /title='Exposure checking'
  /missing=variable
  /cells=count.



* Tally exposure by age group for each of the 3 sets of exposure.
use all.
compute zage = higage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp1.
aggregate
  /outfile='exp1'
  /break=zage
  /higexp=sum(higexp)
  /mhigexp=sum(mhigexp).

use all.
compute zage = midage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp2.
aggregate
  /outfile='exp2'
  /break=zage
  /midexp=sum(midexp)
  /mmidexp=sum(mmidexp).

use all.
compute zage = lowage-2.
compute filter_$ = (zage>=1 and zage<=7).
filter by filter_$.
dataset declare exp3.
aggregate
  /outfile='exp3'
  /break=zage
  /lowexp=sum(lowexp)
  /mlowexp=sum(mlowexp).

* Activiate the deaths file and merge in the 3 sets of exposure variables, plus the age distribution, all by age group.
dataset activate deaths.
match files
  /file=*
  /table='exp1'
  /table='exp2'
  /table='exp3'
  /table='agedis'
  /rename (wage=zage)
  /by zage.

* Compute total exposure for females and for males.
compute totexp = (higexp+midexp+lowexp)/12.
compute mtotexp = (mhigexp+mmidexp+mlowexp)/12.
* Calculate mortality rates by age group.
compute admmr = 1000*adm/mtotexp.
compute adfmr = 1000*adf/totexp.
compute mrate = 1000*md/totexp.
* calculate age adjustments for the mortality rates.
compute admmr_adj = admmr * propagegrp.
compute adfmr_adj = adfmr * propagegrp.
compute mrate_adj = mrate * propagegrp.

* Combine the mortality and fertility datasets.
match files
  /file=*
  /file='births'.
execute.

* Aggregate the deaths, exposure and age adjusted rates as well as TFR and GFR to produce the totals entry.
dataset declare rates.
aggregate
  /outfile='rates'
  /break=
  /adm=sum(adm)
  /adf=sum(adf)
  /md=sum(md)
  /totexp=sum(totexp)
  /mtotexp=sum(mtotexp)
  /admmr_adj=sum(admmr_adj)
  /adfmr_adj=sum(adfmr_adj)
  /mrate_adj=sum(mrate_adj)
  /tfr=sum(asfr)
  /gfr=sum(asfr_adj).

* Add the totals entry to the deaths and exposure by age group.
add files
  /file=*
  /file='rates'.


dataset close agedis.
dataset close rates.
dataset close exp1.
dataset close exp2.
dataset close exp3.
dataset close mm.

* Add a variable for the total and label it and the age groups.
if (sysmis(zage)) total = 0.
variable labels total "".
value labels total 0 "Total 15-49".
value labels zage 1 '15-19' 2 '20-24' 3 '25-29' 4 '30-34' 5 '35-39' 6 '40-44' 7 '45-49' 9 'Total'.

* Compute the TFR.
if (total = 0) tfr = tfr*5.
* Calcalute the proportion maternal of the adult female deaths.
compute pmdf = 100 * md / adf.
* Set the mortality rates in the total line to the age adjusted mortality rates (for adult male, adult female and maternal deaths).
if (total=0) admmr = admmr_adj.
if (total=0) adfmr = adfmr_adj.
if (total=0) mrate = mrate_adj.

compute female = 2.
compute male = 1.
value labels female 2 "Female" / male 1 "Male".
variable labels
  zage 'Age'
 /adf 'Number of Deaths'
 /adm 'Number of Deaths'
 /md 'Number of Deaths'
 /totexp 'Exposure years'
 /mtotexp 'Exposure years'
 /adfmr 'Mortality rates [a]'
 /admmr 'Mortality rates [a]'
 /mrate 'Maternal mortality rates [a]'
 /pmdf 'Percentage of female deaths that are maternal'.

* tavbulate the adult male and female mortality rates.
ctables
  /vlabels variables= total female male
    display=none
  /table total + zage by
    female > ((adf + totexp) [s][mean '' comma5.0] + adfmr [s][mean '' f5.2]) +
    male > ((adm + mtotexp) [s][mean '' comma5.0] + admmr [s][mean '' f5.2])
  /slabels position=column
  /categories variables=zage empty=exclude
  /titles
    title='Table RH.18: Adult mortality rates		' ''
    'Direct estimates of female and male mortality rates for the seven years preceding the survey, by five-year age groups, ' + surveyname
    caption='[a] Expressed per 1,000 population'
                '[b] Age-adjusted rate'.




* Calculate 35q15 for men and women.
compute mqx = 1 - ( 5 * (admmr/1000) / (1+2.4*(admmr/1000)) ).
compute fqx = 1 - ( 5 * (adfmr/1000) / (1+2.4*(adfmr/1000)) ).
do if (zage = 1).
+ compute probm = mqx.
+ compute probf = fqx.
else if (not sysmis(zage)).
+ compute probm = lag(probm) * mqx.
+ compute probf = lag(probf) * fqx.
end if.
do if (total = 0).
+ compute m35q15 = 1000 * (1 - lag(probm)).
+ compute f35q15 = 1000 * (1 - lag(probf)).
end if.
variable labels f35q15 'Women 35q15 [a]' / m35q15 ' Men 35q15 [a]'.


* tabulate the adult mortality probabilities.
ctables
  /table by (f35q15 + m35q15) [s][mean 'Survey name, Year' comma5.0]
  /slabels position=row
  /titles
    title='Table RH.19: Adult mortality probabilities' ''
    'The probability of dying between the ages of 15 and 50 for women and men for the seven years preceding the survey, ' + surveyname
    corner='Survey name'
    caption='[a] The probability of dying between exact ages 15 and 50 per 1,000'.

	

* tabulate the maternal mortality rates.
ctables
  /vlabels variables= total
    display=none
  /table total+zage by
    pmdf [s][mean '' f5.1] + (md + totexp) [s][mean '' comma5.0] + mrate [s][mean '' f5.2]
  /slabels position=column
  /categories variables=zage empty=exclude
  /titles
    title='Table RH.20: Maternal mortality' ''
    'Direct estimates of maternal mortality rates for the 7 years preceding the survey, by five-year age groups, ' + surveyname
    caption='CI: Confidence interval'
      '[1] MICS indicator 5.13; MDG indicator 5.1 - Maternal mortality ratio'
      '[a] Expressed per 1,000 woman-years of exposure'
      '[b] Age-adusted rate'	
      '[c] Expressed per 1,000 women age 15-49'
      '[d] Calculated as the maternal mortality rate divided by the general fertility rate, expressed per 100,000 live births	'		
      '[e] Calculated as 1-(1-MMR)TFR where MMR is the maternal mortality ratio, and TFR represents the total fertility rate for the seven years preceding the survey'.				


compute filter_$ = (total=0).
filter by filter_$.
do if (total = 0).
+ compute mmr = 100 * mrate_adj / gfr.
+ compute gfr = gfr * 1000.
+ compute ltr = 1 - (1 - (mmr/100000))**tfr.
end if.

* tabulate the maternal mortality rates.
ctables
  /vlabels variables=gfr mmr ltr display=none
  /table
    gfr [s][mean 'General fertility rate (GFR) [c]' comma5.0] + mmr [s][mean 'Maternal mortality ratio [1,d]' comma5.0] + ltr [s][mean 'Lifetime risk of maternal death [e]' f5.3]
  /slabels position=row
  /titles
 /titles
    title='Table RH.20: Maternal mortality' ''
    'Direct estimates of maternal mortality rates for the 7 years preceding the survey, by five-year age groups, ' + surveyname
    corner='Age'
    caption=
      '[1] MICS indicator 5.13; MDG indicator 5.1 - Maternal mortality ratio'
      '[a] Expressed per 1,000 woman-years of exposure'
      '[b] Age-adusted rate'	
      '[c] Expressed per 1,000 women age 15-49'
      '[d] Calculated as the maternal mortality rate divided by the general fertility rate, expressed per 100,000 live births	'		
      '[e] Calculated as 1-(1-MMR)TFR where MMR is the maternal mortality ratio, and TFR represents the total fertility rate for the seven years preceding the survey'.		


* Clean up all of the data files.
dataset close deaths.
dataset close births.
new file.

