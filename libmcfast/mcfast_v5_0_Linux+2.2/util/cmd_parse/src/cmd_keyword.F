      subroutine cmd_keyword(in_string, out_string, pos)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Looks for the first blank delimited string in a character string.
c   The idea is that we are trying to extract a keyword from a line
c   of the form
c
c                keyword data_1 data_2 ... data_n
c
c   The position of the last letter of the keyword is returned so that the
c   user can pass the rest of the line to cmd_getitems.
c
c   The parsing stops when a "!" character is encountered since it assumes
c   that the rest of the line is a comment.
c
c
c  Inputs
c
c  in_string    character variable
c               Input string to be parsed
c
c  Outputs
c
c  out_string   character variable
c               Output string
c
c  pos          integer variable
c               Position of last character of out_string in in_string
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Arguments
      character in_string*(*)
      integer pos
      character out_string*(*)

c     Local variables
      integer leng_in, i, put, leng_out, leng_comment
      character chr*1
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Read to end of string or to comment character
      leng_in  = len(in_string)
      leng_comment = index(in_string, '!')
      if(leng_comment .gt. 0) leng_in = min(leng_comment - 1, leng_in)

      leng_out = len(out_string)       !Length of output string
      put = 0                          !Current length of string being built
      pos = 0
      out_string = ' '

c     Loop over input string, looking for beginning and end of first
c     blank delimited string
      do i=1,leng_in
        chr = in_string(i:i)
        if(chr .eq. ' ') then
          if(put .gt. 0) goto 1000
        else
          put = put + 1
          pos = i
          if(put .le. leng_out) out_string(put:put) = chr
        endif

      enddo

c     Only exit
 1000 return
      end
