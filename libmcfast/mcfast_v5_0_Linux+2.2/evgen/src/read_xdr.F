      program read_xdr
C
C      read in MCFio events and histogram contents
C
      implicit none

#ifdef vms
      include 'stdlun.inc'
      include 'file_names.inc'
#else
#include "stdlun.inc"
#include "file_names.inc"
#endif

      integer lok,ifl,ikeep,icnt(300),i,istr,ntries
      data icnt/300*0/
      save icnt

C initialize HEP logical units
      lnhwrt=0
      lnhrd=0
      lnhdcy=24
      lnhout=22
      ntries = 1000

C...Open the input file
      open(lnhdcy,file='read_xdr.std',status='old')
      read(lnhdcy,9500) file_lpt
      read(lnhdcy,9500) file_evt_rd
      close(lnhdcy)

C...now open and read events
      open(unit=lnhout,file=file_lpt,status='new')
      call stdxrinit(file_evt_rd,ntries,istr,lok)
      if(lok.ne.0) go to 200
C...book histograms
      call tstbkem
C...keep reading the file until you reach the end
  10  call stdxrd(ifl,istr,lok)
      if(lok.ne.0) goto 100
C...keep count
      if(ifl.le.300) icnt(ifl) = icnt(ifl) + 1
      if(ifl.eq.1)then
	if(icnt(1).lt.1000)then
          if (mod(icnt(1),100).eq.0) write(lnhout,9001) icnt(1)
	elseif(icnt(1).lt.10000)then
          if (mod(icnt(1),1000).eq.0) write(lnhout,9001) icnt(1)
	elseif(icnt(1).lt.100000)then
          if (mod(icnt(1),10000).eq.0) write(lnhout,9001) icnt(1)
	else
          if (mod(icnt(1),100000).eq.0) write(lnhout,9001) icnt(1)
	endif
      endif
C...fill histograms
      if(ifl.eq.1)then
        call usr_filter(ikeep)
        if(ikeep.eq.1) call tstflem
      endif
      go to 10
 100  continue
      call stdxend(istr)
C...print statistics
      write(lnhout,1002)
      do i=1,300
        if(icnt(i).gt.0) write(lnhout,1003) icnt(i),i
      enddo
C...print histograms
      call houtpu(lnhout)
      call histdo
      close(unit=lnhout)
      stop
 200  continue
      call stdxend(istr)
      write(lnhout,1001) file_evt_rd
      close(unit=lnhout)
1001  format(' Unable to open event file: ',A50)
1002  format(//5X,' Record types read:')
1003  format(10X,I10,' events of type ',I3)
 9001 format(1X,'Events Read: ',I10)
9500  format(A250)
      end

      subroutine tstflem

C... fill histograms

C---  HEPEVT common block
#ifdef vms
      include 'stdhep.inc'
      include 'stdlun.inc'
#else
#include "stdhep.inc"
#include "stdlun.inc"
#endif

      integer i

      call hfill(11,float(nevhep),0.,1.)
      call hfill(12,float(nhep),0.,1.)
      do 100 i=1,nhep
        call hfill(13,float(idhep(i)),0.,1.)
        call hfill(14,float(isthep(i)),0.,1.)
        call hfill(15,float(jmohep(1,i)),0.,1.)
        call hfill(16,float(jmohep(2,i)),0.,1.)
        call hfill(17,float(jdahep(1,i)),0.,1.)
        call hfill(18,float(jdahep(2,i)),0.,1.)
        call hfill(21,sngl(phep(1,i)),0.,1.)
        call hfill(22,sngl(phep(2,i)),0.,1.)
        call hfill(23,sngl(phep(3,i)),0.,1.)
        call hfill(24,sngl(phep(4,i)),0.,1.)
        call hfill(25,sngl(phep(5,i)),0.,1.)
        call hfill(26,sngl(vhep(1,i)),0.,1.)
        call hfill(27,sngl(vhep(2,i)),0.,1.)
        call hfill(28,sngl(vhep(3,i)),0.,1.)
        call hfill(29,sngl(vhep(4,i)),0.,1.)
 100  continue
      return
      end

      subroutine tstbkem
C--- book histograms
C
      implicit none
C---   The HBOOK common
      real hmemor
      common/pawc/hmemor(50000)

C---   Setup the HBOOK memory limit.
      call hlimit(50000)
C---   Book histograms.
      call hbook1(11,'stdhep: nevhep',100,0.0,100.0,0.)
      call hbook1(12,'stdhep: nhep',100,0.,1000.,0.)
      call hbook1(13,'stdhep: idhep',100,0.,100.,0.)
      call hbook1(14,'stdhep: isthep',100,0.,200.,0.)
      call hbook1(15,'stdhep: jmohep(1,)',100,0.,1000.,0.)
      call hbook1(16,'stdhep: jmohep(2,)',100,0.,1000.,0.)
      call hbook1(17,'stdhep: jdahep(1,)',100,0.,1000.,0.)
      call hbook1(18,'stdhep: jdahep(2,)',100,0.,1000.,0.)
      call hbook1(21,'stdhep: phep(1,)',100,-100.,100.,0.)
      call hbook1(22,'stdhep: phep(2,)',100,-100.,100.,0.)
      call hbook1(23,'stdhep: phep(3,)',100,-1000.,1000.,0.)
      call hbook1(24,'stdhep: phep(4,)',100,-1000.,1000.,0.)
      call hbook1(25,'stdhep: phep(5,)',50,-250.,250.,0.)
      call hbook1(26,'stdhep: vhep(1,)',10,-1.,1.,0.)
      call hbook1(27,'stdhep: vhep(2,)',10,-1.,1.,0.)
      call hbook1(28,'stdhep: vhep(3,)',10,-1.,1.,0.)
      call hbook1(29,'stdhep: vhep(4,)',10,0.,1.,0.)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.3  1998/06/25 15:49:03  bphyslib
c add all necessary changes from v3_3
c
