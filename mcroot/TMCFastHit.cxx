//*-- Author :    Paul Eugenio 16-Mar-1999
//*-- CMZ : PME 16-Mar-1999

////////////////////////////////////////////////////////////////////////
// TMCFastHit
//
// This class is an object oriented version 
// of mcfast trace common block.
//
// More information see Tracking in MCFast doc at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////

#include "TMCFastHit.h"

ClassImp(TMCFastHit)

//____________________________________________________________________________
TMCFastHit::TMCFastHit(){
  // initialize all values to zero
  // 

  this->SetLayer(0);
  for(Int_t i=0;i<3;i++)
    this->SetWireInfo(i,0);

}
//____________________________________________________________________________
TMCFastHit::~TMCFastHit()
{
  // Clear()
  //

  this->Clear();
}

void TMCFastHit::operator=(TMCFastHit &source){
  //assignment operator
  
  //1: don't assign to self
  if(this == &source) 
    return;

  //2. chain to base class assignment operator
  TObject::operator=(source);

  //3: chain to data members
  flayer = source.flayer;
  for(Int_t i=0; i<3;i++)
    fWireInfo[i] = source.fWireInfo[i];
  ftrace = (source.ftrace);

}
TMCFastHit::TMCFastHit(TMCFastHit &source){
  // copy constructure
  //
  // allocate memory for ftrace and call
  // TMCFastHit assignment operator


  TMCFastHit::operator=(source);
}
//____________________________________________________________________________
TMCFastHit::TMCFastHit(dev_hit_t *devhit){
  // Call FIll()
  //

  Fill(devhit);
}

//____________________________________________________________________________
void  TMCFastHit::Fill(dev_hit_t *devhit){
  // Fill the object info using 
  //common block information
  //
  
  this->SetLayer(devhit->layer);
  for(Int_t i=0;i<3;i++)
    this->SetWireInfo(i,devhit->wire_info[i]);
  this->SetTrace(&(devhit->trace));

}
//____________________________________________________________________________
Double_t TMCFastHit::GetdX(){
  // dX is cell_heigth/CosTheta
  // where CosTheta is the angle
  // between the chamber normal
  // and the particle direct at
  // cell radial center.
  //
  Double_t cell_height = 1.0;
  TMCFastTrace *tr = GetTrace();
  Double_t Rnorm = TMath::Sqrt((tr->GetX())*(tr->GetX())+(tr->GetY())*(tr->GetY()));
  Double_t cosine = ((tr->GetX()*tr->GetPx()) + (tr->GetY()*tr->GetPy()))/
    (tr->GetP() * Rnorm);
  Double_t dX = cell_height/cosine ;
  return dX;
}
//____________________________________________________________________________
Double_t TMCFastHit::GetADCsignal(Double_t dX){
 // Return a signal count based on
  // dE/dX  calls this->GetdEdX()
  return this->GetdEdX()*dX;
}

//____________________________________________________________________________
Double_t TMCFastHit::GetdEdX(){
  // Return a signal for
  // dE/dX based on the  Bethe-Bloch formula.
  // See PDG review: Euro. Phys. C. V3 144, 1998
  //
  // dE/dX = a/(beta*beta) * (log(beta*beta*gamma*gamma*b) - beta*beta)
  // where a=1.0 , b = me*c^2/I, me = mass elcetron, c = c, and I is the mean
  // excitation energy.
  // Note that the return units are arbitrary (scalable by "a").

  Double_t beta =  GetTrace()->GetBeta();
  Double_t gamma = 1.0/(1.0 - beta*beta);
  Double_t a = 1.0;
  Double_t b = 0.511e6/150.0;
  Double_t dEdx = a/(beta*beta) * (TMath::Log(beta*beta*gamma*gamma*b) - beta*beta);
  return dEdx;
}
//____________________________________________________________________________
Double_t TMCFastHit::GetdEdX2(){
  // Return a signal for
  // dE/dX based on the  Bethe-Bloch formula.
  // See PDG review: Euro. Phys. C. V3 144, 1998
  //
  // dE/dX = a/(beta*beta) * (log(beta*beta*gamma*gamma*b) - beta*beta)
  // where a=1.0 , b = me*c^2/I, me = mass elcetron, c = c, and I is the mean
  // excitation energy.
  // Note that the return units are arbitrary (scalable by "a").

  Double_t beta =  GetTrace()->GetBeta();
  Double_t gamma = 1.0/(1.0 - beta*beta);
  Double_t alpha_t=0.153*0.45*1.662e-3*this->GetdX();
  Double_t b = 0.511e6/(150.0*150.0);
  Double_t delta =0;
  Double_t dEdx = alpha_t/(beta*beta) *
    (TMath::Log(b*alpha_t) +0.891+2.0*TMath::Log(beta*gamma)   
     -TMath::Log(beta*beta) -beta*beta - delta)/this->GetdX();
  return dEdx;
}

//____________________________________________________________________________
Double_t TMCFastHit::GetADCsignal(){
  // return this->GetADCsignal(this->GetdX())
  return this->GetADCsignal(this->GetdX());
}

//____________________________________________________________________________
void TMCFastHit::Print(ostream *os){
  // Prints TMCFastHit object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << hits;
  // 
  // where hits is an instance of TMCFastHit

  *os<<"\t Hit Layer: "
     << this->GetLayer()
     <<" WireInfo: "
     <<this->GetWireInfo(0)<<","
     <<this->GetWireInfo(1)<<","
     <<this->GetWireInfo(2)<<","
     <<endl;
  *os<<"\tADC signal: "<<GetADCsignal()<<" dX: "<<GetdX() <<" dEdX: "<<GetdEdX()<<endl;
  *os<<"\tTrace Point: "<< ftrace<<endl;

}



ostream &operator<<(ostream &os, TMCFastHit &hit){
  // overload the standard print operator
  hit.Print(&os);
  return os;
}
