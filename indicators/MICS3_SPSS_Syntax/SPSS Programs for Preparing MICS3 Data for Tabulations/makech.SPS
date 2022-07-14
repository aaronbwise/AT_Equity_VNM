* open the children file.
get file ="ch.sav".

* calculate the CMC date of interview.
compute cmcdoic = (UF8Y - 1900)*12 + UF8M.
variable label cmcdoic "Date of interview child (CMC)".
format cmcdoic (f4.0).

* set random number seed.
set seed = 1003.

* calculate CMC date of birth and age (in months).
do if (UF10Y < 9996 and UF10M < 96).
+ compute cdob = (UF10Y - 1900)*12 + UF10M.
else if (UF10Y < 9996).
+ compute aldob = cmcdoic - (UF11*12) - 11.
+ compute audob = cmcdoic - (UF11*12) - 0.
+ compute ldob = (UF10Y - 1900)*12 + 1.
+ compute udob = (UF10Y - 1900)*12 + 12.
+ if (ldob >= aldob & ldob <= audob) cdob = trunc(rv.uniform(ldob,audob)).
+ if (aldob >= ldob & aldob <= udob) cdob = trunc(rv.uniform(aldob,udob)).
+ if (ldob > audob | aldob > udob) cdob = trunc(rv.uniform(aldob,audob)).
else.
+ compute aldob = cmcdoic - (UF11*12) - 11.
+ compute audob = cmcdoic - (UF11*12) - 0.
+ compute cdob = trunc(rv.uniform(aldob,audob)).
end if.
if (cmcdoic - cdob = 60) cdob = cdob + 1.
if (cdob <> 9999) cage = cmcdoic - cdob.
variable label cage "Age (months)".
variable label cdob "Date of birth (CMC)".
missing values cdob (9999).
format cage (f2.0).
format cdob (f4.0).

* recode age in months into 6 or 12 month groups.
recode cage (0 thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) (24 thru 35 = 4)
  (36 thru 47 = 5) (48 thru 59 = 6) into cage_6.
variable label cage_6 "Age".
value label cage_6
  1 "< 6 months"
  2 "6-11 months"
  3 "12-23 months"
  4 "24-35 months"
  5 "36-47 months"
  6 "48-59 months".
format cage_6 (f1.0).

* recode age in months into 12 month groups.
recode cage (0 thru 11 = 1) (12 thru 23 = 2) (24 thru 35 = 3) (36 thru 47 = 4)
  (48 thru 59 = 5) into cage_11.
variable label cage_11 "Age".
value label cage_11
  1 "0-11 months"
  2 "12-23 months"
  3 "24-35 months"
  4 "36-47 months"
  5 "48-59 months".
format cage_11 (f1.0).

* education level.
recode ED3A (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Mother's education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Non-standard curriculum"
  9 "Missing/DK".
format melevel (f1.0).

delete variables aldob audob ldob udob.

* save the children's file.
save outfile = 'ch.sav'.
