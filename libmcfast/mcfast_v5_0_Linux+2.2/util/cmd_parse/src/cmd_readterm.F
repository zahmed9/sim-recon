      integer function cmd_readterm(string)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Checks to see if anything was typed at the terminal without stopping
c  the program, i.e. it performs an asynchronous read.
c
c  Input: None
c
c  Output:
c    Function     integer variable
c                   0 for nothing typed in
c                  >0 for something typed in
c
c    string       character variable
c                 Character string typed in (blank if nothing or <CR>)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_asynck
      external cmd_asynck

c     Calling arguments
      character*(*) string

c     Local variables
      integer status, bytes
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      status = cmd_asynck(bytes)

      if(bytes .gt. 0) then
        read(5,5000) string
 5000   format(a)
        cmd_readterm = 1
      else
        string = ' '
        cmd_readterm = 0
      endif

      return
      end
