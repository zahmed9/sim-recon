#ifndef SOLENOID_STRUCT
#define SOLENOID_STRUCT

c   Solenoid magnet definition. Several of these can be defined at one time.
c
c   The magnet must lie along the z direction and the B field is assumed
c   to be along z.

      structure /solenoid_struct/
        real rmin		!rmin of magnetic region
        real rmax		!rmax of magnetic region
        real zmin		!zmin of magnetic region
        real zmax		!zmax of magnetic region
        real Bfield		!Signed magnitude of B in Tesla
        character*40 name	!Name of device
        integer mat_fill        !material filling solenoid area
        real thick_boun(4)      !boundries thickness at rmin...zmax
        integer mat_boun(4)     !materials at these boundries
      end structure
#endif
