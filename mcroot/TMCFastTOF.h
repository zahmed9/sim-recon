#ifndef ROOT_TMCFastTOF
#define ROOT_TMCFastTOF

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastTOF   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastTrace.h"
#include "TH1.h"
#include "TMath.h"

#include <iostream.h>


#define TRACE_MAX 3*(TTRK_OFF_MAX)


#define TTOF_TRACE_MAX TRACE_MAX

#define CENTRAL 41
#define TMCFAST_CENTRAL_TRACE  CENTRAL

#define FORWARD 42
#define TMCFAST_FORWARD_TRACE   FORWARD

#define CTOF_PLANE 3
#define FTOF_Z 200  

const Double_t kSpeedOfLight=29.9792; // units: cm/nSec

class TMCFastTOF: public TObject {
  
private:
  Int_t fntraces;        // The number of track intersections
  Int_t fhep[TTOF_TRACE_MAX];            // Position of track in /HEPEVT/ list 
  Int_t ftype[TTOF_TRACE_MAX];           // Trace type (see trace_type.inc) 
  Int_t fplane[TTOF_TRACE_MAX];          // Radial or z plane number 
  Int_t fhit[TTOF_TRACE_MAX];            // # of hits in hit track list 
  Float_t fpx[TTOF_TRACE_MAX];           // Track parameters at interaction 
  Float_t fpy[TTOF_TRACE_MAX];
  Float_t fpz[TTOF_TRACE_MAX];
  Float_t fE[TTOF_TRACE_MAX];
  Float_t fx[TTOF_TRACE_MAX];
  Float_t fy[TTOF_TRACE_MAX];
  Float_t fz[TTOF_TRACE_MAX];
  Float_t fpt[TTOF_TRACE_MAX];          // pt = sqrt(px*px+py*py) 
  Float_t fp[TTOF_TRACE_MAX];           // momentum 
  Float_t fq[TTOF_TRACE_MAX];           // charge 
  Float_t feta[TTOF_TRACE_MAX][3];    // Direction cosines of normal to plane 
  Float_t fpath[TTOF_TRACE_MAX];        // Total track length up to this hit 
  Float_t ftime[TTOF_TRACE_MAX];        // Time at which track made hit 
  Float_t ftau[TTOF_TRACE_MAX];         // Proper flight time to intersection 
  Int_t fmaterial[TTOF_TRACE_MAX];       // Position in material list 
  Float_t fradl[TTOF_TRACE_MAX];        // # of radiation lengths in material 
  Float_t fdedx[TTOF_TRACE_MAX];        // dE/dx of material 

public:
  TMCFastTOF() { }
  TMCFastTOF(traces_t *traces);
  virtual ~TMCFastTOF() ;

  Double_t GetCTOF(Int_t hep);
  Double_t GetFTOF(Int_t hep);
  Double_t GetMass(Int_t hep);
  Double_t GetR(Int_t i);
  Double_t Beta(Int_t hep);
  Double_t CTOFmass(Int_t hep);
  Double_t FTOFmass(Int_t hep);
  Double_t TMCFastTOF::CTOFmass(Int_t hep, TMCFastOfflineTrack &offtrk);
  Double_t TMCFastTOF::FTOFmass(Int_t hep, TMCFastOfflineTrack &offtrk);
  Int_t  GetNtraces() const { return fntraces; }
  Int_t  GetHep(Int_t i) const { return fhep[i]; }
  Int_t  GetType(Int_t i) const { return ftype[i]; }
  Int_t  GetPlane(Int_t i) const { return fplane[i]; }
  Int_t  GetHits(Int_t i) const { return fhit[i]; }
  Double_t GetPx(Int_t i) const {return fpx[i];}
  Double_t GetPy(Int_t i) const {return fpy[i];}
  Double_t GetPz(Int_t i) const {return fpz[i];}
  Double_t GetE(Int_t i) const {return fE[i];}
  Double_t GetX(Int_t i) const {return fx[i];}
  Double_t GetY(Int_t i) const {return fy[i];}
  Double_t GetZ(Int_t i) const {return fz[i];}
  Double_t GetPt(Int_t i) const {return fpt[i];}
  Double_t GetP(Int_t i) const {return fp[i];}
  Double_t GetQ(Int_t i) const {return fq[i];}
  Double_t GetEta(Int_t i,Int_t j) const {return feta[i][j];}
  Double_t GetPath(Int_t i) const {return fpath[i];}
  Double_t GetTime(Int_t i) const {return ftime[i];}
  Double_t GetTau(Int_t i) const {return ftau[i];}
  Int_t    GetMaterial(Int_t i) const {return fmaterial[i];}
  Double_t GetRadl(Int_t i) const {return fradl[i];}
  Double_t GetDedx(Int_t i) const {return fdedx[i];}

  void SetNtraces(Int_t n)  {  fntraces=n; }
  void SetHep(Int_t i,Int_t n)  {  fhep[i]=n; }
  void SetType(Int_t i,Int_t n)  {  ftype[i]=n; }
  void SetPlane(Int_t i,Int_t n)  {  fplane[i]=n; }
  void SetHits(Int_t i,Int_t n)  {  fhit[i]=n; }
  void SetPx(Int_t i,Double_t x)  { fpx[i]=x;}
  void SetPy(Int_t i,Double_t x)  { fpy[i]=x;}
  void SetPz(Int_t i,Double_t x)  { fpz[i]=x;}
  void SetE(Int_t i,Double_t x)  { fE[i]=x;}
  void SetX(Int_t i,Double_t x)  { fx[i]=x;}
  void SetY(Int_t i,Double_t x)  { fy[i]=x;}
  void SetZ(Int_t i,Double_t x)  { fz[i]=x;}
  void SetPt(Int_t i,Double_t x)  { fpt[i]=x;}
  void SetP(Int_t i,Double_t x)  { fp[i]=x;}
  void SetQ(Int_t i,Double_t x)  { fq[i]=x;}
  void SetEta(Int_t i,Int_t j,Double_t x)  { feta[i][j]=x;}
  void SetPath(Int_t i,Double_t x)  { fpath[i]=x;}
  void SetTime(Int_t i,Double_t x)  { ftime[i]=x;}
  void SetTau(Int_t i,Double_t x)  { ftau[i]=x;}
  void SetMaterial(Int_t i,Int_t n)  { fmaterial[i]=n;}
  void SetRadl(Int_t i,Double_t x)  { fradl[i]=x;}
  void SetDedx(Int_t i,Double_t x)  { fdedx[i]=x;}

   void Print(ostream *os);
   void Fill(traces_t *traces);
 
   ClassDef(TMCFastTOF,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastTOF &tof); 


#endif
