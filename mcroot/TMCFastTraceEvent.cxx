//*-- Author :    Paul Eugenio 28-May-2004

////////////////////////////////////////////////////////////////////////
// TMCFastTraceEvent
//
//  This class contains all of the trace point information provided by 
//  the core mcfast processing.  This information is contained in an array
//  of TMCFastTracePoint objects with the individual particle trace boundary
//  information stored in an array of TMCFastTraceParticle objects.
//
////////////////////////////////////////////////////////////////////////




#include "TMCFastTraceEvent.h"
ClassImp(TMCFastTraceEvent)

  // static pointers need for TClonesArrays
TClonesArray *TMCFastTraceEvent::fgtrace_parts = 0;
TClonesArray *TMCFastTraceEvent::fgtrace_points = 0;


TMCFastTraceEvent::TMCFastTraceEvent(struct traces_t *traces){
  // Construct an object 
  // and fill it using  FIll(struct traces_t *traces) 
  //
  if(!fgtrace_parts) fgtrace_parts = new TClonesArray("TMCFastTraceParticle",100);
  if(!fgtrace_points) fgtrace_points = new TClonesArray("TMCFastTracePoint",100);

  ftrace_parts = fgtrace_parts;
  ftrace_points = fgtrace_points;

  Fill(traces);

}

TMCFastTraceEvent::TMCFastTraceEvent(){
  // Default constructor
  //
  if(!fgtrace_parts) fgtrace_parts = new TClonesArray("TMCFastTraceParticle",10);
  if(!fgtrace_points) fgtrace_points = new TClonesArray("TMCFastTracePoint",10);

  ftrace_parts = fgtrace_parts;
  ftrace_points = fgtrace_points;

}


void  TMCFastTraceEvent::Fill(struct traces_t *traces){
  // Fill the object using a c 
  // struct map of the trace point
  // 
  TClonesArray &tparts=*(this->ftrace_parts);
  TClonesArray &tpoints=*(this->ftrace_points);

  int first[MAX_TRACE_PARTICLES],last[MAX_TRACE_PARTICLES];
  int ntrace_parts=0;

  if(traces->trace->type != TRACE_TYPE_PRODUCTION){ // check first trace point
    cerr<<"ERROR----TMCFastTraceEvent::Fill():  First trace point is not a TRACE_TYPE_PRODUCTION!!\n\n";
    exit(-1);
  }
  
  //
  // Fill trace points 
  // and find particle boundaries
  for(int i =0; i< traces->ntraces;i++){
     new(tpoints[i]) TMCFastTracePoint((traces->trace) + i);

    if( (traces->trace + i)->type == TRACE_TYPE_PRODUCTION){ //start of particle trace info
      first[ntrace_parts++] = i;  //save index value 
    }
    last[ntrace_parts -1] = i;
  }
 
  // Fill particle boundary info
  for(Int_t i =0; i< ntrace_parts ;i++){
    new(tparts[i]) TMCFastTraceParticle(first[i],last[i]);
  }
}


void TMCFastTraceEvent::Clear()
{
  // Clear the TClonesArray fHepParticle
  //
  ftrace_parts->Clear();
  ftrace_points->Clear();
}


TMCFastTraceEvent::~TMCFastTraceEvent(){
  // Default destructor
  //
  this->Clear();
}


int TMCFastTraceEvent::GetNTracePoints(int partNo){
  // Get the number of trace points for
  // a particle

  TClonesArray *tp =this->GetTraceParticles();
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tp)[partNo];
  return   tracepart->GetLast() - tracepart->GetFirst() + 1 ;
}

double TMCFastTraceEvent::GetTZero(int partNo){
  // Get the mcfast clock production time for 
  // a particle
  
  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint;
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];
  tracepoint =  (TMCFastTracePoint *)(*tpoints)[tracepart->GetFirst()];

  return   tracepoint->GetTime();
}

double TMCFastTraceEvent::GetMass(int partNo){
  // Get the real particle mass
  //   m = sqrt(E^2 - P^2)
  //
  // This method uses trace point info.

  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint;
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];
  tracepoint =  (TMCFastTracePoint *)(*tpoints)[tracepart->GetFirst()];
  double p = tracepoint->GetP();
  double E = tracepoint->GetE();
  return    TMath::Sqrt(E*E - p*p);
}



double TMCFastTraceEvent::GetTOFMass(int partNo, int direction, double location){
 // Calculate time-of-flight mass
  // Currently there is no smearing!!!!! (but soon should be implemented)
  //
  //  m = p/(beta*gamma)
  //
  //  beta = (tracepoint->GetPath(i)/tof)*(1/kSpeedOfLight);
  //  tof = GetCTOF(partNo, R);
  //
  // return -1 if GetCTOF(partNo, R) fails to find a tracepoint.
  // Note: the value of direction can equal "kFORWARD" or "kCENTRAL" 

 double mass = -1; // default return  if GetCTOF(partNo, R) fails to find a tracepoint.

 TMCFastTracePoint *tracepoint = GetTracePoint(partNo, direction, location); 
 double tof = GetTOF(partNo, direction, location);
 double path = tracepoint->GetPath();

 if(tof>0){
   double beta = (path/tof)*(1/kSpeedOfLight);
   double gamma = 1/(TMath::Sqrt( 1 - beta*beta));

   if(gamma!=gamma) // look for NaN this means beta=1
     mass =0;
   else
     mass =   tracepoint->GetP()/(beta*gamma);
 }
 return  mass;
}

double TMCFastTraceEvent::GetCTOFMass(int partNo, double R){
  // Calculate time-of-flight mass
  //
  // Uses GetTOFMass(partNo, kCENTRAL, R);
  
  return this->GetTOFMass(partNo, kCENTRAL, R);
}

double TMCFastTraceEvent::GetFTOFMass(int partNo, double Z){
  // Calculate time-of-flight mass
  //
  // Uses GetTOFMass(partNo, kFORWARD, Z);
  
  return this->GetTOFMass(partNo, kFORWARD, Z);
}

double TMCFastTraceEvent::GetTOF(int partNo,int direction, double location){
  // Get TOF from production to either forward or central location
  //
  // Function returns a negative number if
  // particle never reached Z location
  //
  // Note: the value of direction can equal "kFORWARD" or "kCENTRAL" 
  //
  double tof = GetT(partNo,direction,location) -  GetTZero(partNo);
  return  tof>0? tof:-1;
}



double TMCFastTraceEvent::GetFTOF(int partNo, double Z){
  // Get Forward TOF from production to Z location
  //
  // Function returns a negative number if
  // particle never reached Z location
 
  return  GetTOF(partNo,kFORWARD, Z);
  
}

double TMCFastTraceEvent::GetCTOF(int partNo, double R){
  // Get Central TOF from production to radius R
  //
  // Function returns a negative number if
  // particle never reached R location
  
  GetTOF(partNo,kCENTRAL, R);
}


double TMCFastTraceEvent::GetT(int partNo, int direction, double location){
  // Get the mcfast clock time for
  // a particle moving in the forward/central direction at the given location
  //
  // Note: the value of direction can equal "kFORWARD" or "kCENTRAL" 
  // Method return -1 if tracepoint at location is not found.
 

  double time=-1; //default
 
  TMCFastTracePoint *tracepoint = GetTracePoint(partNo, direction,location);
  double loc = direction==kFORWARD?tracepoint->GetZ():tracepoint->GetR();  
  if(loc >= location ) //we found closest tracepoint
    time =  tracepoint->GetTime();
  return time;
}

double TMCFastTraceEvent::GetFT(int partNo, double Z){
  // Get the mcfast clock time for
  // a particle at Forward location  [Uses GetT(partNo,direction,location)]

  return this->GetT(partNo,kFORWARD,Z);

}

double TMCFastTraceEvent::GetCT(int partNo, double Z){
  // Get the mcfast clock time for
  // a particle at the Central location  [Uses GetT(partNo,direction,location)]

  return this->GetT(partNo,kCENTRAL,Z);

}


TMCFastTracePoint* TMCFastTraceEvent::GetTracePoint(int partNo){
  // Get the particle's 1st trace point.  This is the trace point at
  // the production vertex

  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint=0;
  TMCFastTraceParticle *tracepart;

  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];
  tracepoint =  (TMCFastTracePoint *)(*tpoints)[tracepart->GetFirst()];
  return  tracepoint;
}

TMCFastTracePoint* TMCFastTraceEvent::GetTracePoint(int partNo, int direction, double Position){
  // Get the particle trace point closest to the  location requested
  // direction can equal "kFORWARD" or "kCENTRAL" which refers to forward/z tracing 
  //
  if(direction != kFORWARD && direction != kCENTRAL){
    // error: wrong direction
    cerr<<"WARNING:::: Using TMCFastTraceEvent::GetTracePoint() with invalid direction\n";
  }

  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint=0;
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];

  for(int i = tracepart->GetFirst(); i<=tracepart->GetLast();i++){
   tracepoint =  (TMCFastTracePoint *)(*tpoints)[i];
   double loc = direction?tracepoint->GetR():tracepoint->GetZ();
   if(loc>= Position)
     i = tracepart->GetLast()+1; //get out of loop   
  }
  return  tracepoint;
}

TMCFastTracePoint* TMCFastTraceEvent::GetTracePointR(int partNo, double R){
  // Get the particle trace point closest to the Z location requested
  //  
    
  return  GetTracePoint(partNo,kCENTRAL,R);
}

TMCFastTracePoint* TMCFastTraceEvent::GetTracePointZ(int partNo, double Z){
  // Get the particle trace point closest to the Z location requested
  //  

  return GetTracePoint(partNo, kFORWARD,Z);
}



void TMCFastTraceEvent::Print(ostream *os){
  // Prints TMCFastTraceEvent object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << traces;
  // 
  //
 

  *os<<"TraceEvent has "<< this->GetNTraceParticles()<<" particle trace information(s)\n";
  
  // Now Print the trace points
  TIter next(this->GetTraceParticles());
  TMCFastTracePoint *tracepoint;
  TClonesArray *ta =this->GetTracePoints();

  while( TMCFastTraceParticle *tracepart = (TMCFastTraceParticle *)next()){
    int count=0;
    *os<<"Particle has "<<tracepart->GetNTraces()<<" traces\n";
    for(int i = tracepart->GetFirst(); i<=tracepart->GetLast();i++){
      *os<<"  ["<<count++<<"] ";
      tracepoint =  (TMCFastTracePoint *)(*ta)[i];
      tracepoint->Print(os);
     
    }
  }
}


ostream &operator<<(ostream &os, TMCFastTraceEvent &obj){
// overload the standard print operator
  obj.Print(&os);
  return os;
}
