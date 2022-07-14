get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute htotal  = 1.
value labels htotal 1 "".
variables labels htotal "Number of households interviewed".


recode SI1 (6 = 100) (else = 0) into nosalt.
variable label nosalt "Percent of households with no salt".

recode SI1 (1,2,3 = 100) (else = 0) into salttest.
variable label salttest "Percent of households in which salt was tested".


recode SI1 (6=0)  (1,2 = 1) (3 = 2) (else = sysmis) into iodized.
variable label iodized "Percent of households with salt test result".
value label iodized
  0 "Percent of households with no salt"
  1 "< 15 PPM"
  2 "15+ PPM*".

do if (nosalt  = 100 or salttest  = 100).
compute total = 1.
variable label total "Number of households in which salt was tested or with no salt".
value label total 1 "".
end if.

tables
  /format = zero
  /observation =  salttest
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 +wlthind5+ tot1 by  salttest +htotal+ iodized +tot1+ total
  /statistics
    mean(salttest (f5.1) '')
    count(Htotal (f5.0) '')
    cpct(iodized (f5.1) '' : HH7 HH6 wlthind5 )
    count(total (f5.0) '')
  /title
    "Table NU.5: Iodized salt consumption" "Percentage of households consuming adequately iodized salt, Country, Year"
  /caption
      "*MICS indicator 41".

new file.
