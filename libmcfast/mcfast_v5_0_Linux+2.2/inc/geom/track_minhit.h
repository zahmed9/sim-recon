#ifndef TRACK_MINHIT_H
#define TRACK_MINHIT_H

/*

   Rob Kutschke, Oct. 20, 1998.

   Minimum hit requirements for track to be fitted.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            track_minhit.inc !

   --------------------------------------------------------

*/


typedef struct Track_minhit_struct{
        int all;                      /* Min. # of hits.             */
        int z;                        /* Min. # of hits with z info. */
        int svx;                      /* Min. # of silicon hits.     */
} trk_minhit_s;

extern struct trk_minhit1{
     trk_minhit_s trk_minhit;
} trk_minhit1_;

#endif
