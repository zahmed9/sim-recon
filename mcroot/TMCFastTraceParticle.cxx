//*-- Author :    Paul Eugenio 28-May-2004

////////////////////////////////////////////////////////////////////////
// TMCFastTraceParticle
//
// This class contains a collection of trace points for a particle 
//
//  TMCFastTraceParticle contains a TClonesArray of  TMCFastTrace
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastTraceParticle.h"
ClassImp(TMCFastTraceParticle)



//____________________________________________________________________________

TMCFastTraceParticle::TMCFastTraceParticle(int first, int last){
  // Create the object 
  // and fill it using  FIll( first, last) 
  //

  Fill(first, last);
}

TMCFastTraceParticle::TMCFastTraceParticle(){
  // default constructor
  //
  SetFirst(-1);
  SetLast(-1);
}


void  TMCFastTraceParticle::Fill(int first, int last){
  // Fill the object with the trace point indices
  // 
  SetFirst(first);
  SetLast(last); 
}


void TMCFastTraceParticle::Print(ostream *os){
  // Prints TMCFastTraceParticle object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << obj;
  // 
  // where obj is an instance of TMCFastTraceParticle


  *os<<"TraceParticle starts at index "<< this->GetFirst()<<" and ends at index "<<this->GetLast()<<endl;
  
}


ostream &operator<<(ostream &os, TMCFastTraceParticle &tr_part){
// overload the standard print operator
  tr_part.Print(&os);
  return os;
}
