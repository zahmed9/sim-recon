c
c   Path information for a particle ---
c 
c       trace points for conversions and decays
c

#include "const.inc"

      integer PATH_LIST_WORD
      parameter (PATH_LIST_WORD = 4*INT_WORD)

      structure /path_list_struct/
        integer end_trace   ! tracing stopped 
        integer decay       ! particle decay
        integer shower      ! shower starts here
        integer convert     ! pair coversion 
      end structure
      
