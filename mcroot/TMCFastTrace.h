#ifndef ROOT_TMCFastTrace
#define ROOT_TMCFastTrace

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastTrace   MCFast Trace  Class                                  //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TMCFastOfflineTrack.h"
#include "TH1.h"
#include "TMath.h"

#include <iostream.h>

// MCFast structures that map to the common blocks

struct trace_s {
  int hep;            /* Position of track in /HEPEVT/ list */
  int type;           /* Trace type (see trace_type.inc) */
  int plane;          /* Radial or z plane number */
  int hit;            /* # of hits in hit track list */
  struct wtrack_struct w;  /* Track parameters at interaction */
  double eta[3];      /* Direction cosines of normal to plane */
  double path;        /* Total track length up to this hit */
  double time;        /* Time at which track made hit */
  double tau;         /* Proper flight time to intersection */
  int material;       /* Position in material list */
  double radl;        /* # of radiation lengths in material */
  double dedx;        /* dE/dx of material */
} ;


#define TRACE_MAX 20000

struct trace_par_c {
  int trace_num;      /* Number of track intersections */
  int trace_num_dum;  /* dummy for alignment */
  struct trace_s trace_par[TRACE_MAX];
} ;


#define TTRACE_MAX 2000

#define CENTRAL 1
#define FORWARD 2
#define CTOF_PLANE 3
#define FTOF_Z 200 

class TMCFastTrace: public TObject {
  
private:
  Int_t fntraces;        // The number of track intersections
  Int_t fhep[TTRACE_MAX];            // Position of track in /HEPEVT/ list 
  Int_t ftype[TTRACE_MAX];           // Trace type (see trace_type.inc) 
  Int_t fplane[TTRACE_MAX];          // Radial or z plane number 
  Int_t fhit[TTRACE_MAX];            // # of hits in hit track list 
  Double_t fpx[TTRACE_MAX];           // Track parameters at interaction 
  Double_t fpy[TTRACE_MAX];
  Double_t fpz[TTRACE_MAX];
  Double_t fE[TTRACE_MAX];
  Double_t fx[TTRACE_MAX];
  Double_t fy[TTRACE_MAX];
  Double_t fz[TTRACE_MAX];
  Double_t fpt[TTRACE_MAX];          // pt = sqrt(px*px+py*py) 
  Double_t fp[TTRACE_MAX];           // momentum 
  Double_t fq[TTRACE_MAX];           // charge 
  Double_t feta[TTRACE_MAX][3];      // Direction cosines of normal to plane 
  Double_t fpath[TTRACE_MAX];        // Total track length up to this hit 
  Double_t ftime[TTRACE_MAX];        // Time at which track made hit 
  Double_t ftau[TTRACE_MAX];         // Proper flight time to intersection 
  Int_t fmaterial[TTRACE_MAX];       // Position in material list 
  Double_t fradl[TTRACE_MAX];        // # of radiation lengths in material 
  Double_t fdedx[TTRACE_MAX];        // dE/dx of material 

public:
  TMCFastTrace() { }
  TMCFastTrace(trace_par_c *trace);
  virtual ~TMCFastTrace() ;

  Double_t GetCTOF(Int_t hep);
  Double_t GetFTOF(Int_t hep);
  Double_t GetR(Int_t i);

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
   void Fill(trace_par_c *trace);
 
   ClassDef(TMCFastTrace,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastTrace &trace); 


#endif
