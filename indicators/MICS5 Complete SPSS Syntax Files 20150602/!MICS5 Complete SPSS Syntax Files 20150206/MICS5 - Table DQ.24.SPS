*v02 - 2014-05-08.
* syntax simplified.
*v03 - 2014-05-19.
* Latest changes to tab plan introduced.

* This data quality table is only produced for surveys that have included a birth history.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'bh.sav'.

weight by wmweight.

compute byeardiff = trunc ((WDOI - BH4C)/12).
recode byeardiff (0 thru 4 = 1)(5 thru 9 = 2)(10 thru 14 = 3)(15 thru 19 = 4)(20 thru hi = 5)  into byeargr.
recode byeardiff (10 thru hi = 10).

variable labels 
  byeardiff "Years"
  /byeargr "Five year periods".
value labels byeardiff   10 "10+"
  /byeargr 1 "0-4" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20+".
formats byeardiff (f2.0).

compute totl = (BH5 = 1).
compute totd = (BH5 <> 1).

compute compl = 0.
compute compd = 0.
do if (BH4Y < 9997 & BH4M < 97).
+ if (BH5 = 1) compl = 1.
+ if (BH5 <> 1) compd = 1.
end if.

compute sexml = (BH5 = 1 and BH3 = 1).
compute sexmd = (BH5 <> 1 and BH3 = 1).
compute sexfl = (BH5 = 1 and BH3 = 2).
compute sexfd = (BH5 <> 1 and BH3 = 2).

compute tot1 = 0.

dataset declare aggr1.
aggregate
  /outfile='aggr1'
  /break=byeardiff
  /totl=sum(totl) 
  /totd=sum(totd) 
  /compl=sum(compl) 
  /compd=sum(compd) 
  /sexml=sum(sexml) 
  /sexmd=sum(sexmd) 
  /sexfl=sum(sexfl) 
  /sexfd=sum(sexfd).

dataset declare aggr2.
aggregate
  /outfile='aggr2'
  /break=byeargr
  /totl=sum(totl) 
  /totd=sum(totd) 
  /compl=sum(compl) 
  /compd=sum(compd) 
  /sexml=sum(sexml) 
  /sexmd=sum(sexmd) 
  /sexfl=sum(sexfl) 
  /sexfd=sum(sexfd).

dataset declare aggr3.
aggregate
  /outfile='aggr3'
  /break=tot1
  /totl=sum(totl) 
  /totd=sum(totd) 
  /compl=sum(compl) 
  /compd=sum(compd) 
  /sexml=sum(sexml) 
  /sexmd=sum(sexmd) 
  /sexfl=sum(sexfl) 
  /sexfd=sum(sexfd).

dataset activate aggr1.
add files 
  /file=*
  /file='aggr2'
  /file='aggr3'.

execute.

compute tott = totl + totd.

compute compt = 100*(compl + compd)/(totl+totd).
compute compl = 100*compl/totl.
compute compd = 100*compd/totd.

compute srabl = 100*sexml/sexfl.
compute srabd = 100*sexmd/sexfd.
compute srabt = 100*(sexml+sexmd)/(sexfl+sexfd).

sort cases by byeardiff (a).
do if (byeardiff >= 1 and byeardiff <=  9).
+ compute lagtotl = lag(totl).
+ compute lagtotd = lag(totd).
+ compute lagtott = lag(tott).
end if.
sort cases by byeardiff (d).
do if (byeardiff >= 1 and byeardiff <=  9).
+ compute leadtotl = lag(totl).
+ compute leadtotd = lag(totd).
+ compute leadtott = lag(tott).
+ compute calratl = 200 * totl / (lagtotl + leadtotl).
+ compute calratd = 200 * totd / (lagtotd + leadtotd).
+ compute calratt = 200 * tott / (lagtott + leadtott).
end if.

compute lay1 = 0.
compute lay2 = 0.
compute lay3 = 0.
compute lay4 = 0.

execute.

variable labels 
  totl "Living"
 /totd "Dead"
 /tott "Total"
 /compl "Living" 
 /compd "Dead"
 /compt "Total"
 /srabl "Living" 
 /srabd "Dead"
 /srabt "Total"
 /calratl "Living" 
 /calratd "Dead"
 /calratt "Total".
value labels 
  lay1 0 "Number of births"
 /lay2 0 "Percent with complete birth date [a]"
 /lay3 0 "Sex ratio at birth [b]"
 /lay4 0 "Period ratio [c]"
 /tot1 0 "Total".

ctables
  /format empty = "na" missing = "na"
  /vlabels variables = lay1 lay2 lay3 lay4 tot1 display = none
  /table (tot1 + byeardiff + byeargr)[c] by
    lay1 [c] > (totl + totd + tott) [s][mean f5.0] +
   	lay2 [c]> (compl + compd + compt) [s][mean f5.1] +
   	lay3 [c]> (srabl + srabd + srabt) [s][mean f5.1] +
   	lay4 [c]> (calratl + calratd + calratt) [s][mean f5.1]
  /categories var=byeardiff order=a empty=exclude
  /slabels visible = no
  /titles title = 
   "Table DQ.24: Births by calendar years"
   "Number of births, percentage with complete birth date, sex ratio at birth, and calendar year ratio by calendar year, " + 
   "according to living, deceased, and total children (imputed), as reported in the birth histories, " + surveyname
  caption=
    "na: not applicable"
   "[a] Both month and year of birth given. The inverse of the percent reported is the percent with incomplete and therefore imputed date of birth"
	 	"[b] (Bm/Bf) x 100, where Bm and Bf are the numbers of male and female births, respectively"
	 	"[c] (2 x Bt/(Bt-1 + Bt+1)) x 100, where Bt is the number of births in year t preceding the survey".

dataset close aggr1.
dataset close aggr2.
dataset close aggr3.

new file.
