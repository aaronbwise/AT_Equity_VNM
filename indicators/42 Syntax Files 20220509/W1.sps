* Encoding: windows-1252.
* PREPARE FILES, SET UP MACRO COMMANDS.

*	Get hl.sav to check servants and parents living abroad.
get file = "hl.sav".

*showing both numbers and labels at the outputs.
set Small=0.0001 TVars=Both  TNumbers=Both ONumbers=Both  DIGITGROUPING=No  TLook=None SUMMARY=None  OVars=Both TFit=Both LEADZERO=No ODISPLAY=modelviewer TABLERENDER=light.

frequencies vars = HL3 .

* Merge servant variables from hl onto hh.
recode HL3 (14=1) (else=0) into servant.
execute.

sort cases HH1 HH2.
aggregate /outfile="temp.sav" /break=HH1 HH2
	         /servant	"One or more live-in servants" = max(servant).

*	Get hh.sav, select completed households.
get file = "hh.sav".
sort cases HH1 HH2.
select if (HH46=1).

match files
  /file = *
  /table = 'temp.sav'
  /by HH1 HH2.

*	Prepare urban, rural and national variables.
compute national=1.
compute urban=(HH6 = 1).
compute rural=(HH6 = 2).
recode urban rural (0=sysmis).
variable labels national	 'National' urban 'Urban' rural 'Rural'.
value labels national 1 'National' / urban 1 "Urban" / rural 1 "Rural".
formats national urban rural (f1.0).
execute.

* Macros.

* Generates percent distributions of variables by national, urban and rural. Include as many variables as needed.
* Format: macroname var1 var2 var3 @.
define varpdist (!pos !charend ('@'))
!DO !i !IN (!1)
ctables 	/table !i [c] [colpct,'Percentage',f4.1,count,'Count',f5.0]
	by national [c] + urban [c] + rural [c]
	/titles title=surveyname
		"Percentage distributions and numbers of cases for the national sample, urban and rural areas"
	/categories variables=!i total=yes.
!doend
!enddefine.

* Generates descriptives of variables by national, urban and rural. Include as many variables as needed.
* Format: macroname var1 + var2 + var3 @.
define varmeans (!pos !charend ('@'))
ctables 	/table ( !1 ) [s] [validn 'Count' f5.0 sum 'Sum' f9.0 mean 'Mean' f5.4 missing 'Missing' f5.0] 
	by national [c] + urban [c] + rural [c]
	/titles title=Surveyname
		"Numbers of cases, sums, means and missing cases for the national sample, urban and rural areas".
!enddefine.

* Generates means of variables by common and combined wealth quintiles. Include as many variables as needed.
* Format: macroname var1 + var2 + var3 @. 
define wqmeans1 (!pos !charend ('@'))
ctables 	/table ( !1 ) [s] [mean '' f5.4] 
	by windexini5 [c] + windex5 [c]
	/categories variables = windex5 total = yes
	/titles title=Surveyname
		"Average values of component indicators in initial (common) and combined wealth index quintiles".
!enddefine.

* Generates means of variables by combined wealth quintiles, by urban and rural areas. Include as many variables as needed.
* Format: macroname ((var1 + var2 + var3)). 
define wqmeans2 (!pos !charend ('@'))
ctables 	/table ( !1 ) [s] [mean '' f5.4] 
	by (urban [c] + rural [c]) > windex5 [c]
	/categories variables = windex5 total = yes
	/titles title=Surveyname
		"Average values of component indicators in combined wealth index quintiles by urban and rural areas".
!enddefine.

*	Generates dichotomous variables and labels from response codes
* Format: macroname var1 (1) (9) var1@r "Watch".
define dichotomize( !pos !tokens(1) / !pos !enclose('(',')') / !pos !enclose('(',')') / !pos !tokens(1) / !pos !tokens(1) )
recode !1 (!2 = 1) (!3 = 9) (else = 0) into !4.
variable labels !4 !5.
value labels !4 1 !5 0 "No" 9 "Missing".
missing values !4 (9).
formats !4 (f1.0).
!enddefine.

*	Generates continuous variables based on condition and for giving labels
* Format: macroname hc12n (0 thru 95) (98 thru hi) agland_ha "Household owns agricultural land: hectares".
define continuize( !pos !tokens(1) / !pos !enclose('(',')') / !pos !enclose('(',')') / !pos !tokens(1) / !pos !tokens(1) )
recode !1 (!2 = copy) (!3 = 999) (else = 0) into !4.
variable labels !4 !5.
value labels !4 999 "Missing".
missing values !4 (999).
formats !4 (f3.0).
!enddefine.

*	Extracts shared sanitation from unshared, creating two variables for each sanitation facility.
* Format: macroname ws8@13 ws8@13s "Flush to pit latrine toilet - shared".
define sharedfac( !pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) ).
compute !2 = 0.
do if (latshare=1).
+ compute !2 = !1.
+ compute !1 = 0.
end if.
variable labels !2 !3.
value labels !2 1 !3 0 "No" 9 "Missing".
missing values !2 (9).
formats !2 (f1.0).
!enddefine.

* Generates grouped large animal variables.
* Format: macroname variable animal0 animal1 animal5 animal10.
define lanimal (!pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) ).
recode !1 (0 = 1) (96 thru 99 = 9) (else = 0) into !2.
recode !1 (1 thru 4 = 1) (96 thru 99 = 9) (else = 0) into !3.
recode !1 (5 thru 9 = 1) (96 thru 99 = 9) (else = 0) into !4.
recode !1 (10 thru 95 = 1) (96 thru 99 = 9) (else = 0) into !5.
missing values !2 !3 !4 !5 (9).
value labels !2 1 "Has None" 9 "Missing".
value labels !3 1 "Has 1-4" 9 "Missing".
value labels !4 1 "Has 5-9" 9 "Missing".
value labels !5 1 "Has 10+" 9 "Missing".
!enddefine.

* Generates grouped small animal variables.
* Format: macroname variable animal0 animal1 animal10 animal30.
define sanimal (!pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) / !pos !tokens(1) ).
recode !1 (0 = 1) (96 thru 99 = 9) (else = 0) into !2.
recode !1 (1 thru 9 = 1) (96 thru 99 = 9) (else = 0) into !3.
recode !1 (10 thru 29 = 1) (96 thru 99 = 9) (else = 0) into !4.
recode !1 (30 thru 95 = 1) (96 thru 99 = 9) (else = 0) into !5.
missing values !2 !3 !4 !5 (9).
value labels !2 1 "Has None" 9 "Missing".
value labels !3 1 "Has 1-9" 9 "Missing".
value labels !4 1 "Has 10-29" 9 "Missing".
value labels !5 1 "Has 30+" 9 "Missing".
!enddefine.

*output close *.
