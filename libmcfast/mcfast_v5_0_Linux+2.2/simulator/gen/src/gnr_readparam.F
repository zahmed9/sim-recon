      subroutine gnr_readparam
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Read commands to define internal generation of particles
c
c  input file format:
c            keyword value
c        or  keyword value1 value2 ...
c
c    where keyword is one of the variables that can be set
c
c  A whole series of reals, integers and strings can be read in. See the
c  routine cmd_getitems which is used below.
c

c  Author: Paul Avery  6-9-94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "gnr_params.inc"

      integer mlen
      parameter (mlen = 120)

c     Externals
      integer  cmd_match, cmd_integer, cmd_logical, cmd_lenstr
      external cmd_match, cmd_integer, cmd_logical, cmd_lenstr

      real cmd_real
      external cmd_real

      character*(mlen) cmd_string
#ifndef Linux  /* ABSOFT compiler cannot handle external character functions */
      external cmd_string
#endif
      
c     Local variables
      integer mcommand
      parameter (mcommand = 13)
      character cmdlist(mcommand)*20
      character command*20, chr*1, keyword*20

      character string*(mlen), remain*(mlen), cfile*(mlen)
      integer pos, error, list(10), nread, icmd, leng, status
      integer leng_remain, leng_string
      integer num_type, list_type(3)
      integer num_vertex, list_vertex(3)
      real xlist(10)
      character*20 clist(10)

      equivalence (list, xlist)

      data cmdlist/
     * 'multiplicity', 'fix_multiplicity', 'slope', 'type_info',
     * 'ptmin', 'ptmax', 'etamin', 'etamax', 'phimin', 'phimax',
     * 'vertex', 'dvertex', 'end'/

      data num_type,   list_type  /3, 1, 3, 3/
      data num_vertex, list_vertex/3, 3, 3, 3/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Read loop. cmd_readcmd reads in a line of text, skipping comments
c     and stripping off inline comments. The commmands 'exit', 'stop',
c     and 'include' are recognized by the program and dealt with internally.
100   call cmd_readline(string, status)
      if(status .eq. 1) goto 1000              !End of input
      if(status .eq. 2) goto 9999              !Error

      leng_string = cmd_lenstr(string)

c     Get initial keyword and match it to our command list
      call cmd_keyword(string, keyword, pos)
      icmd = cmd_match(keyword, cmdlist, mcommand)
      if(icmd .le. 0) goto 9993

      remain = string(pos+1:)
      leng_remain = cmd_lenstr(remain)

      command = cmdlist(icmd)

c     "multiplicity"
      if(command .eq. 'multiplicity') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        if(xlist(1) .le. 0.) goto 9996
        gnr_avetrk = xlist(1)

c     "fix_multiplicity"
      else if(command .eq. 'fix_multiplicity') then
        list(1) = cmd_logical(remain, error)
        if(error .ne. 0) goto 9993
        gnr_fix_mult = list(1) .eq. 1

c     "slope"
      else if(command .eq. 'slope') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        gnr_slope = xlist(1)

c     "ptmin"
      else if(command .eq. 'ptmin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        if(xlist(1) .le. 0.) goto 9996
        gnr_ptmin = xlist(1)

c     "ptmax"
      else if(command .eq. 'ptmax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        if(xlist(1) .le. 0.) goto 9996
        gnr_ptmax = xlist(1)

c     "etamin"
      else if(command .eq. 'etamin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        gnr_etamin = xlist(1)

c     "etamax"
      else if(command .eq. 'etamax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        gnr_etamax = xlist(1)

c     "phimin"
      else if(command .eq. 'phimin') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        gnr_phimin = xlist(1)

c     "phimax"
      else if(command .eq. 'phimax') then
        xlist(1) = cmd_real(remain, error)
        if(error .ne. 0) goto 9993
        gnr_phimax = xlist(1)

c     "type_info"
      else if(command .eq. 'type_info') then
        call cmd_getitems(remain, num_type, list_type, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9993
        if(gnr_ntype .ge. gnr_maxtype) goto 9994
        if(nread .lt. num_type) goto 9995
        gnr_ntype = gnr_ntype + 1
        gnr_type_list(gnr_ntype) = list(1)
        gnr_type_probs(gnr_ntype) = xlist(2)
        gnr_type_masses(gnr_ntype) = xlist(3)

c     "vertex"
      else if(command .eq. 'vertex') then
        call cmd_getitems(remain, num_vertex, list_vertex, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9993
        if(nread .lt. num_vertex) goto 9995
        gnr_vtx(1) = xlist(1)
        gnr_vtx(2) = xlist(2)
        gnr_vtx(3) = xlist(3)

c     "dvertex"
      else if(command .eq. 'dvertex') then
        call cmd_getitems(remain, num_vertex, list_vertex, nread,
     *                    list, clist, error)
        if(error .ne. 0) goto 9993
        if(nread .lt. num_vertex) goto 9995
        if(xlist(1).lt.0. .or. xlist(2).lt.0. .or.
     *     xlist(3).lt.0.) goto 9996
        gnr_dvtx(1) = xlist(1)
        gnr_dvtx(2) = xlist(2)
        gnr_dvtx(3) = xlist(3)

c     "end"
      else if(command .eq. 'end') then
        goto 1000

      endif

      goto 100

c     Come here when done reading
 1000 continue
      return

c     Error reading line
 9993 write(6,5033) string(:leng_string), remain(:leng_remain)
 5033 format(a,/,'Error reading command line: "',a,'"')
      stop

c     Too many particle types
 9994 write(6,5034) string(:leng_string),
     *              gnr_maxtype, remain(:leng_remain)
 5034 format(a,/,'Too many particle types defined. Only ',i3,/
     * ' allowed."',a,'"')
      stop

c     Parameters missing
 9995 write(6,5035) string(:leng_string), remain(:leng_remain)
 5035 format(a,/,'Parameters missing: "',a,'"')
      stop

c     Illegal value for parameter
 9996 write(6,5036) string(:leng_string), remain(:leng_remain)
 5036 format(a,/,'Illegal value for parameter: "',a,'"')
      stop

c     Error reading input file
 9999 stop
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:19  eugenio
c Initial revision
c
c Revision 1.3  1998/11/24 19:43:27  procario
c Remove external on character functions on LInux only
c
c Revision 1.2  1997/04/04  18:07:48  garren
c add hooks to initialize user trigger code
c
