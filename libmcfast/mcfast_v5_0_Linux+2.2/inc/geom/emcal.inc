#include "emcal_struct.inc"

c    Electromagnetic calorimeters

c    All variables have the prefix "emcal_"
c    7/22/94  A.Boehnlein, added common for hits structure
c    7/18/96  Julia Yarba - removed common for hit structure

      integer max_emcal
      parameter (max_emcal = 40)

      integer emcal_num			!Number of emcal detectors

      common /emcal_comm1/
     *  emcal_num

      record /emcal_struct/ emcal_par	!Calorimeter parameters

      common /emcal_comm2/
     *  emcal_par(max_emcal)

