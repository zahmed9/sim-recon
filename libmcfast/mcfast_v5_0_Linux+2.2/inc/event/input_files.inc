*  -------------------------------------------------------------------------
*  Contains
*    1. List of signal input data sets to be read
*    2. List of background input data sets to be read
*  -------------------------------------------------------------------------

#include "dataset.inc"

      integer dtf_maxsig        !Max number of signal datasets
      integer dtf_maxback       !Max number of background datasets
      parameter (dtf_maxsig  = 100)
      parameter (dtf_maxback = 100)

      integer dtf_numsig        !# of signal files
      integer dtf_numback       !# of background files
      integer dtf_sig_current   !Currentsignal  dataset number
      integer dtf_back_current  !Current background dataset number

      record /dataset/ dtf_sig  !Signal files
      record /dataset/ dtf_back !Background files

      common/dtf_comm1/
     *  dtf_numsig,
     *  dtf_numback,
     *  dtf_sig_current,
     *  dtf_back_current,
     *  dtf_sig(dtf_maxsig),
     *  dtf_back(dtf_maxback)
