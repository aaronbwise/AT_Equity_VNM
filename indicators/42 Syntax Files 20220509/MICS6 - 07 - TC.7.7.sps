* Encoding: UTF-8.
* MICS6 TC-7.7.
***.
* v02 - 2020-04-23. A new note has been inserted. Labels in French and Spanish have been removed.
***.

 * The 7 food groups as listed above are distributed here:.
 * 1) Breastmilk: BD3=1
2) Grains, roots, and tubers: BD8[B], BD8[C], and BD8[E]
3) Legumes and nuts: BD8[M]
4) Dairy products: BD7[D], BD7[E], BD8[A], and BD8[N]
5) Flesh foods: BD8[I], BD8[J], and BD8[L]
6) Eggs: BD8[K]
7) Vitamin A rich fruits and vegetables: BD8[D], BD8[F], and BD8[G]
8) Other fruits and vegetables: BD8[H]

 * Minimum dietary diversity:
Children who received food from at least 5 of the 8 groups listed above.

 * Minimum meal frequency:
Currently breastfed: 
  i) Age 6-8 months: Solid, semi-solid, or soft foods at least two times (BD11>=2)
 ii) Age 9-23 months: Solid, semi-solid, or soft foods at least three times (BD11>=3)
Currently not breastfed: Solid, semi-solid, soft, or milk feeds at least four times: (BD7[D]N+BD7[E]N+BD11 >= 4)

 * Currently not breastfed children who received at least 2 milk feeds:
(BD7[D]N+BD7[E]N+BD8[A]N >= 2)

 * Minimum acceptable diet:
Currently breastfed:
Children who received the minimum dietary diversity and the minimum meal frequency as defined above.
 * Currently not breastfed:
Children who received the minimum meal frequency, at least 2 milk feeds, and the minimum dietary diversity (as defined above, with the exception that food group 4 is limited to just BD8[N] to avoid double-counting).

 * Note that the algorithms presented here are for illustrative purposes only and do not take the full programming into account, e.g. dealing with "Don't know" responses.

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

include "CommonVarsCH.sps".

select if (UF17 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 23).

* Recode system missing and missing to zero, even the variable is one digit 7 is 7+ not Incositent, so 7 is not included.
recode BD7D1 BD7E1 BD8A1 BD9
  (sysmis, 8, 9 = 0) .

* Generate indicators.
recode BD3 (sysmis, 8, 9 = 2) .
* Minimum dietary diversity.
 * The 8 food groups as listed above are distributed here:.
 * 1) Breastmilk: BD3=1
2) Grains, roots, and tubers: BD8[B], BD8[C], and BD8[E]
3) Legumes and nuts: BD8[M]
4) Dairy products: BD7[D], BD7[E], BD8[A], and BD8[N]
5) Flesh foods: BD8[I], BD8[J], and BD8[L]
6) Eggs: BD8[K]
7) Vitamin A rich fruits and vegetables: BD8[D], BD8[F], and BD8[G]
8) Other fruits and vegetables: BD8[H].

compute breastmilk= any(1, BD3) .
compute grainsRootsTubers = any(1, BD8B, BD8C, BD8E) .
compute legumesNuts = any(1, BD8M) .
compute dairyProducts = any(1, BD7D, BD7E, BD8A, BD8N) .
compute fleshFoods = any(1, BD8I, BD8J, BD8L) .
compute eggs = any(1, BD8K) .
compute vitaminA = any(1, BD8D, BD8F, BD8G) .
compute other = any(1, BD8H) .

* Children who received food from at least 5 of the 8 groups listed above.
compute minimumDietaryDiversity = sum(breastmilk, grainsRootsTubers, legumesNuts, dairyProducts, fleshFoods, eggs, vitaminA, other) >= 5 .

* Adjusted minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]) for non breastfed children.
 * do if (BD3 = 1).
 * + compute dairyProductsAdj = any(1, BD7D, BD7E, BD8A, BD8N) .
 * else .
 * + compute dairyProductsAdj = any(1,                   BD8N) .
 * end if.

do if (BD3<> 1).
+compute minimumDietaryDiversityAdj = sum(grainsRootsTubers, legumesNuts, fleshFoods, eggs, vitaminA, other) >= 4 .
end if.

* Minimum meal frequency .

*Currently breastfed.
do if (BD3 = 1) .
* Age 6-8 months: Solid, semi-solid, or soft foods at least two times (BD9>=2).
+ do if (cage >= 6 and cage <= 8).
+   compute minimumMealFrequency = BD9>=2 .
* Age 9-23 months: Solid, semi-solid, or soft foods at least three times (BD9>=3).
+ else .
+   compute minimumMealFrequency = BD9>=3 .
+ end if.
*Currently not breastfed.
else .
* Solid, semi-solid, soft, or milk feeds at least four times: (BD7[D]1+BD7[E]1+BD9 >= 4).
+ compute minimumMealFrequency = BD7D1+BD7E1+BD9 >= 4 .
* Currently not breastfed children who received at least 2 milk feeds.
* (BD7[D]1+BD7[E]1+BD8[A]1 >= 2).
+ compute atLeast2MilkFeeds = BD7D1+BD7E1+BD8A1 >= 2 .
end if.

* Minimum acceptable diet .
* Currently breastfed.
do if (BD3 = 1) .
* Children who received the minimum dietary diversity and the minimum meal frequency as defined above.
+ compute minimumAcceptableDiet = minimumDietaryDiversity & minimumMealFrequency .
* Currently not breastfed.
else .
* Children who received the minimum meal frequency, at least 2 milk feeds, 
* and the minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]).
+ compute minimumAcceptableDiet = minimumDietaryDiversityAdj & minimumMealFrequency & atLeast2MilkFeeds.
end if .

compute childrenNo = 1.
variable labels childrenNo "Number of children age 6-23 months".
value labels childrenNo 1 "".

compute layerAll = 1.
do if (BD3 = 1).
+ compute layerBreastefed = 1.
else .
+ compute layerNotBreastefed = 1.
end if.

compute layerPercent  = 1.
compute total = 1.

variable labels layerAll ""
  /layerBreastefed ""
  /layerNotBreastefed ""
  /layerPercent ""
  /total "Total" .

value labels layerAll 1 "All"
  /layerBreastefed 1 "Currently breastfeeding"
  /layerNotBreastefed 1 "Currently not breastfeeding"
  /layerPercent 1 "Percent of children who received:"
  /total 1 " " .

* multiplay by 100 to obtain percents .
compute minimumDietaryDiversity = 100 * minimumDietaryDiversity .
compute minimumMealFrequency    = 100 * minimumMealFrequency .
compute minimumAcceptableDiet   = 100 * minimumAcceptableDiet .
compute atLeast2MilkFeeds       = 100 * atLeast2MilkFeeds .

variable labels caretakerdis "Mother's functional difficulties [D]".

* Ctables command in English.
ctables
  /vlabels variables = layerAll layerBreastefed layerNotBreastefed layerPercent
                       minimumDietaryDiversity minimumMealFrequency minimumAcceptableDiet 
                       atLeast2MilkFeeds childrenNo
           display = none
  /table   total [c]
         + hl4 [c]
         + hh6 [c]
         + hh7 [c]
         + ageCatz [c]
         + melevel [c]
         + caretakerdis[c]
         + ethnicity [c]
         + windex5 [c]
   by
           layerBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [1] [C]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerNotBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [2] [C]" ,f5.1]
             + atLeast2MilkFeeds      [s][mean, "At least 2 milk feeds [3]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerAll [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [4] [A]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [5] [B]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [C]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
  /categories variables=all empty=exclude missing=exclude
  /titles title=
     "Table TC.7.7: Infant and young child feeding (IYCF) practices"
     "Percentage of children age 6-23 months who received appropriate liquids and solid, semi-solid, or soft foods " +
     "the minimum number of times or more during the previous day, by breastfeeding status, " + surveyname
  caption=
     "[1] MICS indicator TC.39a - Minimum acceptable diet (breastfed children)"
     "[2] MICS indicator TC.39b - Minimum acceptable diet (non-breastfed children)"
     "[3] MICS indicator TC.40 - Milk feeding frequency for non-breastfed children"
     "[4] MICS indicator TC.41 - Minimum dietary diversity"
     "[5] MICS indicator TC.42 - Minimum meal frequency"
     "[A] Minimum dietary diversity is defined as receiving foods from at least 5 of 8 food groups: 1) breastmilk, 2) grains, roots and tubers, 3) legumes " 
          "and nuts, 4) dairy products (milk, infant formula, yogurt, cheese), 5) flesh foods (meat, fish, poultry and liver/organ meats), 6) eggs, 7) vitamin-A "
          "rich fruits and vegetables, and 8) other fruits and vegetables."															
     "[B] Minimum meal frequency among currently breastfeeding children is defined as children who also received solid, semi-solid, or soft foods "
          "2 times or more daily for children age 6-8 months and 3 times or more daily for children age 9-23 months. For non-breastfeeding children "
          "age 6-23 months it is defined as receiving solid, semi-solid or soft foods, or milk feeds, at least 4 times."
     "[C] The minimum acceptable diet for breastfed children age 6-23 months is defined as receiving the minimum dietary diversity and the "
          "minimum meal frequency, while it for non-breastfed children further requires at least 2 milk feedings and that the minimum dietary "
          "diversity is achieved without counting milk feeds." 
     "[D] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.

new file.
