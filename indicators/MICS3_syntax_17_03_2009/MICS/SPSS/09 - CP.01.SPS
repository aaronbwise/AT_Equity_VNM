get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1) .
compute total = 1.
value label total 1 "Number of children aged 0-59 months".

compute regist = 0.
if (BR1 = 1 or BR2 = 1) regist = 100.
compute registdk = 0. 
if (BR2 = 8 or BR2 = 9) registdk = 100.

recode BR3 (1 thru 9 = copy) (else=sysmis) into register.

if (register >= 1 and register <= 9) total1 = 1.
variable label total1 "Number of children aged 0-59 months without birth registration".
value label total1 1 "".

variable label register "Birth is not registered because:".
value label register
  1 "Costs too much"
  2 "Must travel too far"
  3 "Didn't know child should be registered"
  4 "Late, didn't want to pay fine"
  5 "Doesn't know where to register"
  6 "Other"
  8 "Don't know"
  9 "Missing".
variable label regist "Birth is registered *".
variable label registdk "Don't know if birth is registered".

tables
  /format = zero
  /ftotal = tot1 "Total" tot2 "Total"
  /observations regist registdk
  /tables = HL4 + HH7 + HH6 + cage_11 + melevel +wlthind5+HC1B+ tot1 by regist +registdk+ total+ register + tot2 + total1
  /statistics
    mean(regist (f5.1) '')
    mean(registdk (f5.1) '')
    count(total (f5.0) '')
    cpct(register (f5.1) '' :  HL4 HH7 HH6 cage_11 melevel Wlthind5 HC1B)
    count(total1 (f5.0) '')
  /title
    "Table CP.1: Birth registration"
		"Percent distribution of children aged 0-59 months by whether birth is "+
		"registered and reasons for non-registration, Country, Year"
  /caption
    "* MICS Indicator 62".

new file.
