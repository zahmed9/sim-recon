#ifndef ROOT_TMCParticle
#define ROOT_TMCParticle
//*-- Author :    Paul Eugenio 15-Jan-99
//*-- CMZ : PME 15-Jan-99

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCParticle   MCFast Particle Class                              //
//                                                                      //
// TMCParticle is a summary collection of both charged 
// and neutral particle smeared information                             //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TRandom.h"
#include "TMath.h"
#include "TClonesArray.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastHepParticle.h"
#include "TLGDparticle.h"

#include <iostream.h>

#define MADE_FROM_OFFTRK 0
#define MADE_FROM_BCAL 1
#define MADE_FROM_LGD 2
#define PDG_GAMMA 22
#define MADE_FROM_HEPEVT -1

class TMCParticle: public TObject {
  
private:

  Int_t    fmaker;         // -1=hepevt, 0=offtrk, 1=bcal, 2=lgd 
  Int_t    fstatus;       // status (currently not used) 
  Int_t    fhepIndex;    // position of corresp. track in HEPEVT list
  Int_t    fidhep;        // PDG MC id
  Int_t     fq;           // charge 
  Double_t fpx;           // four-momentum 
  Double_t fpy;
  Double_t fpz;
  Double_t fE;
  Double_t fx;            // vertex  point-of-decay
  Double_t fy;
  Double_t fz;


public:
  TMCParticle() { }
  TMCParticle(TMCFastHepParticle &heppart,TMCFastOfflineTrack &offtrk,Int_t track);
  TMCParticle(TMCFastHepParticle &heppart,Double_t eSmeared); 
  TMCParticle(TMCFastHepParticle &heppart,Double_t eSmeared,
	      Double_t z_resolution); 
  TMCParticle(TLGDparticle &lgdpart); 
  TMCParticle(TMCFastHepParticle &heppart);
  virtual ~TMCParticle() ;

  Double_t GetPx() const {return fpx;}
  Double_t GetPy() const {return fpy;}
  Double_t GetPz() const {return fpz;}
  Double_t GetE() const {return fE;}
  Double_t GetX() const {return fx;}
  Double_t GetY() const {return fy;}
  Double_t GetZ() const {return fz;}
  Double_t GetCharge() const {return fq;}
  Int_t  GetIdHep() const { return fidhep; }
  Int_t  GetHepIndex() const { return fhepIndex; }
  Int_t  GetMaker() const { return fmaker; }
  Int_t GetStatus() const {return fstatus;}

  void SetPx(Double_t x)  { fpx=x;}
  void SetPy(Double_t x)  { fpy=x;}
  void SetPz(Double_t x)  { fpz=x;}
  void SetE(Double_t x)  { fE=x;}
  void SetX(Double_t x)  { fx=x;}
  void SetY(Double_t x)  { fy=x;}
  void SetZ(Double_t x)  { fz=x;}
  void SetCharge(Int_t q)  { fq=q;}
  void SetIdHep(Int_t n)  {  fidhep=n; }
  void SetHepIndex(Int_t n)  {  fhepIndex=n; }
  void SetMaker(Int_t n)  {  fmaker=n; }
  void SetStatis(Int_t n)  {  fstatus=n; }

  Double_t GetMass();
  Double_t GetP();
  void Print(ostream *os);

  
  ClassDef(TMCParticle,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCParticle &particle); 


#endif
