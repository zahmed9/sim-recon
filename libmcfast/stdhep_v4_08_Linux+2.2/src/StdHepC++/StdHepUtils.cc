// StdHepUtils.cc
//
// Purpose: various utility routines
//

#include <iostream.h>
#include <vector>

#include "StdRun.hh"
#include "StdHepDictionary.hh"

#include "stdhep.h"
#include "stdtmp.h"
#include "stdcm1.h"
#include "stdver.h"

extern "C" {
 void stdzero_();
}

void PrintStdVersion(void) 
{
   static int ncalls=0;
   if( ncalls == 0 ) {
      ncalls++;
      strcpy( stdver_.stdhep_ver  , "4.08     ");
      strcpy( stdver_.stdhep_date , "February 24, 2000  ");

      cout << endl;
      cout << "********************************************************" << endl;
      cout << "*    StdHepC++ version 4.08 - February 24, 2000        *" << endl;
      cout << "********************************************************" << endl;
      cout << endl;
   }
}

void StdHepZero( StdHep::Event* & ep ) 
{
       ep = new StdHep::Event(0, 0, 0);
}

int StdHepTempCopy( int idir, int istr, StdHep::Event* & ep )
{
    int i, evnum, ntry, nm, nmi;
    HepLorentzVector pmom, vh;
    //
    // create event using info from stdtmp 
    // (temporary copy of the hepevt common block)
    // multiple collision information must be created
    //
    if( idir == 1 ) {
	//
	// fill stdtmp.h from event class
	//
	stdtmp_.nevhept = ep->EventNumber();
	stdtmp_.nhept = ep->Entries();
	// create particles
	for (i = 0; i < ep->Entries(); i++) {
            StdHep::Particle pp = ep->HEParticle(i);
	    pmom = pp.Momentum();
	    vh = pp.CreationVertex();
            stdtmp_.idhept[i] = pp.ParticleID(); 
	    stdtmp_.isthept[i] = pp.StatusCode();
	    stdtmp_.jmohept[i][0] = pp.Mother();
	    stdtmp_.jmohept[i][1] = pp.SecondMother();
	    stdtmp_.jdahept[i][0] = pp.BeginDaughters();
	    stdtmp_.jdahept[i][1] = pp.EndDaughters();
	    stdtmp_.phept[i][0] = pmom.px();
	    stdtmp_.phept[i][1] = pmom.py();
	    stdtmp_.phept[i][2] = pmom.pz();
	    stdtmp_.phept[i][3] = pmom.e();
	    stdtmp_.phept[i][4] = pp.Mass();
	    stdtmp_.vhept[i][0] = vh.x();
	    stdtmp_.vhept[i][1] = vh.y();
	    stdtmp_.vhept[i][2] = vh.z();
	    stdtmp_.vhept[i][3] = vh.t();
	}
    } else if( idir == 2 ) {
       // cout << "creating StdHep::Event" << endl;
       evnum = ep->EventNumber();
       ep -> setEventNumber( stdtmp_.nevhept + evnum );
       ntry = ep->Entries();
       ep -> setEntries( stdtmp_.nhept + ntry );
       nmi = ep->NumberCollisions();
       nm = nmi + 1;
       ep -> setNumberCollisions( nm );
       // create particles
       for (i = 0; i < stdtmp_.nhept; i++) {
           StdHep::Particle *pp = new StdHep::Particle(stdtmp_.idhept[i], 
	                   stdtmp_.isthept[i], 
			   stdtmp_.jmohept[i][0], stdtmp_.jmohept[i][1], 
			   stdtmp_.jdahept[i][0], stdtmp_.jdahept[i][1], 0,
                           1,
			   HepLorentzVector( stdtmp_.phept[i][0],
			   stdtmp_.phept[i][1], stdtmp_.phept[i][2],
			   stdtmp_.phept[i][3] ), stdtmp_.phept[i][4],
			   HepLorentzVector( stdtmp_.vhept[i][0], stdtmp_.vhept[i][1],
			                     stdtmp_.vhept[i][2], stdtmp_.vhept[i][3] ),
			   HepLorentzVector( 0 ) );
	   //
           // set everything again for testing purposes
	   //
	   pp -> setParticleID( stdtmp_.idhept[i] );
	   pp -> setStatusCode( stdtmp_.isthept[i] );
	   pp -> setMother( stdtmp_.jmohept[i][0] );
	   pp -> setSecondMother( stdtmp_.jmohept[i][1] );
	   pp -> setBeginDaughters( stdtmp_.jdahept[i][0] );
	   pp -> setEndDaughters( stdtmp_.jdahept[i][1] );
	   pp -> setColor( 0 );
	   pp -> setCollisionNumber( nm );
	   pp -> setMomentum( stdtmp_.phept[i][0],  stdtmp_.phept[i][1],
	                  stdtmp_.phept[i][2], stdtmp_.phept[i][3] );
	   pp -> setMass( stdtmp_.phept[i][4] );
	   pp -> setCreationVertex( stdtmp_.vhept[i][0], stdtmp_.vhept[i][1],
			            stdtmp_.vhept[i][2], stdtmp_.vhept[i][3] );
	   pp -> setDecayVertex( stdtmp_.vhept[i][0], stdtmp_.vhept[i][1],
			            stdtmp_.vhept[i][2], stdtmp_.vhept[i][3] );
	   //
	   // add this particle to the list
	   //
	   ep -> appendParticle( pp );
       }
       // fill in collision information
       StdHep::Collision *col = new StdHep::Collision(stdtmp_.nevhept, 
	               istr, ntry, ( ep->Entries() - 1 ) );
       ep -> appendCollision( col );
    } else {
        cerr << " StdHepTempCopy: only idir = 1 or 2 allowed" << endl;
	ep = 0;
    }
    return 0;
}

int StdHepFtoCXX( int istr, StdHep::Event* & ep )
{
    int i, j, endcol;
    //
    // create event using info from stdhep.h 
    // (stdhep.h is in sync with stdhep.inc)
    //
    // cout << "creating StdHep::Event" << endl;
    ep = new StdHep::Event(hepevt_.nevhep, hepevt_.nhep, hepev2_.nmulti);
    // create particles
    for (i = 0; i < hepevt_.nhep; i++) {
        StdHep::Particle *pp = new StdHep::Particle(hepevt_.idhep[i], 
	                hepevt_.isthep[i], 
			hepevt_.jmohep[i][0], hepevt_.jmohep[i][1], 
			hepevt_.jdahep[i][0], hepevt_.jdahep[i][1], 0,
                        hepev2_.jmulti[i],
			HepLorentzVector( hepevt_.phep[i][0],
			hepevt_.phep[i][1], hepevt_.phep[i][2],
			hepevt_.phep[i][3] ), hepevt_.phep[i][4],
			HepLorentzVector( hepevt_.vhep[i][0], hepevt_.vhep[i][1],
			                  hepevt_.vhep[i][2], hepevt_.vhep[i][3] ),
			HepLorentzVector( 0 ) );
	//
	// add this particle to the list
	//
	ep -> appendParticle( pp );
    }
    // create multiple collision info
    for (i = 0; i < hepev2_.nmulti; i++) {
        j = i + 1;	// look at next interaction for end of this one
	if ( j < hepev2_.nmulti ) {
	    endcol = hepev3_.itrkmulti[j] - 2;
	} else {
	    endcol = hepevt_.nhep - 1;
	}
        StdHep::Collision *col = new StdHep::Collision(hepev3_.nevmulti[i], 
	                hepev3_.mltstr[i], 
	                ( hepev3_.itrkmulti[i] - 1 ), 
	                endcol );
	//
	// add this particle to the list
	//
	ep -> appendCollision( col );
    }
    return 0;
}

int StdHepCXXtoF( int istr, StdHep::Event* & ep )
{
    int i;
    HepLorentzVector pmom, vh;
    //
    // fill stdhep.h from event class - mostly for XDR output
    //
    stdzero_();
    hepevt_.nevhep = ep->EventNumber();
    hepevt_.nhep = ep->Entries();
    hepev2_.nmulti = ep->NumberCollisions();
    // create particles
    for (i = 0; i < ep->Entries(); i++) {
        StdHep::Particle pp = ep->HEParticle(i);
	pmom = pp.Momentum();
	vh = pp.CreationVertex();
        hepevt_.idhep[i] = pp.ParticleID(); 
	hepevt_.isthep[i] = pp.StatusCode();
	hepevt_.jmohep[i][0] = pp.Mother();
	hepevt_.jmohep[i][1] = pp.SecondMother();
	hepevt_.jdahep[i][0] = pp.BeginDaughters();
	hepevt_.jdahep[i][1] = pp.EndDaughters();
	hepevt_.phep[i][0] = pmom.px();
	hepevt_.phep[i][1] = pmom.py();
	hepevt_.phep[i][2] = pmom.pz();
	hepevt_.phep[i][3] = pmom.e();
	hepevt_.phep[i][4] = pp.Mass();
	hepevt_.vhep[i][0] = vh.x();
	hepevt_.vhep[i][1] = vh.y();
	hepevt_.vhep[i][2] = vh.z();
	hepevt_.vhep[i][3] = vh.t();
	hepev2_.jmulti[i] = pp.CollisionNumber();
    }
    // create multiple collision info
    for (i = 0; i < ep->NumberCollisions(); i++) {
        StdHep::Collision col = ep->HEPCollision(i);
	hepev3_.nevmulti[i] = col.InteractionEventNumber();
	hepev3_.mltstr[i] = col.IOStream();
	hepev3_.itrkmulti[i] = col.BeginCollision() + 1;
    }
    return 0;
}

void StdHepFtoCM( StdHep::Run & thisrun )
{
    thisrun.setEventsToGenerate( stdcm1_.nevtreq );
    thisrun.setEventsGenerated( stdcm1_.nevtgen );
    thisrun.setEventsWritten( stdcm1_.nevtwrt );
    thisrun.setCoMEnergy( stdcm1_.stdecom );
    thisrun.setCrossSection( stdcm1_.stdxsec );
    thisrun.appendSeed( stdcm1_.stdseed1 );
    thisrun.appendSeed( stdcm1_.stdseed2 );
}

void StdHepCMtoF( StdHep::Run & thisrun )
{
    stdcm1_.nevtreq = thisrun.EventsToGenerate();
    stdcm1_.nevtgen = thisrun.EventsGenerated();
    stdcm1_.nevtwrt = thisrun.EventsWritten();
    stdcm1_.stdecom = thisrun.CoMEnergy();
    stdcm1_.stdxsec = thisrun.CrossSection();
    stdcm1_.stdseed1 = thisrun.Seed( 0 );
    stdcm1_.stdseed2 = thisrun.Seed( 1 );
}
