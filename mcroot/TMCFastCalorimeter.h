#ifndef ROOT_TMCFastCalorimeter
#define ROOT_TMCFastCalorimeter

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastCalorimeter   MCFast Calorimeter  Class                       //
//                                                                      //
// This is port of MCFast cal_hit structure to ROOT                     //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"

#include "TMCFastCalorHits.h"
#include "TCalHitTracks.h"
#include <iostream>
using namespace std;

class TMCFastCalorimeter: public TObject {
  
private:
  Int_t fnHits;           // The total number of hits for this calorimeter
  Int_t fNinfo;      // The number of TCalHitTracks = Sum_i(Hit_i*Ntrk_i)
  TClonesArray  *fCalorHits; // an array of TMCFastCalorHits objects
  TClonesArray *finfo_tr; // A pointer a array of TCalHitTracks (hits2trks info)

  static TClonesArray *fginfo_tr; // dummy needed to init TClonesArray                 
  static TClonesArray *fgCalorHits; // dummy needed to init TClonesArray
public:
  TMCFastCalorimeter();    
  TMCFastCalorimeter(Int_t nhits,struct cal_hit_t **calor);
  virtual ~TMCFastCalorimeter() ;
  void Clear();
  Int_t  GetNhits() const { return fnHits; }

  TClonesArray *GetHits() const { return fCalorHits; }
  void SetNhits(Int_t n)  { fnHits=n; }
  void Print(ostream *os);
  void Fill(Int_t nhits,struct cal_hit_t **calor);
  void AddHit(Int_t hitIndex,struct cal_hit_t *calorhit);
  TClonesArray *GetInfoTr() const { return finfo_tr; }
  void AddInfoTr(Int_t hitIndex,struct cal_hit_tracks_t *info_tr);
  ClassDef(TMCFastCalorimeter,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastCalorimeter &calor); 


#endif
