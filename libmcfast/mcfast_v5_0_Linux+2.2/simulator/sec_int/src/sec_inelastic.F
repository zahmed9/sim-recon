	integer function sec_inelastic(w1,hep,wtime)
c***********************************************************************
c       generate a secondary interaction in a scattering material
c
c	Inputs
c
c	w1    : structure describing input particle
c
c	hep   : postition of incoming particle in hepevt list
c
c	wtime : time of interaction
c
c	
c***********************************************************************
	implicit none

#include "const.inc"	
#include "stdhep.inc"
#include "wtrack_struct.inc"
#include "vtxhep.inc"

c 	Calling Arguments
	record /wtrack_struct/ w1
	integer hep
	DFLOAT wtime
	
c 	Externals
	external fill_stdhep
	external rann, get_gauss
	
	integer fill_stdhep
	real rann, get_gauss
	
c 	Local Variables
	integer i, id,int_ok, line, idsec(25)
	integer nsec, num_sec, nbad, err
	integer npiz, ntot
	integer status
	
	DFLOAT s, rts, lnrts, lns, gamma, energy, charge
	DFLOAT phi,  Ecut, xmass, beta
	DFLOAT costh, pt, smass, theta
	DFLOAT etalab, eta(25), etamax, etacms
	DFLOAT eta_to_cos_d, cos_to_eta_d
	DFLOAT coscms,pp, Ecms, pz, Etemp
	DFLOAT Esum, pxsum,pysum,pzsum
	DFLOAT Atgt, Escale, Echeck, etascale
	real nav, nadd, kprob,pscale, pmin, pcut
	record /wtrack_struct/ wsec(25),w
		
	data kprob, pscale, pmin, pcut /0.08, 0.45, 0.05, 0.05/
	data Atgt /28.09/
	
c***********************************************************************

	int_ok = 0
	id = idhep(hep)
	energy = w1.E
	xmass = sqrt(w1.E**2 - w1.p**2)
	s = 2.0*energy*p_mass + xmass**2 + p_mass**2
	rts = sqrt(s)
	lns = log(s)
	gamma = (energy+p_mass)/rts
	beta = sqrt(1.0-1./gamma**2)
	etalab = -0.5*log((1.0-beta)/(1.0+beta))
	Esum = 0.
	
c  Mean number of secondary tracks at this energy
	nav = -0.35 + 1.21*lns + 0.03*(lns)**2  
c  Add extra particles depending on A of target - assume silicon 
        nadd =  0.2*nav*(Atgt**0.3 -1.0) 
        nav = nav + nadd	
	
c  select number of secondary tracks from truncated gaussian distribution
c  with mean nav. Check there is enough energy
c   include pi-zeros, turn on decays to get gammas

100	nsec = nav* (get_gauss(0)/2.28 + 1.0) + 0.5
	if(nsec.lt.1.0) go to 100

	npiz = 0.5 *nav* (get_gauss(0)/2.28 + 1.0)
	if(npiz.lt.0) npiz = 0 

	ntot = nsec+npiz
	if(ntot.gt.25) ntot=25
	
101	Ecut = p_mass + (ntot-1)*pi_mass
	if(rts.lt.Ecut) then
	   ntot = ntot -1
	   go to 101
	endif  
	if(nsec.gt.ntot) nsec=ntot
	
c   generate energy of secondary tracks: gaussian in pt
c    flat in pseudorapidity
c  
	
	  
	do i = 1,ntot
90	  pt = abs(get_gauss(0)*pscale)
	  if(pt.lt.0.001)pt=0.001

	  if(i.eq.1)then
	     charge = w1.q
	  else if(i.le.nsec) then
	     charge = (-1)**i
	  else   
             charge = 0
	  endif
	  
	  if(i.eq.2) then
	    if(mod(nsec,2).eq.0)then
	      smass = p_mass
	      idsec(i) = 2212
	    else
	      smass = n_mass
	      idsec(i) = 2112
	    endif    
	  else if(charge.eq.0)then
	     if(rann(0).lt.kprob)then
	       smass = ks0_mass
	       idsec(i) = 310
	       if(rann(0).lt.0.5)idsec(i)=311
	     else  
	      smass = pi0_mass
	      idsec(i) = 111
	     endif 
	  else if(rann(0).lt.kprob)then
	     smass = k_mass
	     idsec(i) = 321*charge
	  else  
	     smass = pi_mass
	     idsec(i) = 211 * charge
	  endif
	  
	  etamax = log(s/(2*pt**2+smass**2))
	  if(etamax.lt.0)etamax=0.
	  etacms = (rann(0)-0.5)*etamax
	  
	  eta(i) = etacms + etalab
	  costh = eta_to_cos_d(eta(i))
	  phi = rann(0)*tpi
	  pp =  pt/sqrt(1.0-costh**2)
	  if(pp.lt.pcut) go to 90
	  
	  wsec(i).px = pt*cos(phi)
	  wsec(i).py = pt*sin(phi)
	  wsec(i).p =  pp
	  wsec(i).pz = wsec(i).p*costh
	  wsec(i).E =  sqrt(wsec(i).p**2+smass**2)
	  wsec(i).x =  w1.x
	  wsec(i).y =  w1.y
	  wsec(i).z =  w1.z
	  wsec(i).pt = pt
	  wsec(i).q =  charge
	  
	  Esum = Esum + wsec(i).E
	end do   	  	
	  

c Rescale Energy and momentum of all secondaries 
	Escale = (energy+p_mass)/Esum
	  
	num_sec = 0
	if (vtx_hep_n .ge. maxvtx) goto 9999
        vtx_hep_n   = vtx_hep_n + 1
        idvhep(hep) = vtx_hep_n
        jdahep(1,hep) = nhep + 1
        isthep(hep)   = ISTHEP_SEC_INT
		
	do i = 1, ntot
	  call rescale_wtk(Escale,wsec(i),w)
c recalculate eta
	  costh = sqrt(1.0- (w.pt/w.p)**2)
	  if(w.pz.lt.0) costh = -costh	  
	  eta(i) = cos_to_eta_d(costh)
	  
c  rotate to lab frame and add to stdhep list
	  if(w.p .gt. pmin) then
	    call rotate_wtk(w,w1,w)
	    status = fill_stdhep(w,hep,idsec(i),wtime)
	    if (status .ne. 0) goto 9999
	    num_sec = num_sec + 1
	  endif 

	end do
	
        jdahep(2,hep) = nhep
	
c     Save vertex info
        vtx_ntrk(vtx_hep_n) =  num_sec      ! num. of sec. saved
        vtx_intrk(vtx_hep_n) = hep          ! incoming track
        vtx_outrk(vtx_hep_n) = jdahep(1,hep) ! first outgoing track
        vtx_pos(1,vtx_hep_n) = w1.x
        vtx_pos(2,vtx_hep_n) = w1.y
        vtx_pos(3,vtx_hep_n) = w1.z
        vtx_pos(4,vtx_hep_n) = clight * wtime
	  
	  
c     Normal exit	
	sec_inelastic = 0
	return
	
c     Error exit
 9999   sec_inelastic = 1
	return
	end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.5  1998/10/21 23:23:12  mcbride
c change masses to use const.inc values
c
c Revision 1.4  1998/09/24  03:49:09  mcbride
c updated nadd
c
c Revision 1.3  1998/09/24  01:46:13  kutschke
c Mark parent as having interacted.
c
c
