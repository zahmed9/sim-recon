c     Dimensions of region including all detectors

      structure /detector_region_struct/
        real xmin      !xmin of region
        real xmax      !xmax of region
        real ymin      !ymin of region
        real ymax      !ymax of region
        real zmin      !zmin of region
        real zmax      !zmax of region
      end structure

      record /detector_region_struct/ det_reg
      common /det_reg_comm1/
     *  det_reg
