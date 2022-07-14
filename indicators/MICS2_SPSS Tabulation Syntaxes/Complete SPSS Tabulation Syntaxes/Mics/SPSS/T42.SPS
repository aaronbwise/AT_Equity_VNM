get file = 'hl.sav'.

weight by hhweight.

select if (HL4 >= 5 and HL4 <= 14).

recode HL4 (5 thru 9 = 1) (10 thru 14 = 2) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "5-9 years"
  2 "10-14 years".

compute paid = 0.
if (CL3 = 1) paid = 100.
variable label paid "Paid work".

compute unpaid = 0.
if (CL3 = 2) unpaid = 100.
variable label unpaid "Unpaid work".

recode CL7 (0 thru 27 = 100) (else = 0) into less4.
variable label less4 "Domestic work: < 4 hours/day".

recode CL7 (28 thru 96 = 100) (else = 0) into more4.
variable label more4 "Domestic work: 4 or more hours/day".

compute working = 0.
if (paid = 100 or unpaid = 100 or more4 = 100 or CL8 = 1) working = 100.
variable label working "Currently working".

tables
  /observation = paid unpaid less4 more4 working
  /ftotal = tot1 "Total" tot2 "Number of children"
  /tables = HL3 + HI7 + HI6 + agegrp + tot1 by paid + unpaid + less4 + more4 + working + tot2
  /statistics
    mean(paid (f5.1) '')
    mean(unpaid (f5.1) '')
    mean(less4 (f5.1) '')
    mean(more4 (f5.1) '')
    mean(working (f5.1) '')
    count(tot2 (f5.0) '')
  /title
    "Table 42: Percentage of children 5-14 years of age who are currently working, Country, Year"
  /caption
    "Monitoring Children's Rights Indicator".
