c    Dimensions of region enclosing tracking region

      structure /trk_region_struct/
        real xmin      !xmin of region
        real xmax      !xmax of region
        real ymin      !ymin of region
        real ymax      !ymax of region
        real zmin      !zmin of region
        real zmax      !zmax of region
      end structure

      record /trk_region_struct/ trk_reg
      common /trk_reg_comm1/
     *  trk_reg
