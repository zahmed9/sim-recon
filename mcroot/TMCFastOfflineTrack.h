#ifndef ROOT_TMCFastOfflineTrack
#define ROOT_TMCFastOfflineTrack

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastOfflineTrack   MCFast Offline Track (Smeared ) Class          //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"
#include "TH1.h"
#include "TMath.h"

#include <iostream>
using namespace std;

// MCFast structures that map to the common blocks

struct wtrack_struct {
  double px;
  double py;
  double pz;
  double E;
  double x;
  double y;
  double z;
  double pt; /* pt = sqrt(px*px+py*py) */
  double p; /* momentum */
  double q; /* charge */
} ;


struct offline_track_t {
  struct wtrack_struct w;
  double mass;
  double cov[7][7]; /* covariance matrix */
  double chisq;     /* fit chisq */
  int nhit;         /* nhits in fit */
  int nhit_sil;     /* # of silicon hits */
  int nhit_stereo;  /* # of  hits with stereo info*/
  int icov;         /* icov = 0 if covariance matrix not defined
                            = 1 if covariance matrix defined
                            = 2 defined, but no momentum information */
  int hep;          /* position of corresp. track in HEPEVT list */
  int pad;          /* pad for alignment */
} ;

#define TRK_OFF_MAX 20
struct trk_off2 {
  struct offline_track_t trk_off[TRK_OFF_MAX];
} ;

struct ntrkoff_t {
  int ntracks;
  struct offline_track_t *trk_off;
} ;


#define TTRK_OFF_MAX TRK_OFF_MAX

class TMCFastOfflineTrack: public TObject {
  
private:

  Int_t    fntracks;                    // number of tracks
  Float_t fpx[TTRK_OFF_MAX];           // Track parameters at interaction 
  Float_t fpy[TTRK_OFF_MAX];
  Float_t fpz[TTRK_OFF_MAX];
  Float_t fE[TTRK_OFF_MAX];
  Float_t fx[TTRK_OFF_MAX];
  Float_t fy[TTRK_OFF_MAX];
  Float_t fz[TTRK_OFF_MAX];
  Float_t fpt[TTRK_OFF_MAX];          // pt = sqrt(px*px+py*py) 
  Float_t fp[TTRK_OFF_MAX];           // momentum 
  Float_t fq[TTRK_OFF_MAX];           // charge 

  Float_t fmass[TTRK_OFF_MAX];        // mass 
  Float_t fcov[TTRK_OFF_MAX][7][7];   //  covariance matrix		
  Float_t fchisq[TTRK_OFF_MAX];       // fit chisq 	     
  Int_t    fnhits[TTRK_OFF_MAX];        // nhits in fit
  Int_t    fnhitsSilicon[TTRK_OFF_MAX] ;   // # of silicon hits
  Int_t    fnhitsStereo[TTRK_OFF_MAX];    // # of  hits with stereo info
  Int_t    ficov[TTRK_OFF_MAX];  //  icov = 0 if covariance matrix not defined
                                 //       = 1 if covariance matrix defined
                                      //  = 2 defined, but no momentum info 
  Int_t    fhep[TTRK_OFF_MAX];  // position of corresp. track in HEPEVT list

public:
  TMCFastOfflineTrack() { }
  TMCFastOfflineTrack( ntrkoff_t *trk_off);
  virtual ~TMCFastOfflineTrack() ;

  Int_t  GetNtracks() const { return fntracks; }
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

  Double_t GetMass(Int_t i) const {return fmass[i];}
  Double_t GetCov(Int_t i,Int_t j, Int_t k) const {return fcov[i][j][k];}
  Double_t GetChisq(Int_t i) const {return fchisq[i];}
  Int_t  GetNhits(Int_t i) const { return fnhits[i]; }
  Int_t  GetNhitsSilicon(Int_t i) const { return fnhitsSilicon[i]; }
  Int_t  GetNhitsStereo(Int_t i) const { return fnhitsStereo[i]; }
  Int_t  GetIcov(Int_t i) const { return ficov[i]; }
  Int_t  GetHep(Int_t i) const { return fhep[i]; }


  void SetNtracks(Int_t n)  {  fntracks=n; }
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

  void SetMass(Int_t i,Double_t x)  { fmass[i]=x;}
  void SetCov(Int_t i,Int_t j,Int_t k,Double_t x)  { fcov[i][j][k]=x;}
  void SetChisq(Int_t i,Double_t x)  { fchisq[i]=x;}
  void SetNhits(Int_t i,Int_t n)  { fnhits[i]=n;}
  void SetNhitsSilicon(Int_t i,Int_t n)  { fnhitsSilicon[i]=n;}
  void SetNhitsStereo(Int_t i,Int_t n)  { fnhitsStereo[i]=n;}
  void SetIcov(Int_t i,Int_t n)  { ficov[i]=n;}
  void SetHep(Int_t i,Int_t n)  {  fhep[i]=n; }

  Double_t GetHepEvtP(Int_t hep);
  void Print(ostream *os);
  void Fill(ntrkoff_t *trk_off);
  
  ClassDef(TMCFastOfflineTrack,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastOfflineTrack &offtrack); 


#endif
