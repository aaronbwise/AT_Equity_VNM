get file = 'hl.sav'.

variable labels
  HI1     "Cluster number"
  /HI2    "Household number"
  /HID    "Household ID"
  /HHMID  "Household member ID"
  /HL1    "Line number"
  /HL2    "Name"
  /HL3    "Sex"
  /HL4    "Age"
  /HL5    "Eligibility for women's interview"
  /HL6    "Eligibility for child labor module"
  /HL7    "Eligibility for child health module"
  /HL8    "Can read a newspaper"
  /HL9    "Marital status"
  /HL10   "Mother alive"
  /HL11   "Mother in household"
  /HL12   "Father alive"
  /HL13   "Father in household"
  /ED14   "Line number (education module)"
  /ED15   "Ever attended school"
  /ED16A  "Highest school level"
  /ED16B  "Highest school grade"
  /ED17   "Currently attending school"
  /ED18   "Attended school anytime this year"
  /ED19   "Days of school attended in last week"
  /ED20A  "School level attended this year"
  /ED20B  "School grade attended this year"
  /ED21   "Attended school last year"
  /ED22A  "School level attended last year"
  /ED22B  "School grade attended last year"
  /CL1    "Line number (child labor module)"
  /CL2    "Name"
  /CL3    "Worked during past week for non-HH member"
  /CL4    "Hours worked during past week"
  /CL5    "Worked during past year for non-HH member"
  /CL6    "Helped with chores during past week"
  /CL7    "Hours spent helping with chores"
  /CL8    "Did family work during the past week"
  /CL9    "Hours of family work during past week"
.

value labels
  HL3
    1 "Male"
    2 "Female"
    7 "Missing"
  /HL4
    96 "96+"
    97 "Missing"
    99 "Don't know"
  /HL8
    1 "Easily"
    2 "With difficulty"
    3 "Not at all"
    7 "Missing"
    9 "Don't know"
  /HL9
    1 "Currently married/In union"
    2 "Widowed"
    3 "Divorced"
    4 "Separated"
    5 "Never married"
    7 "Missing"
  /HL10
    1 "Yes"
    2 "No"
    7 "Missing"
    9 "Don't know"
  /HL11
    1 "Yes"
    2 "No"
    7 "Missing"
  /HL12
    1 "Yes"
    2 "No"
    7 "Missing"
    9 "Don't know"
  /HL13
    1 "Yes"
    2 "No"
    7 "Missing"
  /ED15
    1 "Yes"
    2 "No"
    7 "Missing"
  /ED16A
    1 "Primary"
    2 "Secondary"
    3 "Higher"
    4 "Non-standard curriculum"
    7 "Missing"
    9 "Don't know"
  /ED16B
    96 "Inconsistent"
    97 "Missing"
    99 "Don't know"
  /ED17
    1 "Yes"
    2 "No"
    7 "Missing"
  /ED18
    1 "Yes"
    2 "No"
    7 "Missing"
  /ED19
    6 "6+"
    7 "Missing"
  /ED20A
    1 "Preschool"
    2 "Primary"
    3 "Secondary"
    4 "Non-standard curriculum"
    7 "Missing"
    9 "Don't know"
  /ED20B
    96 "Inconsistent"
    97 "Missing"
    99 "Don't know"
  /ED21
    1 "Yes"
    2 "No"
    7 "Missing"
    9 "Don't know"
  /ED22A
    1 "Preschool"
    2 "Primary"
    3 "Secondary"
    4 "Non-standard curriculum"
    7 "Missing"
    9 "Don't know"
  /ED22B
    96 "Inconsistent"
    97 "Missing"
    99 "Don't know"
  /CL3
    1 "Yes, paid"
    2 "Yes, unpaid"
    3 "No"
    7 "Missing"
  /CL4
    97 "Missing"
    99 "DK"
  /CL5
    1 "Yes, paid"
    2 "Yes, unpaid"
    3 "No"
    7 "Missing"
  /CL6
    1 "Yes"
    2 "No"
    7 "Missing"
  /CL7
    97 "Missing"
    99 "DK"
  /CL8
    1 "Yes"
    2 "No"
    7 "Missing"
  /CL9
    97 "Missing"
    99 "DK"
.

save outfile = 'hl.sav'.
