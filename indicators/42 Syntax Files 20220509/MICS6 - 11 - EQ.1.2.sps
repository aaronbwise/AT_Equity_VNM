* Encoding: windows-1252.
***.
* 2018.08.29: after computing" hearing" variable labels line was for "seing" so this changed to "hearing".
* v03 - 2019-08-28 Last modified to reflect tab plan changes as of 25 July 2019.
* v04 - 2020-04-11 A note has been inserted on the disaggregate of Mother’s functional difficulties. Labels in French and Spanish have been removed. 

*The hearing variable 
* The child functioning module for children age 5-17 is administered in the Questionnaire for Children Age 5-17. In households with at least one child age 5-17, 
one child is randomly selected. To account for the random selection, the household sample weight is multiplied by the total number of children age 5-17 in each household; this weight is used when producing this table.

 * Functional difficulty in the individual domains are calculated as follows:
Seeing (FCF6A/B=3 or 4), Hearing (FCF8A/B=3 or 4), Walking (FCF10=3 or 4 OR FCF11=3 or 4 OR FCF14=3 or 4 OR FCF15=3 or 4), Self-care (FCF16=3 or 4), 
Communication a) Being understood inside household (FCF17=3 or 4) or b) Being understood outside household (FCF18=3 or 4), Learning (FCF19=3 or 4), 
Remembering (FCF20=3 or 4), Concentrating ((FCF21=3 or 4), Accepting change (FCF22=3 or 4), Controlling behaviour (FCF23=3 or 4), 
Making friends (FCF24=3 or 4), Anxiety (FCF25=1), Depression (FCF26=1).

 * The percentage of children age 5-17 years with functional difficulty in at least one domain is presented in the last column.
							

include "surveyname.sps".

get file = 'fs.sav'.

include "CommonVarsFS.sps".

select if (FS17 = 1).

weight by fsweight.
 	 	
*Seeing (FCF6A/B=3 or 4),.
compute seeing=0.
if (any(FCF6, 3, 4)) seeing=100.
variable labels seeing "Seeing".

* Hearing (FCF8A/B=3 or 4),.
compute hearing=0.
if (any(FCF8, 3, 4)) hearing=100.
variable labels hearing "Hearing".

 * Walking Walking (FCF10=3 or 4 OR FCF11=3 or 4 OR FCF14=3 or 4 OR FCF15=3 or 4).
compute walking=0.
if ((any(FCF10, 3, 4)) or (any(FCF11, 3, 4)) or (any(FCF14, 3, 4)) or (any(FCF15, 3, 4))) walking=100.
variable labels walking "Walking".

 * Self-care (FCF16=3 or 4),.
compute selfcare=0.
if (any(FCF16, 3, 4)) selfcare=100.
variable labels selfcare "Self Care".

 * Communication a) Being understood inside household (FCF17=3 or 4) or b) Being understood outside household (FCF18=3 or 4), .
compute communication=0.
if ((any(FCF17, 3, 4)) or (any(FCF18, 3, 4))) communication=100.
variable labels communication "Communication".

 * Learning (FCF19=3 or 4),.
compute learning=0.
if (any(FCF19, 3, 4)) learning=100.
variable labels learning "Learning".

 * Remembering (FCF20=3 or 4), .
compute remembering=0.
if (any(FCF20, 3, 4)) remembering=100.
variable labels remembering "Remembering".

*Concentrating ((FCF21=3 or 4).     . 
compute concentrating=0.
if (any(FCF21, 3, 4)) concentrating=100.
variable labels concentrating "Concentrating".

 * Accepting change (FCF22=3 or 4),.
compute accepting=0.
if (any(FCF22, 3, 4)) accepting=100.
variable labels accepting "Accepting change".

*Controlling behaviour (FCF23=3 or 4), .
compute behaviour=0.
if (any(FCF23, 3, 4)) behaviour=100.
variable labels behaviour "Controlling behaviour".

*Making friends (FCF24=3 or 4), . 
compute makingfriends=0.
if (any(FCF24, 3, 4)) makingfriends=100.
variable labels makingfriends "Making friends ".

*Anxiety (FCF25=1),. 
compute anxiety=0.
if FCF25=1 anxiety=100.
variable labels anxiety "Anxiety".

*Depression (FCF26=1).
compute depression=0.
if FCF26=1 depression=100.
variable labels depression "Depression".

compute anyfuncdifficulty=0.
if (seeing=100 or hearing=100 or walking=100 or selfcare=100 or communication=100 or learning=100 or remembering=100 or 
    concentrating=100 or accepting=100 or behaviour=100 or makingfriends=100 or anxiety=100 or depression=100) anyfuncdifficulty=100.
variable labels anyfuncdifficulty "Percentage of children age 5-17 years with functional difficulty in at least one domain".

compute numChildren = 1.
value labels numChildren 1 "Number of children age 5-17 years".

compute layer = 1.
value labels layer 1 "Percentage of children aged 5-17 years with functional difficulty [A] in the domain of:" .

variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending [B]" 2 "Not attending" .

variable labels melevel "Mother's education [C]".
variable labels caretakerdis "Mother's functional difficulties [D]".

compute total = 1.
variable labels total "Total".
value labels  total 1 "Total".

* Ctables command in English.
ctables
   /vlabels variables = total layer numChildren
            display = none
   /table  total [c]
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + fsage [c]
         + schoolAttendance [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c] 
    by 
           layer [c] > (seeing[s][mean '' f5.1] + hearing[s][mean '' f5.1] + walking[s][mean '' f5.1] + selfcare[s][mean '' f5.1] + communication [s][mean '' f5.1] 
          + learning[s][mean '' f5.1] + remembering[s][mean '' f5.1] + concentrating[s][mean '' f5.1] + accepting[s][mean '' f5.1] + behaviour[s][mean '' f5.1] 
          + makingfriends[s][mean '' f5.1] + anxiety[s][mean '' f5.1] + depression[s][mean '' f5.1])  + anyfuncdifficulty[s][mean '' f5.1]
      + numChildren [c] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table EQ.1.2: Child functioning (children age 5-17 years)"
    "Percentage of children age 5-17 years who have functional difficulty, by domain, " + surveyname
   caption =
  "[A] Functional difficulty for children age 5-17 years are defined as having responded 'A lot of difficulty' or 'Cannot at all' to questions within all listed domains, "
      "except the last domains of anxiety and depression, for which the response category 'Daily' is considered a functional difficulty."														
  "[B] Includes attendance to early childhood education"														
  "[C] The disaggregate of Mother's education is not available for children age 15-17 years identified as emancipated."														
  "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."		
.												

new file. 

