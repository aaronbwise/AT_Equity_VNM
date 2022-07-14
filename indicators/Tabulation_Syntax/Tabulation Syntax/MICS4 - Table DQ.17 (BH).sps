* This data quality table is only produced for surveys that have included a birth history.

include "surveyname.sps".

* Please note that the bh.sav file should be the unimputed.
get file = 'bh.sav'.

weight by wmweight.

recode BH4Y (2012 = 0) (2011 = 1) (2010 = 2) (2009 = 3) (2008 = 4) (2007 = 5) (2006 = 6) (2005 = 7) (2004 = 8)
                      (2003 = 9) (2002 = 10) (2001 = 11) (2000 = 12) (1999 = 13) (1998 = 14) (1997 = 15) (1996 = 16)
                      (1995 = 17) (1994 = 18) (1993 = 19) (1992 = 20) (else = sysmis) into year.
variable labels year 'Year of birth'.
value labels year
 0 '2012'
 1 '2011'
 2 '2010'
 3 '2009'
 4 '2008'
 5 '2007'
 6 '2006'
 7 '2005'
 8 '2004'
 9 '2003'
 10 '2002'
 11 '2001'
 12 '2000'
 13 '1999'
 14 '1998'
 15 '1997'
 16 '1996'
 17 '1995'
 18 '1994'
 19 '1993'
 20 '1992'.

recode BH4Y (2008 thru 2012 = 31) (2003 thru 2007 = 32) (1998 thru 2002 = 33) (1993 thru 1997 = 34)
                      (lo thru 1992 = 35) (else = 36) into year1.

recode year1 (lo thru hi = 37) into year2.

compute myt = 9.
if (BH4M  >= 97 or BH4M  >= 9997) myt = 1.
variable labels myt "Month or year of birth missing".
missing values myt (9).

do if (BH5 = 1).
+ compute myl = 9.
+ if (BH4M  >= 97 or BH4Y  >= 9997) myl = 1.
end if.
variable labels myl "Month or year of birth missing".
missing values myl (9).

do if (BH5 = 2).
+ compute myd = 9.
+ if (BH4M  >= 97 or BH4Y  >= 9997) myd = 1.
end if.
variable labels myd "Month or year of birth missing".
missing values myd (9).

do if (BH3 = 1).
+ compute mbirths = year.
+ compute mbirths1 = year1.
+ compute mbirths2 = year2.
end if.

do if (BH3 = 2).
+ compute fbirths = year.
+ compute fbirths1 = year1.
+ compute fbirths2 = year2.
end if.

sort cases by year.

aggregate 
  /outfile ='temp1.sav'
  /break = year
  /births = n(year)
  /male = n(mbirths)
  /female = n(fbirths)
  /mymisst = n(myt)
  /mymissl = n(myl).

sort cases by year1.

aggregate 
  /outfile ='temp2.sav'
  /break = year1
  /births = n(year1)
  /male = n(mbirths1)
  /female = n(fbirths1)
  /mymisst = n(myt)
  /mymissl = n(myl).

sort cases by year2.

aggregate 
  /outfile ='temp3.sav'
  /break = year2
  /births = n(year2)
  /male = n(mbirths2)
  /female = n(fbirths2)
  /mymisst = n(myt)
  /mymissl = n(myl).

select if (BH5 = 2).

sort cases by year.

aggregate 
  /outfile ='temp4.sav'
  /break = year
  /deaths = n(year)
  /maled = n(mbirths)
  /femaled = n(fbirths)
  /mymissd = n(myd).

sort cases by year1.

aggregate 
  /outfile ='temp5.sav'
  /break = year1
  /deaths = n(year1)
  /maled = n(mbirths1)
  /femaled = n(fbirths1)
  /mymissd = n(myd).

sort cases by year2.

aggregate 
  /outfile ='temp6.sav'
  /break = year2
  /deaths = n(year2)
  /maled = n(mbirths2)
  /femaled = n(fbirths2)
  /mymissd = n(myd).

get file = 'temp1.sav'.

match files
 /file = *
 /table ='temp4.sav'
 /by year.
save outfile 'temp7.sav'.

get file = 'temp2.sav'.

match files
 /file = *
 /table ='temp5.sav'
 /by year1.

rename variables (year1 = year). 

save outfile 'temp8.sav'.

get file = 'temp3.sav'.

match files
 /file = *
 /table ='temp6.sav'
 /by year2.

rename variables (year2 = year). 

save outfile 'temp9.sav'.

add files 
 /file = 'temp7.sav'
 /file = 'temp8.sav'
 /file = 'temp9.sav'.

variable labels year 'Year of birth'.
value labels year 0 '2012*' 1 '2011' 2 '2010' 3 '2009' 4 '2008' 5 '2007' 6 '2006' 7 '2005' 8 '2004' 9 '2003' 10 '2002' 11 '2001' 12 '2000' 
                           13 '1999' 14 '1998' 15 '1997' 16 '1996' 17 '1995' 18 '1994' 19 '1993' 20 '1992' 
                           31 '2008-2012' 32 '2003-2007' 33 '1998-2002' 34 '1993-1997' 35 '<1993' 36 'DK/missing' 37 'Total'.

compute living = births - deaths.
compute dobcl = ((living - mymissl)/living) * 100.
compute dobcd = ((deaths - mymissd)/deaths) * 100.
compute dobct = ((births - mymisst)/births) * 100.

compute mliving = male - maled.
compute fliving = female - femaled.

compute lsr = (mliving/fliving) * 100.
compute dsr = (maled/femaled) * 100.
compute tsr = (male/female) * 100.

compute lagbirths = lag(births, 1).
create leadbirths = lead(births, 1).

compute lagliving = lag(living, 1).
create leadliving = lead(living, 1).

compute lagdeaths = lag(deaths, 1).
create leaddeaths = lead(deaths, 1).

do if (year > 1 and year < 21).
+ compute rliving = ((2 * living) / (lagliving + leadliving)) * 100.
+ compute rdeaths = ((2 * deaths) / (lagdeaths + leaddeaths)) * 100.
+ compute rbirths = ((2 * births) / (lagbirths + leadbirths)) * 100.
end if.

variable labels living "Living".
variable labels deaths "Dead".
variable labels births "Total".
variable labels dobcl "Living".
variable labels dobcd "Dead".
variable labels dobct "Total".
variable labels lsr "Living".
variable labels dsr "Dead".
variable labels tsr "Total".
variable labels rliving "Living".
variable labels rdeaths "Dead".
variable labels rbirths "Total".

compute tot1 = 1.
variable labels tot1 'All'.
value labels tot1 1 ' '.

compute tbirth = 0.
variable labels tbirth ''.
value labels tbirth 0 'Number of births'.

compute dobmiss = 0.
variable labels dobmiss ''.
value labels dobmiss 0 'Percent with complete birth date**'.

compute sexratio = 0.
variable labels sexratio ''.
value labels sexratio 0 'Sex ratio at birth***'.

compute cyratio = 0.
variable labels cyratio ''.
value labels cyratio 0 'Calendar year ratio****'.

ctables
  /format empty = "na" missing = "na"
  /vlabels variables = tbirth dobmiss sexratio cyratio display = none
  /table year [c] by 
                tbirth [c] > (living [s] [sum,'Living',f5.0] + deaths[s] [sum,'Dead',f5.0] + births [s] [sum,'Total',f5.0]) + 
                dobmiss [c] > (dobcl [s] [sum,'Living',f5.1] + dobcd [s] [sum,'Dead',f5.1] + dobct[s] [sum,'Total',f5.1])  + 
                sexratio [c] > (lsr [s] [sum,'Living',f5.1] + dsr [s] [sum,'Dead',f5.1] + tsr[s] [sum,'Total',f5.1]) + 
                cyratio [c] > (rliving [s] [sum,'Living',f5.1] + rdeaths [s] [sum,'Dead',f5.1] + rbirths[s] [sum,'Total',f5.1])                    
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table DQ.17: Births by calendar years"
		 "Number of births, percentage with complete birth date, sex ratio at birth, and calendar year ratio " + 
   "by calendar year, according to living, dead, and total children (weighted, unimputed), " + surveyname
  caption=
	 	"na: Not Applicable"
   "* Interviews were conducted from [Month] to [Month]"
	 	"** Both month and year of birth given"
	 	"*** (Bm/Bf) x 100, where Bm and Bf are the numbers of male and female births, respectively"
	 	"**** (2 x Bt/(Bt-1 + Bt+1)) x 100, where Bt is the number of births in calendar year t".

new file.

erase file 'temp1.sav'.
erase file 'temp2.sav'.
erase file 'temp3.sav'.
erase file 'temp4.sav'.
erase file 'temp5.sav'.
erase file 'temp6.sav'.
erase file 'temp7.sav'.
erase file 'temp8.sav'.
erase file 'temp9.sav'.
