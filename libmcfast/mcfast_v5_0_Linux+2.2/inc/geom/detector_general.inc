#ifndef DET_GENERAL_STRUCT
#define DET_GENERAL_STRUCT

      structure /det_general_struct/

       character*40 geom_id   ! tells whether geometry is forward or central
       character*40 name      ! detector's name

      end structure

#endif

      record /det_general_struct/ det_general

      common /det_general_comm/ det_general

