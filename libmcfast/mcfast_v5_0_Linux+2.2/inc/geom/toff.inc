c    Forward time of flight detector.

c    All variables have the prefix "toff_"

      integer max_toff
      parameter (max_toff = 10)

      integer toff_num			!Number of toff detectors

      common /toff_comm1/
     *  toff_num

      record /toff_struct/ toff_par	!TOF parameters

      common /toff_comm2/
     *  toff_par(max_toff)
