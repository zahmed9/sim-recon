//*-- Author :    Paul Eugenio 28-May-2004

////////////////////////////////////////////////////////////////////////
// TMCFastTraceEvent
//
// 
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
  // Get the particle mass
  //   m = sqrt(E^2 - P^2)

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


double TMCFastTraceEvent::GetFTOF(int partNo, double Z){
  // Get Forward TOF from production to Z location
  //
  // Function returns a negative number if
  // particle never reached Z location
  double tof = GetFT(partNo,Z) -  GetTZero(partNo);
  return  tof>0? tof:-1;
}

double TMCFastTraceEvent::GetCTOF(int partNo, double R){
  // Get Central TOF from production to radius R
  //
  // Function returns a negative number if
  // particle never reached Z location
   double tof =  GetCT(partNo,R) -  GetTZero(partNo);
  return tof>0? tof:-1;
}


double TMCFastTraceEvent::GetFT(int partNo, double Z){
  // Get the mcfast clock time for
  // a particle at Z location

  double time=-1; //default
 
  TMCFastTracePoint *tracepoint = GetTracePointZ(partNo, Z);
  double zloc = tracepoint->GetZ();  
  if(zloc>= Z) 
    time =  tracepoint->GetTime();
  
  return time;
}


double TMCFastTraceEvent::GetCT(int partNo, double R){
  // Get the mcfast clock time for
  // a particle at radius R

  double time=-1; //default

  TMCFastTracePoint *tracepoint = GetTracePointR(partNo, R);
  double rloc = tracepoint->GetR();
  if(rloc>= R){ 
    time =  tracepoint->GetTime();
  }
  
  return time;
}





TMCFastTracePoint* TMCFastTraceEvent::GetTracePoint(int partNo, int direction, double Position){
  // Get the particle trace point closest to the  location requested
  // Direction=0 refers to forward/z tracing (i.e. uses  tracepoint->GetZ())
  // whereas direction =1 refers to central/radial tracing (i.e. uses  tracepoint->GetR())
  
  if(direction != 0 && direction != 1){
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
    
  /*
  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint=0;
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];

  for(int i = tracepart->GetFirst(); i<=tracepart->GetLast();i++){
   tracepoint =  (TMCFastTracePoint *)(*tpoints)[i];
   double loc = tracepoint->GetR();
   if(loc>= R)
     i = tracepart->GetLast()+1; //get out of loop   
  }
  */
  return  GetTracePoint(partNo, 1,R);
}



TMCFastTracePoint* TMCFastTraceEvent::GetTracePointZ(int partNo, double Z){
  // Get the particle trace point closest to the Z location requested
  //  
 
  /*   
  TClonesArray *tpoints =this->GetTracePoints();
  TClonesArray *tparts =this->GetTraceParticles();
  TMCFastTracePoint *tracepoint=0;
  TMCFastTraceParticle *tracepart;
  tracepart =  (TMCFastTraceParticle *)(*tparts)[partNo];

  for(int i = tracepart->GetFirst(); i<=tracepart->GetLast();i++){
   tracepoint =  (TMCFastTracePoint *)(*tpoints)[i];
   double loc = tracepoint->GetZ();
   if(loc>= Z)
     i = tracepart->GetLast()+1; //get out of loop   
  }

  return  tracepoint;
  */
  return GetTracePoint(partNo, 0,Z);
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
