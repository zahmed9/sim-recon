//*-- Author :    Paul Eugenio 21-Jan-99

////////////////////////////////////////////////////////////////////////
// TCalHitTracks
//
//  track vs cal. hit info 
//
////////////////////////////////////////////////////////////////////////


#include "TCalHitTracks.h"

ClassImp(TCalHitTracks)

TCalHitTracks::TCalHitTracks(Int_t index,struct cal_hit_tracks_t *info)
{
  this->SetCalHitIndex(index);
  this->SetHepIndex(info->tr_num);
  this->SetEmip(info->e_mip);
  this->SetEem(info->e_em);
  this->SetEhad(info->e_had);

}


//____________________________________________________________________________
TCalHitTracks::~TCalHitTracks()
{
  //Clear()
  //
   this->Clear();
}
//____________________________________________________________________________
void TCalHitTracks::Print(ostream *os){
   // Prints TCalHitTracks object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << infoTrk;
  // 
  // where infoTrk is an instance of TCalHitTracks
  
  *os<<"\tCalHitIndex: "<<this->GetCalHitIndex()
    <<" HEPEVT index: "<<this->GetHepIndex()
    <<endl;
  *os<<"\t\tEmip: "<<this->GetEmip()
     <<"\t\tEem: "<<this->GetEem()
     <<"\t\tEhad: "<<this->GetEhad()
    <<endl;
    
}

ostream &operator<<(ostream &os, TCalHitTracks &info){
// overload the standard print operator
  info.Print(&os);
  return os;
}
