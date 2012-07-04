// $Id$
//
//    File: DNeutralParticleHypothesis_factory.cc
// Created: Thu Dec  3 17:27:55 EST 2009
// Creator: pmatt (on Linux ifarml6 2.6.18-128.el5 x86_64)
//


#include <iostream>
#include <iomanip>
using namespace std;

#include <TMath.h>

#include "DNeutralParticleHypothesis_factory.h"
using namespace jana;


DNeutralParticleHypothesis_factory::DNeutralParticleHypothesis_factory()
{

  CENTER_VERTEX=0;
  gPARMS->SetDefaultParameter( "NEUTHYPO:CENTER_VERTEX",CENTER_VERTEX,
			       "Assumption center of target for vertex");

  REQ_BCAL_ENTRY_HIT=false;
  gPARMS->SetDefaultParameter( "NEUTHYPO:REQ_BCAL_ENTRY_HIT",REQ_BCAL_ENTRY_HIT,
			       "Require that BCAL showers begin at entry layer");
  TEST_EM_SHOWER=false;
  gPARMS->SetDefaultParameter( "NEUTHYPO:TEST_EM_SHOWER",TEST_EM_SHOWER,
			       "Test for EM-signature of BCAL showers");
  
  EM_BACK_E_THRES=0.5;
  EM_CENT_THRES=6.5; 
  gPARMS->SetDefaultParameter( "NEUTHYPO:EM_BACK_E_THRES",EM_BACK_E_THRES,
			       "Threshold for max. energy in 4th BCAL layer in EM shower");
  gPARMS->SetDefaultParameter( "NEUTHYPO:EM_CENT_THRES", EM_CENT_THRES,
			       "Threshold for shower layer centroid (in SiPM patch units)");

}


//------------------
// init
//------------------
jerror_t DNeutralParticleHypothesis_factory::init(void)
{
	return NOERROR;
}

//------------------
// brun
//------------------
jerror_t DNeutralParticleHypothesis_factory::brun(jana::JEventLoop *locEventLoop, int runnumber)
{

	// Get Target parameters from XML
	DApplication *locApplication = dynamic_cast<DApplication*> (locEventLoop->GetJApplication());
	DGeometry *locGeometry = locApplication ? locApplication->GetDGeometry(runnumber):NULL;
	dTargetLength = 30.0;
	dTargetRadius = 1.5; //FIX: grab from database!!!
	dTargetCenter_Z = 65.0;
	if(locGeometry){
	  locGeometry->GetTargetLength(dTargetLength);
	  locGeometry->GetTargetZ(dTargetCenter_Z);
	}

  // Get the particle ID algorithms
	vector<const DParticleID *> locPIDAlgorithms;
	locEventLoop->Get(locPIDAlgorithms);
	if(locPIDAlgorithms.size() < 1){
		_DBG_<<"Unable to get a DParticleID object! NO PID will be done!"<<endl;
		return RESOURCE_UNAVAILABLE;
	}
	// Drop the const qualifier from the DParticleID pointer (I'm surely going to hell for this!)
	dPIDAlgorithm = const_cast<DParticleID*>(locPIDAlgorithms[0]);
  
	// Warn user if something happened that caused us NOT to get a dPIDAlgorithm object pointer
	if(!dPIDAlgorithm){
		_DBG_<<"Unable to get a DParticleID object! NO PID will be done!"<<endl;
		return RESOURCE_UNAVAILABLE;
	}

	return NOERROR;
}

//------------------
// evnt
//------------------
jerror_t DNeutralParticleHypothesis_factory::
evnt(jana::JEventLoop *locEventLoop, int eventnumber)
{
  unsigned int loc_i, loc_j, loc_k, locNDF = 1;
  bool locShowerMatchFlag;
  float locMass, locMomentum, locShowerEnergy, locParticleEnergy;
  float locPathLength, locFlightTime, locProjectedTime, locTimeDifference;
  float locParticleEnergyUncertainty, locShowerEnergyUncertainty; 
  float locTimeDifferenceVariance, locChiSq, locFOM;
  DVector3 locPathVector;
  DLorentzVector locVertexPos(0,0,0,0);
  locVertexPos.SetZ(dTargetCenter_Z);

  const DNeutralShower *locNeutralShower;
  const DChargedTrackHypothesis *locChargedTrackHypothesis;
  const DVertex *locVertex;
  DNeutralParticleHypothesis *locNeutralParticleHypothesis;
  DMatrixDSym locVariances, locErrorMatrix;
  vector<const DBCALShower*> locAssociatedBCALShowers_NeutralShower;
  vector<const DFCALShower*> locAssociatedFCALShowers_NeutralShower;
  vector<const DBCALShower*> locAssociatedBCALShowers_ChargedTrack;
  vector<const DFCALShower*> locAssociatedFCALShowers_ChargedTrack;
  
  vector<const DChargedTrack*> locChargedTracks;
  vector<const DNeutralShower*> locNeutralShowers;
  vector<const DVertex*> locVertices;
  locEventLoop->Get(locChargedTracks);
  locEventLoop->Get(locNeutralShowers);
  locEventLoop->Get(locVertices);
  
  vector<Particle_t> locPIDHypotheses;
  locPIDHypotheses.push_back(Gamma);
  locPIDHypotheses.push_back(Neutron);
  
  // Loop over DNeutralShowers
  for (loc_i = 0; loc_i < locNeutralShowers.size(); loc_i++){
    locNeutralShower = locNeutralShowers[loc_i];
    locNeutralShower->GetT(locAssociatedBCALShowers_NeutralShower);
    locNeutralShower->GetT(locAssociatedFCALShowers_NeutralShower);
    
    
    // Disqualify showers that don't start on BCAL entry -IS
    if(REQ_BCAL_ENTRY_HIT &&
       BCALShowerLacksEntryHit(locAssociatedBCALShowers_NeutralShower)) continue;
    

    // If the DNeutralShower is matched to the DChargedTrackHypothesis 
    // with the highest FOM of ANY DChargedTrack, skip it
    locShowerMatchFlag = false;
    for (loc_j = 0; loc_j < locChargedTracks.size(); loc_j++){
      locChargedTrackHypothesis = locChargedTracks[loc_j]->dChargedTrackHypotheses[0];
      locChargedTrackHypothesis->GetT(locAssociatedBCALShowers_ChargedTrack);
      locChargedTrackHypothesis->GetT(locAssociatedFCALShowers_ChargedTrack);
      if ((locAssociatedBCALShowers_ChargedTrack.size() > 0) && 
	  (locAssociatedBCALShowers_NeutralShower.size() > 0)){
	if (locAssociatedBCALShowers_ChargedTrack[0]->id == 
	    locAssociatedBCALShowers_NeutralShower[0]->id){
	  locShowerMatchFlag = true;
	  break;
	}
      }
      if ((locShowerMatchFlag == false) && 
	  (locAssociatedFCALShowers_ChargedTrack.size() > 0) && 
	  (locAssociatedFCALShowers_NeutralShower.size() > 0)){
	if (locAssociatedFCALShowers_ChargedTrack[0]->id == 
	    locAssociatedFCALShowers_NeutralShower[0]->id){
	  locShowerMatchFlag = true;
	  break;
	}
      }
    }
    //shower matched to a DChargedTrackHypothesis with the highest FOM, not a neutral
    if (locShowerMatchFlag == true) continue; 
    
    // Loop over vertices and PID hypotheses & 
    // create DNeutralParticleHypotheses for each combination
    for (loc_j = 0; loc_j < locVertices.size(); loc_j++){
      locVertex = locVertices[loc_j];
      if(!CENTER_VERTEX) locVertexPos = locVertex->dSpacetimeVertex;

      for (loc_k = 0; loc_k < locPIDHypotheses.size(); loc_k++){

	// If considering photon hypo, test if looks like EM shower -IS
	if(TEST_EM_SHOWER && 
	   locPIDHypotheses[loc_k]==Gamma &&
	   locAssociatedBCALShowers_NeutralShower.size()>0 &&
	   !BCALShowerLikelyEM(locAssociatedBCALShowers_NeutralShower[0])) 
	  continue;
	   


	// Calculate DNeutralParticleHypothesis Quantities 
	// (projected time at vertex for given id, etc.)
	locMass = ParticleMass(locPIDHypotheses[loc_k]);
	locShowerEnergy = locNeutralShower->dEnergy;
	locParticleEnergy = locShowerEnergy; //need to correct this for neutrons!
	if (locParticleEnergy < locMass)
	  continue; //not enough energy for PID hypothesis
	
	locShowerEnergyUncertainty = locNeutralShower->dEnergyUncertainty;
	locParticleEnergyUncertainty = locShowerEnergyUncertainty; //need to correct this for neutrons!
	
	locPathVector = locNeutralShower->dSpacetimeVertex.Vect() - locVertexPos.Vect();
	locPathLength = locPathVector.Mag();
	if(!(locPathLength > 0.0))
	  continue; //invalid, will divide by zero when creating error matrix, so skip!
	locMomentum = sqrt(locParticleEnergy*locParticleEnergy - locMass*locMass);
	locFlightTime = locPathLength*locParticleEnergy/(locMomentum*SPEED_OF_LIGHT);
	locProjectedTime = locNeutralShower->dSpacetimeVertex.T() - locFlightTime;
	
	// Calculate DNeutralParticleHypothesis FOM
	locTimeDifference = locVertexPos.T() - locProjectedTime;
	locTimeDifferenceVariance = 1.0; //completely random, ok because ID disabled for neutrons anyway
	locChiSq = locTimeDifference*locTimeDifference/locTimeDifferenceVariance;
	locFOM = TMath::Prob(locChiSq, locNDF);
	if(locPIDHypotheses[loc_k] == Neutron)
	  locFOM = -1.0; //disables neutron ID until the neutron energy is calculated correctly from the deposited energy in the shower
	
	// Build DNeutralParticleHypothesis // dEdx not set
	locNeutralParticleHypothesis = new DNeutralParticleHypothesis;
	locNeutralParticleHypothesis->AddAssociatedObject(locVertex);
	locNeutralParticleHypothesis->AddAssociatedObject(locNeutralShower);
	
	locNeutralParticleHypothesis->setMass(locMass);
	locNeutralParticleHypothesis->setCharge(0.0);
	
	Calc_Variances(locNeutralShower, locParticleEnergyUncertainty, locVariances);
	Build_ErrorMatrix(locPathVector, locParticleEnergy, locVariances, locErrorMatrix);
	
	locNeutralParticleHypothesis->setErrorMatrix(locErrorMatrix);
	locNeutralParticleHypothesis->clearTrackingErrorMatrix();
	locPathVector.SetMag(locMomentum);
	locNeutralParticleHypothesis->setMomentum(locPathVector);
	locNeutralParticleHypothesis->setPosition(locVertexPos.Vect());
	locNeutralParticleHypothesis->setT0(locVertexPos.T(), locVertex->dTimeUncertainty, SYS_NULL);
	locNeutralParticleHypothesis->setT1(locNeutralShower->dSpacetimeVertex.T(), locNeutralShower->dSpacetimeVertexUncertainties.T(), locNeutralShower->dDetectorSystem);
	locNeutralParticleHypothesis->setPathLength(locPathLength, 0.0); //zero uncertainty (for now)
	
	locNeutralParticleHypothesis->dPID = locPIDHypotheses[loc_k];
	locNeutralParticleHypothesis->dChiSq = locChiSq;
	locNeutralParticleHypothesis->dNDF = locNDF;
	locNeutralParticleHypothesis->dFOM = locFOM;
	
				_data.push_back(locNeutralParticleHypothesis);	
      } //end PID loop
    } //end DVertex loop
  } //end DNeutralShower loop
  
  return NOERROR;
}


/**
 * This function tests whether a BCAL shower is likely electromagnetic
 * by looking at the energy distribution by layer. An EM shower from a
 * photon should deposit most of its energy in the front (entry) layers.
 * If more enery is in the back, it is likely a dark hit or hadronic.
 * The 4th layer is expected to have less than EM_DIST_THRES1 of the energy
 * (default: 50%) and the centroid is expected to be within EM_CENT_THRES
 * of BCAL entry
*/
bool DNeutralParticleHypothesis_factory::
BCALShowerLikelyEM(const DBCALShower* shower)
{

  vector<const DBCALHit*> showerHits;
  shower->GetT(showerHits);
  if(showerHits.size() <= 2) return false;

  double EbyLayer[]={0,0,0,0,0}; //using indices 1-4, not 0th
  double centLayer=0;
  
  for(unsigned int ind_hits=0; ind_hits < showerHits.size(); ++ind_hits){
    const DBCALHit* curhit = showerHits[ind_hits];
    EbyLayer[curhit->layer] += curhit->E;
    // center of layer "bin" is 0.5*(layerNumber^2) 
    centLayer += 0.5*curhit->layer*curhit->layer * curhit->E;

  }

  if(centLayer>EM_CENT_THRES) return false;


  if( EM_BACK_E_THRES*(EbyLayer[4]+EbyLayer[3]+EbyLayer[2]+EbyLayer[1])
      < EbyLayer[4])  return false;
  
  // Reject "showers" with energy deposts separated by 2 layers
  // as unrealistic for an EM shower
  if(EbyLayer[4] > 0  && EbyLayer[1] >  0 && 
     EbyLayer[2] == 0 && EbyLayer[3] == 0) return false;

  if(EbyLayer[1] >  0 && EbyLayer[2] == 0 && 
     EbyLayer[3] == 0 && EbyLayer[4] == 0) return false;
    
 
  return true;

}



bool DNeutralParticleHypothesis_factory::
BCALShowerLacksEntryHit(vector<const DBCALShower*> &showers)
{

  if(&showers==NULL || showers.size()==0) return false;
  
  // Don't scrutinize a shower >150MeV and with centroid 
  // less than half-way through the depth of BCAL module
  if(showers[0]->E > 0.15 && 
     sqrt(showers[0]->x*showers[0]->x + showers[0]->y*showers[0]->y)<77/*cm*/)
    return false;

  //cout << "Requiring layer 1 hit.: ";
  
  vector<const DBCALHit*> BCALshowerHits;
  showers[0]->GetT(BCALshowerHits);
  vector<int> firstLayerHitSectors, otherLayerHitSectors;
  double L1cumE=0, L234cumE=0, L1meanCol=-999, L234meanCol=-999;
  int firstHitSector=0, Nsectors=48*4;
  
  for(unsigned int ind_hits=0; ind_hits < BCALshowerHits.size(); ++ind_hits){
    const DBCALHit* curhit = BCALshowerHits[ind_hits];

    // solve the issue of the module 48->0 transition
    // to ensure distances across this boundary makes sense

    int globSector = (curhit->sector - 1) + (curhit->module - 1)*4;
    int unwrapSec = globSector; 

    if(ind_hits==0)
      firstHitSector = globSector;
    else{
      if(firstHitSector - globSector > Nsectors/2)
	unwrapSec += Nsectors;
      else if(firstHitSector - globSector < -Nsectors/2)
	unwrapSec -= Nsectors;
    }

    //cout << curhit->layer << " s" << globSector << "(" << unwrapSec << ") m" 
    // << curhit->module << "; ";
 
    if(curhit->layer == 1){
      L1meanCol = L1meanCol*L1cumE + unwrapSec*curhit->E;
      L1cumE += curhit->E;
      //firstLayerHitSectors.push_back(globSector);
    }else{
      //otherLayerHitSectors.push_back(globSector);
      L234meanCol = L234meanCol*L234cumE + unwrapSec*curhit->E;
      L234cumE += curhit->E;
    }
  }
  
  //cout << endl;
  //if(firstLayerHitSectors.size()==0) return true;
  if(L1cumE == 0) return true;
  
      /*for(unsigned int iL1=0; iL1<firstLayerHitSectors.size() && 
	!hitSectorMatch; ++iL1){
	for(unsigned int iLo=0; iLo<otherLayerHitSectors.size(); ++iLo){
	if(firstLayerHitSectors[iL1]==otherLayerHitSectors[iLo]){
	hitSectorMatch = true;
	break;
	}
	}
	}
	if(!hitSectorMatch) return true;*/
  if(fabs(L1meanCol - L234meanCol) > 2.0) return true;

  return false;
}



//------------------
// erun
//------------------
jerror_t DNeutralParticleHypothesis_factory::erun(void)
{
	return NOERROR;
}

//------------------
// fini
//------------------
jerror_t DNeutralParticleHypothesis_factory::fini(void)
{
	return NOERROR;
}

#define DELTA(i,j) ((i==j) ? 1 : 0)
void DNeutralParticleHypothesis_factory::Calc_Variances(const DNeutralShower *locNeutralShower, double locParticleEnergyUncertainty, DMatrixDSym &locVariances){
	DLorentzVector locShowerPositionUncertainties = locNeutralShower->dSpacetimeVertexUncertainties;

	// create the simplest error matrix:
	// At this point, it is assumed that error matrix of measured quantities is diagonal,
	// with elements like: sigma_Z_t = L/sqrt(12) sigma_X_t = sigma_Y_t = r0/2 
	// L=target length, r0 = target radius...
	// This means that energy-depth-polar angle relation  is neglected.
	// the order of sigmas is:  x_c, y_c, z_c, E, x_t, y_t, z_t

	locVariances.Clear();
	locVariances.ResizeTo(7, 7);

	locVariances(0,0) = pow(locShowerPositionUncertainties.X(), 2.0);
	locVariances(1,1) = pow(locShowerPositionUncertainties.Y(), 2.0);
	locVariances(2,2) = pow(locShowerPositionUncertainties.Z(), 2.0);

	locVariances[3][3] = pow(locParticleEnergyUncertainty, 2.0);

	locVariances[4][4] = pow(0.5*dTargetRadius, 2.0) ; // x_t, y_t
	locVariances[5][5] = pow(0.5*dTargetRadius, 2.0) ; // x_t, y_t
	locVariances[6][6] = pow(dTargetLength/sqrt(12.0), 2.0) ; // z_t
}

void DNeutralParticleHypothesis_factory::Build_ErrorMatrix(const DVector3 &locPathVector, double locEnergy, const DMatrixDSym& locVariances, DMatrixDSym& locErrorMatrix)
{
	unsigned int loc_i, loc_j, loc_ik, loc_jk;
   double R = locPathVector.Mag(); //path length
   double R2= locPathVector.Mag2(); //path length ^ 2
   double R3 = R*R2; //path length ^ 3
   double E_R3 = locEnergy/R3; 

	// init and fill rotation matrix, first with momentum derivatives
	DMatrix A(7, 7);
	for (loc_i = 0; loc_i < 3; loc_i++) {
		for (loc_j = 0; loc_j <3; loc_j++) {
			A[loc_i][loc_j] = E_R3*( R2*DELTA(loc_i, loc_j) - locPathVector(loc_i) * locPathVector(loc_j) );
			A[loc_i][loc_j + 4] = - A[loc_i][loc_j];
		}
	}

	// fill energy part and remember: relation between energy and photon position in calorimeter is neglected!
	A[3][3] = 1.;
	for (loc_j = 0; loc_j < 3; loc_j++)
		A[loc_j][3] = locPathVector(loc_j)/R;

	// fill spatial part where: dp_r_x/dp_x_c = - dp_r_x/dp_x_v ....
	for (loc_i = 0; loc_i < 3; loc_i++) {
		for ( loc_j = 0; loc_j < 3; loc_j++) {
			loc_ik = loc_i + 4;
			loc_jk = loc_j + 4;
			A[loc_ik][loc_j] = DELTA(loc_i, loc_j);
			A[loc_ik][loc_jk] = - A[loc_ik][loc_j];
		}
	}

	locErrorMatrix.ResizeTo(7, 7);
   locErrorMatrix = locVariances;
   locErrorMatrix = locErrorMatrix.Similarity(A);
}

