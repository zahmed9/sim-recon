#ifndef ROOT_TMCFastTracePoint
#define ROOT_TMCFastTracePoint

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastTrace   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TH1.h"
#include "TMCFastOfflineTrack.h"
#include "TMath.h"
 
#include <iostream>
using namespace std;

// MCFast structures that map to the common blocks
#define TRACE_TYPE_PRODUCTION 4

struct trace_t {
  int hep;            /* Position of track in /HEPEVT/ list */
  int type;           /* Trace type (see trace_type.inc) */
  int plane;          /* Radial or z plane number */
  int hit;            /* hit index in hit track list */
  struct wtrack_struct w;  /* Track parameters at interaction */
  double eta[3];      /* Direction cosines of normal to plane */
  double path;        /* Total track length up to this hit */
  double time;        /* Time at which track made hit */
  double tau;         /* Proper flight time to intersection */
  int material;       /* Position in material list */
  int dummy;          /* needed for pad alignment */
  double radl;        /* # of radiation lengths in material */
  double dedx;        /* dE/dx of material */
} ;

struct traces_t {
  int ntraces;
  struct trace_t *trace;
};

class TMCFastTracePoint: public TObject {
  
private:
  Int_t fhepIndex;        // Position of track in /HEPEVT/ list 
  Int_t ftype;           // Trace type (see trace_type.inc) 
  Int_t fplane;          // Radial or z plane number 
  Int_t fhitIndex;           // hit index in hit track list
  Float_t fpx;           // Track parameters at interaction 
  Float_t fpy;
  Float_t fpz;
  Float_t fE;
  Float_t fx;
  Float_t fy;
  Float_t fz;
  Float_t fpt;          // pt = sqrt(px*px+py*py) 
  Float_t fp;           // momentum 
  Float_t fq;           // charge 
  Float_t feta[3];    // Direction cosines of normal to plane 
  Float_t fpath;        // Total track length up to this hit 
  Float_t ftime;        // Time at which track made hit 
  Float_t ftau;         // Proper flight time to intersection 
  Int_t fmaterial;       // Position in material list 
  Float_t fradl;        // # of radiation lengths in material 
  Float_t fdedx;        // dE/dx of material (this is 1e6 *mcfast value)

public:
  TMCFastTracePoint();
  TMCFastTracePoint(TMCFastTracePoint &source); // copy constructor
  TMCFastTracePoint(trace_t *trace);
  void TMCFastTracePoint::operator=(TMCFastTracePoint &source); //assignment operator
  virtual ~TMCFastTracePoint() ;

  Int_t  GetHepIndex() const { return fhepIndex; }
  Int_t  GetType() const { return ftype; }
  Int_t  GetPlane() const { return fplane; }
  Int_t  GetHitIndex() const { return fhitIndex; }
  Double_t GetPx() const {return fpx;}
  Double_t GetPy() const {return fpy;}
  Double_t GetPz() const {return fpz;}
  Double_t GetE() const {return fE;}
  Double_t GetX() const {return fx;}
  Double_t GetY() const {return fy;}
  Double_t GetZ() const {return fz;}
  Double_t GetPt() const {return fpt;}
  Double_t GetP() const {return fp;}
  Double_t GetQ() const {return fq;}
  Double_t GetEta(Int_t j) const {return feta[j];}
  Double_t GetPath() const {return fpath;}
  Double_t GetTime() const {return ftime;}
  Double_t GetTau() const {return ftau;}
  Int_t    GetMaterial() const {return fmaterial;}
  Double_t GetRadiationLength() const {return fradl;}
  Double_t GetDedx() const {return fdedx;}
  Double_t GetR();
  Double_t GetBeta();

  void SetHepIndex(Int_t n)  {  fhepIndex=n; }
  void SetType(Int_t n)  {  ftype=n; }
  void SetPlane(Int_t n)  {  fplane=n; }
  void SetHitIndex(Int_t n)  {  fhitIndex=n; }
  void SetPx(Double_t x)  { fpx=x;}
  void SetPy(Double_t x)  { fpy=x;}
  void SetPz(Double_t x)  { fpz=x;}
  void SetE(Double_t x)  { fE=x;}
  void SetX(Double_t x)  { fx=x;}
  void SetY(Double_t x)  { fy=x;}
  void SetZ(Double_t x)  { fz=x;}
  void SetPt(Double_t x)  { fpt=x;}
  void SetP(Double_t x)  { fp=x;}
  void SetQ(Double_t x)  { fq=x;}
  void SetEta(Int_t j,Double_t x)  { feta[j]=x;}
  void SetPath(Double_t x)  { fpath=x;}
  void SetTime(Double_t x)  { ftime=x;}
  void SetTau(Double_t x)  { ftau=x;}
  void SetMaterial(Int_t n)  { fmaterial=n;}
  void SetRadl(Double_t x)  { fradl=x;}
  void SetDedx(Double_t x)  { fdedx=x;}

  
  Double_t TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax);
  void TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax,
			       Int_t nSegments,Double_t *Segment);
  Int_t Npe(Double_t indexOfRefraction, Double_t &Rmin, Double_t &Rmax, Double_t &Zmax);
  Int_t TMCFastTracePoint::Npe(Double_t indexOfRefraction,Double_t PathLength);
  
  void Print(ostream *os);
  void Fill(trace_t *trace);
  
  ClassDef(TMCFastTracePoint,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastTracePoint &trace); 


#endif
