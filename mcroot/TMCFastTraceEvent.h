#ifndef ROOT_TMCFastTraceEvent
#define ROOT_TMCFastTraceEvent
//*-- Author :    Paul Eugenio 23-May-2004


//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastTraceEvent                                                      //
//                                                                      //
// A collection of particle traces                               //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"
#include "TMCFastTraceParticle.h"
#include "TMCFastTracePoint.h"

#include<stdlib.h>
#include <iostream>
using namespace std;

#define MAX_TRACE_PARTICLES 100
const int kFORWARD=0; //Z direction
const int kCENTRAL=1; //Radial direction
const Double_t kSpeedOfLight=29.9792; // units: cm/nSec

class TMCFastTraceEvent: public TObject {
  
private:

  TClonesArray *ftrace_parts;  // array of TMCFastTraceParticle points
  static TClonesArray *fgtrace_parts; // dummy needed to init TClonesArray 

  TClonesArray *ftrace_points;  // array of TMCFastTracePoint points
  static TClonesArray *fgtrace_points; // dummy needed to init TClonesArray 


public:
  TMCFastTraceEvent();
  TMCFastTraceEvent(struct traces_t *traces);
  void Fill(struct traces_t *traces);
  virtual ~TMCFastTraceEvent() ;
  void Clear();

  TClonesArray *GetTraceParticles() const { return ftrace_parts; }
  TClonesArray *GetTracePoints() const { return ftrace_points; }

  int GetNTraceParticles() {return ftrace_parts->GetEntriesFast();}

  int GetNTracePoints() {return ftrace_points->GetEntriesFast();}

  int GetNTracePoints(int partNo) ;
  double GetTZero(int partNo);
  double GetT(int partNo, int direction, double location);
  double GetFT(int partNo, double Z);
  double GetCT(int partNo, double R);
  double GetTOF(int partNo, int direction, double location);
  double GetFTOF(int partNo, double Z);
  double GetCTOF(int partNo, double R);
  double GetTOFMass(int partNo, int direction, double location);
  double GetFTOFMass(int partNo, double Z);
  double GetCTOFMass(int partNo, double R);
  double GetMass(int partNo);

 
  TMCFastTracePoint* GetTracePointZ(int partNo, double Z);
  TMCFastTracePoint* GetTracePointR(int partNo, double R);
  TMCFastTracePoint* GetTracePoint(int partNo, int direction, double Position);
  TMCFastTracePoint* GetTracePoint(int partNo);


  void Print(ostream *os);
  ClassDef(TMCFastTraceEvent,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastTraceEvent &tr_event); 


#endif
