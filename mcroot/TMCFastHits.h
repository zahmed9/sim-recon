#ifndef ROOT_TMCFastHits
#define ROOT_TMCFastHits

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastHits   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"
#include "TMCFastHit.h"
#include <iostream.h>

struct dev_hits_t{
  Int_t nhits;
  struct dev_hit_t devhit[1];
};

class TMCFastHits: public TObject {
  
private:
  Int_t fnhits;           // Number hits in device
  TClonesArray  *fhits; // an array of TMCFastHit objects

  static TClonesArray *gfhits_1; // dummy needed to init TClonesArray
  static TClonesArray *gfhits_2; // dummy needed to init TClonesArray
  static TClonesArray *gfhits; // dummy needed to init TClonesArray
  static TClonesArray *gfh[5];
  static Int_t gfTClones_counter;
  static Int_t fTClones_number;
public:
  TMCFastHits() ;
  TMCFastHits(dev_hits_t *hits);
  virtual ~TMCFastHits() ;
  void Clear();
  Int_t  GetNhits() const { return fnhits;}
  TClonesArray *GetHits() const {return fhits;}

  void SetNhits(Int_t n) { fnhits = n;}
  void Print(ostream *os);
  void Fill(dev_hits_t *hits);
  void AddHit(dev_hit_t *hit);
 
  ClassDef(TMCFastHits,1)  //Needed by ROOT

};

ostream &operator<<(ostream &os,TMCFastHits &hits); 

#endif
