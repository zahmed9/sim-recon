#ifndef ROOT_TMCFastTraceParticle
#define ROOT_TMCFastTraceParticle
//*-- Author :    Paul Eugenio 28-May-2004


//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastTraceParticle                                                      //
//                                                                      //
// A collection of MCFast trace points for a particle   
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"


#include <iostream>
using namespace std;

/**
Particle trace information. This information is used to map
event particles from the tracepoint list.  The trace points
for the whole event contains on big list.  The index of first
and last refer the location in the trace point list of the 
particle first and last trace point, respectively.
****/
class TMCFastTraceParticle: public TObject {
private:

  int ffirst;    //index of particles 1st trace point
  int flast;     //index of particles last trace point

public:
  TMCFastTraceParticle();
  TMCFastTraceParticle(int first, int last);
  void Fill(int first, int last);
  virtual ~TMCFastTraceParticle() {;}
  void Clear(){;}
  Int_t GetFirst() {return this->ffirst;}
  Int_t GetLast() {return this->flast;}
  Int_t GetNTraces() {return  GetLast() - GetFirst() +1;}
  void SetFirst(int first) { this->ffirst= first;}
  void SetLast(int last) {this->flast=last;}

  void Print(ostream *os);
  ClassDef(TMCFastTraceParticle,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastTraceParticle &tr_part); 


#endif
