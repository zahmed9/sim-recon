*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
#if defined(CLEO_VAX)
*CMZ :  1.04/00 04/03/94  16.24.27  by  Lynn Garren
*-- Author :
        function     translate_logical (logical_name,translation)

c       Craig Young             3-AUG-87

        implicit        none
        include         '($lnmdef)'
        include         '($ssdef)'


        integer*4       translate_logical
        character*(*)   translation
        character*(*)   logical_name

        integer*4       sys$trnlnm
        integer*4       status
        integer*4       attribute
        integer*4       ret_buf_len
        integer*4       n
        character*230   templog

        structure /item_list/
          integer*2     item_len
          integer*2     item_code /lnm$_string/
          integer*4     buffer_addr
          integer*4     ret_buffer_addr
          integer*4     end_items /0/
        end structure
        record /item_list/ items

        translation = ' '
        attribute = lnm$m_case_blind
        items.item_len = LEN(translation)
        items.buffer_addr = %loc(translation)
        items.ret_buffer_addr = %loc(ret_buf_len)
        call str$trim(templog,logical_name,n)

        status = sys$trnlnm ( attribute, 'LNM$PROCESS',
     -          templog(1:n),,items)
        if ( status .ne. ss$_normal ) then
          status = sys$trnlnm ( attribute, 'LNM$JOB',
     -          templog(1:n),,items)
          if ( status .ne. ss$_normal )
     -      status = sys$trnlnm ( attribute, 'LNM$SYSTEM',
     -          templog(1:n),,items)
        end if

        translate_logical = status
        return
        end
#endif
