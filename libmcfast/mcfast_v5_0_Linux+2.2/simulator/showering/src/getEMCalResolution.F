
      subroutine get_emcal_resol( index, aEM, bEM, aHAD, bHAD, em_had )

      implicit none

#include "emcal.inc"

      integer index
      real aEM, bEM, aHAD, bHAD, em_had

      aEM    = emcal_par(index).siga_em
      bEM    = emcal_par(index).sigb_em
      aHAD   = emcal_par(index).siga_had
      bHAD   = emcal_par(index).sigb_had
      em_had = emcal_par(index).em_had_ratio

      return
      end
