#ifndef TRACK_FORWARD_STRUCT_H
#define TRACK_FORWARD_STRUCT_H

/*

   Rob Kutschke, Oct. 23, 1998.

   Output of tracks fitted using the f parameterization.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            track_forward_struct.inc !

   --------------------------------------------------------

*/


#include "const.h"
#include "ftrack_struct.h"

typedef struct Track_forward_s{
  ftrack_s  f;              /* Track parameters. */
  DFLOAT    mass;           /* Mass used in fit. */
  DFLOAT    cov[5][5];      /* Covariance matrix of f. */
  int       ihep;           /* index into hepevt common */
  int       icov;           /* 0 ==> covariance matrix not defined
                               1 ==> covariance matrix defined
                               2 ==> defined, but no momentum information
			       */
} track_forward_s;

typedef struct Track_forward_s *Track_forward_p;
#endif
