#ifndef ROOT_TMCFastHepParticle
#define ROOT_TMCFastHepParticle

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastHepParticle   MCFast StdHep  Class                             //
//                                                                      //
// This is port of MCFast HEPEVT Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"

#include <iostream>
using namespace std;

struct heppart_t {
  int isthep;     /* The particle status */
  int idhep;      /* The particle id */
  int jmohep[2];    /* The position of the mother particle */
  int jdahep[2];    /* Position of the first daughter... */
  double phep[5];    /* 4-Momentum, mass */
  double vhep[4];    /* Vertex information */
} ;

struct hepevt_t {
  int nevhep;             /* The event number */
  int nhep;               /* The number of entries in this event */
  struct heppart_t *heppart;
};


class TMCFastHepParticle: public TObject{
private:
  Int_t fisthep;     // The Particle status
  Int_t fidhep;      // The particle id (PDG pid)
  Int_t findex;      // The HEPEVT index
  Int_t fjmohep[2];    // The position of the mother particles 
  Int_t fjdahep[2];    // Position of the first daughter... 
  Float_t  fphep[5];    // 4-Momentum (Px,Py,Pz,E), mass
  Float_t fvhep[4];    // Vertex information(x,y,z), time 

public:
  TMCFastHepParticle() { }
  TMCFastHepParticle(struct heppart_t *part,Int_t index);
  virtual ~TMCFastHepParticle() ;
  Int_t  GetIsthep() const { return fisthep; }
  Int_t  GetIdhep() const { return fidhep; }
  Int_t GetIndex() const {return findex;}
  Int_t  GetJmohep(Int_t j) const { return fjmohep[j]; }
  Int_t  GetJdahep(Int_t j) const { return fjdahep[j]; }
  Double_t GetMass() const {return fphep[4];}
  Double_t GetPx() const {return fphep[0];}
  Double_t GetPy() const {return fphep[1];}
  Double_t GetPz() const {return fphep[2];}
  Double_t GetE() const {return fphep[3];}
  Double_t GetPt();
  Double_t GetVx() const {return fvhep[0];}
  Double_t GetVy() const {return fvhep[1];}
  Double_t GetVz() const {return fvhep[2];}
  Double_t GetVt() const {return fvhep[3];}


  void SetIsthep( Int_t n)  { fisthep=n; }
  void SetIdhep( Int_t n)  { fidhep=n; }
  void SetIndex(Int_t n) {findex=n;}
  void SetJmohep(Int_t j,Int_t n)  { fjmohep[j]=n; }
  void SetJdahep(Int_t j,Int_t n)  { fjdahep[j]=n; }
  void SetMass( Double_t x)  { fphep[4]=x;}
  void SetPx(Double_t x)  { fphep[0]=x;}
  void SetPy(Double_t x)  { fphep[1]=x;}
  void SetPz(Double_t x)  { fphep[2]=x;}
  void SetE(Double_t x)   { fphep[3]=x;}
  void SetVx(Double_t x)  { fvhep[0]=x;}
  void SetVy(Double_t x)  { fvhep[1]=x;}
  void SetVz(Double_t x)  { fvhep[2]=x;}
  void SetVt(Double_t x)  { fvhep[3]=x;}

  void Print(ostream *os);
  void Fill(struct heppart_t *part,Int_t index);
  ClassDef(TMCFastHepParticle,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastHepParticle &part); 


#endif
