#include "siz_rect_struct.inc"

c    Silicon disk detectors (rectangular)

c    All variables have the prefix "siz_rect_"

      integer max_siz_rect
      parameter (max_siz_rect = 100)

      integer siz_rect_num                   !# of rect. z silicon detectors
      record /siz_rect_struct/ siz_rect_par  !Silicon disk parameters

      common /siz_rect_comm1/
     *  siz_rect_num,
     *  siz_rect_par(max_siz_rect)
