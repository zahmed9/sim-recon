	program t1
c
c	Example program for mcfio. Simple case.
c
	implicit none
#include "mcfio.inc"
	integer ostr_all, ostr_sel, istr_old
	character *60 device
	character *80 title
	integer numblocks, blkids(5)
	integer i, ivalue
	integer NUMTRIES
	PARAMETER (NUMTRIES = 100)
	integer xdr_stdhep_multi
	external xdr_stdhep_multi
	
c	device = '/home/simulation/pltmp/crap1.dat'
        device = '/dev/rmt/tps0d5nrnsv'
	title = ' First Simple test '
	numblocks = 3
	blkids(1) = MCFIO_STDHEPM
	blkids(2) = MCFIO_OFFTRACKARRAYS
	blkids(3) = MCFIO_OFFTRACKSTRUCT
	ostr_all = mcfio_OpenWriteSequential(device,
     &     	 'ZB1025',title, %val(0), 
     &             NUMTRIES, blkids, numblocks)
        if (ostr_all .eq. -1) then 
           print *, ' Can t open output file, give up '
           stop
        end if
        
        ivalue = 456
        call mcfio_SetEventInfo(ostr_all, MCFIO_RUNNUMBER, ivalue) 
        do i = 1, NUMTRIES
          call fill_stdhep(i)
          if (mcfio_block(ostr_all, MCFIO_STDHEPM, xdr_stdhep_multi)
     &        .eq. -1) then 
             print *, ' Error writing STDHEP block '
             STOP
          end if
          ivalue = i/12
          call mcfio_SetEventInfo(ostr_all, MCFIO_STORENUMBER, ivalue) 
          if (i .ne. 13) then 
            ivalue = 0
          else
            ivalue =255
            call study_stdhep
          end if
          call mcfio_SetEventInfo(ostr_all, MCFIO_TRIGGERMASK, ivalue) 
          if (mcfio_NextEvent(ostr_all) .eq. -1) then 
             print *,'  Error writing next event, Stop '
             stop
          end if
        end do
        call mcfio_closeSequentialFile(ostr_all)
c
c	Write an other file
c
	ostr_all = mcfio_OpenWriteSequential(device,
     &     	 'ZB1025',title, %val(0), 
     &             NUMTRIES, blkids, numblocks)
        
        do i = 101, NUMTRIES+100
          call fill_stdhep(i)
          if (mcfio_block(ostr_all, MCFIO_STDHEPM, xdr_stdhep_multi)
     &        .eq. -1) then 
             print *, ' Error writing STDHEP block '
             STOP
          end if
          ivalue = i/12
          call mcfio_SetEventInfo(ostr_all, MCFIO_STORENUMBER, ivalue) 
          if (i .ne. 13) then 
            ivalue = 0
          else
            ivalue =255
            call study_stdhep
          end if
          call mcfio_SetEventInfo(ostr_all, MCFIO_TRIGGERMASK, ivalue) 
          if (mcfio_NextEvent(ostr_all) .eq. -1) then 
             print *,'  Error writing next event, Stop '
             stop
          end if
        end do
        call mcfio_closeSequentialTape(ostr_all)
        stop
        end 
        subroutine fill_stdhep(inum)
c
c	Moronic routine to generate pseudo data.
c
        implicit none 
#include "stdhep.inc"
	integer inum
	real ran
	external ran
	integer i, j, nn, iseed
	save iseed
	data iseed/66678756/
	double precision vec(4), masses(5)
	save masses
	data masses/0.1345, 0.6783, 1.245, 1.45, 5.678/
	
	
	nn = mod(inum, 100) * 5 * ifix(5. * ran(iseed))
	nevhep = inum
	nhep = nn
	do i = 1, nn
	  phep(5,i) = masses(ifix(1. + 3.*ran(iseed)))
	  phep(1,i) = i*0.1
	  phep(2,i) = i*0.2
	  phep(3,i) = i*0.3
	  vec(4) = 0.
	  do j = 1,3
	    vec(j) = 1.d0*phep(j,i)
	    vec(4) = vec(4) + vec(j)**2
	  end do
	  phep(4,i) = sngl(dsqrt(vec(4) +
     &                    (1.d0*phep(5,i))*(1.d0*phep(5,i))))
          vhep(1,i) = ran(iseed)
          vhep(2,i) = vhep(1,i)
          vhep(3,i) = 0.
          isthep(i) = i
          jmohep(1,i) = 1
          jmohep(2,i) = 3
          jdahep(1,i) = 0
          jdahep(2,i) = 4
        end do
        return
        end 
	subroutine study_stdhep
	implicit none
	integer i, io, nn
#include "stdhep.inc"
	
	print  *, ' Number of tracks ', nhep
	nn = nhep
	if (nn .gt. 3 ) nn = 3
	do i = 1, nn
	 print *, ' Pz, Py, Pz, ', (phep(io,i), io = 1,3)
	 print *, '   Mass ', phep(5,i)
	 print *, ' Y position, Z position ', vhep(2,i), vhep(3,i)
	end do
	return
	end 	
          
	    
	  
	
