      subroutine trig_get_pt_threshold(line, mult, thresh, 
     &  etamin,etamax,phimin,phimax,ier)

C----------------------------------------------------------------------
C-
C-   Purpose and Methods : parses pt threshold
C-
C-   Inputs  : line -- line to be parsed
C-   Outputs : mult -- the object multiplicity
C-             thresh--pt threshold
C-             eta_min,eta_max --  eta range
C-             phi_min, phi_max --phi range
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
      real etamin,etamax,phimin,phimax
      integer ier

c     character string handling variables
      integer list_num
      parameter (list_num = 14)
      integer list_type(list_num), list_read, list_item(list_num)
      character*10 clist_item(list_num)
c      "l1 term type pol  num mult pt thresh eta min max phi min max"
c       1   2     3   4    5  6    7     8   9   10  11  12  13
c       c   c     c   c    c    i  c    r     c   r    r  c   r   r
      data list_type 
     & /0,  0,    0,  0,   0,  1, 0,    3,   0,  3,   3, 0,  3,   3/
c     local variable
c     default values for eta and phi
      real etamin_default,etamax_default,phimin_default,phimax_default 
      integer ix
      real     x
      equivalence (ix,x)
C----------------------------------------------------------------------
      ier = 0
      etamin_default = 0.0
      etamax_default = 50.0
      phimin_default = 0.0
      phimax_default = 6.283185308
      call cmd_getitems(line, list_num, list_type,
     *                        list_read, list_item, clist_item, ier)
!     put some error handling here

      mult = list_item(6)      

      ix   = list_item(8)
      thresh = x

c     decode eta and phi, don't expect all parts
        etamin = etamin_default
        etamax = etamax_default
        phimin = phimin_default
        phimax = phimax_default
      if(list_read.ge.10) then
        ix = list_item(10)
        etamin = x
      endif
      if(list_read.ge.11) then
        ix = list_item(11)
        etamax = x
      endif
      if(list_read.ge.13) then
        ix = list_item(13)
        phimin = x
      endif
      if(list_read.ge.14) then
        ix = list_item(14)
        phimax = x
      endif
  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:39  garren
c add rcs log line
c
