//*-- Author :    Paul Eugenio 28-Jan-1999

////////////////////////////////////////////////////////////////////////
// TLGDparticle
//
// These are the smeared particles contained in the TClonesArray 
// from TLGDsmears. See implementation of TLGDsmears for more
// information.
//
// A TClonesArray of TLGDparticle is created by 
// TLGDsmears::Fill(struct lgdinfo)
//
////////////////////////////////////////////////////////////////////////

#include "TMath.h"
#include "TLGDparticle.h"

ClassImp(TLGDparticle)




//____________________________________________________________________________
 TLGDparticle::TLGDparticle(lgd_smearedpart_t *lgdpart){
  //  This Calls Fill()
  Fill(lgdpart);
}

//____________________________________________________________________________
void  TLGDparticle::Fill(lgd_smearedpart_t *lgdpart){
  //Fill the object information using a c struct map 
  // of the lgd smeared particle information  
  //
  SetHepIndex(lgdpart->hepIndex);
  SetType(lgdpart->type);
  SetXlocal(lgdpart->xlocal);
  SetYlocal(lgdpart->ylocal);
  SetPx(lgdpart->px);
  SetPy(lgdpart->py);
  SetPz(lgdpart->pz);
  SetVx(lgdpart->vx);
  SetVy(lgdpart->vy);
  SetVz(lgdpart->vz);
  
}

//____________________________________________________________________________
TLGDparticle::~TLGDparticle()
{
  // this->Clear()
  //
  this->Clear();
}
//____________________________________________________________________________
Double_t TLGDparticle::GetE(){
  // E = Sqrt( px*px + py*py + pz*pz)
  //
  Double_t E;
  E=TMath::Sqrt( (GetPx()*GetPx()) + (GetPy()*GetPy()) + (GetPz()*GetPz()) );
  return E;
}


//____________________________________________________________________________
void TLGDparticle::Print(ostream *os){
   // Prints TLGDparticle object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << lgdpart;
  // 
  // where lgdpart is an instance of TLGDparticle


    *os<<"Hep Index: "<<this->GetHepIndex()
      <<" type: "<<this->GetType()
      <<" local(x,y): ("<< this->GetXlocal()
      <<","<< this->GetYlocal()<<")"
      <<" (px,py,pz) : ("<< this->GetPx()
      <<","<<this->GetPy()<<","<<this->GetPz()<<")"
      <<" (vx,vy,vz) : ("<< this->GetVx()
      <<","<<this->GetVy()<<","<<this->GetVz()<<")"
      << endl;
}


ostream &operator<<(ostream &os, TLGDparticle &lgdparticle){
// overload the standard print operator
  lgdparticle.Print(&os);
  return os;
}


