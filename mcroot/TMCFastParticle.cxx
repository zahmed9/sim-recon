//*-- Author :    Paul Eugenio 15-Jan-99
//*-- CMZ :       PME 15-Jan-99

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastParticle   MCFast Smeared Particle                            //
//                                                                      //
//                                                           
//////////////////////////////////////////////////////////////////////////

#include "TMCFastParticle.h"
#include "TMath.h"

ClassImp(TMCFastParticle)


//____________________________________________________________________________
Double_t TMCFastParticle::GetP(){
  // Return the smeared momentum 
  //

  Double_t p=TMath::Sqrt(GetPx()*GetPx() + GetPy()*GetPy() + GetPz()*GetPz());
  
  
  return p;
}

//____________________________________________________________________________
Double_t TMCFastParticle::GetMass(){
  // Return the particle mass  
  // mass^2 = E^2 - p^2
  //
  Double_t p = GetP();
  Double_t mass = TMath::Sqrt(GetE()*GetE() - p*p);
  return mass;
}


//____________________________________________________________________________
TMCFastParticle::~TMCFastParticle()
{
  //Clear()
  //
   Clear();
}

//____________________________________________________________________________
void TMCFastParticle::Print(ostream *os){
  // Prints  TMCFastParticle object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << object;
  // 
  // where object is an instance of TMCFastparticle



  *os<<"Type: "<< GetType()
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


ostream &operator<<(ostream &os, TMCFastParticle &part){
  // overload the standard print operator
  part.Print(&os);
  return os;
}
