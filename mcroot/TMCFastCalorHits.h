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

enum calHitState {
    EMPTY,     /* memory has been allocated, but no meaningfull info */
    NOISE,     /* Noise componenet. No track info, obviously */
    SHOWERING, /*  hits is created as the shower propagates. The track info 
                  is not available at that time */
    SINGLE_TRACK, /* The amount of energy deposition is due to a signle track 
                     typically created in make_cal_hit, after showering 
                     process is completed */
    CONSOLIDATED   /* The energy deposition may now include the contribution 
                        from more than 1 track. Typically obtained the event 
                        has been completly traced. */
};

struct cal_hit_t {
    int icr1; //The cell number of the hit. x1 refers x or phi.
    int icr2; //The cell number of the hit. x2 refers y or eta.
    float e_mip; /* The amount of energy due to energy loss for a single 
                    particle, occuring before showering starts */
    float e_em;  /* The amount of energy due to electromagnetic processes */
    float e_had; /* The amount of energy due hadronic processes */
    int status; /* A word defining the status of the hit, see calHitState */
    int n_tracks; /* The number of tracks contributing to this hit */ 
    struct cal_hit_tracks_t *info_tr; 
                 /* A pointer to a set of track vs cal. hit info d/s  */
};



class TMCFastCalorHits: public TObject{
private:
  Int_t fHitIndex;    // Hit index for referencing hit-track info
  Int_t fX1CellIndex; //The cell number of the hit. x1 refers x or phi.
  Int_t fX2CellIndex; //The cell number of the hit. x2 refers y or eta.
  Float_t fEmip; // The amount of energy due to energy loss for a single particle, occuring before showering starts 
  Float_t fEem;  // The amount of energy due to electromagnetic processes 
  Float_t fEhad; // The amount of energy due hadronic processes 
  Int_t fstatus;  // A word defining the status of the hit, see calHitState
  Int_t fNtracks; // The number of tracks contributing to this hit 
 
public:
  TMCFastCalorHits(){} 
  TMCFastCalorHits(Int_t i,struct cal_hit_t *calor);
  virtual ~TMCFastCalorHits() ;
  Int_t GetHitIndex() const{return this->fHitIndex;}
  Int_t GetX1CellIndex() const { return this->fX1CellIndex; }
  Int_t GetX2CellIndex() const { return this->fX2CellIndex; }
  Double_t GetEtotal();
  Float_t GetEmip() const { return this->fEmip; }
  Float_t GetEem() const { return this->fEem; }
  Float_t GetEhad() const { return this->fEhad; }
  Int_t  GetStatus() const { return this->fstatus; }
  Int_t  GetNtracks() const { return this->fNtracks; }
  void SetHitIndex(Int_t i) {this->fHitIndex=i;  } 
  void SetX1CellIndex(Int_t i) {this->fX1CellIndex=i;  } 
  void SetX2CellIndex(Int_t i) {this->fX2CellIndex=i;  } 
  void SetEmip(Float_t E) { this->fEmip=E; }
  void SetEem(Float_t E) { this->fEem=E; }
  void SetEhad(Float_t E) { this->fEhad=E; }
  void SetStatus(Int_t n) { this->fstatus=n; }
  void SetNtracks(Int_t n) { this->fNtracks=n; }  

									     
  void Print(ostream *os);
  void Fill(Int_t i,struct cal_hit_t *calorhit);
  ClassDef(TMCFastCalorHits,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastCalorHits &hit); 


#endif
