#ifndef TRK_CHANNEL_STRUCT_INC
#define TRK_CHANNEL_STRUCT_INC

c
c   Rob Kutschke, Sept 24, 1998.
c
c   Structure to identify a hit detector element, both logically
c   and as an electronics channel number.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change 
c            trk_channel_struct.h !
c
c   -------------------------------------------------------- 
c
c         devtype   !Type of device
c         devnum    !Device # of this type (i.e., may be more than 1)
c         devlayer  !Layer # (or plane #) in device
c         devwid(4) !Info within layer (wire, plane, strip, etc.)
c         channel   !Address of electronic channel (computed from above info)

      structure /trk_channel_struct/
        integer devtype
        integer devnum
        integer devlayer
        integer devwid(4)
        integer channel
      end structure

#endif
