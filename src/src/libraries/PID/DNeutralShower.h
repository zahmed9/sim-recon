// $Id$
//
//    File: DNeutralShower.h
// Created: Tue Aug  9 14:29:24 EST 2011
// Creator: pmatt (on Linux ifarml6 2.6.18-128.el5 x86_64)
//

#ifndef _DNeutralShower_
#define _DNeutralShower_

#include <vector>
#include <JANA/JObject.h>
#include <BCAL/DBCALShower.h>
#include <BCAL/DBCALGeometry.h>
#include <FCAL/DFCALShower.h>
#include <FCAL/DFCALGeometry.h>
#include <GlueX.h>
#include <DLorentzVector.h>
#include <DMatrix.h>


using namespace std;

class DNeutralShower : public jana::JObject{
public:
  JOBJECT_PUBLIC(DNeutralShower);
  
  DLorentzVector dSpacetimeVertex;
  DLorentzVector dSpacetimeVertexUncertainties;
  float dEnergy;
  float dEnergyUncertainty;
  DetectorSystem_t dDetectorSystem;
  
  DNeutralShower(const DBCALShower *locBCALShower){
    dDetectorSystem = SYS_BCAL;
    dEnergy = locBCALShower->E;
    dEnergyUncertainty = (dEnergy >= 0.0) ? 0.0445*sqrt( dEnergy ) + 0.009*dEnergy : 1e-3; //from old DPhoton_factory::makeBCalPhoton() function
    dSpacetimeVertex.SetXYZT(locBCALShower->x, locBCALShower->y, locBCALShower->z, locBCALShower->t);
    dSpacetimeVertexUncertainties.SetXYZT(locBCALShower->xErr, locBCALShower->yErr, locBCALShower->zErr, locBCALShower->tErr);
  }
  
  DNeutralShower(const DFCALShower *locFCALShower){
    dDetectorSystem = SYS_FCAL;
    dEnergy = locFCALShower->getEnergy();
    dEnergyUncertainty = (dEnergy >= 0.0) ? 0.042*sqrt(dEnergy) + 0.0001 : 1e-3; 
    //^from old DPhoton_factory::makeFCalPhoton() function
    dSpacetimeVertex.SetVect(locFCALShower->getPosition());
    
    // changes from Will Levine to compensate for the FCAL shower depth
    //dSpacetimeVertex.SetT(locFCALShower->getTime());
    
    //from calib/FCAL, probably should look this up somehow...
    const double cEff = 15.;
    const double FCALback = DFCALGeometry::fcalFaceZ()+DFCALGeometry::blockLength();
    double t = locFCALShower->getTime() - 
      ( FCALback - locFCALShower->getPosition().Z() )/cEff;
    dSpacetimeVertex.SetT(t);
    
    dSpacetimeVertexUncertainties.SetVect(locFCALShower->getPositionError());
    dSpacetimeVertexUncertainties.SetT(0.0); //not stored in DFCALShower
  }
  
		void toStrings(vector<pair<string,string> > &items) const{
			AddString(items, "E", "%3.5f", dEnergy);
			AddString(items, "x", "%3.2f", dSpacetimeVertex.X());
			AddString(items, "y", "%3.2f", dSpacetimeVertex.Y());
			AddString(items, "z", "%3.2f", dSpacetimeVertex.Z());
			AddString(items, "t", "%3.2f", dSpacetimeVertex.T());
		}

};

#endif // _DNeutralShower_

