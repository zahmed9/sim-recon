      SUBROUTINE trig_define_trigger(line,bitnumber,level,ier)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods :
C-
C-   Inputs  : Trigger programming
C-   Outputs : Assigned bitnumber and commons
C-   Controls:
C-
C-   Created  22-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_index.params"
#include "trig_l1_terms.params"
#include "trig_l2_terms.params"
#include "trig_term_struct.inc"
#include "trig_bit_struct.inc"
#include "trig_l1_bits.inc"
#include "trig_l1_terms.inc"
#include "trig_l2_bits.inc"
#include "trig_l2_terms.inc"
c     Inputs
      character*(*) line
c     Outputs
      integer ier
      integer bitnumber
      integer level

c     local variables
      integer last_l1_bit
      logical use
      integer iloop

c     character string handling variables
      integer list_num
      parameter (list_num = 5)
      integer list_type(list_num), list_read, list_item(list_num)
      character*30 clist_item(list_num)
c     the line will have the form "l1 define num name use"
c                                   1   2     3   4    5
c                                   c   c     I   c    c
      data list_type                /0, 0,    1,  0,   0/

      save last_l1_bit

      integer lenocc
      external lenocc
C----------------------------------------------------------------------
      ier = 0  !Everything's ok so far
C
C ****  call the string parser
C
      call cmd_getitems(line, list_num, list_type,
     *                        list_read, list_item, clist_item, ier)

      if(ier.ne.0) goto 999

      do iloop = 1, list_read
        call cmd_upcase(clist_item(iloop),clist_item(iloop))
      enddo

      bitnumber = list_item(3)

      use=.false.  !set up the use flag
      if (clist_item(5).eq.'USE') use= .true.

      if (clist_item(1)(1:lenocc(clist_item(1))).eq.'L1') then
        if (bitnumber.ge.l1trig_bits_max) then
            ier = -5
            bitnumber = -1000
            return
        endif
        if(trig_l1_bits(bitnumber).trig_bit.eq.bitnumber) then
        write (6,100)trig_l1_bits(0).trig_bit
 100    format( ' trig_define_trigger',i2)   
           ier = - 6
           bitnumber = -1000
           return
        endif        
        trig_l1_bits(bitnumber).trig_bit = bitnumber
        trig_l1_bits(bitnumber).trig_name = clist_item(4)
        trig_l1_bits(bitnumber).use_trigger = use
        trig_l1_bits(bitnumber).ref_bit = 0 ! no reference bit for level1

        level = level1
        last_l1_bit = bitnumber  !remember the last level 1 bit

      elseif (clist_item(1)(1:lenocc(clist_item(1))).eq.'L2') then
        if (bitnumber.ge.l2trig_bits_max) then
            ier = -7
            bitnumber = -1000
            return
        endif
c Have we seen this trigger bit before?
        if(trig_l2_bits(bitnumber).trig_bit.eq.bitnumber) then 
           ier = - 8
           bitnumber = -1000
           return
        endif                
        trig_l2_bits(bitnumber).trig_bit = bitnumber
        trig_l2_bits(bitnumber).trig_name = clist_item(4)
        trig_l2_bits(bitnumber).use_trigger = use
        trig_l2_bits(bitnumber).ref_bit = last_l1_bit ! reference to level1

        level = level2

      endif

  999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:37  garren
c add rcs log line
c
