#ifndef DIPOLE_STRUCT
#define DIPOLE_STRUCT

c   Dipole magnet definition. Several of these can be defined at one time.
c
c   The magnet must lie along the z direction and the B field is assumed
c   to be in the (x,y) plane.

      structure /dipole_struct/
        real xmin		!xmin of gap
        real xmax		!xmax of gap
        real ymin		!ymin of gap
        real ymax		!ymax of gap
        real zmin		!zmin of magnetic region
        real zmax		!zmax of magnetic region
        real Bfield		!Magnitude of B in Tesla
        real dircos(3)		!Direction cosines of B field
        real ptkick		!Pt kick of magnet = 0.3*B*(zmax - zmin)
        character*40 name	!Name of device
        integer mat_fill        !material filling dipole's "gap"
        real thick_boun(6)      !thickness of boundries 
        integer mat_boun(6)     !materails for boundries
      end structure
#endif
