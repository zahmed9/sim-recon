#ifndef ROOT_TMCFastCalorHits
#define ROOT_TMCFastCalorHits

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastCalorHits   MCFast Calorimeter Hits Class                     //
//                                                                      //
// Also see  TMCFastCalorimeter                                         //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"


#include <iostream.h>

// C style structures imported from mcfast code cal_hit.[ch]


struct cal_hit_t {
  int icr1; //The cell number of the hit. x1 refers x or phi.
  int icr2; //The cell number of the hit. x2 refers y or eta.
  float e_tot; /* The total calorimeter energy*/
  int n_tracks; /* The number of tracks contributing to this hit */ 
  struct cal_hit_tracks_t *info_tr; 
      /* A pointer to a set of track vs cal. hit info d/s  */
};



class TMCFastCalorHits: public TObject{
private:
  Int_t fHitIndex;    // Hit index for referencing hit-track info
  Int_t fX1CellIndex; //The cell number of the hit. x1 refers x or phi.
  Int_t fX2CellIndex; //The cell number of the hit. x2 refers y or eta.
  Float_t fE; // The total calor hit energy
  Int_t fNtracks; // The number of tracks contributing to this hit 
 
public:
  TMCFastCalorHits(){} 
  TMCFastCalorHits(Int_t i,struct cal_hit_t *calor);
  virtual ~TMCFastCalorHits() ;
  Int_t GetHitIndex() const{return this->fHitIndex;}
  Int_t GetX1CellIndex() const { return this->fX1CellIndex; }
  Int_t GetX2CellIndex() const { return this->fX2CellIndex; }
  Float_t GetE() const { return this->fE; }
  Int_t  GetNtracks() const { return this->fNtracks; }
  void SetHitIndex(Int_t i) {this->fHitIndex=i;  } 
  void SetX1CellIndex(Int_t i) {this->fX1CellIndex=i;  } 
  void SetX2CellIndex(Int_t i) {this->fX2CellIndex=i;  } 
  void SetE(Float_t E) { this->fE=E; }
  void SetNtracks(Int_t n) { this->fNtracks=n; }  

									     
  void Print(ostream *os);
  void Fill(Int_t i,struct cal_hit_t *calorhit);
  ClassDef(TMCFastCalorHits,2)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastCalorHits &hit); 


#endif
