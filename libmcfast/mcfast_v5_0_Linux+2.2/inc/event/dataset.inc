#ifndef DATASET
#define DATASET

*  -------------------------------------------------------------------------
*  Contains definition of a dataset
*  -------------------------------------------------------------------------

      integer lendat
      parameter (lendat = 120)

      structure /dataset/
        character*(lendat) file !File name
        integer anal            !0 if not analyzed, 1 if analyzed
        integer events          !Number of events in this dataset
        real sigma              !Cross section in file
        integer active          !0 if not active, 1 if active
      end structure
#endif
