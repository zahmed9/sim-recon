#include "const.inc"
C
C  Contains info for least square fits
C
C  max_iter      Max number of iterations
C  max_del_chisq   Quit iterating when change in chisquare < CHDELF
C
c  nconf      # of constraints
c  ndegf      # of degrees of freedom
c  iterf      actual number of iterations used in fit
c  choldf     value of chisquare at last iteration
c  chif       final chisquare
      integer max_iter, nconf, ndegf, iterf
      DFLOAT max_del_chisq, choldf, chif
      common/kchi01/
     *  max_del_chisq, max_iter

      common/kchi02/
     *  choldf, chif, nconf, ndegf, iterf
