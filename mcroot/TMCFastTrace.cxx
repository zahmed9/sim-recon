//*-- Author :    Paul Eugenio 2-Nov-98

////////////////////////////////////////////////////////////////////////
//
// This class maps the MCFast Trace FORTRAN common block. See MCFast Doc.
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastTrace.h"



ClassImp(TMCFastTrace)


//____________________________________________________________________________
TMCFastTrace::TMCFastTrace(struct trace_par_c *trace){

  Fill(trace);
}

//____________________________________________________________________________
void  TMCFastTrace::Fill(struct trace_par_c *trace){
 
  SetNtraces(trace->trace_num);
  for(Int_t i=0;i< this->GetNtraces();i++){
    SetHep(i, trace->trace_par[i].hep)  ;
    SetType(i,trace->trace_par[i].type) ;
    SetPlane(i,trace->trace_par[i].plane);
    SetHits(i,trace->trace_par[i].hit) ;
    SetPx(i,trace->trace_par[i].w.px);
    SetPy(i,trace->trace_par[i].w.py);
    SetPz(i,trace->trace_par[i].w.pz);
    SetE(i,trace->trace_par[i].w.E) ;
    SetX(i,trace->trace_par[i].w.x) ;
    SetY(i,trace->trace_par[i].w.y) ;
    SetZ(i,trace->trace_par[i].w.z) ;
    SetPt(i,trace->trace_par[i].w.pt);
    SetP(i,trace->trace_par[i].w.p) ;
    SetQ(i,trace->trace_par[i].w.q) ;
    for(Int_t j=0;j<3;j++)
      SetEta(i,j,trace->trace_par[i].eta[j]);
    SetPath(i,trace->trace_par[i].path); 
    SetTime(i,trace->trace_par[i].time); 
    SetTau(i,trace->trace_par[i].tau) ; 
    SetMaterial(i,trace->trace_par[i].material); 
    SetRadl(i,trace->trace_par[i].radl);  
    SetDedx(i,trace->trace_par[i].dedx) ; 
  } 
}

//____________________________________________________________________________
Double_t TMCFastTrace::GetCTOF(Int_t hep){
  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==CENTRAL&&GetPlane(i)==CTOF_PLANE)
      tof = GetTime(i) - GetTime(0);
  }
  return tof;
}

//____________________________________________________________________________
Double_t TMCFastTrace::GetFTOF(Int_t hep){
  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD
       && (Int_t)GetR(i)==(Int_t)FTOF_Z )
      tof = GetTime(i) - GetTime(0);
  }
   return tof;
}

//____________________________________________________________________________
Double_t TMCFastTrace::GetR(Int_t i){
  Double_t r;
 
  r= TMath::Sqrt(GetX(i)*GetX(i) + GetY(i)*GetY(i));
  return r;
  
}


//____________________________________________________________________________
TMCFastTrace::~TMCFastTrace()
{
   Clear();
}

//____________________________________________________________________________
void TMCFastTrace::Print(ostream *os){
 // Now Print object

  *os<<" TraceNum: "<< GetNtraces()<<endl;
 
  for(Int_t j=0;j< GetNtraces();j++){
    *os<<"Trace["<<j<<"]"<<endl;
    // line 
    *os<<"\t HepIndex: "<< this->GetHep(j)<<" Type: "<< this->GetType(j);
    *os<<" Plane: "<< GetPlane(j)<<" Nhits: "<< GetHits(j)<<endl;
    // line 
    *os<<"\t\t P(x,y,z,t): ("<< 
      GetPx(j)<<","<<
      GetPy(j)<<","<<
      GetPz(j)<<","<<
      GetE(j) <<","<< ")"<<endl;
    // line
    *os<<"\t\t (x,y,z): ("<< 
      GetX(j)<<","<<
      GetY(j)<<","<<
      GetZ(j)<<","<< ")";
    *os<<" Pt "<<GetPt(j)<<" p "<<GetP(j)<<" q "<< GetQ(j)<< endl;
    // line 
    for(Int_t k=0;k<3;k++)
      *os<<"\t\t eta["<<k<<"]: "<< GetEta(j,k);
    *os<<endl;
    // line 
    *os<<"\t\t Path: "<<GetPath(j)<<" Time: "<<GetTime(j)
      <<" Tau: "<<GetTau(j)<<endl;
    // line 
    *os<<"\t\tMaterial: "<<GetMaterial(j)<<" Radl: "<<GetRadl(j)
      <<" Dedx: "<<GetDedx(j)<< endl;

  }
}

// overload the standard print operator
ostream &operator<<(ostream &os, TMCFastTrace &trace){
  trace.Print(&os);
  return os;
}
