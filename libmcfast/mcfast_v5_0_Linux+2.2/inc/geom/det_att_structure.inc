*
*       detector attribute structure
*
      integer it_opaque, it_wireframe, it_transparent, it_invisible
      integer it_cutaway
      parameter (it_opaque=1, it_wireframe=2, it_transparent=4, 
     +  it_invisible=8, it_cutaway=16)

      structure /color_s/
        real r
        real g
        real b
      end structure

      structure /det_att_s/
        record /color_s/ color
        integer visible
        real trans
      end structure
      record /det_att_s/ att(nmxdet_id)

      record /color_s/
     +  white,
     +  green,yellow,orange,red,magenta,cyan,blue,
     +  dkgreen,dkyellow,dkorange,dkred,dkmagenta,dkcyan,dkblue,
     +  ltgreen,ltyellow,ltorange,ltred,ltmagenta,ltcyan,ltblue
      common /det_att_c/ 
     +  white,
     +  green,yellow,orange,red,magenta,cyan,blue,
     +  dkgreen,dkyellow,dkorange,dkred,dkmagenta,dkcyan,dkblue,
     +  ltgreen,ltyellow,ltorange,ltred,ltmagenta,ltcyan,ltblue,
     +  att
