#ifndef ROOT_TCalHitTracks
#define ROOT_TCalHitTracks

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TCalHitTracks   MCFast Calorimeter Hits info Class                   //
//                                                                      //
// Also see  TMCFastCalorimeter                                         //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include <iostream.h>

struct cal_hit_tracks_t {
  Int_t tr_num; /* The track number, refering to the HEP evt list */
  Float_t e_mip; // energy from minimum ionizing particle 
  Float_t e_em;  // energy from electromagnetic particle
  Float_t e_had; // energy from a hadronic particle

};



class TCalHitTracks: public TObject {
private:
  Int_t fCalHitIndex;  // Hit index for referencing hit-track info
  Int_t fHepIndex; // The track number, refering to the particle in the HEPEVT list
  Float_t fEmip; // energy from minimum ionizing particle 
  Float_t fEem;  // energy from electromagnetic particle
  Float_t fEhad; // energy from a hadronic particle

public:
  TCalHitTracks(){};
  TCalHitTracks(Int_t i,struct cal_hit_tracks_t *info_tr);
  virtual ~TCalHitTracks();
  Int_t GetHepIndex()const{return this->fHepIndex;}
  Int_t GetCalHitIndex()const{return this->fCalHitIndex;}  
  Float_t GetEmip() const{return this->fEmip;} 
  Float_t GetEem() const{return this->fEem;} 
  Float_t GetEhad() const{return this->fEhad;} 
  void SetCalHitIndex(Int_t n){this->fCalHitIndex=n;}  
  void SetHepIndex(Int_t n){this->fHepIndex=n;}
  void SetEmip(Float_t E){this->fEmip=E;}
  void SetEem(Float_t E){this->fEem=E;}
  void SetEhad(Float_t E){this->fEhad=E;}
  void Print(ostream *os);
  ClassDef(TCalHitTracks,2)  //Needed by ROOT
};

ostream &operator<<(ostream &os, TCalHitTracks &info); 

#endif

