#include "offline_partid_struct.inc"

c  Particle ID information for each offline reconstructed charged track

      integer pid_off_max
      parameter (pid_off_max = 400)        !Same as # of tracks ?????????

      integer pid_off_num       !Same as # of charged tracks
      record /offline_partid_s/ pid_off !Pid per track
      integer idm_pidof         ! alignment dummy
      common/pid_off_c/ pid_off_num, idm_pidof,
     *  pid_off(pid_off_max)
