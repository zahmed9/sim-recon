      FUNCTION LENOCC (CHV)
#define _OUTLIB_ 
      implicit none
C
C CERN PROGLIB# M507    LENOCC          .VERSION KERNFOR  4.21  890323
C ORIG. March 85, A.Petrilli, re-write 21/02/89, JZ
C T. Wenaus 22/08/1995.17:41 (Tue)   mod to handle '\0' terminators
C
C-    Find last non-blank character in CHV

      CHARACTER    CHV*(*)
      character zero*1
      byte bzero
      equivalence (zero,bzero)
      data bzero /0/
      save bzero
      integer n, jj, kk, lenocc

      N = LEN(CHV)

      DO 17  JJ= N,1,-1
      IF (CHV(JJ:JJ).NE.' '.and.chv(jj:jj).ne.zero) GO TO 99
   17 CONTINUE
      JJ = 0

   99 LENOCC = JJ
      do kk=1,jj
        if (chv(kk:kk).eq.zero) then
          lenocc = kk
          return
        endif
      enddo
      END

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:34  garren
c add rcs log line
c
