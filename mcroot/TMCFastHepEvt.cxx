//*-- Author :    Paul Eugenio 2-Nov-98

////////////////////////////////////////////////////////////////////////
// TMCFastHepEvt
//
// This class is an object oriented version of StdHep FORTRAN common block.
// The StdHep common block is filled by MCFast routines. An instance of
// TMCFastHepEvt is created using this information and is save to Root
// Tree for I/O.
//
//  TMCFastHepEvt contains a TClonesArray of  TMCFastHepParticle
//
// More information about StdHep can be found at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/stdhep.html" >
http://www-pat.fnal.gov/stdhep.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastHepEvt.h"


ClassImp(TMCFastHepEvt)


TClonesArray *TMCFastHepEvt::fgParticles = 0;

//____________________________________________________________________________
TMCFastHepEvt::TMCFastHepEvt(struct hepevt_t *evt){
  // Create the object 
  // and fill it using  FIll(struct hepevt_t *evt) 
  //
  if(!fgParticles) fgParticles = new TClonesArray("TMCFastHepParticle",10);
  fHepParticle = fgParticles;
  Fill(evt);
}

TMCFastHepEvt::TMCFastHepEvt(){
  fnhep=0;
  if(!fgParticles) fgParticles = new TClonesArray("TMCFastHepParticle",10);
  fHepParticle = fgParticles;
}


//____________________________________________________________________________
void TMCFastHepEvt::AddHepParticle(struct heppart_t *part,Int_t index){
  // Create a TMCFastHepParticle instance
  // from the c struct heppart_t and add the instance to 
  // the  TClonesArray fHepParticle
  //
  TClonesArray &partilces = *fHepParticle;
  new(partilces[fnhep++]) TMCFastHepParticle(part,index);
}



//____________________________________________________________________________
void  TMCFastHepEvt::Fill(struct hepevt_t *evt){
  // Fill the object using a c 
  // struct map of the hepevt FORTRAN common block
  // 
  SetNevhep(evt->nevhep);
  fnhep=0;
  for(Int_t i =0; i< evt->nhep;i++)
    AddHepParticle(&(evt->heppart[i]),i+1);
  if(evt->nhep != GetNhep()){
    cerr<< "ERROR!! TClonesArray TMCFastHepParticle != evt->nhep elements\n";
  }
 
}
//____________________________________________________________________________
void TMCFastHepEvt::Clear()
{
  // Clear the TClonesArray fHepParticle
  //
   fHepParticle->Clear();
}

TMCFastHepParticle TMCFastHepEvt::GetHepParticle(Int_t HepEvtIndex){
  // return the TMCFastHepParticle which
  // has the HepEvtIndex
  //
  Int_t found=0,n=0;
  TMCFastHepParticle particle;
  
  TIter next(this->GetHepParticles());
  while( TMCFastHepParticle *p = (TMCFastHepParticle *)next()){
    n++;
    if(n == HepEvtIndex){
      found=1;
      particle = *p; 
    }
  }
  if(!found){
    cerr<<"Failed to  GetHepParticle("<<HepEvtIndex<<")\n";
    exit(-1);
  }
  else
    return particle;
}
//____________________________________________________________________________
TMCFastHepEvt::~TMCFastHepEvt()
{
   Clear();
}

//____________________________________________________________________________
void TMCFastHepEvt::Print(ostream *os){
  // Prints TMCFastHepEvt object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << hepevt;
  // 
  // where hepevt is an instance of TMCFastHepEvt
  Int_t index=1;

  *os<<" HepEvt number: "<< this->GetNevhep();
  *os<<"\t Number of Particles: "<< this->GetNhep()<<endl;

  // Now Print the Particles

  TIter next(this->GetHepParticles());
  
  while( TMCFastHepParticle *particle = (TMCFastHepParticle *)next()){
    *os<<"\tHepEvt Index: "<<index++;
    particle->Print(os);
  }
}


ostream &operator<<(ostream &os, TMCFastHepEvt &hepevt){
// overload the standard print operator
  hepevt.Print(&os);
  return os;
}
