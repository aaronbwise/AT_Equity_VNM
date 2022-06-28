* Encoding: windows-1252.
* Convert string to numeric.

*!!!! Run this syntax only once after exporting the data, as original variables are being changed!

get file = "fs.sav".

*correct FL20A and FL20B.
compute OldFL20A = FL20A.
compute OldFL20B = FL20B.
compute FL20A = 0.
compute FL20B = 0.

do if (FL28=1 and sysmis(OldFL20A)=0).
+ recode FL19W1 to FL19W69 (' ' ='0')('!' = '2')(else = copy).
+ value labels FL19W1 to FL19W69
 0 "CORRECT"
 1 "INCORRECT"
 2 "NOT REACHED".
end if.

alter type  FL19W1 to FL19W69 (f1.0).

**recode all values after 2 (previously !) to 2.
do repeat var = FL19W1 to FL19W69.
do if var = 2.
+ recode var to FL19W69 (else = 2).
end if.
end repeat.

do repeat var = FL19W1 to FL19W69.
do if var <> 2.
+ compute FL20A=FL20A+1.
end if.
do if var = 1.
+ compute FL20B=FL20B+1.
end if.
end repeat.

do if not (FL28=1 and sysmis(OldFL20A)=0).
recode FL20A FL20B (0 =sysmis)(else = copy).
end if.

delete variables OldFL20A OldFL20B.
execute.

save outfile = "fs.sav".
