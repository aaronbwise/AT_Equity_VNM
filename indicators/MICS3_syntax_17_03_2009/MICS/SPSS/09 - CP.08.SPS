get file = "wm.sav".

weight by wmweight.

* Women with at least one living daughter.
recode CM4B CM6B (sysmis = 0).
compute daughter = CM4B + CM6B.
select if (daughter > 0).

compute total = 1.
value label total 1 "".
variable label total "Number of women aged 15-49 years".

compute fgm = 0.
if (FG9 >= 1 and FG9 <= 9) fgm  = 100.
variable label fgm "Daughter had any form of FGM/C *".

do if (fgm = 100).
+ compute fgmtype = 9.
+ if (FG11 = 1 and FG13 <> 1) fgmtype = 1.
+ if (FG12 = 1 and FG13 <> 1) fgmtype = 2.
+ if (FG13 = 1) fgmtype = 3.
+ compute extreme = 0.
+ if (FG11 = 1 and FG13 = 1) extreme = 100.
+ compute totfgm = 1.
end if.
variable label fgmtype "Percentage of women whose daughters:".
value label fgmtype
   1 "Had flesh removed" 
   2 "Were nicked" 
   3 "Were sewn closed" 
   9 "Form of FGM/C not determined".
variable label extreme "Daughter had an extreme form of FGM/C".  
variable label totfgm "Number of women aged 15-49 years with at least one living daughter who had FGM/C".
value label totfgm 1 "".

tables
  /format = zero
  /observation = fgm extreme
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by 
	  fgm + total + fgmtype + tot1 + extreme + totfgm
  /statistics
    mean(fgm (f5.1) '')
    count(total (f5.0) '')
    cpct(fgmtype (f5.1) '': HH7 HH6 wage melevel  wlthind5 HC1B)
    mean(extreme (f5.1) '')
    count(totfgm (f5.0) '')
 /title
    "Table CP.8: Female genital mutilation/cutting (FGM/C) among daughters"
		"Percentage of women with at least one living daughter who has had "+
		"female genital mutilation (FGM/C) and the percentage by type of FGM/C "+
		"of the daughters, country, year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 65".

new file.
