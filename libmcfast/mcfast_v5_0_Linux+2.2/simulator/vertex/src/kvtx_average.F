      integer function kvtx_average(z1, vz1, z2, vz2,
     *                              z3, vz3, chisq)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Returns the weighted average of 2 vertices and the chisquare.
C    The vertices are assumed to be independent of each other.
C
C  Z1      real array (read)
C          (x,y,z) of first vertex
C
C  VZ1     real array (read)
C          3x3 covariance matrix of first vertex
C
C  Z2      real array (read)
C          (x,y,z) of second vertex
C
C  VZ2     real array (read)
C          3x3 covariance matrix of second vertex
C
C *Z3      real array (write)
C          (x,y,z) of averaged vertex
C
C *VZ3     real array (write)
C          3x3 covariance matrix of averaged vertex
C
C *CHISQ   real variable (write)
C          chisquare of combined vertex
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C   The solution is just a generalization of the formula for the weighted
C   sum of two scalers. It can be written, using a clever trick to reduce
C   the number of matrix inversions, as
C
C      z = (Vz1(inv) + Vz2(inv))(inv) * (Vz1(inv)*z1 + Vz2(inv)*z2)
C        = z1 + Vz1 * [Vz1 + Vz2](inv) * (z2 - z1)
C
C   The chisquare can be computed as (after some manipulation)
C
C     chisq = (z2 - z1)(t) * [Vz1 + Vz2](inv) * (z2 - z1)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  created 11/21/94 A. Boehnlein, from P. Avery CLEO routine KVAVRG

      implicit none
#include "const.inc"
C     External declarations
C       1. DSYNV2

C     Calling arguments
      DFLOAT z1(3), vz1(3,3), z2(3), vz2(3,3)
      DFLOAT z3(3), vz3(3,3), chisq

C     Local variables
      integer i, j, status, ifail
      DFLOAT dz(3), vtmp(3,3), vtmp1(3,3), vz(3,3)
      DFLOAT vtmpdz(3)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Compute [Vz1 + Vz2](inv)
      do 6 i=1,3
        do 5 j=1,i
          vtmp(j,i) = vz1(j,i) + vz2(j,i)
5       continue
6     continue
      vtmp(2,1) = vtmp(1,2)
      vtmp(3,1) = vtmp(1,3)
      vtmp(3,2) = vtmp(2,3)

      call dsynv2(vtmp, 3, 3, ifail)
      IF(ifail.ne.0) goto 9999

C     Compute dz = z2 - z1
      do 10 i=1,3
        dz(i) = z2(i) - z1(i)
10    continue

C     Calculate VTMPDZ = [Vz1 + Vz2](inv) * dz
C               VTMP1  = Vz1 * [Vz1 + Vz2](inv)
      do 20 i=1,3
        vtmpdz(i) = vtmp(1,i)*dz(1) + vtmp(2,i)*dz(2) + vtmp(3,i)*dz(3)
        vtmp1(i,1) = vz1(1,i)*vtmp(1,1) + vz1(2,i)*vtmp(2,1)
     *             + vz1(3,i)*vtmp(3,1)
        vtmp1(i,2) = vz1(1,i)*vtmp(1,2) + vz1(2,i)*vtmp(2,2)
     *             + vz1(3,i)*vtmp(3,2)
        vtmp1(i,3) = vz1(1,i)*vtmp(1,3) + vz1(2,i)*vtmp(2,3)
     *             + vz1(3,i)*vtmp(3,3)
20    continue

C     Calculate Vz3 = Vz1 * [Vz1 + Vz2](inv) * Vz2
C                   = VTMP1 * VZ2
C     Calculate as temporary array in case VZ3 is same as VZ1 or VZ2
      do 30 i=1,3
        vz(i,1) = vtmp1(i,1)*vz2(1,1) + vtmp1(i,2)*vz2(2,1)
     *          + vtmp1(i,3)*vz2(3,1)
        vz(i,2) = vtmp1(i,1)*vz2(1,2) + vtmp1(i,2)*vz2(2,2)
     *          + vtmp1(i,3)*vz2(3,2)
        vz(i,3) = vtmp1(i,1)*vz2(1,3) + vtmp1(i,2)*vz2(2,3)
     *          + vtmp1(i,3)*vz2(3,3)
30    continue

C     Calculate chisq = dz(t) * [Vz1 + Vz2](inv) * dz
C                     = DZ * VTMPDZ
      chisq = vtmpdz(1)*dz(1) + vtmpdz(2)*dz(2) + vtmpdz(3)*dz(3)

C     Calculate  z3 = z1 + Vz1 * [Vz1 + Vz2](inv) * (z2 - z1)
C                   = z1 + Vz1 * VTMPDZ
      do 40 i=1,3
        z3(i) = z1(i) + vz1(1,i)*vtmpdz(1) + vz1(2,i)*vtmpdz(2)
     *                + vz1(3,i)*vtmpdz(3)
40    continue

      call ucopy(vz, vz3, 3*3*FLOAT_WORD)

C     Normal return
      kvtx_average = 0
1000  return

C     Error return
9999  chisq = -1.
      kvtx_average = 1
      call vzero(z3, 3*FLOAT_WORD)
      call vzero(vz3, 3*3*FLOAT_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:12  garren
c add rcs log line
c
