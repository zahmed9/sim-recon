/*

   Rob Kutschke,  Mar. 20/97

   For a list of 4-vectors their covariance matrices, compute the
   sum of the 4 vectors and the sum of the covariance matrices.

   Calling arguments,
   int *n         - input  - the number of 4-vectors in the input list.
   int *first_dim - input  - the first dimension of the covariance matrix.
   float *pout    - output - the sum of the input 4-vectors.
   float *vout    - output - the 4x4 covariance matrix of the output 4-vector.
   float *pin_1   - input  - the first 4-vector in the list.
   float *vin_1   - input  - the 7x7 covariance matrix of the first 4-vector.
   float *pin_2   - input  - the next 4-vector in the list.
   float *vin_2   - input  - the 7x7 covariance matrix of the second 4-vector.
   float *pin_3   - input  - the next 4-vector in the list.
   float *vin_3   - input  - the 7x7 covariance matrix of the third 4-vector.
     .....

   The number of input 4-vectors can be any positive integer, so long as 
   the first argument correctly describes how many there are.

   The first argument is passed by reference in order to make this
   routine fortran callable.

   Here a 4-vector is assumed to be 4 contiguous floats.  The
   routine sum_4_vectors_wcov_d_ does the same operation for doubles.

   The input covariance matrices are fortran arrays dimensioned: 
   A(FIRST_DIM,N), where FIRST_DIM is the second argument and where N is
   at least 4.

   The output covariance matrix is 4x4.

   The sums are accumulated in a temporary variable so that constructions
   like the following will work:

   real*4 psum(4), p(4,n_max)
   call vzero( psum, 4)
   do i = 1, n
     call sum_4_vectors_wcov_f ( 2, psum, psum, p(1,i) )
   enddo
*/

#include <stdarg.h>
#define  DIM 4

void sum_4vec_cov_f_ ( int *n, int *first_dim,
                             float *pout,  float *vout, ... ){

   va_list ap;    /* Argument pointer for variable number of input args */
   float  *pi;   /* Pointer to next input 4-vector */
   float  *vi;   /* Pointer to next input covariance matrix */

   /* Temporaries to accumulate the sums. */
   float psum[DIM]      = {0., 0. };
   float vsum[DIM][DIM] = {0., 0., 0., 0.};
   float  *ps, *vs;

   /* Odds and ends. */
   int len_pout = 2*DIM;   
   int len_vout = 2*DIM*DIM;
   int      i, j, m;

   /* Initialize the variable number of argument stuff. */
   va_start ( ap, vout );

   /* Loop over pairs of 4-vector + covariance matrix. */
   for ( m = *n; m>0; m-- ){

      /* Get pointers to the next pair of arguments */
      pi = va_arg( ap, float *) ;
      vi = va_arg( ap, float *) ; 

      /* Increment sums */
      ps = (float *)psum;
      vs = (float *)vsum;
      for ( i = 0; i < DIM ; i++){
          *(ps++) += *(pi++) ;
          for (j = 0; j < DIM ; j++) *(vs++) += *(vi++) ;
          vi += (*first_dim)-DIM;
      }
   }

   /* Copy the sums to the output arrays. */
   ucopy_ ( psum, pout, &len_pout );
   ucopy_ ( vsum, vout, &len_vout );
 
   /* Clean up the variable number of argument stuff. */
   va_end(ap);

}
/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:59:46  eugenio
 * Initial revision
 *
 * Revision 1.1  1998/05/20 02:42:21  kutschke
 * New file.  Now file name matches routine name.
 *
 *
 */
