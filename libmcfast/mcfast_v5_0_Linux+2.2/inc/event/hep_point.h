#ifndef HEP_POINT_H
#define HEP_POINT_H

/*

   Rob Kutschke, Oct. 23, 1998.

   Arrays of pointers from the hep list into various track lists  

                                   Mike Procario  
                                   10 Apr 1995


   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            hep_point.inc !

   --------------------------------------------------------

*/

#define MAX_POINT MCF_NMXHEP

extern struct Hep_point{
  int hep_off[MAX_POINT];   /* Position in the offline track list. */
  int hep_cen[MAX_POINT];   /* Position in the central track list. */
  int hep_for[MAX_POINT];   /* Position in the forward track list. */
  int hep_gen[MAX_POINT];   /* Position in the generated track list. */
} hep_point_;

#endif
