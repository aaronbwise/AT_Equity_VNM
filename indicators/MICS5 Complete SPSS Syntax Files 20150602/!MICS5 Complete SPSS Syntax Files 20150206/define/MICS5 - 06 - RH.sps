
compute contraceptiveMethod = 99.
if (CP3X = "X") contraceptiveMethod = 14.
if (CP3M = "M") contraceptiveMethod = 13.
if (CP3L = "L") contraceptiveMethod = 12.
if (CP3K = "K") contraceptiveMethod = 11.
if (CP3I = "I" or CP3J = "J") contraceptiveMethod = 9.
if (CP3H = "H") contraceptiveMethod = 8.
if (CP3G = "G") contraceptiveMethod = 7.
if (CP3F = "F") contraceptiveMethod = 6.
if (CP3E = "E") contraceptiveMethod = 5.
if (CP3D = "D") contraceptiveMethod = 4.
if (CP3C = "C") contraceptiveMethod = 3.
if (CP3B = "B") contraceptiveMethod = 2.
if (CP3A = "A") contraceptiveMethod = 1.

* If pregnant or state they are not using, set method to 0.
if (CP1 = 1 or CP2 = 2 or CP2 = 9) contraceptiveMethod = 0.

value labels contraceptiveMethod
   0 "No method"
   1 "Female sterilization"
   2 "Male sterilization"
   3 "IUD"
   4 "Injectables"
   5 "Implants"
   6 "Pill"
   7 "Male condom"
   8 "Female condom"
   9 "Diaphragm/foam/jelly"
  11 "Lactational amenorrhoea method (LAM)"
  12 "Periodic abstinence/Rhythm"
  13 "Withdrawal"
  14 "Other"
   99 "Missing".

***.

compute anc = 0.
if (MN2A = "A") anc = 11.
if (anc = 0 and MN2B = "B") anc = 12.
if (anc = 0 and MN2C = "C") anc = 13.
if (anc = 0 and MN2F = "F") anc = 21.
if (anc = 0 and MN2G = "G") anc = 22.
if (anc = 0 and (MN2X = "X" or MN2A = "?")) anc = 97.
if (anc = 0) anc = 98.
variable labels anc "Person providing antenatal care".
value labels anc
  11 "Medical doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  21 "Traditional birth attendant"
  22 "Community health worker"
  97 "Other/missing"
  98 "No antenatal care".

***.

compute agebrth = (wdoblc - wdob)/12.
variable label agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute ageAtBirth = 9.
if (agebrth < 20) ageAtBirth = 1.
if (agebrth >= 20 and agebrth < 35) ageAtBirth = 2.
if (agebrth >= 35 and agebrth <= 49) ageAtBirth = 3.
variable labels ageAtBirth "Mother's age at birth".
value labels ageAtBirth
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

***.

compute deliveryPlace = 0.
if (MN18 >= 21 and MN18 <= 26) deliveryPlace = 11.
if (MN18 >= 31 and MN18 <= 36) deliveryPlace = 12.
if (MN18 = 11 or MN18 = 12) deliveryPlace = 13.
if (MN18 = 96) deliveryPlace = 96.
if (MN18 = 98 or MN18 = 99) deliveryPlace = 98.
variable labels deliveryPlace "Place of delivery".
value labels deliveryPlace
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "Missing/DK".
  
recode deliveryPlace (13=1) (11,12=2) (96,98=5) into place1 .
recode deliveryPlace (11=3) (12=4) into place2 .
value labels place1 place2
  1 'Home'
  2 'Health facility'
  3 '   Public'
  4 '   Private'
  5 'Other/DK/Missing' .
mrsets 
  /mcgroup name=$deliveryPlace label='Place of delivery' variables=place1 place2 
  .

***.

compute noVisits = 0.
if (MN3 >= 1 and MN3 <= 3) noVisits = 1.
if (MN3 >= 4) noVisits = 2.
if (MN3 = 98 or MN3 = 99) noVisits = 9.
variable labels noVisits "Percent of women who had:".
value labels noVisits
  0 "None"
  1 "1-3 visits"
  2 "4+ visits"
  9 "Missing/DK".

***.

* Person checking health: excluding relative / friend and other.
compute pncmedC = 0.
if (PN13A = "A" or PN13B = "B "or PN13C = "C" or PN13F = "F" or PN13G = "G") pncmedC = 1.
variable labels pncmedC "Person checking health".

compute pncVisitC = 9.
* No PNC visit: PN5><1 or PN9><1 or PN10><1 or PN13><A through G.
if (PN5 <> 1 or PN9 <>  1 or PN10 <> 1 or pncmedC = 0) pncVisitC = 6.
* same day.
if (PN12U = 1 and pncmedC = 1) pncVisitC = 1.
* 1 day.
if (PN12U = 2 and PN12N  = 1 and pncmedC = 1) pncVisitC = 2.
* 2 days.
if (PN12U = 2 and PN12N  = 2 and pncmedC = 1) pncVisitC = 3.
* 3-6 days.
if (PN12U = 2 and PN12N >= 3 and PN12N <= 6 and pncmedC = 1) pncVisitC = 4.
* After 1 week or more.
if (PN12U = 2 and PN12N > 6 and PN12N < 98 and pncmedC = 1) pncVisitC = 5.
if (PN12U = 3 and pncmedC = 1) pncVisitC = 5.
variable labels pncVisitC "PNC visit".
value labels pncVisitC
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "Missing/DK".

***.

compute pncmedM = 0.
if (PN22A = "A" or PN22B = "B "or PN22C = "C" or PN22F = "F" or PN22G = "G") pncmedM = 1.
variable labels pncmedM "Person checking health".

compute pncVisitM = 9.
* No PNC visit: PN16><1 or PN18><1 or PN19><1 or PN23><A through G.
if (PN16 <> 1 or PN18 <> 1 or PN19 <> 1 or pncmedM = 0) pncVisitM = 6.
* same day.
if (PN21U = 1 and pncmedM = 1) pncVisitM = 1.
* 1 day.
if (PN21U = 2 and PN21N  = 1 and pncmedM = 1) pncVisitM = 2.
* 2 days.
if (PN21U = 2 and PN21N  = 2 and pncmedM = 1) pncVisitM = 3.
* 3-6 days.
if (PN21U = 2 and PN21N >= 3 and PN21N <= 6 and pncmedM = 1) pncVisitM = 4.
* After 1 week or more.
if (PN21U = 2 and PN21N > 6 and PN21N < 98 and pncmedM = 1) pncVisitM = 5.
if (PN21U = 3 and pncmedM = 1) pncVisitM = 5.
variable labels pncVisitM "PNC visit".
value labels  pncVisitM
  1 "Same day"
  2 "1 day following birth"
  3 "2 days following birth"
  4 "3-6 days following birth"
  5 "After the first week following birth"
  6 "No post-natal care visit"
  9 "Missing/DK".

***.

recode MN19 (1=2) (else=1) into deliveryType.
variable labels deliveryType "Type of delivery".
value labels deliveryType
  1 "Vaginal birth"
  2 "C-section" .
