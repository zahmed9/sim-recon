//*-- Author :    Paul Eugenio 2-Nov-98

////////////////////////////////////////////////////////////////////////
// TMCFastHepParticle
//
// These are the particle contained in the TClonesArray from TMCFastHepEvt
//
// This class is an object oriented version of StdHep FORTRAN common block.
// The StdHep common block is filled by MCFast routines. A TClonesArray of
// TMCFastHepParticle is created by 
// TMCFastHepEvt::Fill(common block information)
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


#include "TMCFastHepParticle.h"

ClassImp(TMCFastHepParticle)
//____________________________________________________________________________
TMCFastHepParticle::TMCFastHepParticle(struct heppart_t *part,Int_t index){
  //  This Calls Fill()
  Fill(part,index);
}
//____________________________________________________________________________
void  TMCFastHepParticle::Fill(struct heppart_t *part,Int_t index){
  //Fill the object information using a c struct map 
  //of the Fortran common block used in mcfast  
  //
  SetIndex(index);
  SetIsthep(part->isthep);
  SetIdhep(part->idhep);
  for(Int_t j=0; j< 2; j++){
    SetJmohep(j,part->jmohep[j]);
    SetJdahep(j,part->jmohep[j]);
  }
  SetMass(part->phep[4]);
  SetPx(part->phep[0]);
  SetPy(part->phep[1]);
  SetPz(part->phep[2]);
  SetE(part->phep[3]);
  SetVx(part->vhep[0]);
  SetVy(part->vhep[1]);
  SetVz(part->vhep[2]);
  SetVt(part->vhep[3]);  
}




//____________________________________________________________________________
TMCFastHepParticle::~TMCFastHepParticle()
{
  // call Clear()
   Clear();
}

//____________________________________________________________________________
void TMCFastHepParticle::Print(ostream *os){
   // Prints TMCFastHepParticle object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << heppart;
  // 
  // where heppart is an instance of TMCFastHepParticle


    *os<<"\t Index: "<<this->GetIndex()
      <<" Ishep: "<< this->GetIsthep()<<" Idhep: "<< 
      this->GetIdhep();
    *os<<" Mass: "<<  this->GetMass()<<endl;
    *os<<"\t\t Px: "<<  this->GetPx();
    *os<<" Py: "<<  this->GetPy();
    *os<<" Pz: "<<  this->GetPz();
    *os<<" E: "<<  this->GetE()<<endl;
    *os<<"\t\t Vx: "<<  this->GetVx();
    *os<<" Vy: "<<  this->GetVy();
    *os<<" Vz: "<<  this->GetVz();
    *os<<" Vt: "<<  this->GetVt();
    *os<<endl;
}


ostream &operator<<(ostream &os, TMCFastHepParticle &part){
// overload the standard print operator
  part.Print(&os);
  return os;
}


