get file = 'ch.sav'.

weight by chweight.

compute total = 1.
variable label total "Number of children under 5".

do if (ari = 100).

+ recode CI10A (1 = 100) (else = 0) into ho.
+ variable label ho "Hospital".

+ recode CI10B (2 = 100) (else = 0) into hc.
+ variable label hc "Health centre".

+ recode CI10C (3 = 100) (else = 0) into di.
+ variable label di "Dispensary".

+ recode CI10D (4 = 100) (else = 0) into vi.
+ variable label vi "Village health worker".

+ recode CI10E (5 = 100) (else = 0) into mc.
+ variable label mc "MCH clinic".

+ recode CI10F (6 = 100) (else = 0) into mo.
+ variable label mo "Mobile/outreach clinic".

+ recode CI10G (7 = 100) (else = 0) into pr.
+ variable label pr "Private physician".

+ recode CI10H (8 = 100) (else = 0) into tr.
+ variable label tr "Traditional healer".

+ compute ot = 0.
+ if (CI10I = 9 or CI10J = 10 or CI10K = 11) ot = 100.
+ variable label ot "Other".

+ compute any = 0.
+ if (ho = 100 or hc = 100 or di = 100 or vi = 100 or mc = 100 or mo = 100 or pr = 100) any = 100.
+ variable label any "Any appropriate provider".

+ compute atotal = 1.
+ variable label atotal "Number of children with ARI".

end if.

tables
  /observation = ari ho hc di vi mc mo pr ot any
  /ftotal = tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by
           ari + total + ho + hc + di + vi + mc + mo + pr + ot + any + atotal
  /statistics
    mean(ari (f5.1) '')
    count(total (f5.0) '')
    mean(ho (f5.1) '')
    mean(hc (f5.1) '')
    mean(di (f5.1) '')
    mean(vi (f5.1) '')
    mean(mc (f5.1) '')
    mean(mo (f5.1) '')
    mean(pr (f5.1) '')
    mean(ot (f5.1) '')
    mean(any (f5.1) '')
    count(atotal (f5.0) '')
  /title
    "Table 25: Percentage of under-five children with acute respiratory infection in the last two weeks and treatment by health"
    "providers, Country, Year"
  /caption
    "World Summit for Children Goal => Number 24".
