      Subroutine MxABAtr ( na, nb, A, B, C )

C  Calculate the matrix product:    C = A B A^t  + C
C  in single precision, where:
C    B is an nb x nb matrix.
C    A is an na x nb matrix.
C    C is an na x na matrix.

      Implicit none

#include "const.inc"

C...............................................Formal declarations

      Integer     na, nb
      DFLOAT    A ( na, nb )
      DFLOAT    B ( nb, nb )
      DFLOAT    C ( na, na )

C...............................................Local storage

      Integer             i, j, k

C  scr is just some scratch space for the intermediate calculation.

      DFLOAT    scr ( 20, 20 )

C---------------------------------------------------------------------

C  First form the intermediate matrix scr = A B

      Do j=1,nb
        Do i=1,na
          scr(i,j) = 0.0
          Do k=1,nb
            scr(i,j) = scr(i,j) + A(i,k)*B(k,j)
          EndDo
        EndDo
      EndDo

C  Second get the result C = scr A^t = A B A^t

      Do j=1,na
        Do i=j,na
          c(i,j) = 0.
          Do k=1,nb
            C(i,j) = C(i,j) + scr(i,k)*A(j,k)
          EndDo
          C(j,i) = C(i,j)
        EndDo
      EndDo

      Return
      End
