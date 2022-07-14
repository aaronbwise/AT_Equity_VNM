*define a MACRO that merges 2 files with 3 ID variables.
define !merge (file1 = !tokens(1)
               /mvar1 = !tokens(1)
               /mvar2 = !tokens(1)
               /mvar3 = !tokens(1)
               /file2 = !tokens(1)
               /name1 = !tokens(1)
               /name2 = !tokens(1)
               /name3 = !tokens(1)).
get file = !file1.
sort cases by !mvar1 !mvar2 !mvar3.
save outfile = 'tmp.sav'
  /rename = (!mvar1 = !name1) (!mvar2 = !name2) (!mvar3 = !name3).
get file = !file2.
sort cases by !name1 !name2 !name3.
match files
  /file = *
  /table = 'tmp.sav'
  /by !name1 !name2 !name3.
save outfile = !file2.
get file = !file2.
erase file = 'tmp.sav'.
!enddefine.

*add variables from the household listing file.
!merge file1=hl.sav mvar1=HI1 mvar2=HI2 mvar3=HL1 file2=ch.sav name1=CHCLNO name2=CHHHNO name3=CHLNNO.

get file = 'hl.sav'.

sort cases by HI1 HI2 HL1.

save outfile = 'momed.sav'
  /keep = HI1 HI2 HL1 ED16A
  /rename = (HI1 = CHCLNO) (HI2 = CHHHNO) (HL1 = CHCTNO) (ED16A = MED).

get file = 'ch.sav'.

sort cases by CHCLNO CHHHNO CHCTNO.

match files
  /file = *
  /table = 'momed.sav'
  /by CHCLNO CHHHNO CHCTNO.

save outfile = 'chtmp.sav'.

get file = 'chtmp.sav'.

*education level.
recode MED (1 = 2) (2,3 = 3) (4 = 4) (7,9 = 7) (else = 1) into melevel.
variable label melevel "Mother's education level".
value labels melevel
  1 "None"
  2 "Primary"
  3 "Secondary"
  4 "Non-standard curriculum"
  7 "Missing/DK".

*create an age in months variable.
compute cmcdoi = (HI3Y - 1900)*12 + HI3M.
variable label cmcdoi "Date of interview (CMC)".

*set random number seed.
set seed = 1003.

do if (BR3Y < 9996 and BR3M < 96).
  compute cdob = (BR3Y - 1900)*12 + BR3M.
  compute cage = cmcdoi - cdob.
else if (BR3Y < 9996).
  compute cdob = (BR3Y - 1900)*12 + trunc(rv.uniform(1.00,12.99)).
  compute cage = cmcdoi - cdob.
else.
  compute cdob = 9999.
  compute cage = BR2*12 + trunc(rv.uniform(0.00,11.99)).
end if.
variable label cage "Age (months)".
variable label cdob "Date of birth (CMC)".
missing values cdob (9999).

*create a recoded age variable.
recode cage (0 thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) (24 thru 35 = 4)
            (36 thru 47 = 5) (48 thru 59 = 6) into cage_6.
variable label cage_6 "Age".
value labels cage_6
  1 "< 6 months"
  2 "6-11 months"
  3 "12-23 months"
  4 "24-35 months"
  5 "36-47 months"
  6 "48-59 months".

*BCG.
compute bcg = 3.
if ((IM2D >= 1 and IM2D <= 31) or IM2D = 44 or IM2D >= 97) bcg = 1.
if (IM2D = 66 or IM8 = 1) bcg = 2.
variable label bcg "BCG".
value label bcg 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*polio 0.
compute polio0 = 3.
if ((IM3AD >= 1 and IM3AD <= 31) or IM3AD = 44 or IM3AD >= 97) polio0 = 1.
if (IM3AD = 66 or IM10 = 1) polio0 = 2.
variable label polio0 "Polio 0".
value label polio0 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*polio 1.
compute polio1 = 3.
if ((IM3BD >= 1 and IM3BD <= 31) or IM3BD = 44 or IM3BD >= 97) polio1 = 1.
if (IM3BD = 66 or (IM9 = 1 and IM10 <> 1 and IM11 >= 1 and IM11 <= 19) or (IM9 = 1 and IM10 = 1 and IM11 >= 2 and IM11 <= 19)) polio1 = 2.
variable label polio1 "Polio 1".
value label polio1 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*polio 2.
compute polio2 = 3.
if ((IM3CD >= 1 and IM3CD <= 31) or IM3CD = 44 or IM3CD >= 97) polio2 = 1.
if (IM3CD = 66 or (IM9 = 1 and IM10 <> 1 and IM11 >= 2 and IM11 <= 19) or (IM9 = 1 and IM10 = 1 and IM11 >= 3 and IM11 <= 19)) polio2 = 2.
variable label polio2 "Polio 2".
value label polio2 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*polio 3.
compute polio3 = 3.
if ((IM3DD >= 1 and IM3DD <= 31) or IM3DD = 44 or IM3DD >= 97) polio3 = 1.
if (IM3DD = 66 or (IM9 = 1 and IM10 <> 1 and IM11 >= 3 and IM11 <= 19) or (IM9 = 1 and IM10 = 1 and IM11 >= 4 and IM11 <= 19)) polio3 = 2.
variable label polio3 "Polio 3".
value label polio3 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*DPT1.
compute DPT1 = 3.
if ((IM4AD >= 1 and IM4AD <= 31) or IM4AD = 44 or IM4AD >= 97) DPT1 = 1.
if (IM4AD = 66 or IM12 = 1) DPT1 = 2.
variable label DPT1 "DPT1".
value label DPT1 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*DPT2.
compute DPT2 = 3.
if ((IM4BD >= 1 and IM4BD <= 31) or IM4BD = 44 or IM4BD >= 97) DPT2 = 1.
if (IM4BD = 66 or (IM12 = 1 and IM13 >= 2 and IM13 <= 19)) DPT2 = 2.
variable label DPT2 "DPT2".
value label DPT2 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*DPT3.
compute DPT3 = 3.
if ((IM4CD >= 1 and IM4CD <= 31) or IM4CD = 44 or IM4CD >= 97) DPT3 = 1.
if (IM4CD = 66 or (IM12 = 1 and IM13 >= 3 and IM13 <= 19)) DPT3 = 2.
variable label DPT3 "DPT3".
value label DPT3 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*measles.
compute measles = 3.
if ((IM5D >= 1 and IM5D <= 31) or IM5D = 44 or IM5D >= 97) measles = 1.
if (IM5D = 66 or IM8 = 1) measles = 2.
variable label measles "Measles".
value label measles 1 "Vaccination Card" 2 "Mother's Report" 3 "Not vaccinated".

*all vaccinations.
do if (bcg = 3 or measles = 3 or dpt1 = 3 or dpt2 = 3 or dpt3 = 3 or polio1 = 3 or polio2 = 3 or polio3 = 3).
   compute allvacc = 3.
else if (bcg = 1 & measles = 1 & dpt1 = 1 & dpt2 = 1 & dpt3 = 1 & polio1 = 1 & polio2 = 1 & polio3 = 1).
   compute allvacc = 1.
else.
   compute allvacc = 2.
end if.
variable label allvacc "All vaccinations".
value label allvacc 1 "Vaccination Card" 2 "Mother's Report" 3 "Doesn't have all vaccinations".

*no vaccinations.
compute novacc = 3.
do if (bcg = 3 & measles = 3 & dpt1 = 3 & dpt2 = 3 & dpt3 = 3 & polio1 = 3 & polio2 = 3 & polio3 = 3).
   if (IM1 = 1) novacc = 1.
   if (IM1 <> 1) novacc = 2.
end if.
variable label novacc "No vaccinations".
value label novacc 1 "Vaccination Card" 2 "Mother's Report" 3 "Has some vaccinations".

recode IM1 (1 = 1) (else = 2) into hasvcard.
variable label hasvcard 'Has vaccination card'.
value label hasvcard 1 'Yes' 2 'No'.

*diarrhea in last 2 weeks.
recode CI1 (1 = 100) (else = 0) into diarrhea.
variable label diarrhea "Had diarrhea in last two weeks".

*ari in the last 2 weeks.
recode CI8 (2,3,9 = 100) (else = 0) into ari.
variable label ari "Had acute respitory infection".

*fever in the last 2 weeks.
recode ML1 (1 = 100) (else = 0) into fever.
variable label fever "Had a fever in last two weeks".

*save the children's file.
save outfile = 'ch.sav'
  /drop = CL2 CL3 CL4 CL5 CL6 CL7 CL8 CL9 ED15 ED16A ED16B ED17 ED18 ED19 ED20A ED20B ED21 ED22A ED22B.

get file = 'ch.sav'.

erase file = 'chtmp.sav'.
