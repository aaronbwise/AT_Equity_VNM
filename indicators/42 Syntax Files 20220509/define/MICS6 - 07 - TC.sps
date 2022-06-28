* Encoding: windows-1252.
 * compute solidSemiSoft = any(1, BD8A, BD8B, BD8C, BD8D, BD8E, BD8F, BD8G, BD8H, BD8I, BD8J, BD8K, BD8L, BD8M, BD8N, BD8X).
 * variable labels solidSemiSoft "Receiving any solid, semi-solid or soft foods".

 * compute exclusivelyBreastfed = 0.
 * if (BD3 = 1 and not any(1, BD7A, BD7B, BD7C, BD7D, BD7E, BD7X)
            and not solidSemiSoft) exclusivelyBreastfed = 100.
 * variable labels exclusivelyBreastfed "Exclusive breastfeeding".

 * compute predominantlyBreastfed = 0.
 * if (BD3 = 1 and not any(1, BD7D, BD7E)
            and not solidSemiSoft) predominantlyBreastfed = 100.
 * variable labels predominantlyBreastfed "Predominant breastfeeding".

compute solidSemiSoft = any(1, BD8A, BD8B, BD8C, BD8D, BD8E, BD8F, BD8G, BD8H, BD8I, BD8J, BD8K, BD8L, BD8M, BD8N, BD8X).
variable labels solidSemiSoft "Receiving any solid, semi-solid or soft foods".

compute exclusivelyBreastfed = 0.
if (BD3 = 1 &  (BD7A=2 &  BD7B=2 &  BD7C=2 &  BD7D=2 &  BD7E=2 &  BD7X=2)
            & (BD8A=2 &  BD8B=2 &  BD8C=2 & BD8D=2 &  BD8E=2 &  BD8F=2 &  BD8G=2 &  BD8H=2 &  BD8I=2 &  BD8J=2 & BD8K=2 & BD8L=2 & BD8M=2 & BD8N=2 & BD8X=2 )) exclusivelyBreastfed = 100.
variable labels exclusivelyBreastfed "Exclusive breastfeeding".

compute predominantlyBreastfed = 0.
if (BD3 = 1 & (BD7D=2 &  BD7E=2)  & (BD8A=2 &  BD8B=2 &  BD8C=2 & BD8D=2 &  BD8E=2 &  BD8F=2 &  BD8G=2 &  BD8H=2 &  BD8I=2 &  BD8J=2 & BD8K=2 & BD8L=2 & BD8M=2 & BD8N=2 & BD8X=2 )) predominantlyBreastfed = 100.
variable labels predominantlyBreastfed "Predominant breastfeeding".
