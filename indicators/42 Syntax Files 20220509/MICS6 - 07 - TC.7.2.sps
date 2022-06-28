* Encoding: UTF-8.
***.
*V2. updated 7 September 2018.
* v03 - 2020-04-14. Labels in French and Spanish have been removed.
***.

* MICS6 TC-7.2.
* Children are distributed by the responses to MN39A/B. 

 * Children consuming:
- milk-based liquids only are: MN39=A and/or G AND MN39<>(B, C, D, F, H, I, X)
- non-milk-based liquids/items only are: MN39=B, C, D, F, H, I and/or X AND MN39<>(A, G) 
- "both" are those consuming at least one milk-based liquid and at least one non-milk-based liquid/item:  MN39=A and/or G AND MN39=B, C, D, F, H, I and/or X.
 * - "any" are those consuming any milk-based liquid and  non-milk-based liquid/item: MN39=A, B, C, D, F, G, H, I or X


* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'wm.sav'.

include "CommonVarsWM.sps".

select if (WM17 = 1).

weight by wmweight.

include 'define\MICS6 - 06 - TM.sps' .

select if (CM17 = 1).

* Calculate months since last birth IF last birth in last five years.
compute monthsSinceLastBirth = wdoi - wdoblc.
variable labels monthsSinceLastBirth "Months since last birth".

*Create a recoded months variable since last birth.
recode monthsSinceLastBirth (0 thru 11 = 1)(12 thru 24 = 2) into monthsSinceLastBirthGroups.
variable labels monthsSinceLastBirthGroups "Months since last birth".
value labels monthsSinceLastBirthGroups 
1 " 0-11 months" 
2 "12-23 months".

compute everBreastfed = MN36.
variable labels everBreastfed "Breastfeeding status".
value labels everBreastfed
1 "Ever breastfed"
2 "Never breastfed"
9 "Missing".

compute layer = 1.
value labels layer 
1 "Percentage of children who consumed:".

compute otherLiquids = 1.
value labels  otherLiquids 
1 "Consumed other than breastmilk:".

compute milk = 0.
if (MN39A = "A") milk = 100.
variable labels milk "Milk (other than breastmilk)".

compute water = 0. 
if (MN39B = "B") water = 100.
variable labels water "Plain water".

compute sugar = 0.
if (MN39C = "C") sugar = 100.
variable labels sugar "Sugar or glucose water".

compute gripe = 0.
if (MN39D = "D") gripe = 100.
variable labels gripe "Gripe water".

compute fruit = 0.
if (MN39F = "F") fruit = 100.
variable labels fruit "Fruit juice".

compute formula = 0.
if (MN39G = "G") formula = 100.
variable labels formula "Infant formula".

compute tea = 0.
if (MN39H = "H") tea = 100.
variable labels tea "Tea/Infusions/Traditional herbal preparations".

compute honey = 0.
if (MN39I = "I") honey = 100.
variable labels honey "Honey".

compute ors=0.
if ((MN39E = "E" or MN39J = "J")) ors = 100.
variable labels ors "Prescribed medicine/ ORS/Sugar-salt solutions".

compute other = 0.
if (MN39X = "X") other = 100.
variable labels other "Other".

compute milkbased = 0.
if ((MN39A = "A" or MN39G = "G")  and (MN39B <> "B" and MN39C <> "C" and  MN39D <> "D" and MN39F <> "F" and  MN39H <> "H"  and MN39I <> "I" and  MN39X <> "X")) milkbased = 100.

compute nonmilkbased = 0.
if ((MN39A <> "A" and MN39G <> "G")  and (MN39B = "B" or MN39C = "C" or  MN39D = "D" or   MN39F = "F" or  MN39H = "H"  or MN39I = "I" or  MN39X = "X")) nonmilkbased = 100.

compute both=0.
if ((MN39A = "A" or MN39G = "G")  and (MN39B = "B" or MN39C = "C" or  MN39D = "D" or  MN39F = "F" or MN39H = "H"  or MN39I = "I" or  MN39X = "X")) both = 100.

compute any=0.
if (MN39A = "A" or MN39G = "G" or MN39B = "B" or MN39C = "C" or  MN39D = "D" or  MN39F = "F" or  MN39H = "H"  or MN39I = "I" or  MN39X = "X") any = 100.

variable labels nonmilkbased "Non-milk based liquids".
variable labels milkbased "Milk-based liquids".
variable labels both "Both".
variable labels any "Any".

compute layer1 = 1.
value labels layer1 1 "Type[A] of liquids or items (not considering breastmilk) consumed in the first 3 days of life".

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

compute numChildren = 1.
value labels numChildren 1 "Number of most recent live-born children to women with a live birth in the last 2 years".

variable labels welevel "Mother’s education".
variable labels disability "Mother's functional difficulties".

* Ctables command in English.
ctables
  /format missing = "na" 
  /vlabels variables = numChildren layer layer1 
           display = none
  /table   total [c]
        + hh6 [c]
        + hh7 [c]
        + monthsSinceLastBirthGroups [c]
        + everBreastfed [c]
        + personAtDelivery1 [c]
        + $deliveryPlace [c]
        + welevel [c]
        + disability[c]
        + ethnicity [c]
        + windex5 [c]
   by
        layer [c] >( milk[s][mean '' f5.1] + water[s][mean '' f5.1] + sugar[s][mean '' f5.1] + gripe[s][mean '' f5.1] + fruit[s][mean '' f5.1]
                             + formula[s][mean '' f5.1] + tea[s][mean '' f5.1] + honey[s][mean '' f5.1] + ors[s][mean '' f5.1] + other[s][mean '' f5.1])
        + layer1 [c]> (milkbased [s][mean '' f5.1] + nonmilkbased [s][mean '' f5.1]+both [s][mean '' f5.1]+any [s][mean '' f5.1])
        + numChildren[c][count '' f5.0]  
  /categories variables=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table TC.7.2: Newborn feeding"
     "Percentage of last live-born children ever breastfed by consumption of breastmilk and other items, percentage receiving a prelacteal feed, and percentage of child " 
     "never breastfed by consumption of other items in the first 3 days after birth, " + surveyname
  caption=
        "[A] Milk-based liquids include milk (other than breastmilk) and infant formula. Non-milk-based include plain water, sugar or glucose water, gripe water, fruit juice, " +
        "tea/infusions/traditional herbal preparations, honey and 'other'. Note that prescribed medicine/ORS/sugar-salt solutions are not included in any category." .
		
new file.
