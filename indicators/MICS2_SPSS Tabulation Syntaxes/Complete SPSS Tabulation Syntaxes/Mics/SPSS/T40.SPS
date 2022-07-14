get file = 'ch.sav'.

weight by chweight.

compute total = 1.
variable label total "Number of children".

compute register = 0.
if (BR4 = 1 or BR5 = 1) register = 100.
variable label register "Birth is registered".

do if (register = 0).
+ recode BR6 (1 thru 7 = copy) (9 = 7) into notreg.
+ variable label notreg "Birth is not registered because:".
+ value label notreg
    1 "Costs too much"
    2 "Must travel too far"
    3 "Didn't know it should be registered"
    4 "Late & didn't want to pay fine"
    5 "Doesn't know where to register"
    6 "Other"
    7 "DK/Missing".
end if.

tables
  /observation = register
  /ftotal = tot1 "Total"
  /tables = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by register + notreg + tot1 + total
  /statistics
    mean(register (f5.1) '')
    cpct(notreg (f5.1) '')
    count(total (f5.1) '')
  /title
    "Table 40: Percent distribution of children aged 0-59 months by whether birth is registered and reasons for non-registration,"
    "Country, Year"
  /caption
    "Monitoring Children's Rights Indicator".
