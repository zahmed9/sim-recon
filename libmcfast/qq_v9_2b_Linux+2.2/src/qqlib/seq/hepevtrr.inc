*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:50  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:33  zfiles
* first version of qqlib in CVS
*
*
*
* hepevtrr.inc
*
FLD     81 1 HEPEVT event
INTEGER   30                      0   NEVHEP Event #
INTEGER   12                      0   NHEP
INTEGER   12                      0   NFHEP

FLD     82 1 HEPEVT generated track info
INTEGER    9                      0   ISTHEP
INTEGER   17                  65536   IDHEP
INTEGER   10                      0   ID2HEP

FLD     83 1 HEPEVT mother list
INTEGER   12                      0   JMOHEP(1)
INTEGER   12                      0   JMOHEP(2)

FLD     84 1 HEPEVT daughter list
INTEGER   12                      0   JDAHEP(1)
INTEGER   12                      0   JDAHEP(2)

FLD     85 1 HEPEVT generated 4-vector and mass (GeV)
REAL      31  1.E4       1000000000  PHEP(1)
REAL      31  1.E4       1000000000  PHEP(2)
REAL      31  1.E4       1000000000  PHEP(3)
REAL       1  1.                  0  PHEP(4) Energy
REAL      31  1.E5       1000000000  PHEP(5) Mass

FLD     86 1 HEPEVT generated vertex (mm)
REAL      31  1.E5       1000000000  VHEP(1)
REAL      31  1.E5       1000000000  VHEP(2)
REAL      31  1.E5       1000000000  VHEP(3)
REAL      30  1.E5                0  VHEP(4) c*Time

FLD     87 1 Pointer from HEPEVT to final state
INTEGER   12                      0  IBHEP

FLD     88 1 Pointer from final state to HEPEVT
INTEGER   12                      0  IFHEP
