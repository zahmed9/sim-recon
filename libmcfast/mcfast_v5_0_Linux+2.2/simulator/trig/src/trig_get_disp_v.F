      subroutine trig_get_disp_v(line, min_dist,ier) 

C----------------------------------------------------------------------
C-
C-   Purpose and Methods : parses forward angle terms
C-
C-   Inputs  : line -- line to be parsed
C-   Outputs : min_dist -- minimum distance from primary to secondary vertex
C-             ier  -- error code
C-   Controls:
C-
C-   Created  28-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
      character*(*) line
      real min_dist
      integer ier

c     character string handling variables
      integer list_num
      parameter (list_num = 6)
      integer list_type(list_num), list_read, list_item(list_num)
      character*10 clist_item(list_num)
c      "l1 term type polarity dist min"
c       1   2     3   4        5    6
c       c   c     c   c        c    r
      data list_type 
     & /0,  0,    0, 0, 0,   3/
c     local variable
      integer ix
      real     x
      equivalence (ix,x)
C----------------------------------------------------------------------
      ier = 0
      call cmd_getitems(line, list_num, list_type,
     *                        list_read, list_item, clist_item, ier)
!      put some error handling here

      ix   = list_item(6)
      min_dist = x

  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:38  garren
c add rcs log line
c
