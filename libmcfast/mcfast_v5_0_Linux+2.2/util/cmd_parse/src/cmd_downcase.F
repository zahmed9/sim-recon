      subroutine cmd_downcase(string1, string2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Convert characters of string1 to lowercase and put them into string2
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Arguments
      character string1*(*), string2*(*)

c     Local variables
      integer i, len_min, ichr
      character chr*1
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Don't go past string boundaries
      len_min = min(len(string1), len(string2))
      do i=1,len_min
        chr = string1(i:i)
        ichr = ichar(chr)
        if(chr.ge.'A' .and. chr.le.'Z') ichr = ichr + 32
        string2(i:i) = char(ichr)
      enddo

      if(len_min .lt. len(string2)) string2(len_min+1:) = ' '

      return
      end
