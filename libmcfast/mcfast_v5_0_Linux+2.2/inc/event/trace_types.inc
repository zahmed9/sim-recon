#ifndef TRACE_TYPE
#define TRACE_TYPE


c
c   Rob Kutschke, Sept 24, 1998.
c
c     Definitions of trace types.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change 
c            trace_types.h !
c
c   -------------------------------------------------------- 
c


      integer jtrace_rplane
      integer jtrace_zplane
      integer jtrace_cone
      integer jtrace_prod
      integer jtrace_decay
      integer jtrace_pair
      integer jtrace_absorb
      integer jtrace_calor
      integer jtrace_shower
      integer jtrace_dummy
      integer jtrace_scat

      parameter (jtrace_rplane    =  1)  !Radial plane
      parameter (jtrace_zplane    =  2)  !Z plane
      parameter (jtrace_cone      =  3)  !Cone
      parameter (jtrace_prod      =  4)  !Production
      parameter (jtrace_decay     =  5)  !Decay in flight
      parameter (jtrace_pair      =  6)  !Pair production
      parameter (jtrace_absorb    =  7)  !Absorption
      parameter (jtrace_calor     =  8)  !Calorimeter face
      parameter (jtrace_shower    =  9)  !shower conversion point
      parameter (jtrace_dummy     = 10)  !Dummy point
      parameter (jtrace_scat      = 11)  !Scattering event

#endif
