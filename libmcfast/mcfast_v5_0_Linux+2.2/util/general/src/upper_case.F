
      subroutine upper_case(chr,chr_up)

      implicit none

c     Calling arguments :
c     Input
      character*(*) chr 
c     Output
      character*(*) chr_up

c     Local variables :
      integer lenchr, i, num_chr

      lenchr = len(chr)      
      do i = 1,lenchr
       num_chr = ichar(chr(i:i))
       if (num_chr .ge. 97 .and. num_chr .le. 122) then       
        chr_up(i:i) = char(num_chr-32)
       else
        chr_up(i:i) = chr(i:i)
       end if
      end do

      return
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:50  eugenio
cInitial revision
c
cRevision 1.3  1997/03/10 22:07:37  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:50  eugenio
cadd cInitial revision
cadd c
c
