** TABLE TO CHECK HOUSEHOLD CLUSTERS **.
get file ='hh.sav'.

ctables
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title = 'Household region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK HOUSEHOLD LISTING CLUSTERS **.
get file ='hl.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title =  'Household listing region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK WOMEN'S CLUSTERS **.
get file ='wm.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title = 'Womens region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK MEN'S CLUSTERS **.
get file ='mn.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Mens region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK CHILDREN'S CLUSTERS **.
get file ='ch.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Childrens region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK BIRTH HISTORY CLUSTERS **.
get file ='bh.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Birth history region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK FGM CLUSTERS **.
get file ='fg.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Female genital cutting: region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK ITN CLUSTERS **.
get file ='tn.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='ITNs region and type of place of residence by cluster'.

new file.

** TABLE TO CHECK MATERNAL MORTALITY CLUSTERS **.
get file ='mm.sav'.

ctables
  /mrsets countduplicates=yes
  /format empty=blank
  /table hh1[c] by hh6[s][mean,f5.1,range,f5.1]+hh7[s][mean,f5.1,range,f5.1]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /titles title='Maternal mortality: region and type of place of residence by cluster'.

new file.