#ifndef ROOT_TMCesr
#define ROOT_TMCesr
//*-- Author :    Paul Eugenio 15-Jan-99
//*-- CMZ : PME 15-Jan-99

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCesr   MCFast Particles Class                            //
//                                                                      //
// A collection of TMCesr
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"
#include "TMCFastHepEvt.h"
#include "TMCFastHepParticle.h"
#include "TMCFastOfflineTrack.h"
#include "TLGDsmears.h"
#include "TMCFastCalorimeter.h"
#include "TMCParticle.h"

#include <iostream>
using namespace std;

class TMCesr: public TObject {
  
private:
  Int_t fnParticles;           // Total number of particles detected 
  Int_t fnLGDparticles;        // Number of particles detected by LGD 
  Int_t fnBCALparticles;       // Number of particles detected by BCAL 
  Int_t fnOFFTRKparticles;     // Number of particles detected by charged tracking
  TClonesArray *fParticles;  // array of TMCParticle
  static TClonesArray *fgParticles; // dummy needed to init TClonesArray  
  
public:
  TMCesr();
  TMCesr(TMCFastHepEvt &hepevt,
         TMCFastOfflineTrack &offtrk, 
         TLGDsmears &lgdsmears,
	 TMCFastCalorimeter &bcal);
  TMCesr(TMCFastHepEvt &hepevt,
         TMCFastOfflineTrack &offtrk, 
         TLGDsmears &lgdsmears,
	 TMCFastCalorimeter &bcal,Double_t bcal_resolution,Double_t phi_res);
  TMCesr(TMCFastHepEvt &hepevt);
  void Fill(TMCFastHepEvt &hepevt,
       TMCFastOfflineTrack &offtrk, 
       TLGDsmears &lgdsmears,
	    TMCFastCalorimeter &bcal,Double_t bcal_resolution,Double_t phi_res);
  void Fill(TMCFastHepEvt &hepevt);
  virtual ~TMCesr() ;
  void Clear();
  Int_t GetNparticles() {return fnParticles;}
  Int_t GetNLGDparticles() {return fnLGDparticles;}
  Int_t GetNBCALparticles() {return fnBCALparticles;}
  Int_t GetNOFFTRKparticles() {return fnOFFTRKparticles;}
  void SetNparticles(Int_t n)  { fnParticles=n; }
  void SetNLGDparticles(Int_t n)  { fnLGDparticles=n; }
  void SetNBCALparticles(Int_t n)  { fnBCALparticles=n; }
  void SetNOFFTRKparticles(Int_t n)  { fnOFFTRKparticles=n; }

  TClonesArray *GetParticles() const { return fParticles; }
  Int_t makeParticles(TMCFastHepEvt &hepevt,TLGDsmears &lgd);
  //Int_t makeParticles(TMCFastHepEvt &hepevt,TMCFastCalorimeter &bcal);
  Int_t makeParticles(TMCFastHepEvt &hepevt,TMCFastCalorimeter &bcal,Double_t bcal_res,Double_t phi_res);
  Int_t makeParticles(TMCFastHepEvt &hepevt,TMCFastOfflineTrack &offtrk);
  Int_t makeParticles(TMCFastHepEvt &hepevt);
  void DumpGampFormat(ostream *os,Double_t b);
  void Print(ostream *os);
  ClassDef(TMCesr,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCesr &esr); 


#endif

