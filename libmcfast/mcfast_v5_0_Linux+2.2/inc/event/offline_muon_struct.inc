#ifndef OFFLINE_MUON_STRUCT
#define OFFLINE_MUON_STRUCT

      integer ndet
      parameter (ndet = 10)

c     Structure of muon id info

      structure /offline_muon_struct/
        integer track        ! Track number in offline track list
        integer hep          ! Number in HEP list        
        integer hits(ndet)   ! Number of hits in each detector
        real Energy(ndet)    ! Energy at detector entrance
        real prob            ! Probability of muon ID
      end structure
#endif
