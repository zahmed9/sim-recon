#ifndef ROOT_TMCFastPasrticle
#define ROOT_TMCFastPasrticle
//*-- Author :    Paul Eugenio 15-Jan-99
//*-- CMZ : PME 15-Jan-99

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastParticle   MCFast Particle Class                              //
//                                                                      //
// TMCFastParticle is a summary collection of both charged 
// and neutral particle smeared information                             //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"

#include <iostream.h>


class TMCFastParticle: public TObject {
  
private:

  Int_t    ftype;         // 0=neutral, 1=charged 
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
  TMCFastParticle() { }
  virtual ~TMCFastParticle() ;

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
  Int_t  GetType() const { return ftype; }
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
  void SetType(Int_t n)  {  ftype=n; }

  Double_t GetMass();
  Double_t GetP();
  void Print(ostream *os);

  
  ClassDef(TMCFastParticle,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastParticle &particle); 


#endif
