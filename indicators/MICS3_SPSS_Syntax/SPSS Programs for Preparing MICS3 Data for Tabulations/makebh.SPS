* open the women file.
get file ="bh.sav".

* set random number seed.
set seed = 1003.

* calculate the CMC date of interview.
compute cmcdoiw = (WM6Y - 1900)*12 + WM6M.
variable label cmcdoiw "Date of interview women (CMC)".

* calculate the CMC date of birth for children.
do if (bh4y < 9996 and bh4m < 96).
+ compute ccdob = (bh4y - 1900)*12 + bh4m.
else if (bh4y < 9996 and bh5 = 1 and bh6 < 96).
+ compute caldob = cmcdoiw - bh6*12 - 11.
+ compute caudob = cmcdoiw - bh6*12 - 0.
+ compute cldob = (bh4y - 1900)*12 + 1.
+ compute cudob = (bh4y - 1900)*12 + 12.
+ compute ccdob = trunc(rv.uniform(cldob,cudob)).
+ if (cldob >= caldob & cldob <= caudob) ccdob = trunc(rv.uniform(cldob,caudob)).
+ if (caldob >= cldob & caldob <= cudob) ccdob = trunc(rv.uniform(caldob,cudob)).
+ if (cldob > caudob | caldob > cudob) ccdob = trunc(rv.uniform(caldob,caudob)).
else if (bh4y < 9996).
+ compute cldob = (bh4y - 1900)*12 + 1.
+ compute cudob = (bh4y - 1900)*12 + 12.
+ compute ccdob = trunc(rv.uniform(cldob,cudob)).
else if (bh5 = 1 and bh6 < 96).
+ compute caldob = cmcdoiw - bh6*12 - 11.
+ compute caudob = cmcdoiw - bh6*12 - 0.
+ compute ccdob = trunc(rv.uniform(caldob,caudob)).
else.
+ compute ccdob = 9999.
end if.
variable label ccdob "Child's date of birth (CMC)".
missing values ccdob (9999).

* calculate the CMC date of birth and age.
do if (WM8Y < 9996 and WM8M < 96).
+ compute wdob = (WM8Y - 1900)*12 + WM8M.
else if (WM8Y < 9996 and WM9 < 96).
+ compute aldob = cmcdoiw - WM9*12 - 11.
+ compute audob = cmcdoiw - WM9*12 - 0.
+ compute ldob = (WM8Y - 1900)*12 + 1.
+ compute udob = (WM8Y - 1900)*12 + 12.
+ if (ldob >= aldob & ldob <= audob) wdob = trunc(rv.uniform(ldob,audob)).
+ if (aldob >= ldob & aldob <= udob) wdob = trunc(rv.uniform(aldob,udob)).
+ if (ldob > audob | aldob > udob) wdob = trunc(rv.uniform(aldob,audob)).
else if (WM9 < 96).
+ compute aldob = cmcdoiw - WM9*12 - 11.
+ compute audob = cmcdoiw - WM9*12 - 0.
+ compute wdob = trunc(rv.uniform(aldob,audob)).
else.
+ compute wdob = 9999.
end if.
if (cmcdoiw - wdob = 600) wdob = wdob + 1.
variable label wdob "Women's date of birth (CMC)".
missing values wdob (9999).

* calculate age in five year groups.
recode WM9 (15 thru 19 =1) (20 thru 24 = 2) (25 thru 29 =3) (30 thru 34 =4) 
	(35 thru 39 =5) (40 thru 44=6) (45 thru 49 =7) into wage.
variable label wage "Women's age".
value label wage
  1 "15-19"
  2 "20-24"
  3 "25-29"
  4 "30-34"
  5 "35-39"
  6 "40-44"
  7 "45-49".

* calculate age at first marriage.
do if (MA6Y < 9996 and MA6M < 96).
+ compute wdom = (MA6Y - 1900)*12 + MA6M.
+ compute agem = trunc ((wdom-wdob)/12) .
else if (MA8 < 96).
+ compute agem = MA8.
else if (not sysmis(MA6M)).
+ compute agem = 99.
end if.
variable label agem "Age at first marriage".
missing values agem (99).

* calculate marital status.
if (MA1 = 1) mstatus = 1.
if (MA3 = 1) mstatus = 2.
if (MA3 = 3) mstatus = 3.
variable label mstatus "Marital status".
value label mstatus
  1 "Currently married"
  2 "Formerly married"
  3 "Never married".

* calculate education level.
recode WM11 (1 = 2) (2,3 = 3) (6 = 4) (8,9 = 9) (else = 1) into melevel.
variable label melevel "Women's education".
value label melevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  4 "Non-standard curriculum"
  9 "Missing/DK".

* calculate total children ever born.
compute ceb = 0.
if (CM1 = 1) ceb = CM9.
variable label ceb "Children ever born".

* calculate number of dead children.
compute deadkids = 0.
if (CM7 = 1) deadkids = CM8A + CM8B.
variable label deadkids "Dead children".

* calculate number of children surviving.
compute surviv = 0.
if (CM1 = 1) surviv = ceb-deadkids.
variable label surviv "Number of children surviving".

execute.

delete variables aldob audob ldob udob  caldob caudob cldob cudob wdom.

*save the birth history file.
*save outfile = 'bh.sav'.
