c   Forward time of flight detector definition. Several of these can be
c   defined at one time, each with different coverages.
c
c   The definition is very simple and based on geometrical coverage for now.
c   It will serve until we have a better idea of what we need.

      structure /toff_struct/
        real eta_min		!Min eta
        real eta_max		!Max eta
        real zpos		!z position
        real radl		!Radiation length
        real tsig		!Time resolution in picoseconds
        character*40 name	!Name of device
      end structure
