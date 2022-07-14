get file = 'wm.sav'.

weight by wmweight.

compute total = 1.
variable label total "Number of women".

recode HA17 (1 = 100) (else = 0) into place.
variable label place "Know a place to get tested".

recode HA15 (1 = 100) (else = 0) into tested.
variable label tested "Have been tested".

do if (tested = 100).
+  recode HA16 (1 = 100) (else = 0) into results.
+  variable label results "If tested, have been told result".
end if.

tables
  /observation place tested results
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + wage + melevel + tot1 by
           place + tested + results + total
  /statistics
    mean(place (f5.1) '')
    mean(tested (f5.1) '')
    mean(results (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 35: Percentage of women aged 15-49 who know where to get an AIDS test and who have been tested, Country, Year"
  /caption
    "Monitoring HIV/AIDS Indicator".
