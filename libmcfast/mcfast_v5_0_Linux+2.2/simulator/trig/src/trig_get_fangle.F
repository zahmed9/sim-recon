      subroutine trig_get_fangle(line, mult, thresh, 
     &  impact_min,impact_max,ier)

C----------------------------------------------------------------------
C-
C-   Purpose and Methods : parses forward angle terms
C-
C-   Inputs  : line -- line to be parsed
C-   Outputs : mult -- the object multiplicity
C-             thresh--pt threshold
C-             impact_min,impact_max -- impact parameter range
C-             ier  -- error code
C-   Controls:
C-
C-   Created  28-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
      character*(*) line
      integer mult
      real thresh
      integer ithresh
      real impact_min,impact_max
      integer ier

c     character string handling variables
      integer list_num
      parameter (list_num = 11)
      integer list_type(list_num), list_read, list_item(list_num)
      character*10 clist_item(list_num)
c      "l1 term type polarity num mult pt thresh impact min max"
c       1   2     3   4        5  6    7      8     9   10   11
c       c   c     c   c        c  i  c    r      c  r    r  
      data list_type 
     & /0,  0,    0,  0, 0,   1, 0,    3,   0,  3,   3/
c     local variable
c     default values for impact parameter
      real impact_min_default,impact_max_default
      integer ix
      real     x
      equivalence (ix,x)
C----------------------------------------------------------------------
      ier = 0
      impact_min_default = 0.05
      impact_max_default = 2.0
      call cmd_getitems(line, list_num, list_type,
     *                        list_read, list_item, clist_item, ier)
!     put some error handling here

      mult = list_item(6)      

      ix   = list_item(8)
      thresh = x

c     decode impact parameter if specified
      impact_min = impact_min_default
      impact_max = impact_max_default
      if(list_read.ge.10) then
        ix = list_item(10)
        impact_min = x
      endif
      if(list_read.ge.11) then
        ix = list_item(11)
        impact_max = x
      endif
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:38  garren
c add rcs log line
c
