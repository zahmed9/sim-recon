      integer function cmd_match(string, clist, nlist)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Returns the position of "string" in the list of strings "clist".
c   "string" can be abbreviated to the minimum required for uniqueness.
c
c  Input:
c
c   string    character variable
c             Character string whose occurrence we are looking for
c
c   clist     character array
c             List of strings we are searching for "string"
c
c   nlist     integer variable
c             Length of list
c
c  Output:
c
c              -1  ==> multiple matches
c               0  ==> no match
c             > 0  ==> position of string matched
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Arguments
      character*(*) string, clist(*)
      integer nlist

c     Local variables
      character upstring*80, ctest*80
      integer match, i, leng, clen, gmatch
      logical lmatch
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Convert strings to upper case and look for matches
      call cmd_upcase(string, upstring)
      leng = cmd_lenstr(upstring)
      match = 0
      lmatch = .false.
      do i=1,nlist
        call cmd_upcase(clist(i), ctest)
        if(ctest(:leng) .eq. upstring(:leng)) then
          clen = cmd_lenstr(ctest)
          if(clen .eq. leng) then
             gmatch = i
             lmatch = .true.
          else
             if(match .eq. 0) then
               match = i
             else
               match = -1
             endif
          endif
        endif
      enddo

c     Error if no match or multiple matches
      cmd_match = match
c     Special case exact match found
      if(lmatch) cmd_match = gmatch

      return
      end
