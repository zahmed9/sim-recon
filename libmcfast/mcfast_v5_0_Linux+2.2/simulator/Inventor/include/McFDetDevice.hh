#ifndef MCFDETDEVICE
#define MCFDETDEVICE
//the internal device numbers for inventor
//I'm going to use these in blocks of if statements to access the
//the device specific fortran commons.  

enum McFDetDevice {ABSORBER=0, ABSORBERXY, BEAMPIPE, CHERNKOV, DIPOLE, DRIFT,
                   DRIFTANODE, DRIFTCATHODE, DRIFTOFFSET,
                   CALORIMETER, CALORXY, FTRACK, FTRACKLYR, HITSONTRACK,
                   MATERIAL,MIXTURE,MUON,SILBAR,SIBLYR,SIBWAFER,
                   SILDISK, SIDLYR, SIDWEDGE, SILXY, SIXYLYR,
                   SILZRECT, SILZRECTLYR, SILZRECTWAFER,
                   SOLENOID, HEAD, NODEVICE};
#endif
