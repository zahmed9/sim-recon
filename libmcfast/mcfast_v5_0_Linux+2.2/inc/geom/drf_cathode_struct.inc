c   Drift chamber cathode layer definition.
c
c   Resolution is given by the formula
c
c      sigma = a + b*x + c*x^2
c
c   where x = drift/max_drift


      structure /drf_cathode_struct/
        integer nwir_z		!Number of strips from 0 - Zmax
        integer nwir_phi	!Phi segmentation
        integer anode		!Corresponding anode layer
        real delta_r		!Added to anode radius to get equiv. radius
        real zmin		!Zmin
        real zmax		!Zmax
        real cell_offset	!Rotation in in phi in cell units
        real eff_hit		!Hit efficiency
        real resa		!a term in res formula
        real resb		!b term in res formula
        real resc		!c term in res formula
        integer nchan           !# of channels in this layer
        integer chan0           !Channel number corresponding to 1st cathode
      end structure
