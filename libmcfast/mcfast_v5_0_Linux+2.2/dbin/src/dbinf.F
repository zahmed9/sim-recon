*
*       dbin.F
*
*       Fortran utility routines for the dbin package: see dbin.lex
* $$$ add array checks, that no. of values = declared length
* $$$ db consistency check; see $$$
*
*         Torre Wenaus
*
      subroutine dbin_getrec(fname,end_of_file,istat)
************************************************************************
*
*       dbin_getrec
*
*       Handle file opening, record retrieval for up to mxfil dbin
*       database files
*
************************************************************************
      implicit none
      character*(*) fname
      logical end_of_file
#include "dbin.inc"
      common /dbinf_c/ inc_depth, nch, lunit, line, dbpath, infile
      integer linesize
      parameter (linesize=500)
      character line*(linesize), dbpath*60, infile*80, instr*132
      integer inc_depth, nch, lunit, lunstd, kk, n_significant
*
      integer mxfile
      parameter (mxfile=10)
      character*80 fnames(mxfile)
      save fnames
      character cccc*1
      integer iflun(mxfile), istat, ndum, nfiles, k
      save iflun
      save nfiles
      integer isl
      integer icfila, lenocc
      external icfila, lenocc
      logical first
      logical already_handled

      integer ascii_tab
      parameter ( ascii_tab = 9 )

      data first /.true./
      data isl /0/
      data nfiles /0/
*
*-----------------------------------------------------------------------
*
      end_of_file = .false.
      if (first) then
        first = .false.
        inc_depth = 0
        call freeunit(lunit)
      endif
      istat = 0
      if (inc_depth.eq.0.and.isl.eq.0) then
        infile = fname
        if (infile(1:1).eq.'-') then
***         read from standard input
          print *,'Reading database from standard input'
          call freeunit(lunstd)
          infile = 'std_input.db'
          open(unit=lunstd,file=infile,status='unknown')
 10       read (5,*,end=11,err=11) instr
          write(lunstd,*) instr(:lenocc(instr))
          if (instr(:lenocc(instr)).eq.'end'.or.
     +      instr(:lenocc(instr)).eq.'END') goto 11
          goto 10
 11      close(lunstd)
        endif
*         
***       extract path if any
        isl = icfila('/',infile,1,lenocc(infile))
        if (isl.le.lenocc(infile)) then
          dbpath = infile(:isl)
        else
          dbpath = './'
        endif
      endif
*
 1    already_handled = .false.
      do k=1,nfiles
        if (index(fnames(k),infile(:lenocc(infile))).ne.0) then
          already_handled = .true.
          nfiles = k
        endif
      enddo
*
      if (.not.already_handled) then
*
***       open the file
        nfiles = nfiles +1
        fnames(nfiles) = infile
        call ciopen(iflun(nfiles),'r',fnames(nfiles),istat)
        if (istat.ne.0) then
          print *,'dbin: error opening ',infile,istat
          return
        endif
      endif
*       
***     read next line
*       
 100  nch = 0
      varname = ' '
 101  call ciget(iflun(nfiles),cccc,1,ndum,istat)

**    Replace tabs with spaces.
      if ( cccc .eq. char(ascii_tab) ) cccc = ' '

      if (ichar(cccc).eq.10.or.istat.eq.-1) then ! line feed or EOF
**        if last significant char of line was '/', continue the line
        isl=0
        do kk=1,nch
          if (line(kk:kk).eq.'!') goto 202
          if (line(kk:kk).eq.'/') isl=kk
        enddo
 202    continue
        if (isl.ne.0) then
          n_significant = 0
          do kk=isl,nch
            if (line(kk:kk).eq.'!') goto 201
            if (line(kk:kk).ne.'/'.and.line(kk:kk).ne.' '.and.
     +        line(kk:kk).ne.'	') then
              n_significant = n_significant +1
            endif
          enddo
 201      continue
          if (n_significant.eq.0) then
            nch = isl -1
            goto 101
          endif
        endif
      else
        nch = min(nch +1,linesize)
        line(nch:nch)=cccc
        if (nch.eq.linesize) then
          print *,'dbin error: truncation: max line length reached',
     +      linesize
        endif
        goto 101
      endif
      if (istat.eq.-1) then     ! end of file
        if (inc_depth.gt.0) then   ! inside an included file. Pop up.
          inc_depth = inc_depth -1
          call ciclos(iflun(nfiles))
          nfiles = nfiles -1
          infile = fnames(nfiles)
          goto 101
        endif
        end_of_file = .true.
        goto 999
      else if (istat.ne.0) then
        print *,'dbin: read error on ',infile,istat
      endif
*       
*       
***     parse the line
*       
      call lineparse(istat)
      if (istat.eq.-1) goto 100
      if (istat.eq.-2) goto 1
 999  end

************************************************************************
      integer function getnvars(str)
      implicit none
      character*(*) str
#include "dbin.inc"
      integer i
*
      getnvars = 0
      do i=1,n_templates
        if (str.eq.template_name(i)) then
          getnvars = n_entries(i)
        endif
      enddo
      end

************************************************************************
      integer function index_for(object)
      implicit none
      character*(*) object
#include "dbin.inc"
      integer i
*
      index_for = 0
      do i=1,n_totobjs
        if (object.eq.template_object(i)) then
          index_for = index_object(i)
        endif
      enddo
      end
************************************************************************
      subroutine lineparse(istat)
      implicit none
#include "dbin.inc"
      integer istat, ist
***     CERNLIB CHPACK M432 string processing common
      common /slate/ nd, ne, nf, ng, num(2), dummy(34)
      integer nd, ne, nf, ng, num, dummy
      real anum(2)
      double precision dnum
      equivalence (num,anum), (num,dnum)
*
      common /dbinf_c/ inc_depth, nch, lunit, line, dbpath, infile
      integer linesize
      parameter (linesize=500)
      character line*(linesize), dbpath*60, infile*80
      integer inc_depth, nch, lunit
*
      integer  iclocl, icloc, lenocc, icfnbl, icnext, icnthl
      external iclocl, icloc, lenocc, icfnbl, icnext, icnthl
      logical in_template, in_file
      save in_template, in_file
      integer ntokens, lentk(30), lvn, i1, i2, i, k, iend, in_string
      character token(30)*80, curstruct*30
      save curstruct, in_string
      character*1 chnull
      integer getnvars
      external getnvars
*-----------------------------------------------------------------------
      chnull=char(0)   ! Get rid of trick that equivalences a byte 0
                       ! to chnull. This is simpler.
      istat = 0
      iend = icloc('!',1,line(:nch),1,nch)   ! appended comment
      if (iend.eq.0) then
        iend = nch
      else
        iend = iend -1
      endif
      if (iend.eq.0) then
        istat = -1
        goto 100                ! line is comment or blank
      endif
ccc      call cutol(line(:iend))   ! downcase all but the comment
      ist = icfnbl(line(:iend),1,iend) ! first non-blank
      if (ist.ge.iend) then
        istat = -1
        goto 100                ! line is comment or blank
      endif
      ntokens = 0
      in_string = 0
      do i=1,999
        i1 = icnext(line,ist,iend)
        if (in_string.eq.0) then
          ntokens = ntokens +1
          token(ntokens) = line(i1:ne-1)
          lentk(ntokens) = ne-i1
          if (ne-1.eq.iend) goto 103 ! end of line
          ist=ne
          if ((token(ntokens)(1:1).eq.'"'.or.
     +      token(ntokens)(1:1).eq.'''').and.
     +      token(ntokens)(lentk(ntokens):lentk(ntokens)).ne.'"'.and.
     +      token(ntokens)(lentk(ntokens):lentk(ntokens)).ne.'''')
     +      in_string = 1
        else
          token(ntokens) = 
     +      token(ntokens)(:lentk(ntokens))//' '//line(i1:ne-1)
          lentk(ntokens) = lentk(ntokens) +ne-i1+1
          if (token(ntokens)(lentk(ntokens):lentk(ntokens)).eq.'"'.or.
     +      token(ntokens)(lentk(ntokens):lentk(ntokens)).eq.'''')
     +      in_string = 0
          ist = ne
        endif
      enddo
 103  continue
*
***     analyse the tokens
c      do i=1,ntokens
c        print *,'"',token(i),'"'
c      enddo

      call cutol(token(1))     ! downcase identifying token
      if (in_file.and.(token(1).ne.'fileend').and.
     +  (token(1).ne.'ffend')) then
        write(lunit,'(a)') line(:nch)
        istat = -1
        goto 100
      endif
      if (token(1).eq.'end') then
        in_template = .false.
        curstruct = '--'
        istat = -1
      else if (token(1).eq.'structure') then
        curstruct = token(2)
        istat = -1
      else if (token(1).eq.'template') then
        n_instance = 0
        in_template = .true.
        curstruct = token(2)
        istat = -1
      else if (token(1).eq.'command') then
        in_template = .true.
        curstruct = token(2)
        istat = -1
      else if (token(1).eq.'make') then
        n_instance = n_instance +1
        call cutol(token(2))
        varname = 'TEMPLATE_'//token(2)
        nvars = ntokens-2
        do k=1,nvars
          call ckrack(token(2+k),1,lenocc(token(2+k)),-1)
          if (index(token(2+k),'"').ne.0) then
            chvar(k) = token(2+k)(2:lenocc(token(2+k))-1)//chnull
          else
            chvar(k) = token(2+k)(1:lenocc(token(2+k)))//chnull
          endif
          if (nf.eq.2) then
            rvar(k) = num(1)
          else if (nf.eq.3) then
            rvar(k) = anum(1)
          else if (nf.eq.4) then
            rvar(k) = dnum
          endif
        enddo
      else if (token(1).eq.'define') then
        call cutol(token(2))
        varname = 'TEMPLATE_'//token(2)
        objname = token(2)(:lentk(2))//'_'//token(3)
        nvars = ntokens-3
        do k=1,nvars
          call ckrack(token(3+k),1,lenocc(token(3+k)),-1)
          if (index(token(3+k),'"').ne.0) then
            chvar(k) = token(3+k)(2:lenocc(token(3+k))-1)//chnull
          else
            chvar(k) = token(3+k)(1:lenocc(token(3+k)))//chnull
          endif
          if (nf.eq.2) then
            rvar(k) = num(1)
          else if (nf.eq.3) then
            rvar(k) = anum(1)
          else if (nf.eq.4) then
            rvar(k) = dnum
          endif
        enddo
      else if (token(1).eq.'call') then
        call cutol(token(2))
        varname = 'COMMAND_'//token(2)
ccc        nvars = getnvars(token(2))
        nvars = ntokens-2
        do k=1,nvars
          call ckrack(token(2+k),1,lenocc(token(2+k)),-1)
          if (index(token(2+k),'"').ne.0.or.
     +      index(token(2+k),'''').ne.0) then
            chvar(k) = token(2+k)(2:lenocc(token(2+k))-1)//chnull
          else
            chvar(k) = token(2+k)(:lenocc(token(2+k)))//chnull
          endif
          if (nf.eq.2) then
            rvar(k) = num(1)
          else if (nf.eq.3) then
            rvar(k) = anum(1)
          else if (nf.eq.4) then
            rvar(k) = dnum
          endif
        enddo
      else if (token(1).eq.'database') then
* $$$ check consistency of db/vsn from include file and that from db file
        istat = -1
      else if (token(1)(1:3).eq.'int'.or.token(1).eq.'real'.or.
     +  token(1).eq.'double'.or.token(1)(1:4).eq.'char'.or.
     +    token(1)(1:8).eq.'material') then
        if (in_template) then
          istat = -1
          varname = '-'
        else
          varname = token(2)
          lvn = lentk(2)
          if (index(token(2),'(').ne.0) then
***           array; pick up array index
            i1 = index(token(2),'(')
            i2 = index(token(2),')')
            varname = token(2)(:i1-1)
            lvn = i1-1
            call ckrack(token(2)(i1+1:i2-1),1,i2-i1-1,-1)
            nvars = num(1)
          else
            nvars = 1
          endif
          if (curstruct(1:2).eq.'--') then
            print *,'dbin: Parameter "',varname(:lvn),
     +        '" declaration not in structure; ignored:'
            print *,'    ',line(:nch)
            istat = -1
            goto 100
          endif
          do k=1,nvars
            call ckrack(token(2+k),1,lenocc(token(2+k)),-1)
            if (token(1)(1:3).eq.'int') then
              if (nf.ne.2) then
                print *,'dbin: Field not integer ',token(2+k)
              else
                rvar(k) = num(1)
              endif
            else if (token(1).eq.'real') then
              if (nf.ne.3) then
                print *,'dbin: Field not real ',token(2+k)
              else
                rvar(k) = anum(1)
              endif
            else if (token(1).eq.'double') then
              if (nf.lt.3) then
                print *,'dbin: Field not real or double ',token(2+k)
              else
                if (nf.eq.3) dvar(k) = anum(1)
                if (nf.eq.4) dvar(k) = dnum
              endif
            else if (token(1)(1:4).eq.'char'.or.
     +          token(1)(1:8).eq.'material') then
              chvar(k) = token(2+k)(2:lenocc(token(2+k))-1)//chnull
            endif
          enddo
*         
***       build complete variable name
*         
          varname = varname(:lvn)//'_'//curstruct
        endif
      else if (token(1).eq.'ffread') then
        in_file = .true.
**        open scratch file for FFREAD cards. Thanks to Doug Wright
**        for the scratch file suggestion.
        open(unit=lunit,status='scratch')
        istat = -1
      else if (token(1).eq.'ffend') then
        in_file = .false.
        rewind(lunit)
        call ffset('LINP',lunit)
        call ffgo
        close(lunit)
        istat = -1
      else if (token(1).eq.'file') then
        in_file = .true.
        open(unit=lunit,file=token(2),status='unknown')
        istat = -1
      else if (token(1).eq.'fileend') then
        in_file = .false.
        close(lunit)
        istat = -1
      else if (token(1).eq.'include') then
        inc_depth = inc_depth+1
        infile = dbpath(:lenocc(dbpath))//token(2)
        istat = -2   ! read new file
      else if (token(1).eq.'dimension') then
        istat = -1
      else if (token(1).eq.'index') then
        istat = -1
      else if (token(1).eq.'provide') then
        istat = -1
      else if (token(1).eq.'parent') then
        istat = -1
      else if (token(1).eq.'child') then
        istat = -1
      else if (token(1).eq.'incname') then
        istat = -1
      else
        print *,'dbin: Unidentified line:'
        print *,'  ',line(:nch)
        istat = -1
      endif
 100  end
************************************************************************
      subroutine dbin_exec(cmd)
************************************************************************
*
*       User routine, called to pass a single line, CMD, for
*       processing by dbin. Intended for use in passing CALL and
*       perhaps MAKE statements; nothing else.
*
************************************************************************
      implicit none
      character*(*) cmd
*
      common /dbinf_c/ inc_depth, nch, lunit, line, dbpath, infile
      integer linesize
      parameter (linesize=500)
      character line*(linesize), dbpath*60, infile*80
      integer inc_depth, nch, lunit
*
      integer istat
      line = cmd
      call lineparse(istat)
      end
