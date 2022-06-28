* Encoding: windows-1252.
* Convert string to numeric.

rename variables FL24A = FL24A_o. 
rename variables FL24B = FL24B_o. 
rename variables FL24C = FL24C_o. 
rename variables FL24D = FL24D_o. 
rename variables FL24E = FL24E_o.

rename variables FL25A = FL25A_o. 
rename variables FL25B = FL25B_o. 
rename variables FL25C = FL25C_o. 
rename variables FL25D = FL25D_o. 
rename variables FL25E = FL25E_o.

rename variables FL27A = FL27A_o. 
rename variables FL27B = FL27B_o. 
rename variables FL27C = FL27C_o. 
rename variables FL27D = FL27D_o. 
rename variables FL27E = FL27E_o.

if (FL28 = 1) FL24A = 3.
if FL24A_o = "7" FL24A = 1.
if FL24A_o = "5" FL24A = 2.
variable labels FL24A "Child identities bigger of two numbers: 7-5".
value labels FL24A
 1 "Child correctly identifies number 7"
 2 "Child didnt identify correct number"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL24B = 3.
if FL24B_o = "24" FL24B = 1.
if FL24B_o = "11" FL24B = 2.
if FL24B = 3 and FL24B_o <> "Z" and FL24B_o <> " "  FL24B = 2.
variable labels FL24B "Child identities bigger of two numbers: 11-24".
value labels FL24B
 1 "Child correctly identifies number 24"
 2 "Child didnt identify correct number"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL24C = 3.
if FL24C_o = "58" FL24C = 1.
if FL24C_o = "49" FL24C = 2.
if FL24C = 3 and FL24C_o <> "Z" and FL24C_o <> " "  FL24C = 2.
variable labels FL24C "Child identities bigger of two numbers: 58-49".
value labels FL24C
 1 "Child correctly identifies number 58"
 2 "Child didnt identify correct number"
 3 "No attempt"
 7 "Inconsistent".


if (FL28 = 1) FL24D = 3.
if FL24D_o = "67" FL24D = 1.
if FL24D_o = "65" FL24D = 2.
if FL24D = 3 and FL24D_o <> "Z" and FL24D_o <> " "  FL24D = 2.
variable labels FL24D "Child identities bigger of two numbers: 65-67".
value labels FL24D
 1 "Child correctly identifies number 67"
 2 "Child didnt identify correct number"
 3 "No attempt"
 7 "Inconsistent".


if (FL28 = 1) FL24E = 3.
if FL24E_o = "154" FL24E = 1.
if FL24E_o = "146" FL24E = 2.
if FL24E = 3 and FL24E_o <> "Z" and FL24E_o <> " "  FL24E = 2.
variable labels FL24E "Child identities bigger of two numbers: 146-154".
value labels FL24E
 1 "Child correctly identifies number 67"
 2 "Child didnt identify correct number"
 3 "No attempt"
 7 "Inconsistent".

formats FL24A FL24B FL24C FL24D FL24E (f3.0).


if (FL28 = 1) FL25A = 3.
if FL25A_o = "5" or FL25A_o = "05" or FL25A_o = "O5" FL25A = 1.
if FL25A = 3 and FL25A_o <> "Z" and FL25A_o <> " "  FL25A = 2.
variable labels FL25A "Child adds numbers correctly: 3+2".
value labels FL25A
 1 "Child adds numbers correctly"
 2 "Child didnt add numbers correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL25B = 3.
if FL25B_o = "14" FL25B = 1.
if FL25B = 3 and FL25B_o <> "Z" and FL25B_o <> "Z1" and FL25B_o <> " "  FL25B = 2.
variable labels FL25B "Child adds numbers correctly: 8+6".
value labels FL25B
 1 "Child adds numbers correctly"
 2 "Child didnt add numbers correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL25C = 3.
if FL25C_o = "10" FL25C = 1.
if FL25C = 3 and FL25C_o <> "Z"  and FL25C_o <> " "  FL25C = 2.
variable labels FL25C "Child adds numbers correctly: 7+3".
value labels FL25C
 1 "Child adds numbers correctly"
 2 "Child didnt add numbers correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL25D = 3.
if FL25D_o = "19" FL25D = 1.
if FL25D = 3 and FL25D_o <> "Z"  and FL25D_o <> " "  FL25D = 2.
variable labels FL25D "Child adds numbers correctly: 13+6".
value labels FL25D
 1 "Child adds numbers correctly"
 2 "Child didnt add numbers correctly"
 3 "No attempt"
 7 "Inconsistent".


if (FL28 = 1) FL25E = 3.
if FL25E_o = "36" FL25E = 1.
if FL25E = 3 and FL25E_o <> "Z"  and FL25E_o <> " "  FL25E = 2.
variable labels FL25E "Child adds numbers correctly: 12+24".
value labels FL25E
 1 "Child adds numbers correctly"
 2 "Child didnt add numbers correctly"
 3 "No attempt"
 7 "Inconsistent".

formats FL25A FL25B FL25C FL25D FL25E (f3.0).

if (FL28 = 1) FL27A = 3.
if FL27A_o = "8" or FL27A_o = "08" or FL27A_o = "'8" or FL27C_o = "8" FL27A = 1.
if FL27A = 3 and FL27A_o <> "Z"  and FL27A_o <> " "  FL27A = 2.
variable labels FL27A "Child identifies next number: 5-6-7-X".
value labels FL27A
 1 "Child identifies next number correctly"
 2 "Child didnt identify next number correctly"
 3 "No attempt"
 7 "Inconsistent".


if (FL28 = 1) FL27B = 3.
if FL27B_o = "16" or FL27D_o = "16" FL27B = 1.
if FL27B = 3 and FL27B_o <> "Z"  and FL27B_o <> " "  FL27B = 2.
variable labels FL27B "Child identifies next number: 14-15-X-17".
value labels FL27B
 1 "Child identifies next number correctly"
 2 "Child didnt identify next number correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL27C = 3.
if FL27C_o = "30" or FL27E_o = "30" FL27C = 1.
if FL27C = 3 and FL27C_o <> "Z"  and FL27C_o <> " "  FL27C = 2.
variable labels FL27C "Child identifies next number: 20-X-40-50".
value labels FL27C
 1 "Child identifies next number correctly"
 2 "Child didnt identify next number correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL27D = 3.
if FL27D_o = "8" or FL27D_o = "08" FL27D = 1.
if FL27D = 3 and FL27D_o <> "Z"  and FL27D_o <> " "  FL27D = 2.
if FL27D_o = "16" FL27D = 7.
variable labels FL27D "Child identifies next number: 2-4-6-X".
value labels FL27D
 1 "Child identifies next number correctly"
 2 "Child didnt identify next number correctly"
 3 "No attempt"
 7 "Inconsistent".

if (FL28 = 1) FL27E = 3.
if FL27E_o = "14" FL27E = 1.
if FL27E = 3 and FL27E_o <> "Z"  and FL27E_o <> " "  FL27E = 2.
if FL27E_o = "30" FL27E = 7.
variable labels FL27E "Child identifies next number: 5-8-11-X".
value labels FL27E
 1 "Child identifies next number correctly"
 2 "Child didnt identify next number correctly"
 3 "No attempt"
 7 "Inconsistent".

formats FL27A FL27B FL27C FL27D FL27E (f3.0).

do if (FL28 = 1).
+ compute FL27_shift = 4.
+ if (FL27A_o = "3" or FL27A_o = "03") FL27_shift = 1.
+ if (FL27A_o = " ") FL27_shift = 3.
end if.
variable labels FL27_shift "Shift on variable FL27".
value labels  FL27_shift
1 "Safely shifted"
2 "Potential shift"
3 "Left blanc"
4 "Not shifted".
formats  FL27_shift (f1.0).
