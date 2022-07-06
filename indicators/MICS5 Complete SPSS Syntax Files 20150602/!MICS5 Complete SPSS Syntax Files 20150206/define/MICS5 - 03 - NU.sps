compute solidSemiSoft = any(1, BD8A, BD8B, BD8C, BD8D, BD8E, BD8F, BD8G, BD8H, BD8I, BD8J, BD8K, BD8L, BD8M, BD8N, BD8O).
variable labels solidSemiSoft "Receiving any solid, semi-solid or soft foods".

compute exclusivelyBreastfed = 0.
if (BD3 = 1 & not any(1, BD7A, BD7B, BD7C, BD7D, BD7E, BD7F)
            & not solidSemiSoft) exclusivelyBreastfed = 100.
variable labels exclusivelyBreastfed "Exclusive breastfeeding".

compute predominantlyBreastfed = 0.
if (BD3 = 1 & not any(1, BD7D, BD7E)
            & not solidSemiSoft) predominantlyBreastfed = 100.
variable labels predominantlyBreastfed "Predominant breastfeeding".