get file = 'ch.sav'.

weight by chweight.

select if (cage >= 36 and cage <= 59).

recode BR8 (1 = 100) (else = 0) into ecep.
variable labels ecep "Attending programme".

compute agerange = 1.
if (cage > 47) agerange = 2.
variable label agerange "Age".
value labels agerange
  1 "36-47 months"
  2 "48-59 months".

tables
  /ftotal = tot1 "Total" tot2 "Number of children"
  /observation = ecep
  /tables = HL3 + HI7 + HI6 + agerange + melevel + tot1 by ecep + tot2
  /statistics
    mean(ecep (f5.1) '')
    validn(tot2 (f5.0) '')
  /title
    "Table 9: Percentage of children aged 36-49 months who are attending some form of organized early childhood education"
    "programme, Country, Year"
  /caption
    "World Summit for Children Goal => Number 26".
