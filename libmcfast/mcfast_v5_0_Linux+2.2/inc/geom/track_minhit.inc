#ifndef TRACK_MINHIT_INC
#define TRACK_MINHIT_INC

c
c
c   Rob Kutschke, Oct. 20, 1998.
c
c   Minimum hit requirements for track to be fitted.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            track_minhit.h !
c
c   --------------------------------------------------------
c

      structure /track_minhit_struct/
        integer all        !Min. # of hits
        integer z          !Min. # of hits with z info
        integer svx        !Min. # of silicon hits
      end structure

      record /track_minhit_struct/ trk_minhit

      common/trk_minhit1/
     *  trk_minhit

#endif
