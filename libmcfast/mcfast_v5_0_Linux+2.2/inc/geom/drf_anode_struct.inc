c   Drift chamber anode layer definition.
c
c   Resolution is given by the formula
c
c      sigma = a + b*x + c*x^2
c
c   where x = |drift|/max_drift
c
c         nwire		!Number of wires
c         lstereo	!FALSE ==> axial wire
c			!TRUE  ==> stereo wire
c         readout	!-1 ==> Readout from zmin side
c			!+1 ==> Readout from zmax side
c         cathode	!Corresponding cathode layer (0 if none)
c         radius	!Radius at Z = Zmax
c         rcenter	!Radius at center of wire
c         phi0		!Phi of wire 0
c         cell_offset	!Nom. phi offset wrt layer 1 in cell units
c         stereo_offset	!Nom. ster. offset in cell units (Zmin to Zmax)
c         offset(3)	!(x,y,z) offsets relative to nominal
c         dircos(3)	!(x,y,z) dir. cosines relative to nominal
c         zmin		!Zmin
c         zmax		!Zmax
c         cell_height	!Radial height of cell
c         cell_width	!Width of cell
c         cell_phi	!Width of cell in phi
c         sag		!Sag of wire at center (sag > 0)
c         tau		!Stereo angle (calc. from stereo_offset)
c         tant		!Tan(tau)
c         eff_hit	!Hit efficiency
c         eff_dedx	!dE/dx efficiency (after hit)
c         siga		!a term in res formula
c         sigb		!b term in res formula
c         sigc		!c term in res formula
c         nchan         !# of electronic channels in this layer
c         chan0         !Channel number corresponding to wire 0
c


      structure /drf_anode_struct/
        integer nwire
        logical lstereo
        integer readout
        integer cathode
        real radius
        real rcenter
        real phi0
        real cell_offset
        real stereo_offset
        real offset(3)
        real dircos(3)
        real zmin
        real zmax
        real cell_height
        real cell_width	
        real cell_phi
        real sag
        real tau
        real tant
        real eff_hit
        real eff_dedx
        real siga
        real sigb
        real sigc
        integer nchan
        integer chan0
      end structure
