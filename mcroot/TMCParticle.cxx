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
//___________________________________________________________________________


TMCParticle::TMCParticle(TMCFastHepParticle &heppart){
  
  SetPx(heppart.GetPx());
  SetPy(heppart.GetPy()) ;
  SetPz(heppart.GetPz()); 
  SetE(heppart.GetE()) ; 
  SetX(heppart.GetVx()) ; 
  SetY(heppart.GetVy()) ;
  SetZ(heppart.GetVz()) ;
  Int_t pid =heppart.GetIdhep();
  Int_t charge=-1;
  if(pid>0)
    switch(pid){
    case 22: //gamma
    case 2112: // neutron
      charge=0;
      break;
    default:
      charge=1;
      break;
    }
  SetCharge(charge);
  SetIdHep(heppart.GetIdhep()) ;
  SetHepIndex(heppart.GetIndex());
  SetMaker(MADE_FROM_HEPEVT) ;
  SetStatis(0); // currently not used
}

TMCParticle::TMCParticle(TMCFastHepParticle &heppart,TMCFastOfflineTrack &offtrk, Int_t track){
  
  SetPx(offtrk.GetPx(track));
  SetPy(offtrk.GetPy(track)) ;
  SetPz(offtrk.GetPz(track)); 
  SetE(offtrk.GetE(track)) ; 
  SetX(offtrk.GetX(track)) ; 
  SetY(offtrk.GetY(track)) ; 
  SetZ(offtrk.GetZ(track)) ; 
  //  SetX(heppart.GetVx()) ; 
  //  SetY(heppart.GetVy()) ;
  //  SetZ(heppart.GetVz()) ;
  SetCharge((int)offtrk.GetQ(track));
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
TMCParticle::TMCParticle(TMCFastHepParticle &heppart,Double_t eSmeared,Double_t z_resolution,Double_t phi_resolution){
  //
  // Create a BCAL gamma with uncertainty in z(cm) and phi (Lx, Ly).
  //

  Double_t e,P,L,Lx,Ly,Lz,LzSmeared,L_Smeared,z_res_calc,esqrt;
  double_t phi,phi_smeared,phi_res_calc,LxSmeared,LySmeared,L2;
  
  e=heppart.GetE();
  P=e; //for ease of reading
  
  const Double_t R=65.0; // Inner radius of the BCAL
  
  // find vector length from vertex to hit
  L = R*P/(heppart.GetPt());

  // find components of L 
  Lx = L*(heppart.GetPx())/P;
  Ly = L*(heppart.GetPy())/P;
  Lz = L*(heppart.GetPz())/P;
  
  // calculate phi
  phi = atan(Ly/Lx);
  // calculate phi_smeared
  esqrt = sqrt(P);
  if(phi_resolution>=0)
    {
      //  phi_res_calc = sqrt(pow(0.7/esqrt,2.0)+pow((phi_resolution/1000.),2.0));
      phi_res_calc = (phi_resolution/1000.)/esqrt;  // convert to radians
      phi_smeared = gRandom->Gaus(phi,phi_res_calc);
      // Smear the vector length
      
      LxSmeared = Lx*(cos(phi_smeared)/cos(phi));
      LySmeared = Ly*(sin(phi_smeared)/sin(phi));
    }
  else
    {  
      LxSmeared = Lx;
      LySmeared = Ly;
    }
  
  if(z_resolution>=0) 
    {
      z_res_calc = sqrt(pow(0.7/esqrt,2.0)+pow(z_resolution,2.0));
      LzSmeared = gRandom->Gaus( Lz, z_resolution);
    }
  else
    LzSmeared = Lz;
  
  L2 = LxSmeared*LxSmeared + LySmeared*LySmeared + LzSmeared*LzSmeared;
  // L_Smeared = TMath::Sqrt(L2);
  L_Smeared = sqrt(L2);
  // cerr<<" Lz, z_resolution,  LzSmeared "
  //    <<Lz<<" "<<z_resolution<<" "
  //    <<LzSmeared<<endl;

  // Set the smeared four-momentum
  SetPx(LxSmeared/L_Smeared*eSmeared); 
  SetPy(LySmeared/L_Smeared*eSmeared); 
  SetPz(LzSmeared/L_Smeared*eSmeared); 
  SetE(eSmeared) ;
  // set vertex using the generated vertex (which is assigned by mcfast)
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
     << GetE()<<")  Mass: "
     <<  sqrt(-( GetPx()* GetPx()+GetPy()* GetPy()+GetPz()* GetPz())
	      +GetE()* GetE())
     <<endl;

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

