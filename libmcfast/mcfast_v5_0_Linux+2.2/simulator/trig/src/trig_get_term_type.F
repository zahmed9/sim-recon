      subroutine trig_get_term_type(type,term_type,ier)
C----------------------------------------------------------------------
C-
C-   Purpose and Methods : Returns the term type
C-
C-   Inputs  : type -- type string from input term line
C-   Outputs : term_type -- integer relating to term type
C-   Controls:
C-
C-   Created  28-FEB-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
      implicit none
#include "trig_term_index.params"
C Input:
      character*5  type
C Output
      integer term_type
      integer ier
C----------------------------------------------------------------------
      ier = 0
      call cmd_upcase(type,type)
      if (type.eq.'MUON') then
        term_type = muon
      elseif(type.eq.'TRACK') then
        term_type = track
      elseif(type.eq.'VERTE') then
        term_type = vertex
      elseif(type.eq.'CALJT') then
        term_type = caljt
      elseif(type.eq.'CALEM') then
        term_type = calem
      elseif(type.eq.'CALSCET') then
        term_type = calscet
      elseif(type.eq.'CALMET') then
        term_type = calmet
      elseif(type.eq.'USER ') then
        term_type = user
      elseif(type.eq.'FANGL') then
        term_type = fangl
      else
        term_type = -1
        ier = -1
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
