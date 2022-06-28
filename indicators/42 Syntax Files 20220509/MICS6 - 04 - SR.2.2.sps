* Encoding: UTF-8.
* MICS6 SR.2.2.

***.
* v01 - 2017-11-02.
* v03 - 2020-04-09. Table sub-title and footnote changed based on the latest tab plan. Labels in French and Spanish have been removed.

** Information on household and personal assets are obtained in the Household Characteristics module of the Household Questionnaire: 
   Television (HC9A), refrigerator (HC9B), agricultural land (HC15), farm animals/livestock (HC17), watch (HC10A), bicycle (HC10B), motorcycle or scooter (HC10C), animal-drawn cart (HC10D), 
    car or truck (HC10E), boat with a motor (HC10F), computer or tablet (HC11), mobile telephone (HC12), and bank account (HC19). Ownership of dwelling is based on responses to HC14.

** Additional household and personal assets should to be added to the questionnaires (for wealth index construction) and shown in this table.

** DK/Missing values are included in the denominators and households with missing information are considered not to own or have these assets
    However, a careful examination of the extent of missing values needs to be undertaken prior to the construction of this table. If DK/Missing cases exceed 5 percent, this should be shown in the table.

** Most of the information collected on household and personal assets are used in the construction of the wealth index.


***.

* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open household data file.
get file = 'hh.sav'.

* Select interviewed households.
select if (HH46 = 1).

* Weight the data by the household weight.
weight by hhweight.

* recode variables to 100/0 as we are going to calculate the mean.
* missing values are treated as recoded to 0.
recode hc9a hc9b hc9c hc10a hc10b hc10c hc10d hc10e hc10f hc10g hc11 hc12 hc15 hc17 hc19
     (1 = 100)
     (else = 0).

* producing variables for housing.
compute own    = (hc14 = 1) * 100 .
compute notown = (hc14 = 2 or hc14 = 6) * 100 .
compute rent   = (hc14 = 2) * 100 .
compute other  = (hc14 = 6) * 100 .
compute mis   = (hc14 = 9) * 100 .

variable labels
  own    "Owned by a household member"/
  notown "Not owned"/
  rent   "    Rented"/
  other  "    Other"/
  mis   "DK/Missing".

compute tot = 1.			
variable labels tot "".
value labels tot 1 "Total".

compute numHouseholds = 1.
variable labels numHouseholds "Number of households".
value labels numHouseholds 1 ' '.

variable labels
  hc9a 	"Television"/
  hc9b 	"Refrigerator"/
  hc9c 	"Country-specific items that run on electricity"/
  hc10a 	"Watch"/
  hc10b 	"Bicycle"/
  hc10c 	"Motorcycle or scooter"/
  hc10d 	"Animal-drawn cart"/
  hc10e 	"Car, truck, or van"/
  hc10f 	"Boat with a motor"/
  hc10g	"Country-specific items"/
  hc11 	"Computer or tablet [A]"/
  hc12	"Mobile telephone [A]"/
  hc15          "Agricultural land"/
  hc17         "Farm animals/Livestock" /
  hc19         "Bank account".

* producing the layers in tables.
compute layer1 = 0.
compute layer2 = 0.
compute layer3 = 0.
compute layer4 = 0.

value labels 
  layer1 0 "Percentage of households that own a"/
  layer2 0 "Percentage of households that own"   /
  layer3 0 "Percentage of households where at least one member owns or has a"/
  layer4 0 "Ownership of dwelling".

* Ctables command in English.
* For first table.
ctables
  /vlabels variables = layer1 layer2 layer3 layer4 tot display = none
  /format missing=' '
  /table 
         layer1 [c] >
            (hc9a [s][mean f5.1]
           + hc9b [s][mean f5.1]
           + hc9c [s][mean f5.1])
         + layer2 [c] >
            (hc15 [s][mean f5.1]
           + hc17 [s][mean f5.1])
         + layer3 [c] >
            (hc10a [s][mean f5.1]
           + hc10b [s][mean f5.1]
           + hc10c [s][mean f5.1]
           + hc10d [s][mean f5.1]
           + hc10e [s][mean f5.1]
           + hc10f [s][mean f5.1]
           + hc10g [s][mean f5.1]
           + hc11 [s][mean f5.1]
           + hc12 [s][mean f5.1]
           + hc19 [s][mean f5.1])
         + layer4 [c] >
           (own    [s][mean f5.1]
           + notown [s][mean f5.1]
           + rent   [s][mean f5.1]
           + other  [s][mean f5.1]
           + mis   [s][mean f5.1])
   by
           tot [c]
         + hh6 [c]
         + hh7 [c]
  /slabels visible = no
  /titles title =
     "Table SR.2.2: Household and personal assets"
     "Percentage of households by ownership of selected household and personal assets, and percent distribution by ownership of dwelling, by area of residence and region, " + surveyname 
      caption = "[A] See Table SR.9.2 for details and indicators on ICT devices in households".

* The second table.
ctables
  /vlabels variables = tot display = none    
  /table  numHouseholds[c][count]
    by
          tot[c]
        + hh6[c]
        + hh7[c]
  /slabels visible = no position=row
  /titles title =
     "Table SR.2.2: Household and personal assets"
     "Percentage of households by ownership of selected household and personal assets, and percent distribution by ownership of dwelling, by area of residence and region, " + surveyname 
      caption = "[A] See Table SR.9.2 for details and indicators on ICT devices in households".
		
new file.