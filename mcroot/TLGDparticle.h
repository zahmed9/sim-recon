#ifndef ROOT_TLGDparticle
#define ROOT_TLGDparticle

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TLGDparticle   MCFast Calorimeter Hits Class                     //
//                                                                      //
// Also see  TMCFastCalorimeter                                         //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include <TObject.h>
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"


#include <iostream>
using namespace std;


typedef struct  {
  int hepIndex;       /* index to the particle in the hepevt list */
  int type;           /* types: 0= hadron, 1=gamma */
  double xlocal;      /* x at lgd face */
  double ylocal;      /* y at lgd face */
  double px;          /* smeared momentum */
  double py;
  double pz;
  double vx;          /* production vertex */
  double vy;
  double vz;
}lgd_smearedpart_t;

typedef  struct {
  int nparts;            /* Number of particles detected by the lgd */
  lgd_smearedpart_t part[1];
}lgd_smearedparts_t ;



class TLGDparticle: public TObject{
private:
  Int_t fhepIndex;      // index to the particle in the hepevt list 
  Int_t ftype;          // types: 0= hadron, 1=gamma
  Float_t fxlocal;      // x at lgd face
  Float_t fylocal;      // y at lgd face 
  Float_t fpx;          // smeared momentum
  Float_t fpy;
  Float_t fpz;
  Float_t fvx;          // production vertex
  Float_t fvy;
  Float_t fvz;
public:
  TLGDparticle(){} 
  TLGDparticle(lgd_smearedpart_t *lgdpart);
  virtual ~TLGDparticle() ;
  Int_t GetHepIndex() const{return this->fhepIndex;}
  Int_t GetType() const{ return this->ftype;}
  Float_t GetXlocal() const{return this->fxlocal;}
  Float_t GetYlocal() const{return this->fylocal;}
  Float_t GetPx() const{return this->fpx;}
  Float_t GetPy() const{return this->fpy;}
  Float_t GetPz() const{return this->fpz;}
  Float_t GetVx() const{return this->fvx;}
  Float_t GetVy() const{return this->fvy;}
  Float_t GetVz() const{return this->fvz;}
  Double_t GetE();

  void SetHepIndex(Int_t i) {this->fhepIndex=i;  } 
  void SetType(Int_t i) {this->ftype=i;  }  
  void SetXlocal(Float_t x) {this->fxlocal=x;  }  
  void SetYlocal(Float_t y) {this->fylocal=y;  }  
  void SetPx(Float_t p) {this->fpx=p;  }  
  void SetPy(Float_t p) {this->fpy=p;  }   
  void SetPz(Float_t p) {this->fpz=p;  }  
  void SetVx(Float_t v) {this->fvx=v;  }  
  void SetVy(Float_t v) {this->fvy=v;  }   
  void SetVz(Float_t v) {this->fvz=v;  }  		
  
  void Print(ostream *os);
  void Fill(lgd_smearedpart_t *lgdpart);
  ClassDef(TLGDparticle,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TLGDparticle &lgdparticle); 


#endif
