//*-- Author :    Paul Eugenio 21-Jan-99

////////////////////////////////////////////////////////////////////////
// TMCFastCalorHits
//
// These are the hits contained in the TClonesArray from TMCFastCalorimeter
//
// A TClonesArray of TMCFastCalorHits is created by 
// TMCFastCalorimeter::Fill(struct info)
//
// More information about MCFast calorimeter hits can be found at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastCalorHits.h"
#include "TCalHitTracks.h"

ClassImp(TMCFastCalorHits)




//____________________________________________________________________________
TMCFastCalorHits::TMCFastCalorHits(Int_t index,struct cal_hit_t *calorhit){
  //  This Calls Fill()
  Fill(index,calorhit);
}

//____________________________________________________________________________
void  TMCFastCalorHits::Fill(Int_t index, struct cal_hit_t *calorhit){
  //Fill the object information using a c struct map 
  // of the calorimeter hit information  
  //
  SetHitIndex(index);
  SetX1CellIndex(calorhit->icr1);
  SetX2CellIndex(calorhit->icr2);
  SetEmip(calorhit->e_mip);
  SetEem(calorhit->e_em);
  SetEhad(calorhit->e_had);
  SetStatus(calorhit->status);
  SetNtracks(calorhit->n_tracks);

}

//____________________________________________________________________________
TMCFastCalorHits::~TMCFastCalorHits()
{
  // this->Clear()
  //
  this->Clear();
}

//____________________________________________________________________________
void TMCFastCalorHits::Print(ostream *os){
   // Prints TMCFastCalorHits object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << calorhit;
  // 
  // where calorhit is an instance of TMCFastCalorHits


    *os<<"Hit Index: "<<this->GetHitIndex()
      <<" X1CellIndex: "<< this->GetX1CellIndex()
      <<" X2CellIndex: "<< this->GetX2CellIndex()
      << endl;
    *os<<"Emip: "<<this->GetEmip()
      <<" Eem: "<<this->GetEem()
      <<" Ehad: "<<this->GetEhad()
      <<endl;
    *os<<"Ntracks: "<<this->GetNtracks()
      <<" status: "<<this->GetStatus()
      <<endl;
    
   
}


ostream &operator<<(ostream &os, TMCFastCalorHits &calorhit){
// overload the standard print operator
  calorhit.Print(&os);
  return os;
}


