//*-- Author :    Paul Eugenio 15-Jan-99
//*-- CMZ :       PME 15-Jan-99

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCParticle   MCFast Smeared Particle                            //
//                                                                      //
//                                                           
//////////////////////////////////////////////////////////////////////////

#include "TMCParticle.h"
#include "TMath.h"

ClassImp(TMCParticle)
//____________________________________________________________________________

TMCParticle::TMCParticle(TMCFastHepParticle &heppart,TMCFastOfflineTrack &offtrk, Int_t track){
  
  SetPx(offtrk.GetPx(track));
  SetPy(offtrk.GetPy(track)) ;
  SetPz(offtrk.GetPz(track)); 
  SetE(offtrk.GetE(track)) ; 
  SetX(heppart.GetVx()) ; 
  SetY(heppart.GetVy()) ;
  SetZ(heppart.GetVz()) ;
  SetCharge(offtrk.GetQ(track));
  SetIdHep(heppart.GetIdhep()) ;
  SetHepIndex(offtrk.GetHep(track));
  SetMaker(MADE_FROM_OFFTRK) ;
  SetStatis(0); // currently not used

}

TMCParticle::TMCParticle(TMCFastHepParticle &heppart,Double_t eSmeared){
  Double_t e=heppart.GetE();

  SetPx(heppart.GetPx()*eSmeared/e); 
  SetPy(heppart.GetPy()*eSmeared/e) ;
  SetPz(heppart.GetPz()*eSmeared/e); 
  SetE(eSmeared) ;
  
  SetX(heppart.GetVx()) ; 
  SetY(heppart.GetVy()) ;
  SetZ(heppart.GetVz()) ;
  
  SetCharge(0);
  SetIdHep(heppart.GetIdhep()) ; // this better be a gamma!
  SetHepIndex(heppart.GetIndex());
  SetMaker(MADE_FROM_BCAL) ;
  SetStatis(0); // currently not used
}  

TMCParticle::TMCParticle(TLGDparticle &lgdpart){

  SetPx(lgdpart.GetPx()); 
  SetPy(lgdpart.GetPy()) ;
  SetPz(lgdpart.GetPz()); 
  SetE(lgdpart.GetE()) ;
  
  SetX(lgdpart.GetVx()) ; 
  SetY(lgdpart.GetVy()) ;
  SetZ(lgdpart.GetVz()) ;
  
  SetCharge(0);
  SetIdHep(PDG_GAMMA) ; // this better be a gamma!
  SetHepIndex(lgdpart.GetHepIndex());
  SetMaker(MADE_FROM_LGD) ;
  SetStatis(0); // currently not used
  
  
}  

//____________________________________________________________________________
Double_t TMCParticle::GetP(){
  // Return the smeared momentum 
  //

  Double_t p=TMath::Sqrt(GetPx()*GetPx() + GetPy()*GetPy() + GetPz()*GetPz());
  
  
  return p;
}

//____________________________________________________________________________
Double_t TMCParticle::GetMass(){
  // Return the particle mass  
  // mass^2 = E^2 - p^2
  //
  Double_t p = GetP();
  Double_t mass = TMath::Sqrt(GetE()*GetE() - p*p);
  return mass;
}


//____________________________________________________________________________
TMCParticle::~TMCParticle()
{
  //Clear()
  //
   Clear();
}

//____________________________________________________________________________
void TMCParticle::Print(ostream *os){
  // Prints  TMCParticle object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << object;
  // 
  // where object is an instance of TMCParticle



  *os<<"Maker: "<< GetMaker()<<" Status: "<< GetStatus()
     <<"\tHepIndex: "<< GetHepIndex()
     <<"\tIdHep: "<< GetIdHep() 
     <<"\tCharge: "<< GetCharge()<<endl; 

  *os<<"Four-Momentum"
     <<"\t P(x,y,z,t): ("
     << GetPx()<<","
     << GetPy()<<","
     << GetPz()<<","
     << GetE()<<")"<<endl;

  *os<<"Vertex"
     <<"\t v(x,y,z): ("
     << GetX()<<","
     << GetY()<<","
     << GetZ()<<")"<<endl;

}


ostream &operator<<(ostream &os, TMCParticle &part){
  // overload the standard print operator
  part.Print(&os);
  return os;
}
