* MICS5 NU-08.

* v02 - 2014-03-05.
* v03 - 2014-06-01.
* Diary products included in minimum dietary diversity changed to include BD7D, BD7E, BD8A, BD8N for both breastfed and non breastfed children.


* The 7 food groups as listed above are distributed here:
  1) Grains, roots, and tubers: BD8[B], BD8[C], and BD8[E]
  2) Legumes and nuts: BD8[M]
  3) Dairy products: BD7[D], BD7[E], BD8[A], and BD8[N]
  4) Flesh foods: BD8[I], BD8[J], and BD8[L]
  5) Eggs: BD8[K]
  6) Vitamin A rich fruits and vegetables: BD8[D], BD8[F], and BD8[G]
  7) Other fruits and vegetables: BD8[H] .

* Minimum dietary diversity:
     Children who received food from at least 4 of the 7 groups listed above.

* Minimum meal frequency:
    Currently breastfed:
       i) Age 6-8 months: Solid, semi-solid, or soft foods at least two times (BD11>=2)
      ii) Age 9-23 months: Solid, semi-solid, or soft foods at least three times (BD11>=3)
    Currently not breastfed: Solid, semi-solid, soft, or milk feeds at least four times:
      (BD7[D]N+BD7[E]N+BD11 >= 4) .

*   Currently not breastfed children who received at least 2 milk feeds:
      (BD7[D]N+BD7[E]N+BD8[A]N >= 2) .

* Minimum acceptable diet:
    Currently breastfed:
      Children who received the minimum dietary diversity and the minimum meal frequency as defined above
    Currently not breastfed:
      Children who received the minimum meal frequency, at least 2 milk feeds,
      and the minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]).

* Note that the algorithms presented here are for illustrative purposes only and do not take the full programming into account,
  e.g. dealing with ""Don't Know"" responses .

***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage >= 6 and cage <= 23).

* Recode system missing and missing to zero, even the variable is one digit 7 is 7+ not Incositent, so 7 is not included.
recode BD7DN BD7EN BD8AN BD11
  (sysmis, 8, 9 = 0) .

* Generate indicators.

* Minimum dietary diversity.
* The 7 food groups
1) Grains, roots, and tubers: BD8[B], BD8[C], and BD8[E]
2) Legumes and nuts: BD8[M]
3) Dairy products: BD7[D], BD7[E], BD8[A], and BD8[N]
4) Flesh foods: BD8[I], BD8[J], and BD8[L]
5) Eggs: BD8[K]
6) Vitamin A rich fruits and vegetables: BD8[D], BD8[F], and BD8[G]
7) Other fruits and vegetables: BD8[H].

compute grainsRootsTubers = any(1, BD8B, BD8C, BD8E) .
compute legumesNuts = any(1, BD8M) .
compute dairyProducts = any(1, BD7D, BD7E, BD8A, BD8N) .
compute fleshFoods = any(1, BD8I, BD8J, BD8L) .
compute eggs = any(1, BD8K) .
compute vitaminA = any(1, BD8D, BD8F, BD8G) .
compute other = any(1, BD8H) .

* Children who received food from at least 4 of the 7 groups listed above.
compute minimumDietaryDiversity = sum(grainsRootsTubers, legumesNuts, dairyProducts, fleshFoods, eggs, vitaminA, other) >= 4 .

* Adjusted minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]) for non breastfed children.
do if (BD3 = 1).
+ compute dairyProductsAdj = any(1, BD7D, BD7E, BD8A, BD8N) .
else .
+ compute dairyProductsAdj = any(1,                   BD8N) .
end if.

compute minimumDietaryDiversityAdj = sum(grainsRootsTubers, legumesNuts, dairyProductsAdj, fleshFoods, eggs, vitaminA, other) >= 4 .

* Minimum meal frequency .

*Currently breastfed.
do if (BD3 = 1) .
* Age 6-8 months: Solid, semi-solid, or soft foods at least two times (BD11>=2).
+ do if (cage >= 6 and cage <= 8).
+   compute minimumMealFrequency = BD11>=2 .
* Age 9-23 months: Solid, semi-solid, or soft foods at least three times (BD11>=3).
+ else .
+   compute minimumMealFrequency = BD11>=3 .
+ end if.
*Currently not breastfed.
else .
* Solid, semi-solid, soft, or milk feeds at least four times: (BD7[D]N+BD7[E]N+BD11 >= 4).
+ compute minimumMealFrequency = BD7DN+BD7EN+BD11 >= 4 .
* Currently not breastfed children who received at least 2 milk feeds.
* (BD7[D]N+BD7[E]N+BD8[A]N >= 2).
+ compute atLeast2MilkFeeds = BD7DN+BD7EN+BD8AN >= 2 .
end if.

* Minimum acceptable diet .
* Currently breastfed.
do if (BD3 = 1) .
* Children who received the minimum dietary diversity and the minimum meal frequency as defined above.
+ compute minimumAcceptableDiet = minimumDietaryDiversityAdj & minimumMealFrequency .
* Currently not breastfed.
else .
* Children who received the minimum meal frequency, at least 2 milk feeds, 
* and the minimum dietary diversity (as defined above, with the exception that food group 3 is limited to just BD8[N]).
+ compute minimumAcceptableDiet = minimumDietaryDiversityAdj & minimumMealFrequency & atLeast2MilkFeeds.
end if .

* Auxilary table variables .
recode cage
  (6,7,8 = 1)
  (9,10,11 = 2)
  (12 thru 17 = 3)
  (else = 4) into ageCat.
variable labels ageCat "Age".
value labels ageCat
  1 "6-8 months"
  2 "9-11 months"
  3 "12-17 months"
  4 "18-23 months".

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

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layerAll layerBreastefed layerNotBreastefed layerPercent
                       minimumDietaryDiversity minimumMealFrequency minimumAcceptableDiet 
                       atLeast2MilkFeeds childrenNo
           display = none
  /table   total [c]
         + hl4 [c]
         + ageCat [c]
         + hh7 [c]
         + hh6 [c]
         + melevel [c]
         + windex5 [c]
         + ethnicity [c]
   by
           layerBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [a]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [b]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [1], [c]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerNotBreastefed [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [a]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [b]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [2], [c]" ,f5.1]
             + atLeast2MilkFeeds      [s][mean, "At least 2 milk feeds [3]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
         + layerAll [c] > (
             layerPercent [c] > (
               minimumDietaryDiversity[s][mean, "Minimum dietary diversity [4], [a]" ,f5.1]
             + minimumMealFrequency   [s][mean, "Minimum meal frequency [5], [b]" ,f5.1]
             + minimumAcceptableDiet  [s][mean, "Minimum acceptable diet [c]" ,f5.1] )
           + childrenNo [s][validn,'Number of children age 6-23 months',f5.0] )
  /categories var=all empty=exclude missing=exclude
  /titles title=
     "Table NU.8: Infant and young child feeding (IYCF) practices"
     "Percentage of children age 6-23 months who received appropriate liquids and solid, semi-solid, or soft foods " +
     "the minimum number of times or more during the previous day, by breastfeeding status, " + surveyname
  caption=
     "[1] MICS indicator 2.17a - Minimum acceptable diet (breastfed)"
     "[2] MICS indicator 2.17b - Minimum acceptable diet (non-breastfed)"
     "[3] MICS indicator 2.14 - Milk feeding frequency for non-breastfed children"
     "[4] MICS indicator 2.16 - Minimum dietary diversity"
     "[5] MICS indicator 2.15 - Minimum meal frequency"
     "[a] Minimum dietary diversity is defined as receiving foods from at least 4 of 7 food groups: 1) Grains, roots and tubers, " +
         "2) legumes and nuts, 3) dairy products (milk, yogurt, cheese), 4) flesh foods (meat, fish, poultry and liver/organ meats), " +
         "5) eggs, 6) vitamin-A rich fruits and vegetables, and 7) other fruits and vegetables"
     "[b] Minimum meal frequency among currently breastfeeding children is defined as children who also received solid, semi-solid, " +
         "or soft foods 2 times or more daily for children age 6-8 months and 3 times or more daily for children age 9-23 months. " +
         "For non-breastfeeding children age 6-23 months it is defined as receiving solid, semi-solid or soft foods, or milk feeds, at least 4 times"
     "[c] The minimum acceptable diet for breastfed children age 6-23 months is defined as receiving the minimum dietary diversity and " +
         "the minimum meal frequency, while it for non-breastfed children further requires at least 2 milk feedings and that the " +
         "minimum dietary diversity is achieved without counting milk feeds"
    .

new file.
