get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value label total 1 "".
variable label total "Number of women aged 15-49 years".

compute fgm = 0.
do if (FG3 = 1).
+ compute fgm = 100.
+ compute totfgm  = 1.
+ compute fgmtype = 9.
+ if (FG4 = 1 and FG6 <> 1) fgmtype = 1.
+ if (FG5 = 1 and FG6 <> 1) fgmtype = 2.
+ if (FG6 = 1) fgmtype = 3.
+ compute extreme = 0.
+ if (FG4 = 1 and FG6 = 1) extreme = 100.
end if.

variable label fgm "Had any form of FGM/C *"
variable label totfgm  "Number of women with FGM/C".
value labels totfgm 1 "".
variable label fgmtype "Percentage of women with FGM/C who:".
value label fgmtype 
   1 "Had flesh removed" 
   2 "Were nicked"  
   3 "Were sewn closed"  
   9 "Form of FGM/C not determined".
variable label extreme "Had an extreme form of FGM/C **".  

recode FG16 (8,9 = 8) into FG16.
value label FG16 1 "Continue ***" 2 "Be discontinued" 3 "Depends on situation" 8 "Don't know/Missing".
variable label FG16 "Percent distribution of women who believe the practice of FGM/C should:".

if (FG1 = 1) heardfgm  = 1.
value label heardfgm 1 "".
variable label heardfgm "Number of women aged 15-49 years who have heard of FGM/C".

compute exper = 0.
if (FG3 = 1) exper = 1.
variable label exper "FGM/C experience".
value label exper 0 "No FGM/C" 1 "Had FGM/C".

tables
  /format = zero
  /observation = fgm extreme  
  /ftotal = tot1 "Total" tot2 "Total"
  /table = HH7 + HH6 + wage + melevel + exper + wlthind5 + HC1B + tot1 by 
	  fgm + total + fgmtype + tot1 + extreme + totfgm +
              FG16 + tot2 + heardfgm 
  /statistics
    mean(fgm (f5.1) '')
    count(total (f5.0) '')
    cpct(fgmtype (f5.1) '': HH7 HH6 wage melevel exper wlthind5 HC1B)    
    mean(extreme (f5.1) '')
    count(totfgm (f5.0) '')
    cpct(FG16 (f5.1) '': HH7 HH6 wage melevel exper wlthind5 HC1B)
    count(heardfgm (f5.0) '')
 /title
    "Table CP.7: Female genital mutilation/cutting (FGM/C)"
		"Percentage of women aged 15-49 who have had any form of the female "+
		"genital mutilation (FGM/C), the percentage who had different type of "+
		"FGM/C, the percentage who have had extreme from of FGM (infibulation), "
		"the percent distribution of attitudes towards wether the practice of "+
		"FGM/C should continued, Country, Year"
  /caption                                                                                                                                                                          
    "* MICS Indicator 63"
    "** MICS Indicator 64"
    "*** MICS Indicator 66".

new file.
