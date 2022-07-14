get file = 'hl.sav'.

weight by hhweight.

compute total  = 1.
variable label total "Number of children 10-14 years of age".

recode HL5 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 =4) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years"
  4 "15-17 years".

compute mfdead = 0.
if (HL9 = 2 and HL11 = 2) mfdead = 100.
variable label mfdead "Percent of children whose mother and father have died".

compute school = 0.
if (ED4 = 1) school = 100.
variable label school "Attending school".

do if (mfdead = 100).
+ compute school1 = 0.
+ if (school = 100) school1 = 100.
+ compute tschool1 = 0.
+ if (school = 100) tschool1 = 1.
end if.
variable label  school1 "School attendance rate of children whose mother and father have died".

compute liveone = 0.
if (HL9 = 1 and HL11 = 1 and (HL10 <> 0 or HL12 <> 0)) liveone = 100.
variable label liveone "Non-orphans living with at least one parent".

do if (liveone = 100).
+ compute school2 = 0.
+ if (school = 100) school2 = 100.
+ compute tschool2 = 0.
+ if (school2 = 100) tschool2 = 1.
end if.
variable label school2 "School attendance rate of children of whom both parent are alive and child is living with at least one parent".

compute ill = 0.
if (HL10A = 1 or HL12A = 1) ill = 100.
variable label ill "Chronically ill".

compute death = 0.
if (OV4 = 1) death = 100.
variable label death "Adult death in household".

compute chroill = 0.
if (TOHL8A >= 1) chroill = 100.
variable label chroill "Chronically ill adult in household".

compute vulne = 0.
if (ill = 100 or death = 100 or chroill = 100) vulne = 100.
variable label vulne "Vulnerable children *".

compute oneboth = 0.
if (HL9 = 2 or HL11 = 2) oneboth = 100.
variable label oneboth "One or both parents dead **".

compute orphans = 0.
if (vulne = 100 or oneboth = 100) orphans = 100.
variable label orphans "Orphans and vulnerable children".

do if (orphans = 100).
+ compute school3 = 0.
+ if (school = 100) school3 = 100.
end if.
variable label school3 "School attendance of children who are orphaned or vulnerable due to AIDS".

compute norpvul = 0.
if (orphans = 0) norpvul = 100.
variable label norpvul "Percent of children who are not orphans "+
  "or vulnerable due to AIDS".

do if (norpvul = 100).
+ compute school4 = 0.
+ if (school = 100) school4 = 100.
end if.
variable label school4 "School attendance of children who are not orphans or vulnerable due to AIDS".

select if (HL5 >= 10 and HL5 <= 14).

compute total = 1.

aggregate outfile = 'tmp1.sav'
  /break HL4
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).

aggregate outfile = 'tmp2.sav'
  /break HH7
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).

aggregate outfile = 'tmp3.sav'
  /break HH6
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).

aggregate outfile = 'tmp4.sav'
  /break wlthind5
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).

aggregate outfile = 'tmp5.sav'
  /break HC1B
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).


aggregate outfile = 'tmp6.sav'
  /break total
  /tot1  = mean(oneboth)
  /tot2  = mean(mfdead)
  /tot2a = sum(mfdead)
  /tot3  = mean(school1)
  /tot3a = sum(tschool1)
  /tot4  = mean(liveone)
  /tot5  = mean(school2)
  /tot5a = sum(tschool2)
  /tot6  = mean(orphans)
  /tot7  = mean(school3)
  /tot8  = mean(norpvul)
  /tot9  = mean(school4)
  /tot10 = sum(total).

get file = 'tmp1.sav'.

add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'.

variable label tot1 "One or both parents dead".
variable label tot2 "Percent of children whose mother and father have died".
variable label tot2a "Number of children whose mother and father have died".
variable label tot3 "School attendance rate of children whose mother and father have died".
variable label tot3a "Number of children whose mother and father have died and who are attending school".
variable label tot4 "Percent of children of whom both parents are alive and child is living with at least one parent".
variable label tot5 "School attendance rate of children of whom both parents are alive and child is living with at least one parent".
variable label tot5a "Number of children of whom both parents are alive and child is living with at least one parent and who are attending school".
variable label tot6 "Percent of children who are orphaned or vulnerable due to AIDS".
variable label tot7 "School attendance of children who are orphaned or vulnerable due to AIDS".
variable label tot8 "Percent of children who are  not orphans or vulnerable due to AIDS".
variable label tot9 "School attendance of children who are not orphans or vulnerable due to AIDS" .
variable label tot10 "Total number of children aged 10-14 years ".

compute ratio1 = tot3/tot5.
variable label ratio1 "Double orphans to non orphans school attendance ratio*".

compute ratio2 = tot7/tot9.
variable label ratio2 "OVC vs non-OVC school attendance ratio".

tables
  /format = zero
  /observation = tot2 tot3 tot4 tot5 ratio1 tot6 tot7 tot8 tot9 ratio2 tot10 
  /ftotal = tot1a "Total" 
  /table = HL4 + HH7 + HH6 + wlthind5 + HC1B + total by 
    tot2 + tot3 + tot4 + tot5 + ratio1 + tot6 + tot7 + tot8 + tot9 + ratio2 + tot10 
  /statistics
    mean(tot2 (f5.1) '')
    mean(tot3 (f5.1) '')
    mean(tot4 (f5.1) '')
    mean(tot5 (f5.1) '')
    mean(ratio1 (f5.2) '')
    mean(tot6 (f5.1) '')
    mean(tot7 (f5.1) '')
    mean(tot8 (f5.1) '')
    mean(tot9 (f5.1) '')
    mean(ratio2 (f5.2) '')
    sum(tot10 (f5.0) '')
  /title
    "Table HA.12: School attendance of orphaned and vulnerable children"
		"School attendance of children aged 10-14 years by orphanhood and vulnerability "+
		"due to AIDS, Country, Year"
  /caption
    "* MICS Indicator 77; MDG Indicator 20".

new file.

*delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
