* Encoding: windows-1252.
* MICS6 SR.9.4M.

* v01 - 2017-11-07.
* v01 - 2019-03-14.
* v03 - 2020-04-09. Labels in French and Spanish have been removed.

** This table shows the results of the 9 individual ICT skills asked in HC10. The last column is computed as at least one yes to any of the 9 skills. The table is based on the full denominator of all men age 15-49.

***.


* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men dataset.
get file = 'mn.sav'.

include "CommonVarsMN.sps".

* Select completed interviews.
select if (MWM17 = 1).

* Weight the data by the women weight.
weight by mnweight.

* Generate numWomen variable.
compute numMen = 1.
variable labels numMen "".
value labels numMen 1 "Number of men".

* Generate indicators.
recode MMT6A (1 = 100) (else = 0) into copied.
variable labels copied "Copied or moved a file or folder".

recode MMT6B (1 = 100) (else = 0) into filecopy.
variable labels filecopy "Used a copy and paste tool to duplicate or move information within a document".

recode MMT6C (1 = 100) (else = 0) into email.
variable labels email "Sent e-mail with attached file, such as a document, picture or video".

recode MMT6D (1 = 100) (else = 0) into formula.
variable labels formula "Used a basic arithmetic formula in a spreadsheet".

recode MMT6E (1 = 100) (else = 0) into install.
variable labels install "Connected and installed a new device, such as a modem, camera or printer".

recode MMT6F (1 = 100) (else = 0) into software.
variable labels software "Found, downloaded, installed and configured software".

recode MMT6G (1 = 100) (else = 0) into presentation.
variable labels presentation "Created an electronic presentation with presentation software, including text, images, sound, video or charts".

recode MMT6H (1 = 100) (else = 0) into transfer.
variable labels transfer "Transferred a file between a computer and other device".

recode MMT6I (1 = 100) (else = 0) into code.
variable labels code "Wrote a computer program in any programming language".

compute atLeastOne = 0.
if (copied = 100 or filecopy = 100 or email = 100 or formula = 100 or install = 100 or software = 100 or presentation = 100 or transfer = 100 or code = 100) atLeastOne = 100.
variable labels atLeastOne "Performed at least one of the nine listed computer related activities [1] [2]".

compute layer0 = 0.
variable labels layer0 "".
value labels layer0 0 "Percentage of men who in the last 3 months:".

compute total = 1.
variable labels total "".
value labels total 1 "Total".

* Ctables command in English.
ctables
  /vlabels variables =  numMen layer0 total
         display = none
  /table   total [c]
        + hh6 [c]
        + hh7 [c]
        + $mwagew [c]
        + mwelevel [c]
        + mdisability [c]
        + ethnicity [c]
        + windex5 [c]
      by
           layer0 [c] > ( copied [s] [mean '' f5.1]
                        + filecopy [s] [mean '' f5.1]
                        + email [s] [mean '' f5.1]
                        + formula [s] [mean '' f5.1]
                        + install [s] [mean '' f5.1]
                        + software [s] [mean '' f5.1]
                        + presentation [s] [mean '' f5.1]
                        + transfer [s] [mean '' f5.1]
                        + code [s] [mean '' f5.1]
                        + atLeastOne [s] [mean '' f5.1] )
            + numMen[c][count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table SR.9.4M: ICT skills (men)"
     "Percentage of men age 15-49 years who in the last 3 months have carried out computer related activities, " 
     + surveyname
   caption =
        "[1] MICS indicator SR.13a - ICT skills (age 15-24 years); SDG indicator 4.4.1"
        "[2] MICS indicator SR.13b - ICT skills (age 15-49 years); SDG indicator 4.4.1"	
.

new file.
