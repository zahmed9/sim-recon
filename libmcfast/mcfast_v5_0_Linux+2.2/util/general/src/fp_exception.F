      subroutine fp_exception

      implicit none

#ifdef IRIX
#include <fsigfpe.h>

c     Abort on first occurrence of everything
      fsigfpe(FPE_DIVZERO).abort = 1
      fsigfpe(FPE_UNDERFL).abort = 1
      fsigfpe(FPE_OVERFL).abort = 1
      fsigfpe(FPE_INVALID).abort = 1

      call handle_sigfpes(
     *      FPE_ON,
     *      FPE_EN_OVERFL  +
     *      FPE_EN_DIVZERO + FPE_EN_INVALID,
     *      0,
     *      FPE_ABORT_ON_ERROR,
     *      0)
#endif

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:49  eugenio
cInitial revision
c
cRevision 1.3  1998/05/14 23:18:29  kutschke
cRemove floating underflow from list of stopping conditions.
c
c Revision 1.2  1997/03/10  22:07:31  garren
c add c$Log$
c add cRevision 1.1  2000/06/19 19:59:49  eugenio
c add cInitial revision
c add c
c add cRevision 1.3  1998/05/14 23:18:29  kutschke
c add cRemove floating underflow from list of stopping conditions.
c add c
c
