#ifndef ROOT_TMCFastHepEvt
#define ROOT_TMCFastHepEvt

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastHepEvt   MCFast StdHep  Class                                  //
//                                                                      //
// This is port of MCFast HEPEVT Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"

#include "TMCFastHepParticle.h"
#include <iostream.h>

class TMCFastHepEvt: public TObject {
  
private:
  Int_t fnevhep;             // The event number 
  Int_t fnhep;               // The number of MCFastHepParticles 
  TClonesArray  *fHepParticle; // an array of TMCFastHepParticles objects
                                
  static TClonesArray *fgParticles; // dummy needed to init TClonesArray
public:
  TMCFastHepEvt();    
  TMCFastHepEvt(struct hepevt_t *evt);
  virtual ~TMCFastHepEvt() ;
  void Clear();
  Int_t  GetNevhep() const { return fnevhep; }
  Int_t  GetNhep() const { return fnhep; }
  TClonesArray *GetHepParticles() const { return fHepParticle; }
  void SetNevhep(Int_t n)  { fnevhep=n; }
  void SetNhep(Int_t n)  { fnhep=n; }
  void Print(ostream *os);
  void Fill(struct hepevt_t *evt);
  void AddHepParticle(struct heppart_t *part);
  
  ClassDef(TMCFastHepEvt,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastHepEvt &hepevt); 


#endif
