* Encoding: windows-1252.
 * Households that received social transfers or benefits in the last 3 months: ST4A, ST4B, ST4C, ST4D, or ST4X=100, 101, 102, or 103 or, for any member age 5-24, ED12=1 or ED14=1)

***.

* v02 - 2019-08-28. Last modified to reflect tab plan changes as of 25 July 2019.
* v03 - 2020-04-21  Labels in French and Spanish have been removed.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

include "CommonVarsHH.sps".

select if (HH46=1).

compute Socialtransfer1=0.
if (ST4U$1=1 and ST4N$1<=3) Socialtransfer1=100.
variable labels Socialtransfer1 "Assistance type 1".

compute Socialtransfer2=0.
if (ST4U$2=1 and ST4N$2<=3) Socialtransfer2=100.
variable labels Socialtransfer2 "Assistance type 2".

compute Socialtransfer3=0.
if (ST4U$3=1 and ST4N$3<=3) Socialtransfer3=100.
variable labels Socialtransfer3 "Assistance type 3".

compute SocialtransferPension=0.
if (ST4U$4=1 and ST4N$4<=3) SocialtransferPension=100.
variable labels SocialtransferPension "Any retirement pension	".

compute SocialtransferOther=0.
if (ST4U$5=1 and ST4N$5<=3) SocialtransferOther=100.
variable labels SocialtransferOther "Any other external assistance program".

save outfile= "tmpHH.sav"
 /keep HH1 HH2 Socialtransfer1 Socialtransfer2 Socialtransfer3 SocialtransferPension SocialtransferOther HHSEX HHAGEy.

new file.

get file= 'hl.sav'.

match files
  /file = *
  /table = "tmpHH.sav"
  /by HH1 HH2.

* only for children age 5 - 24 who are attending primary or higher school during current school year.
do if ((HL6>=5 and HL6<=24) and (ED10A>=1 and ED10A<8)).
+ compute EDsupport=0.
+ if (ED12=1 or ED14=1) EDsupport=1.
end if.

aggregate
  /break   = HH1 HH2
  /nEDsupport  = sum(EDsupport).

compute EDsupport=0.
if nEDsupport>0  EDsupport=100.
variable labels EDsupport "School tuition or school related other support for any household member age 5-24 years attending primary school or higher".

compute any=0.
if (Socialtransfer1=100 or Socialtransfer2=100 or Socialtransfer3=100 or SocialtransferPension=100 or SocialtransferOther=100 or EDsupport=100) any=100.
variable labels any "Any social transfers or benefits [1]".

compute none=0.
if (any=0) none=100.
variable labels none "No social transfers or benefits".

select if (HL6 <18).

weight by hhweight.

compute layer1 = 0.
variable labels layer1 " ".
value labels layer1 0 "Percentage of children living in households receiving specific types of support in the last 3 months:".

compute nhh = 1.
variable labels  nhh "Number of children under age 18".
value labels nhh 1 " ".

compute total = 1.
variable labels  total "Total".
value labels total 1 " ".

* Ctables command in English.
ctables
  /vlabels variables = layer1
           display = none
  /table   total [c]
         + HHSEX [c]
         + HH6 [c]
         + HH7 [c]
         + HHAGEy [c]
         + helevel [c]
         + ethnicity [c]
         + windex5 [c]
   by 
            layer1 [c] > 
           (Socialtransfer1 [s] [mean '' f5.1] 
         + Socialtransfer2 [s] [mean '' f5.1] 
         + Socialtransfer3 [s] [mean '' f5.1] 
         + SocialtransferPension [s] [mean '' f5.1] 
         + SocialtransferOther [s] [mean '' f5.1]
         + EDsupport [s] [mean '' f5.1] )
         + any [s] [mean '' f5.1]
         + none [s] [mean '' f5.1]
         + nhh [s] [count '' f5.0] 
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
    "Table EQ.2.7: Coverage of social transfers and benefits: Children in all households"
    "Percentage of children under age 18 living in households that received social transfers or benefits in the last 3 months, by type of transfers or benefits, " + surveyname
   caption =
     "[1] MICS indicator EQ.5 - Children in the households that received any type of social transfers".

new file.

erase file "tmpHH.sav".
