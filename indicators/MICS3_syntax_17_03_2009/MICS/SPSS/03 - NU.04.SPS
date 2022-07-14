get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

do if (cage >= 0 and cage <= 5).
+ compute exbf5 = 0.
+ if (BF2 = 1 & (BF3B <> 1 & BF3C <> 1 & BF3D <> 1 & BF3E <> 1 & BF3F <> 1 & 
	BF3G <> 1 & BF3H <> 1))	exbf5 = 100.
end if.
variable label exbf5 "0-5 months exclusively  breastfed".

do if (cage >= 6 and cage <= 8).
+ compute time2 = 0.
+ if (BF2 = 1 and BF5 >= 2 and BF5 <= 7) time2 = 100.
end if.
variable label Time2 "6-8 months who received breastmilk and "+
  "complementary food at least 2 times in prior 24 hours".

do if (cage >= 9 and cage <= 11).
+ compute time3 = 0.
+ if (BF2 = 1 and BF5 >= 3 and BF5 <= 7) time3 = 100.
end if.
variable label Time3 "9-11 months who received breastmilk and "+
  "complementary food at least 3 times in prior 24 hours".

do if (cage >= 6 and cage <= 11).
+ compute mrecom = 0.
+ if (time2 = 100 or time3 = 100) mrecom = 100.
end if.
variable label mrecom "6-11 months who received breastmilk and complementary "+
  "food at least the minimum recommended number of times per day*".

do if (cage >= 0 and cage <= 11).
+ compute approp = 0.
+ if (exbf5 = 100 or time2 = 100 or time3 = 100) approp = 100.
+ compute total  = 1.
end if.
variable label total "Number of infants aged 0-11 months".
value label total 1 "".
variable label approp "0-11 months who were appropriately fed**".

tables
  /format = zero
  /observation =  exbf5 time2 time3 mrecom approp
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 
		by exbf5 + time2 + time3 + mrecom + approp + total
  /statistics
    mean(exbf5 (f5.1) '')
    mean(time2 (f5.1) '')
    mean(time3 (f5.1) '')
    mean(mrecom (f5.1) '')
    mean(approp (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table NU.4: Adequately fed infants" 
		"Percentage of infants under 6 months of age exclusively breastfed, "+
		"percentage of infants 6-11 months who are breastfed "
                        "and who ate solid/semi-solid food at least the minimum recommended number of "+
		"times yesterday and percentage of infants adequately fed, Country, Year"
  /caption
    "* MICS indicator 18 "
		"** MICS indicator 19".

new file.
