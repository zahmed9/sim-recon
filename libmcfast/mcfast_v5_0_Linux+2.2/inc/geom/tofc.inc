c    Central time of flight detector.

c    All variables have the prefix "tofc_"

      integer max_tofc
      parameter (max_tofc = 10)

      integer tofc_num			!Number of tofc detectors

      common /tofc_comm1/
     *  tofc_num

      record /tofc_struct/ tofc_par	!TOF parameters

      common /tofc_comm2/
     *  tofc_par(max_tofc)
