#ifndef DEVTYPE
#define DEVTYPE

c
c   Rob Kutschke, Oct. 26, 1998.
c
c   Definitions of device types
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            devtype.inc !
c
c   --------------------------------------------------------
c

      integer jdev_silbarrel
      integer jdev_sildisk
      integer jdev_driftbarrel
      integer jdev_driftplane
      integer jdev_pixelbarrel
      integer jdev_pixelplane
      integer jdev_emcal
      integer jdev_hadcal
      integer jdev_muon
      integer jdev_silplane

      parameter (jdev_silbarrel    =  1)  !Barrel silicon
      parameter (jdev_sildisk      =  2)  !Forward silicon (circular z planes)
      parameter (jdev_driftbarrel  =  3)  !Barrel drift chamber
      parameter (jdev_driftplane   =  5)  !Forward drift plane
      parameter (jdev_pixelbarrel  =  6)  !Barrel pixel detector
      parameter (jdev_pixelplane   =  7)  !Forward pixel detector (rectangular)
      parameter (jdev_emcal        =  8)  !EM calorimeter
      parameter (jdev_hadcal       =  9)  !Hadron calorimeter
      parameter (jdev_muon         = 10)  !Muon detector
      parameter (jdev_silplane     = 11)  !Forward silicon (rectangle z planes)

#endif
