* open the women file.
get file ="wm.sav".

* calculate the CMC date of interview.
compute cmcdoiw = (WM6Y - 1900)*12 + WM6M.
variable label cmcdoiw "Date of interview women (CMC)".
format cmcdoiw (f4.0).

* set random number seed.
set seed = 1003.

* calculate the CMC date of birth and age.
do if (WM8Y < 9996 and WM8M < 96).
+ compute wdob = (WM8Y - 1900)*12 + WM8M.
else if (WM8Y < 9996).
+ compute aldob = cmcdoiw - WM9*12 - 11.
+ compute audob = cmcdoiw - WM9*12 - 0.
+ compute ldob = (WM8Y - 1900)*12 + 1.
+ compute udob = (WM8Y - 1900)*12 + 12.
+ if (ldob >= aldob & ldob <= audob) wdob = trunc(rv.uniform(ldob,audob)).
+ if (aldob >= ldob & aldob <= udob) wdob = trunc(rv.uniform(aldob,udob)).
+ if (ldob > audob | aldob > udob) wdob = trunc(rv.uniform(aldob,audob)).
else.
+ compute aldob = cmcdoiw - WM9*12 - 11.
+ compute audob = cmcdoiw - WM9*12 - 0.
+ compute wdob = trunc(rv.uniform(aldob,audob)).
end if.
if (cmcdoiw - wdob = 600) wdob = wdob + 1.
variable label wdob "Date of birth (CMC)".
missing values wdob (9999).
format wdob (f4.0).

* calculate age in five year groups.
recode WM9 (15 thru 19 =1) (20 thru 24 = 2) (25 thru 29 =3) (30 thru 34 =4)
	(35 thru 39 =5) (40 thru 44=6) (45 thru 49 =7) into wage.
variable label wage "Age".
value label wage
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49".
format wage (f1.0).

* calculate age at first marriage.
do if (MA6Y < 9996 and MA6M < 96).
+ compute wdom = (MA6Y - 1900)*12 + MA6M.
+ compute agem = trunc ((wdom-wdob)/12) .
else if (MA8 < 96).
+ compute agem = MA8.
else if (not sysmis(MA6M)).
+ compute agem = 99.
end if.
variable label agem "Age at first marriage/union".
missing values agem (99).
format agem (f2.0).

* calculate marital status.
if (MA1 = 1 or MA1  = 2) mstatus = 1.
if (MA3 = 1 or MA3  = 2) mstatus = 2.
if (MA3 = 3) mstatus = 3.
variable label mstatus "Marital/Union status".
value label mstatus
  1 "Currently married/in union"
  2 "Formerly married/in union"
  3 "Never married/in union".
format mstatus (f1.0).

* calculate education level.
recode WM11 (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  9 "Missing/DK".
format melevel (f1.0).

* calculate total children ever born.
compute ceb = 0.
if (CM1 = 1) ceb = CM9.
variable label ceb "Children ever born".
format ceb (f2.0).

* calculate number of dead children.
compute deadkids = 0.
if (CM7 = 1) deadkids = CM8A + CM8B.
variable label deadkids "Dead children".
format deadkids (f2.0).

* calculate number of children surviving.
compute surviv = 0.
if (CM1 = 1) surviv = Ceb-deadkids.
variable label surviv "Number of children surviving".
format surviv (f2.0).

* reset variables for incomplete interviews.
do if (WM7 ~= 1).
+ recode wdob (lo thru hi=sysmis).
+ recode wage (lo thru hi=sysmis).
+ recode wdom (lo thru hi=sysmis).
+ recode agem (lo thru hi=sysmis).
+ recode mstatus (lo thru hi=sysmis).
+ recode melevel (lo thru hi=sysmis).
+ recode ceb (lo thru hi=sysmis).
+ recode deadkids (lo thru hi=sysmis).
+ recode surviv (lo thru hi=sysmis).
end if.

delete variables aldob audob ldob udob wdom.

*save the women's file.
save outfile = 'wm.sav'.
