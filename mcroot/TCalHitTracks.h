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
  Float_t percent_e_tot; /* The percentage of the total energy this track
                       contribute to the (cr1,cr2) cell this structure
                        belongs to */
};



class TCalHitTracks: public TObject {
private:
  Int_t fCalHitIndex;  // Hit index for referencing hit-track info
  Int_t fHepIndex; // The track number, refering to the particle in the HEPEVT list
  Float_t fpercent_e_tot; //The percentage of the hit energy due this track

public:
  TCalHitTracks(){};
  TCalHitTracks(Int_t i,struct cal_hit_tracks_t *info_tr);
  virtual ~TCalHitTracks();
  Int_t GetHepIndex()const{return this->fHepIndex;}
  Int_t GetCalHitIndex()const{return this->fCalHitIndex;}  
  Float_t GetPercent()const{return this->fpercent_e_tot;}
  void SetCalHitIndex(Int_t n){this->fCalHitIndex=n;}  
  void SetHepIndex(Int_t n){this->fHepIndex=n;}
  void SetPercent(Float_t p){this->fpercent_e_tot=p;}
  void Print(ostream *os);
  ClassDef(TCalHitTracks,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os, TCalHitTracks &info); 

#endif
