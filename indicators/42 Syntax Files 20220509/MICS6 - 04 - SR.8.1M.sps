* Encoding: windows-1252.
* MICS6 SR.8.1M.

* v01 - 2017-09-27.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** All men (in selected households) age 18-49 years are eligible for the Adult Functioning module. 
** The table presents the prevalence of men wearing glasses/contacts and using hearing aid (MAF2 and MAF3), 
** as well as the 6 domains of functioning (MAF6A/B, MAF8A/B, MAF9, MAF10, MAF11 and MAF12). 
** A response of "A lot of difficulty" (=3) or "Cannot do at all" (=4) is considered a functional difficulty and is included in the compuation of 
** "Percentage of men age 18-49 years with functional difficulties in at least one domain" (MAF6A/B=3 or 4 OR MAF8A/B=3 or 4 OR MAF9=3 or 4 OR MAF10=3 or 4 OR MAF11=3 or 4 OR MAF12=3 or 4).

** The last 4 columns of the table separately measures functional difficulties on only those men who report using assistive devices. 
** For the domain of "Seeing" those with difficulties are those responding "A lot of difficulty" or "Cannot do at all" to question MAF6A with the denominator being MAF2=1. The computation is similar for the domain of "Hearing".

** Note A must be customised using the working table also produced by the syntax. The number of cases of respondents for whom the response code "Incapacitated" (MWM17=05) was recorded should be inserted.

** This table produces the standard disaggregate of "Disability status (age 18-49 years) that is used in many tabulations across the report. 
** The disaggregate is based on column K, presenting respondents with functional difficulties in at least one domain versus respondents with no functional difficulties.


***.

include "surveyname.sps".

get file = 'hl.sav'.

sort cases by hh1 hh2 hl1.

save outfile = "tmp.sav"
  /rename hl1 = ln
  /keep hh1 hh2 ln hl6.

get file = 'mn.sav'.

sort cases by hh1 hh2 ln.

* Merge the household data for age information.
match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 LN.

include "CommonVarsMN.sps".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

do if (HL6 >= 18).
recode MWM17 (5 = 1) (else = 0) into incapaciated.
end if.
variable labels incapaciated "Number cases of respondents for whom the response code 'Incapacitated' was indicated for the individual interview".

* working table.
ctables 
  /table total [c] by incapaciated[s] [sum '' f5.0].

select if (MWB4 >= 18).

select if (MWM17 = 1).

weight by mnweight.
																
compute glasses = 0.
if (MAF2 = 1) glasses = 100.
variable labels glasses "Wear glasses/ contact lenses".

compute hearAid = 0.
if (MAF3 = 1) hearAid = 100.
variable labels hearAid "Use hearing aid".
	
compute seeing = 0.
if (MAF6 = 3 or MAF6 = 4) seeing = 100.
variable labels seeing "Seeing".

compute hearing = 0.
if (MAF8 = 3 or MAF8 = 4) hearing = 100.
variable labels hearing "Hearing".

compute walking = 0.
if (MAF9 = 3 or MAF9 = 4) walking = 100.
variable labels walking "Walking".

compute selfCare = 0.
if (MAF11 = 3 or MAF11 = 4) selfCare = 100.
variable labels selfCare "Self-care".

compute communication = 0.
if (MAF12 = 3 or MAF12 = 4) communication = 100.
variable labels communication "Communication".

compute remember = 0.
if (MAF10 = 3 or MAF10 = 4) remember = 100.
variable labels remember "Remembering".

compute atLeastOne = 0.
if (seeing = 100 or hearing = 100 or walking = 100 or selfCare = 100 or communication = 100 or remember = 100) atLeastOne = 100.
variable labels atLeastOne "Percentage of men age 18-49 years with functional difficulties in at least one domain [A]".

do if (MAF2 = 1).
+ compute seeingDif = 0.
+ if (seeing = 100) seeingDif = 100.
+ compute totGlass = 1.
end if.

do if (MAF3 = 1).
+ compute heairingDif = 0.
+ if (hearing = 100) heairingDif = 100.
+ compute tothAid = 1.
end if.

add value labels mwage 1 "18-19".

variable labels seeingDif "Percentage of men with difficulties seeing when wearing glasses/ contact lenses".	
variable labels totGlass "Number of men age 18-49 years who wear glasses/ contact lenses".

variable labels heairingDif  "Percentage of men with difficulties hearing when using hearing aid".
variable labels tothAid  "Number of men age 18-49 years who use hearing aid".

compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Percentage of men who:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage of men age 18-49 years who have functional difficulties in the domains of:".

compute numMen = 1.
variable labels numMen "Number of men age 18-49 years".
value labels nummen 1 "".

compute tot = 100.
variable labels tot "Total".
value labels tot 100 " ".


* Ctables command in English.
ctables
    /vlabels variables = layer1 layer2 display = none
    /table   total[c]
    + hh6 [c]
    + hh7 [c]
    + mwage [c]
    + mwelevel [c]
    + ethnicity[c]
    + windex5 [c]
    by
    layer1 [c] > (glasses [s] [mean '' f5.1] + hearAid [s] [mean '' f5.1]) +
    layer2 [c] > (seeing [s] [mean '' f5.1] + hearing [s] [mean '' f5.1] + walking [s] [mean '' f5.1] + selfCare [s] [mean '' f5.1] + communication [s] [mean '' f5.1] + remember [s] [mean '' f5.1]) + 
    atLeastOne [s] [mean '' f5.1] +
    numMen[s][sum '' f5.0] +
    seeingDif [s] [mean '' f5.1] +
    totGlass[s][sum '' f5.0] +
    heairingDif [s] [mean '' f5.1] +
    tothAid[s][sum '' f5.0] 
    /categories variables=all empty=exclude missing=exclude
    /slabels position=column visible = no
    /titles title=
    "Table SR.8.1M: Adult functioning (men age 18-49 years)"
    "Percentage of men age 18-49 years with functional difficulties, by domain, and percentage who use assistive devices and have functional difficulty within domain of devices, " + surveyname
    caption =
    "[A] In MICS, the adult functioning module is asked to individual respondents age 18-49 for the purpose of disaggregation. "+
    "No information is collected on eligible household members who, for any reason, were unable to complete the interview. "+
    "It is expected that a significant proportion of the [insert number of cases from working table] cases of respondents for whom the " +
    "response code 'Incapacitated' was indicated for the individual interview are indeed incapacitated due to functional difficulties. " +
    "The percentage of men with functional difficulties presented here is therefore not representing a full measure and should not be used for reporting on prevalence in the population.".

new file.

erase file = "tmp.sav".
