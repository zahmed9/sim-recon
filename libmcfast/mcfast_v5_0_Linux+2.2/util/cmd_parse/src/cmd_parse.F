      subroutine cmd_parse(in_string, nout, out_strings, error)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Extracts blank delimited strings from an input string and puts them
c   into an array returned to the user.
c
c   The parsing stops when a "!" character is encountered since it assumes
c   that the rest of the line is a comment.
c
c  in_string    character variable (read)
c               Input string to be parsed
c
c *nout         integer variable (read/write)
c               Input:  max number of strings to extract
c               Output: number of strings actually extracted
c
c *out_strings  character array (write)
c               List of extracted strings
c
c *error        integer variable (read/write)
c               0 ==> all strings extracted
c              >0 ==> number of strings that could not be extracted because
c                     the total number of strings exceeded nout.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Arguments
      character in_string*(*)
      integer nout, error
      character*(*) out_strings(*)

c     Local variables
      integer leng_in, i, num, leng_out, leng_comment, pos
      character chr*1
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      num = 0                          !Number of output strings

c     Read to end of string or to comment character
      leng_in  = len(in_string)
      leng_comment = index(in_string, '!')
      if(leng_comment .gt. 0) leng_in = min(leng_comment - 1, leng_in)

      leng_out = len(out_strings(1))   !Length of output string
      pos = 0                          !Current length of string being built
      error = 0                        !Number of overflow strings

c     Loop over input string, eliminating white space
      do i=1,leng_in
        chr = in_string(i:i)
        if(chr .ne. ' ') then

c     Start new output string
          if(pos .eq. 0) then
            pos = 1
            if(num .lt. nout) then
              num = num + 1
              out_strings(num) = ' '
            else
              error = error + 1
            endif

c     Add to existing output string
          else
            pos = pos + 1
          endif

          if(num.gt.0 .and. num.le.nout .and. pos.le.leng_out) then
            out_strings(num)(pos:pos) = chr
          endif

c     Blank ends the individual string
        else
          pos = 0
        endif

      enddo

c     Return number of extracted strings
      nout = num

      return
      end
