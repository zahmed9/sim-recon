#ifndef CERN_PROTOTYPES_H
#define CERN_PROTOTYPES_H

/* 
 * Prototypes for some of the functions in cernlib.
 *
*/

float prob_( const float *chi, const int *ndof);

void ucopy_ ( void *p1, void*p2, const int *n);

void vzero_ ( void *p, const int*n);

void hcdir_ ( char *dir, char *flags, const int l1, const int l2);

void hmdir_ ( char *dir, char *flags, const int l1, const int l2);

void hbook1_ ( int *id, char *title, 
               int *nbins, float *xlow, float *xhigh, float *vmx, int l1);

void hf1_ ( int *id, float *x, float *w);

#endif

/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:36  eugenio
 *  Initial revision
 *
 *  Revision 1.2  1998/11/11 03:36:59  kutschke
 *  Declare some more functions.
 *
 * Revision 1.1  1998/09/15  04:22:45  kutschke
 * New file.
 *
 *
 */





