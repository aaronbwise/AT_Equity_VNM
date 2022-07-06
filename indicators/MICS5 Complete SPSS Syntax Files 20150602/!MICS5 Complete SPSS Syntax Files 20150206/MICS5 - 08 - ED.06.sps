* MICS5 ED-06.

* v01 - 2014-03-04.

* Children reaching the last grade of primary, also known as the survival rate to the last grade of primary school, is defined as the percentage
  of children attending the first grade of primary school who would be expected to reach the last grade of primary school, if current rates of
  transition from one grade of primary school to the next were applicable.

* This table assumes that primary school comprises 6 grades.
* In countries where primary school has a different number of grades, columns of the table should be customized accordingly.

* With the assumption of a 6-grade primary school system, the indicator is calculated as the product of the following probabilities:
 The probability that a child completes the first grade and enters second grade;
 The probability that a child completes the second grade and enters third grade;
 The probability that a child completes the third grade and enters fourth grade;
 The probability that a child completes the fourth grade and enters fifth grade; and
 The probability that a child completes the fifth grade and enters sixth grade.

* Since the survey collects information on the attendance of children to primary school only for two school years (the current school year and
  the previous school year), it is not possible to follow a real cohort of children entering primary school and reaching (or dropping out before
  they do so) the last grade of primary school.
* Therefore, calculations are carried out on the basis of a hypothetical cohort that is assumed to experience transition rates during the previous
  and current school years.

* To calculate the first probability above, the number of children who were attending the first grade of primary school during the previous school
  year (ED8A Level=1, ED8B Grade=01) and moved on to the second grade of primary school in the current year (ED6A Level=1, ED6B Grade=02) are
  divided by the the number of children who were in the first grade last year (ED8A Level=1, ED8B Grade=01) and graduated to second grade
  (ED6A Level=1, ED6B Grade=02) or dropped out of school (ED5=2).
* In short, this is the percentage of children who successfully moved from grade 1 to grade 2.
* Children who are repeating the first grade do not enter the calculation because it is not known whether they will eventually graduate.

* The calculation of the other probabilities is similar:
   the number who graduated from one grade to another divided by the number who graduated or dropped out of that grade.

* All probabilities are then multiplied together to obtain the cumulative probability of reaching the last grade among those who enter first grade.

* Many surveys will not have sample sizes that will support breakdowns for all the background variables.
* Denominators are not shown in the table; however, SPSS produces a working table comprising the denominators of each of the cells in the table,
  which should be produced unweighted and the size of denominators checked.
* Categories may need to be grouped together or re-designed, and some of the cells may need to be shown with an asterisk, or parenthesized.
* Detailed information on these reporting conventions can be found on childinfo_org .

***.


include "surveyname.sps".

* the following code assumes thatssumes that primary school comprises 6 grades.
* in countries where primary school has more or fewer grades,
* variables zXYt in the code should be customized accordingly.

get file 'hl.sav'.

weight by hhweight.

compute total = 1.
variable labels total " ".
value labels total 1 "Total".

* Variable 'droppedX'   represents the number of children in X'th grade last year who are not in school this year .
* Variable 'graduatedX' represents the number of children in X'th grade last year who are in (X+1)'th grade this year .
* value in these variables is binary ie logical value of 0/1 deppending if logical condition is false/true .

compute dropped1   = (ED8A = 1 and ED8B = 1 and ED5 <> 1) .
compute graduated1 = (ED8A = 1 and ED8B = 1 and ED6A = 1 and ED6B = 2) .

compute dropped2   = (ED8A = 1 and ED8B = 2 and ED5 <> 1).
compute graduated2 = (ED8A = 1 and ED8B = 2 and ED6A = 1 and ED6B = 3).

compute dropped3   = (ED8A = 1 and ED8B = 3 and ED5 <> 1).
compute graduated3 = (ED8A = 1 and ED8B = 3 and ED6A = 1 and ED6B = 4).

compute dropped4   = (ED8A = 1 and ED8B = 4 and ED5 <> 1).
compute graduated4 = (ED8A = 1 and ED8B = 4 and ED6A = 1 and ED6B = 5).

compute dropped5   = (ED8A = 1 and ED8B = 5 and ED5 <> 1).
compute graduated5 = (ED8A = 1 and ED8B = 5 and ED6A = 1 and ED6B = 6).


aggregate outfile = 'tmp1.sav'
  /break = total
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp2.sav'
  /break = HL4
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp3.sav'
  /break = HH7
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp4.sav'
  /break = HH6
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp5.sav'
  /break = melevel
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp6.sav'
  /break = windex5
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).

aggregate outfile = 'tmp7.sav'
  /break = ethnicity
  /dropped1    = sum(dropped1)
  /graduated1  = sum(graduated1)
  /dropped2    = sum(dropped2)
  /graduated2  = sum(graduated2)
  /dropped3    = sum(dropped3)
  /graduated3  = sum(graduated3)
  /dropped4    = sum(dropped4)
  /graduated4  = sum(graduated4)
  /dropped5    = sum(dropped5)
  /graduated5  = sum(graduated5).



get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

compute num1 = graduated1 + dropped1 .  
compute num2 = graduated2 + dropped2 .  
compute num3 = graduated3 + dropped3 .  
compute num4 = graduated4 + dropped4 .  
compute num5 = graduated5 + dropped5 .  

if (num1 > 0) p1 = graduated1 / num1 * 100 .
if (num2 > 0) p2 = graduated2 / num2 * 100 .
if (num3 > 0) p3 = graduated3 / num3 * 100 .
if (num4 > 0) p4 = graduated4 / num4 * 100 .
if (num5 > 0) p5 = graduated5 / num5 * 100 .

* Percentage for the whole is the multiplication of all percents for all grades, and division with the number of grades included minus one .

compute pAll = (p1*p2*p3*p4*p5) / 100 ** (5-1) .

variable labels p1   "Percent attending grade 1 last school year who are in grade 2 this school year" .
variable labels p2   "Percent attending grade 2 last school year who are attending grade 3 this school year" .
variable labels p3   "Percent attending grade 3 last school year who are attending grade 4 this school year" .
variable labels p4   "Percent attending grade 4 last school year who are attending grade 5 this school year" .
variable labels p5   "Percent attending grade 5 last school year who are attending grade 6 this school year" .
variable labels pAll "Percent who reach grade 6 of those who enter grade 1 [1]" .

variable labels
  num1 "Number of children who attended grade 1 last year"
  /num2 "Number of children who attended grade 2 last year"
  /num3 "Number of children who attended grade 3 last year"
  /num4 "Number of children who attended grade 4 last year"
  /num5 "Number of children who attended grade 5 last year".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table   total [c]
         + hl4 [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           p1   [s] [mean,'',f5.1]
         + p2   [s] [mean,'',f5.1]
         + p3   [s] [mean,'',f5.1]
         + p4   [s] [mean,'',f5.1]
         + p5   [s] [mean,'',f5.1]
         + pAll [s] [mean,'',f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels visible = no
  /titles title=
    "Table ED.6: Children reaching last grade of primary school"
      "Percentage of children entering first grade of primary school who eventually reach " +
    "the last grade of primary school (Survival rate to last grade of primary school), " + surveyname
   caption=
    "[1] MICS indicator 7.6; MDG indicator 2.2 - Children reaching last grade of primary"
  .

* Auxiliary table with denominators (not for printing).
* Only to be run unweighted for supression purposes.
*ctables
  /table   total [c]
         + hl4 [c]
         + hh7[c]
         + hh6[c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]      
   by
           p1   [s] [mean,'',f5.1] + num1 [s] [sum,'',f5.0]
         + p2   [s] [mean,'',f5.1] + num2 [s] [sum,'',f5.0]
         + p3   [s] [mean,'',f5.1] + num3 [s] [sum,'',f5.0]
         + p4   [s] [mean,'',f5.1] + num4 [s] [sum,'',f5.0]
         + p5   [s] [mean,'',f5.1] + num5 [s] [sum,'',f5.0]
         + pAll [s] [mean,'',f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels visible = no
  /title title=
    "Table ED.6.AUX: Auxiliary table with denominators (not for printing) - should be used only when produced unweighted"
  .
new file.

erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.

