* Encoding: UTF-8.

recode CB7 (1 = 1) (9 = 8) (else = 2) into schoolAttendance.
variable labels schoolAttendance "School attendance".
value labels schoolAttendance 1 "Attending" 2 "Not attending" 8 "Missing".