#ifndef ROOT_TLGDsmears
#define ROOT_TLGDsmears

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TLGDsmears   MCFast Calorimeter  Class                       //
//                                                                      //
// This is port of MCFast cal_hit structure to ROOT                     //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"
#include "TLGDparticle.h"
#include <iostream>
using namespace std;

class TLGDsmears: public TObject {
  
private:
  Int_t fnParticles;           // Number of particles detected by the lgd
  TClonesArray  *fLgdParticles; // an array of TLGDparticles objects

  static TClonesArray *fgLgdParticles; // dummy needed to init TClonesArray           
public:
  TLGDsmears();    
  TLGDsmears(lgd_smearedparts_t *lgd);
  virtual ~TLGDsmears() ;
  void Clear();
  Int_t  GetNparts() const { return fnParticles; }

  TClonesArray *GetLgdParticles() const { return fLgdParticles; }
  void SetNparts(Int_t n)  { fnParticles=n; }
  void Print(ostream *os);
  void Fill(lgd_smearedparts_t *lgd);
  void AddPart(lgd_smearedpart_t *part);
 
  ClassDef(TLGDsmears,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TLGDsmears &lgdSmears); 


#endif
