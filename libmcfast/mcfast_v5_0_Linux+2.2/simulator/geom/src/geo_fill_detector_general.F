      subroutine geo_fill_detector_general(keyword,nstart,char_name)
c
      implicit none
c
      character*(*) keyword
      character     char_name*(*)
c
      integer nstart
c
      integer len_char, lenocc
      integer i
      external lenocc
c
#include "detector_general.inc"
c
      len_char = lenocc(char_name)
c
      if (nstart .eq. 1) then
       det_general.name = char_name(1:len_char)
      end if
c
      if (nstart .eq. 2) then
       do i = 1,len_char
        if ( ichar(char_name(i:i)) .ge. ichar('a') .and. 
     &       ichar(char_name(i:i)) .le. ichar('z')) then
         char_name(i:i) = 
     &   char(ichar(char_name(i:i))+ichar('A')-ichar('a'))
        end if
       end do
       det_general.geom_id = char_name(1:len_char)
      end if
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:34  garren
c add rcs log line
c
