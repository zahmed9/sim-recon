// $Id$
//
// Author: David Lawrence  June 24, 2004
//
// changes: Wed Jun 20 17:08:13 EDT 2007 B. Zihlmann
//          modify TOF section to add several new variables incuding the 
//          GEANT particle type to the Truth hits and the hit and track-hit list.
//
// DEventSourceHDDM methods
//

#include <iostream>
#include <iomanip>
using namespace std;

#include <JANA/JFactory_base.h>
#include <JANA/JEventLoop.h>
#include <JANA/JEvent.h>

#include "DEventSourceHDDM.h"
#include "FDC/DFDCGeometry.h"
#include "FCAL/DFCALGeometry.h"

//------------------------------------------------------------------
// Binary predicate used to sort hits
//------------------------------------------------------------------
class MCTrackHitSort{
	public:
		bool operator()(DMCTrackHit* const &thit1, DMCTrackHit* const &thit2) const {
			return thit1->z < thit2->z;
		}
};

bool MCTrackHitSort_C(DMCTrackHit* const &thit1, DMCTrackHit* const &thit2) {
	return thit1->z < thit2->z;
}


//----------------
// Constructor
//----------------
DEventSourceHDDM::DEventSourceHDDM(const char* source_name):JEventSource(source_name)
{
	/// Constructor for DEventSourceHDDM object
	fin = open_s_HDDM((char*)source_name);
	hddm_s = NULL;
	
	if(fin)source_is_open = 1;
	flush_on_free = true;
}

//----------------
// Destructor
//----------------
DEventSourceHDDM::~DEventSourceHDDM()
{
	// Close file and set pointers to NULL
	if(fin)close_s_HDDM(fin);
	hddm_s = NULL;
	fin = NULL;
}

//----------------
// GetEvent
//----------------
jerror_t DEventSourceHDDM::GetEvent(JEvent &event)
{
	/// Implementation of JEventSource virtual function
		
	if(!fin){
		return EVENT_SOURCE_NOT_OPEN;
	}
	hddm_s = read_s_HDDM(fin);

	// each open HDDM file takes up about 1M of memory so it's
	// worthwhile to close it as soon as we can
	if(!hddm_s){
		if(fin)close_s_HDDM(fin);
		fin = NULL;
		return NO_MORE_EVENTS_IN_SOURCE;
	}
	
	++Nevents_read;
	
	int event_number = -1;
	int run_number = -1;
	
	// Get event/run numbers from HDDM
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(PE && PE->mult>0){
		event_number = PE->in[0].eventNo;
		run_number = PE->in[0].runNo;
	}

	// Copy the reference info into the JEvent object
	event.SetJEventSource(this);
	event.SetEventNumber(event_number);
	event.SetRunNumber(run_number);
	event.SetRef(hddm_s);

	return NOERROR;
}

//----------------
// FreeEvent
//----------------
void DEventSourceHDDM::FreeEvent(JEvent &event)
{
	s_HDDM_t *my_hddm_s = (s_HDDM_t*)event.GetRef();
	if(flush_on_free && my_hddm_s!=NULL)flush_s_HDDM(my_hddm_s, 0);
}

//----------------
// GetObjects
//----------------
jerror_t DEventSourceHDDM::GetObjects(JEvent &event, JFactory_base *factory)
{
	/// This gets called through the virtual method of the
	/// JEventSource base class. It creates the objects of the type
	/// on which factory is based. It uses the s_HDDM_t object
	/// kept in the ref field of the JEvent object passed.

	// We must have a factory to hold the data
	if(!factory)throw RESOURCE_UNAVAILABLE;
	
	// HDDM doesn't support tagged factories
	const char* tag = factory->Tag()==NULL ? "":factory->Tag();
	if(strlen(tag)!=0)return OBJECT_NOT_AVAILABLE;
	
	// The ref field of the JEvent is just the s_HDDM_t pointer.
	s_HDDM_t *my_hddm_s = (s_HDDM_t*)event.GetRef();
	if(!my_hddm_s)throw RESOURCE_UNAVAILABLE;
	
	// Get name of data class we're trying to extract
	string dataClassName = factory->GetDataClassName();
	
	if(dataClassName =="DMCTrackHit")
		return Extract_DMCTrackHit(my_hddm_s, dynamic_cast<JFactory<DMCTrackHit>*>(factory));

	if(dataClassName =="DBeamPhoton")
		return Extract_DBeamPhoton(my_hddm_s, dynamic_cast<JFactory<DBeamPhoton>*>(factory));

	if(dataClassName =="DMCThrown")
		return Extract_DMCThrown(my_hddm_s, dynamic_cast<JFactory<DMCThrown>*>(factory));

	if(dataClassName == "DBCALTruthShower" )
	  return Extract_DBCALTruthShower(my_hddm_s, dynamic_cast<JFactory<DBCALTruthShower>*>(factory));

	if(dataClassName =="DHDDMBCALHit")
		return Extract_DHDDMBCALHit(my_hddm_s, dynamic_cast<JFactory<DHDDMBCALHit>*>(factory));

	if(dataClassName =="DCDCHit")
		return Extract_DCDCHit(my_hddm_s, dynamic_cast<JFactory<DCDCHit>*>(factory));

	if(dataClassName =="DFDCHit")
		return Extract_DFDCHit(my_hddm_s, dynamic_cast<JFactory<DFDCHit>*>(factory));

	if(dataClassName == "DFCALTruthShower" )
	  return Extract_DFCALTruthShower(my_hddm_s, dynamic_cast<JFactory<DFCALTruthShower>*>(factory));

	if(dataClassName == "DMCFCALHit" )
	  return Extract_DMCFCALHit(my_hddm_s, dynamic_cast<JFactory<DMCFCALHit>*>(factory), event.GetJEventLoop() );

	if(dataClassName =="DMCTrajectoryPoint")
		return Extract_DMCTrajectoryPoint(my_hddm_s, dynamic_cast<JFactory<DMCTrajectoryPoint>*>(factory));

	if(dataClassName =="DTOFTruth")
	  return Extract_DTOFTruth(my_hddm_s, dynamic_cast<JFactory<DTOFTruth>*>(factory));

	if(dataClassName =="DHDDMTOFHit")
	  return Extract_DHDDMTOFHit(my_hddm_s, dynamic_cast<JFactory<DHDDMTOFHit>*>(factory));

	if(dataClassName =="DSCHit")
	  return Extract_DSCHit(my_hddm_s, dynamic_cast<JFactory<DSCHit>*>(factory));

	if(dataClassName =="DSCTruthHit")
	  return Extract_DSCTruthHit(my_hddm_s, dynamic_cast<JFactory<DSCTruthHit>*>(factory));

	return OBJECT_NOT_AVAILABLE;
}


//------------------
// Extract_DMCTrackHit
//------------------
jerror_t DEventSourceHDDM::Extract_DMCTrackHit(s_HDDM_t *hddm_s, JFactory<DMCTrackHit> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	// The following routines will create DMCTrackHit objects and add them
	// to data.
	vector<DMCTrackHit*> data;
	GetCDCTruthHits(hddm_s, data);
	GetFDCTruthHits(hddm_s, data);
	GetBCALTruthHits(hddm_s, data);
	GetTOFTruthHits(hddm_s, data);
	GetCherenkovTruthHits(hddm_s, data);
	GetFCALTruthHits(hddm_s, data);

	// It has happened that some CDC hits have "nan" for the drift time
	// in a peculiar event Alex Somov came across. This ultimately caused
	// a seg. fault in MCTrackHitSort_C. I hate doing this since it
	// is treating the symptom rather than the cause, but nonetheless,
	// it patches up the problem for now until there is time to revisit
	// it later.
	for(unsigned int i=0;i<data.size(); i++)if(!finite(data[i]->z))data[i]->z=-1000.0;
	
	// sort hits by z
	sort(data.begin(), data.end(), MCTrackHitSort_C);
	
	// Some systems will use negative phis. Force them all to
	// be in the 0 to 2pi range
	for(unsigned int i=0;i<data.size();i++){
		DMCTrackHit *mctrackhit = data[i];
		if(mctrackhit->phi<0.0)mctrackhit->phi += 2.0*M_PI;
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}
//-------------------
// GetCDCTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetCDCTruthHits(s_HDDM_t *hddm_s, vector<DMCTrackHit*>& data)
{
	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL)continue;
		if(hits->centralDC == HDDM_NULL)continue;
		if(hits->centralDC->cdcTruthPoints == HDDM_NULL)continue;
		
		s_CdcTruthPoints_t *cdctruthpoints = hits->centralDC->cdcTruthPoints;
		s_CdcTruthPoint_t *cdctruthpoint = cdctruthpoints->in;
		for(unsigned int j=0; j<cdctruthpoints->mult; j++, cdctruthpoint++){
			DMCTrackHit *mctrackhit = new DMCTrackHit;
			mctrackhit->r			= cdctruthpoint->r;
			mctrackhit->phi		= cdctruthpoint->phi;
			mctrackhit->z			= cdctruthpoint->z;
			mctrackhit->track		= cdctruthpoint->track;
			mctrackhit->primary	= cdctruthpoint->primary;
			mctrackhit->ptype		= cdctruthpoint->ptype;
			mctrackhit->system	= SYS_CDC;
			data.push_back(mctrackhit);
		}
	}
		
	return NOERROR;
}

//-------------------
// GetFDCTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetFDCTruthHits(s_HDDM_t *hddm_s, vector<DMCTrackHit*>& data)
{

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if(hits == HDDM_NULL)continue;
		if(hits->forwardDC == HDDM_NULL)continue;
		if(hits->forwardDC->fdcChambers == HDDM_NULL)continue;

		s_FdcChambers_t* fdcChambers = hits->forwardDC->fdcChambers;
		s_FdcChamber_t *fdcChamber = fdcChambers->in;
		for(unsigned int j=0; j<fdcChambers->mult; j++, fdcChamber++){
			s_FdcTruthPoints_t *fdcTruthPoints = fdcChamber->fdcTruthPoints;
			if(fdcTruthPoints == HDDM_NULL)continue;
			
			s_FdcTruthPoint_t *truth = fdcTruthPoints->in;
			for(unsigned int k=0; k<fdcTruthPoints->mult; k++, truth++){
				float x = truth->x;
				float y = truth->y;
				DMCTrackHit *mctrackhit = new DMCTrackHit;
				mctrackhit->r			= sqrt(x*x + y*y);
				mctrackhit->phi		= atan2(y,x);
				mctrackhit->z			= truth->z;
				mctrackhit->track		= truth->track;
				mctrackhit->primary	= truth->primary;
				mctrackhit->ptype		= truth->ptype;
				mctrackhit->system	= SYS_FDC;
				data.push_back(mctrackhit);
			}
		}
	}

	return NOERROR;
}

//-------------------
// GetBCALTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetBCALTruthHits(s_HDDM_t *hddm_s, vector<DMCTrackHit*>& data)
{
	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->barrelEMcal == HDDM_NULL ||
			hits->barrelEMcal->bcalTruthShowers == HDDM_NULL)continue;
		
		s_BcalTruthShowers_t *bcalTruthShowers = hits->barrelEMcal->bcalTruthShowers;
		s_BcalTruthShower_t *bcalTruthShower = bcalTruthShowers->in;
		for(unsigned int j=0; j<bcalTruthShowers->mult; j++, bcalTruthShower++){
			DMCTrackHit *mctrackhit = new DMCTrackHit;
			mctrackhit->r			= bcalTruthShower->r;
			mctrackhit->phi		= bcalTruthShower->phi;
			mctrackhit->z			= bcalTruthShower->z;
			mctrackhit->track		= bcalTruthShower->track;
			mctrackhit->primary	= bcalTruthShower->primary;
			mctrackhit->ptype		= bcalTruthShower->ptype;
			mctrackhit->system	= SYS_BCAL;
			data.push_back(mctrackhit);
		}
	}

	return NOERROR;
}

//-------------------
// GetTOFTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetTOFTruthHits(s_HDDM_t *hddm_s,  vector<DMCTrackHit*>& data)
{
	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->forwardTOF == HDDM_NULL ||
			hits->forwardTOF->ftofTruthPoints == HDDM_NULL)continue;
		
		s_FtofTruthPoints_t *ftoftruthpoints = hits->forwardTOF->ftofTruthPoints;
		s_FtofTruthPoint_t *ftoftruthpoint = ftoftruthpoints->in;
		for(unsigned int j=0; j<ftoftruthpoints->mult; j++, ftoftruthpoint++){
			float x = ftoftruthpoint->x;
			float y = ftoftruthpoint->y;
			DMCTrackHit *mctrackhit = new DMCTrackHit;
			mctrackhit->r			= sqrt(x*x + y*y);
			mctrackhit->phi		= atan2(y,x);
			mctrackhit->z			= ftoftruthpoint->z;
			mctrackhit->track		= ftoftruthpoint->track;
			mctrackhit->primary	= ftoftruthpoint->primary;
			mctrackhit->ptype    = ftoftruthpoint->ptype; // save GEANT particle type 
			mctrackhit->system	= SYS_TOF;
			data.push_back(mctrackhit);
		}
	}
		
	return NOERROR;
}

//-------------------
// GetCherenkovTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetCherenkovTruthHits(s_HDDM_t *hddm_s, vector<DMCTrackHit*>& data)
{

	return NOERROR;
}

//-------------------
// GetFCALTruthHits
//-------------------
jerror_t DEventSourceHDDM::GetFCALTruthHits(s_HDDM_t *hddm_s, vector<DMCTrackHit*>& data)
{
	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->forwardEMcal == HDDM_NULL ||
			hits->forwardEMcal->fcalTruthShowers == HDDM_NULL)continue;
		
		s_FcalTruthShowers_t *fcalTruthShowers = hits->forwardEMcal->fcalTruthShowers;
		s_FcalTruthShower_t *fcalTruthShower = fcalTruthShowers->in;
		for(unsigned int j=0; j<fcalTruthShowers->mult; j++, fcalTruthShower++){
			float x = fcalTruthShower->x;
			float y = fcalTruthShower->y;
			DMCTrackHit *mctrackhit = new DMCTrackHit;
			mctrackhit->r			= sqrt(x*x + y*y);
			mctrackhit->phi		= atan2(y,x);
			mctrackhit->z			= fcalTruthShower->z;
			mctrackhit->track		= fcalTruthShower->track;
			mctrackhit->primary	= fcalTruthShower->primary;
			mctrackhit->ptype		= fcalTruthShower->ptype;
			mctrackhit->system	= SYS_FCAL;
			data.push_back(mctrackhit);
		}
	}

	return NOERROR;
}

//------------------
// Extract_DBCALHit
//------------------
jerror_t DEventSourceHDDM::Extract_DHDDMBCALHit(s_HDDM_t *hddm_s, JFactory<DHDDMBCALHit> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DHDDMBCALHit*> data;

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->barrelEMcal == HDDM_NULL ||
			hits->barrelEMcal->bcalCells == HDDM_NULL)continue;
		
		// Loop over BCAL cells
		s_BcalCells_t *cells = hits->barrelEMcal->bcalCells;
		for(unsigned int j=0;j<cells->mult;j++){
			s_BcalCell_t *cell = &cells->in[j];
			if(cell->bcalHits != HDDM_NULL){
				for(unsigned int k=0; k<cell->bcalHits->mult; k++){
					s_BcalHit_t *hit = &cell->bcalHits->in[k];
					
					DHDDMBCALHit *bcalhit = new DHDDMBCALHit();
					bcalhit->module = cell->module;
					bcalhit->layer = cell->layer;
					bcalhit->sector = cell->sector;
					bcalhit->E = hit->E;
					bcalhit->t = hit->t;
					bcalhit->zLocal = hit->zLocal;
					data.push_back(bcalhit);
				}
			}
		} // j   (cells)
	} // i   (physicsEvents)
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DBeamPhoton
//------------------
jerror_t DEventSourceHDDM::Extract_DBeamPhoton(s_HDDM_t *hddm_s,  JFactory<DBeamPhoton> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DBeamPhoton*> data;

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		// ------------ Reactions --------------
		s_Reactions_t *reactions=PE->in[i].reactions;
		if(!reactions)continue;

		for(unsigned int j=0; j<reactions->mult; j++){
			s_Beam_t *beam = reactions->in[j].beam;
			if(beam!=HDDM_NULL){
				s_Momentum_t *momentum = beam->momentum;
				
				DVector3 pos(0.0, 0.0, 65.0);
				DVector3 mom(momentum->px, momentum->py, momentum->pz);
				DBeamPhoton *photon = new DBeamPhoton;
				photon->setPosition(pos);
				photon->setMomentum(mom);
				photon->setMass(0.0);
				photon->setCharge(0.0);
				photon->clearErrorMatrix();
				photon->t = 0.0;
		
				data.push_back(photon);
			}
		}
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DMCThrown
//------------------
jerror_t DEventSourceHDDM::Extract_DMCThrown(s_HDDM_t *hddm_s,  JFactory<DMCThrown> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DMCThrown*> data;

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		// ------------ Reactions --------------
		s_Reactions_t *reactions=PE->in[i].reactions;
		if(!reactions)continue;

		for(unsigned int j=0; j<reactions->mult; j++){
			s_Vertices_t *vertices = reactions->in[j].vertices;
			if(vertices){
				for(unsigned int k=0; k<vertices->mult; k++){
					s_Origin_t *origin = vertices->in[k].origin;
					s_Products_t *products = vertices->in[k].products;
					if(products && origin){
						for(unsigned int m=0;m<products->mult;m++){
							s_Product_t *product = &products->in[m];

							double px = product->momentum->px;
							double py = product->momentum->py;
							double pz = product->momentum->pz;
							
							DMCThrown *mcthrown = new DMCThrown;
							mcthrown->type = product->type;
							mcthrown->myid = product->id;
							mcthrown->parentid = product->parentid;
							mcthrown->mech = product->mech;
							mcthrown->pdgtype = product->pdgtype;
							mcthrown->setMass(ParticleMass(product->type));
							mcthrown->setMomentum(DVector3(px, py, pz));
							mcthrown->setPosition(DVector3(origin->vx, origin->vy, origin->vz));
							mcthrown->setCharge(ParticleCharge(product->type));
							
							data.push_back(mcthrown);
						}
					}
				}
			}
		}
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DCDCHit
//------------------
jerror_t DEventSourceHDDM::Extract_DCDCHit(s_HDDM_t *hddm_s,  JFactory<DCDCHit> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DCDCHit*> data;

	// Acquire the pointer to the physics events
	s_PhysicsEvents_t* allEvents = hddm_s->physicsEvents;
	if(!allEvents)return NOERROR;
       
	for (unsigned int m=0; m < allEvents->mult; m++) {
		// Acquire the pointer to the overall hits section of the data
		s_HitView_t *hits = allEvents->in[m].hitView;
		
		if (hits == HDDM_NULL)continue;
		if (hits->centralDC == HDDM_NULL)continue;
		if (hits->centralDC->cdcStraws == HDDM_NULL)continue;
		for(unsigned int k=0; k<hits->centralDC->cdcStraws->mult; k++){
			s_CdcStraw_t *cdcstraw = &hits->centralDC->cdcStraws->in[k];
			for(unsigned int j=0; j<cdcstraw->cdcStrawHits->mult; j++){
				s_CdcStrawHit_t *strawhit = &cdcstraw->cdcStrawHits->in[j];
				
				DCDCHit *hit = new DCDCHit;
				hit->ring = cdcstraw->ring;
				hit->straw = cdcstraw->straw;
				hit->dE = strawhit->dE;
				hit->t = strawhit->t;

				data.push_back(hit);
			}
		}
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}


//------------------
// Extract_DFDCHit
//------------------
jerror_t DEventSourceHDDM::Extract_DFDCHit(s_HDDM_t *hddm_s,  JFactory<DFDCHit> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DFDCHit*> data;

	// Acquire the pointer to the physics events
	s_PhysicsEvents_t* allEvents = hddm_s->physicsEvents;
	if(!allEvents) {
	  //throw JException("Attempt to get physics events from HDDM source failed.");
		return NOERROR;
	}
       
	for (unsigned int m=0; m < allEvents->mult; m++) {
	
		// Acquire the pointer to the overall hits section of the data
		s_HitView_t *hits = allEvents->in[m].hitView;
		
		if (hits == HDDM_NULL) {
		  //throw JException("HDDM source has no hits.");
			continue;
		}

		if (hits->forwardDC == HDDM_NULL) {
		  //throw JException("HDDM source has no forwardDC information.");
			continue;
		}

		if (hits->forwardDC->fdcChambers == HDDM_NULL) {
		  // throw JException("HDDM source has no hits in the FDC.");		
			continue;
		}

		// Acquire the pointer to the beginning of the FDC hit tree
		s_FdcChambers_t* fdcChamberSet = hits->forwardDC->fdcChambers;

		for (unsigned int i=0; i < fdcChamberSet->mult; i++) {
			// Each chamber in the ChamberSet has a wire set and a strip set
			s_FdcChamber_t &fdcChamber 		= fdcChamberSet->in[i];		
			s_FdcAnodeWires_t* wireSet 		= fdcChamber.fdcAnodeWires;
			s_FdcCathodeStrips_t* stripSet 	= fdcChamber.fdcCathodeStrips;
		
			// Each set of wires has (obviously) wires inside of it, and each wire
			// may have one or more hits on it. Make a DFDCHit object for each one
			// of these hits.
			for (unsigned int j=0; j < wireSet->mult; j++) {
				s_FdcAnodeWire_t anodeWire		= wireSet->in[j];
				s_FdcAnodeHits_t* wireHitSet	= anodeWire.fdcAnodeHits;
				for (unsigned int k=0; k < wireHitSet->mult; k++) {
					s_FdcAnodeHit_t wireHit		= wireHitSet->in[k];
					DFDCHit* newHit				= new DFDCHit();
					newHit->layer		 		= fdcChamber.layer;
					newHit->module		 		= fdcChamber.module;
					newHit->element				= anodeWire.wire;
					newHit->q					= wireHit.dE;
					newHit->t					= wireHit.t;
					newHit->plane				= 2;
					newHit->type				= 0;
					newHit->gPlane				= DFDCGeometry::gPlane(newHit);
					newHit->gLayer				= DFDCGeometry::gLayer(newHit);
					newHit->r					= DFDCGeometry::getWireR(newHit);
					
					data.push_back(newHit);
				}
			}
		
			// Ditto for the cathodes.
			for (unsigned int j=0; j < stripSet->mult; j++) {
				s_FdcCathodeStrip_t cathodeStrip = stripSet->in[j];
				s_FdcCathodeHits_t* stripHitSet = cathodeStrip.fdcCathodeHits;
				for (unsigned int k=0; k < stripHitSet->mult; k++) {
					s_FdcCathodeHit_t stripHit	= stripHitSet->in[k];
					DFDCHit* newHit				= new DFDCHit();
					newHit->layer				= fdcChamber.layer;
					newHit->module				= fdcChamber.module;
					newHit->element				= cathodeStrip.strip;
					newHit->plane				= cathodeStrip.plane;
					newHit->q					= stripHit.q;
					newHit->t					= stripHit.t;
					newHit->type				= 1;
					newHit->gPlane				= DFDCGeometry::gPlane(newHit);	 
					newHit->gLayer				= DFDCGeometry::gLayer(newHit);
					newHit->r					= DFDCGeometry::getStripR(newHit);
					data.push_back(newHit);
				}
			}	
		}
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DBCALTruthShower
//------------------
jerror_t DEventSourceHDDM::Extract_DBCALTruthShower(s_HDDM_t *hddm_s,  JFactory<DBCALTruthShower> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.

	if(factory==NULL)return OBJECT_NOT_AVAILABLE;

	vector<DBCALTruthShower*> data;

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i = 0; i < PE->mult; i++) {
		s_BcalTruthShowers_t* bcalTruthShowers = NULL;
		if(PE->in[i].hitView == HDDM_NULL)continue;
		if(PE->in[i].hitView->barrelEMcal == HDDM_NULL)continue;
		if((bcalTruthShowers = PE->in[i].hitView->barrelEMcal->bcalTruthShowers) == HDDM_NULL)continue;
       
		for(unsigned int j = 0; j < bcalTruthShowers->mult; j++) {
			DBCALTruthShower *bcaltruth = new DBCALTruthShower;
			bcaltruth->track = bcalTruthShowers->in[j].track;
			bcaltruth->primary = bcalTruthShowers->in[j].primary ? 1 : 0;
			bcaltruth->phi = bcalTruthShowers->in[j].phi;
			bcaltruth->r = bcalTruthShowers->in[j].r;
			bcaltruth->z = bcalTruthShowers->in[j].z;
			bcaltruth->t = bcalTruthShowers->in[j].t;
			bcaltruth->E = bcalTruthShowers->in[j].E;
			data.push_back(bcaltruth);
		}
	}

	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DFCALTruthShower
//------------------
jerror_t DEventSourceHDDM::Extract_DFCALTruthShower(s_HDDM_t *hddm_s,  JFactory<DFCALTruthShower> *factory)
{
  	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DFCALTruthShower*> data;

		// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	JObject::oid_t id=1;
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->forwardEMcal == HDDM_NULL ||
			hits->forwardEMcal->fcalTruthShowers == HDDM_NULL)continue;

		s_FcalTruthShowers_t *showers = hits->forwardEMcal->fcalTruthShowers;
		for(unsigned int j=0; j<showers->mult; j++){
			s_FcalTruthShower_t *shower = &showers->in[j];
			
			DFCALTruthShower *dfcaltruthshower = new DFCALTruthShower(
				id++,
				shower->x,
				shower->y,
				shower->z,
				shower->px,
				shower->py,
				shower->pz,
				shower->E,
				shower->t,
				shower->primary,
				shower->track,
				shower->ptype
				);
			
			data.push_back(dfcaltruthshower);
		}

	} // i  (physicsEvents)

	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DMCFCALHit
//------------------
jerror_t DEventSourceHDDM::Extract_DMCFCALHit(s_HDDM_t *hddm_s,  JFactory<DMCFCALHit> *factory, JEventLoop* eventLoop )
{
  /// Copies the data from the given hddm_s structure. This is called
  /// from JEventSourceHDDM::GetObjects. If factory is NULL, this
  /// returns OBJECT_NOT_AVAILABLE immediately.
	
  if(factory==NULL)return OBJECT_NOT_AVAILABLE;

  vector<DMCFCALHit*> data;
  
  // Loop over Physics Events
  s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
  if(!PE) return NOERROR;
	
  int hitId = 0;
  for(unsigned int i=0; i<PE->mult; i++){
      s_HitView_t *hits = PE->in[i].hitView;
      if (hits == HDDM_NULL ||
          hits->forwardEMcal == HDDM_NULL ||
          hits->forwardEMcal->fcalBlocks == HDDM_NULL)continue;
      
      s_FcalBlocks_t *blocks = hits->forwardEMcal->fcalBlocks;
      for(unsigned int j=0; j<blocks->mult; j++){
          s_FcalBlock_t *block = &blocks->in[j];
          for(unsigned int k=0; k<block->fcalHits->mult; k++){
              s_FcalHit_t *fcalhit = &block->fcalHits->in[k];
              
              DMCFCALHit *mchit = new DMCFCALHit();
              mchit->column = block->column;
              mchit->row = block->row;
              mchit->E = fcalhit->E;
              mchit->t = fcalhit->t;
              mchit->id = hitId++;
              
              data.push_back(mchit);
              
          } // k  (fcalhits)
      } // j  (blocks)
  } // i  (physicsEvents)
  
  // Copy into factory
  factory->CopyTo(data);
  
  return NOERROR;
}

//------------------
// Extract_DMCTrajectoryPoint
//------------------
jerror_t DEventSourceHDDM::Extract_DMCTrajectoryPoint(s_HDDM_t *hddm_s,  JFactory<DMCTrajectoryPoint> *factory)
{
	/// Copies the data from the given hddm_s structure. This is called
	/// from JEventSourceHDDM::GetObjects. If factory is NULL, this
	/// returns OBJECT_NOT_AVAILABLE immediately.
	
	if(factory==NULL)return OBJECT_NOT_AVAILABLE;
	
	vector<DMCTrajectoryPoint*> data;

	// Loop over Physics Events
	s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
	if(!PE) return NOERROR;
	
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if(hits == HDDM_NULL || hits==NULL)continue;
		if(hits->mcTrajectory == HDDM_NULL || hits->mcTrajectory==NULL)continue;
		if(hits->mcTrajectory->mcTrajectoryPoints == HDDM_NULL || hits->mcTrajectory->mcTrajectoryPoints==NULL)continue;

		s_McTrajectoryPoints_t *points = hits->mcTrajectory->mcTrajectoryPoints;
		for(unsigned int i=0; i<points->mult; i++){
			DMCTrajectoryPoint *p = new DMCTrajectoryPoint;
			
			p->x = points->in[i].x;
			p->y = points->in[i].y;
			p->z = points->in[i].z;
			p->t = points->in[i].t;
			p->px = points->in[i].px;
			p->py = points->in[i].py;
			p->pz = points->in[i].pz;
			p->E = points->in[i].E;

			p->dE = points->in[i].dE;
			p->primary_track = points->in[i].primary_track;
			p->track = points->in[i].track;
			p->part = points->in[i].part;

			p->radlen = points->in[i].radlen;
			p->step = points->in[i].step;
			p->mech = points->in[i].mech;
			
			data.push_back(p);
		}		
	}
	
	// Copy into factory
	factory->CopyTo(data);

	return NOERROR;
}

//------------------
// Extract_DTOFTruth
//------------------
jerror_t DEventSourceHDDM::Extract_DTOFTruth(s_HDDM_t *hddm_s,  JFactory<DTOFTruth>* factory)
{
  /// Copies the data from the given hddm_s structure. This is called
  /// from JEventSourceHDDM::GetObjects. If factory is NULL, this
  /// returns OBJECT_NOT_AVAILABLE immediately.
	
  if(factory==NULL)return OBJECT_NOT_AVAILABLE;
  
  vector<DTOFTruth*> data;

  // Loop over Physics Events
  s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
  if(!PE) return NOERROR;
	
  int id = 0;
  for(unsigned int i=0; i<PE->mult; i++){
    s_HitView_t *hits = PE->in[i].hitView;
    if (hits == HDDM_NULL ||
	hits->forwardTOF == HDDM_NULL ||
	hits->forwardTOF->ftofTruthPoints == HDDM_NULL)continue;

    s_FtofTruthPoints_t* ftofTruthPoints = hits->forwardTOF->ftofTruthPoints;

    // Loop truth hits
    s_FtofTruthPoint_t *ftofTruthPoint = ftofTruthPoints->in;
    for(unsigned int j=0;j<ftofTruthPoints->mult; j++, ftofTruthPoint++){
      DTOFTruth *toftruth = new DTOFTruth;
		
      toftruth->id          = id++;
      toftruth->primary     = ftofTruthPoint->primary;
      toftruth->track       = ftofTruthPoint->track;
      toftruth->x           = ftofTruthPoint->x;
      toftruth->y           = ftofTruthPoint->y;
      toftruth->z           = ftofTruthPoint->z;
      toftruth->t           = ftofTruthPoint->t;
      toftruth->px          = ftofTruthPoint->px;
      toftruth->py          = ftofTruthPoint->py;
      toftruth->pz          = ftofTruthPoint->pz;
      toftruth->E           = ftofTruthPoint->E;
      toftruth->ptype       = ftofTruthPoint->ptype;

      data.push_back(toftruth);
    }
  }

  // Copy into factory
  factory->CopyTo(data);

  return NOERROR;
}

//------------------
// Extract_DHDDMTOFHit
//------------------
jerror_t DEventSourceHDDM::Extract_DHDDMTOFHit( s_HDDM_t *hddm_s,  JFactory<DHDDMTOFHit>* factory)
{
  /// Copies the data from the given hddm_s structure. This is called
  /// from JEventSourceHDDM::GetObjects. If factory is NULL, this
  /// returns OBJECT_NOT_AVAILABLE immediately.
	
  if(factory==NULL)return OBJECT_NOT_AVAILABLE;

  vector<DHDDMTOFHit*> data;
  
  s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
  if(!PE) return NOERROR;
  
  int id = 0;

  for(unsigned int i=0; i<PE->mult; i++){
    s_HitView_t *hits = PE->in[i].hitView;
    if (hits == HDDM_NULL ||
	hits->forwardTOF == HDDM_NULL ||
	hits->forwardTOF->ftofCounters == HDDM_NULL)continue;
		
    s_FtofCounters_t* ftofCounters = hits->forwardTOF->ftofCounters;
		
    // Loop over counters
    s_FtofCounter_t *ftofCounter = ftofCounters->in;
    for(unsigned int j=0;j<ftofCounters->mult; j++, ftofCounter++){
			 
      // Loop over north AND south hits
      s_FtofNorthHits_t *ftofNorthHits = ftofCounter->ftofNorthHits;
      s_FtofNorthHit_t *ftofNorthHit = ftofNorthHits->in;
      s_FtofSouthHits_t *ftofSouthHits = ftofCounter->ftofSouthHits;
      s_FtofSouthHit_t *ftofSouthHit = ftofSouthHits->in;

      for(unsigned int k=0;k<ftofNorthHits->mult; k++, ftofNorthHit++, ftofSouthHit++){
	DHDDMTOFHit *tofhit = new DHDDMTOFHit;
	tofhit->bar	= ftofCounter->bar;
	tofhit->plane	= ftofCounter->plane;
	tofhit->t_north		= ftofNorthHit->t;
	tofhit->dE_north	= ftofNorthHit->dE;
	tofhit->t_south		= ftofSouthHit->t;
	tofhit->dE_south	= ftofSouthHit->dE;
	tofhit->x               = ftofNorthHit->x;
	tofhit->y               = ftofNorthHit->y;
	tofhit->z               = ftofNorthHit->z;
	tofhit->px              = ftofNorthHit->px;
	tofhit->py              = ftofNorthHit->py;
	tofhit->pz              = ftofNorthHit->pz;
	tofhit->E               = ftofNorthHit->E;
	tofhit->ptype           = ftofNorthHit->ptype;
	tofhit->id              = id++;
	data.push_back(tofhit);
      }
			 
    }
  }

  // Copy into factory
  factory->CopyTo(data);

  return NOERROR;
}

//------------------
// Extract_DSCHit
//------------------
jerror_t DEventSourceHDDM::Extract_DSCHit( s_HDDM_t *hddm_s,  JFactory<DSCHit>* factory)
{
  /// Copies the data from the given hddm_s structure. This is called
  /// from JEventSourceHDDM::GetObjects. If factory is NULL, this
  /// returns OBJECT_NOT_AVAILABLE immediately.
	
  if(factory==NULL)return OBJECT_NOT_AVAILABLE;

  vector<DSCHit*> data;
  
  s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
  if(!PE) return NOERROR;
  
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->startCntr == HDDM_NULL)continue;
		
		s_StcPaddles_t* stcPaddles = hits->startCntr->stcPaddles;
		if(stcPaddles==HDDM_NULL)continue;
		//s_StcTruthPoints_t* stcTruthPoints = hits->startCntr->stcTruthPoints;
		
		// Loop over counters
		s_StcPaddle_t *stcPaddle = stcPaddles->in;
		for(unsigned int j=0;j<stcPaddles->mult; j++, stcPaddle++){
			s_StcHits_t *stcHits = stcPaddle->stcHits;
			if(stcHits==HDDM_NULL)continue;
			
			s_StcHit_t *stchit = stcHits->in;
			for(unsigned int k=0; k<stcHits->mult; k++, stchit++){
				DSCHit *hit = new DSCHit;
				hit->sector = stcPaddle->sector;
				hit->dE = stchit->dE;
				hit->t = stchit->t;
				data.push_back(hit);
			}
		}
	}

  // Copy into factory
  factory->CopyTo(data);

  return NOERROR;
}


//------------------
// Extract_DSCTruthHit
//------------------
jerror_t DEventSourceHDDM::Extract_DSCTruthHit( s_HDDM_t *hddm_s,  JFactory<DSCTruthHit>* factory)
{
  /// Copies the data from the given hddm_s structure. This is called
  /// from JEventSourceHDDM::GetObjects. If factory is NULL, this
  /// returns OBJECT_NOT_AVAILABLE immediately.
	
  if(factory==NULL)return OBJECT_NOT_AVAILABLE;

  vector<DSCTruthHit*> data;
  
  s_PhysicsEvents_t* PE = hddm_s->physicsEvents;
  if(!PE) return NOERROR;
  
	for(unsigned int i=0; i<PE->mult; i++){
		s_HitView_t *hits = PE->in[i].hitView;
		if (hits == HDDM_NULL ||
			hits->startCntr == HDDM_NULL)continue;
		
		s_StcTruthPoints_t* stcTruthPoints = hits->startCntr->stcTruthPoints;
		if(stcTruthPoints==HDDM_NULL)continue;
		
		// Loop over counters
		s_StcTruthPoint_t *stcTruthPoint = stcTruthPoints->in;
		for(unsigned int j=0;j<stcTruthPoints->mult; j++, stcTruthPoint++){

			DSCTruthHit *hit = new DSCTruthHit;
			hit->dEdx = stcTruthPoint->dEdx;
			hit->phi = stcTruthPoint->phi;
			hit->primary = stcTruthPoint->primary;
			hit->ptype = stcTruthPoint->ptype;
                        hit->r = stcTruthPoint->r;
			hit->t = stcTruthPoint->t;
			hit->z = stcTruthPoint->z;
			hit->track = stcTruthPoint->track;
			data.push_back(hit);
		}
	}

  // Copy into factory
  factory->CopyTo(data);

  return NOERROR;
}
