//*-- Author :    Paul Eugenio 2-Nov-98
//*-- CMZ : PME 7-Jan-99

////////////////////////////////////////////////////////////////////////
// TMCFastTOF
//
// Time-of-flight information obtained 
// from the mcfast track tracing
//
// This class is an object oriented version 
// of mcfast trace common block.
//
// More information see Tracking in MCFast doc at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////



#include "TMCFastTOF.h"



ClassImp(TMCFastTOF)


//____________________________________________________________________________
TMCFastTOF::TMCFastTOF(struct ntraces_t *trace){
  // Call FIll()
  //
  Fill(trace);
}

//____________________________________________________________________________
void  TMCFastTOF::Fill(struct ntraces_t *trace){
  // Fill the object info using 
  //common block information
  //
  SetNtraces(trace->ntraces);
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
Double_t TMCFastTOF::GetCTOF(Int_t hep){
  // Get time-of-flight for the central region
  //
  // The routine first finds the central trace
  // for the hep particle and then calculates
  // the tof of that trace.
  //
  // See GetType() for information about trace types
  //
  //  tof = gamma * (GetTau(i) - GetTau(0))
  // tof = (GetTau(i) - GetTau(0))*GetTime(i)/GetTau(i);
  //
  // The use of tau is need do to a bug in mcfast that forgets
  // to fill t0 but does fill tau0.
  //
  // WARNING!! TOF is buggy for mcfast version 4.1 DO NOT USE!


  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==CENTRAL){ 
      tof =  (GetTau(i) - GetTau(0))*GetTime(i)/GetTau(i);

      //cout<<  GetTime(i) <<" - "<< GetTime(0)<< " = "<<tof<<endl;
    }
  }
  return tof;
}

//____________________________________________________________________________
Double_t TMCFastTOF::Beta(Int_t hep){
  // Calculate beta for central
  // region particles.
  // beta = GetPath(hep) /( GetCTOF(hep)*kSpeedOfLight)
  //
  Double_t tof=GetCTOF(hep);
  Double_t path=GetPath(hep);
  Double_t beta= path/tof*(1/kSpeedOfLight);

  return beta;
}

//____________________________________________________________________________
Double_t TMCFastTOF::CTOFmass(Int_t hep){
  // Calculate time-of-flight mass
  // Currently there is no smearing!!!!! (but soon should be implemented)
  //
  //  m = p/(beta*gamma)
  //  mass = GetP(i)*TMath::Sqrt(1/beta*beta - 1.0);
  //

  Double_t mass=-1; // default for no info
 
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
   
    if(GetHep(i)==hep && GetType(i)==CENTRAL){
       Double_t gamma = GetTime(i)/GetTau(i);
      /****** This beta is broken --bad time information
	Double_t tof = (GetTau(i) - GetTau(0))/gamma;
	Double_t beta1 = (GetPath(i)/tof)*(1/kSpeedOfLight);
	cerr<<"\n beta1: "<<beta;
	*******************/
      Double_t beta = TMath::Sqrt(1.0 - 1/(gamma*gamma));
      mass =  GetP(i)/(beta*gamma);
      
      /****************** OLD CODE
	Double_t beta= GetPath(i)/(GetTime(i) - GetTime(0))*(1/kSpeedOfLight); 
	mass = GetP(i)*TMath::Sqrt(1.0/(beta*beta) - 1.0);
	******************/
    }
  }
  return  mass;
}
//____________________________________________________________________________
Double_t TMCFastTOF::CTOFmass(Int_t hep, TMCFastOfflineTrack &offtrk){
  // Calculate time-of-flight mass
  // Currently there is no time smearing!!!!! 
  // (but soon it should be implemented)
  //
  //  m = p/(beta*gamma)
  //  mass = GetP(i)*TMath::Sqrt(1/beta*beta - 1.0);
  //


  
  Double_t mass=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)== CENTRAL){
      Double_t gamma = GetTime(i)/GetTau(i);
      /****** This beta is broken --bad time information
	Double_t tof = (GetTau(i) - GetTau(0))/gamma;
	Double_t beta1 = (GetPath(i)/tof)*(1/kSpeedOfLight);
	cerr<<"\n beta1: "<<beta;
	*******************/
      Double_t beta = TMath::Sqrt(1.0 - 1/(gamma*gamma));
      mass =  offtrk.GetHepEvtP(hep)/(beta*gamma);
      
      /****************** OLD CODE
	Double_t beta= GetPath(i)/(GetTime(i) - GetTime(0))*(1/kSpeedOfLight); 
	mass = GetP(i)*TMath::Sqrt(1.0/(beta*beta) - 1.0);
	******************/
    }
  }
  return mass;
}

//____________________________________________________________________________
Double_t TMCFastTOF::GetFTOF(Int_t hep){
  // Get time-of-flight for the forward region
  //
  // The routine first finds the forward trace
  // for the hep particle and then calculates
  // the tof of that trace.
  //
  // See GetType() for information about trace types
  //
  //  tof = gamma * (GetTau(i) - GetTau(0))
  // tof = (GetTau(i) - GetTau(0))*GetTau(i)/GetTime(i);
  //
  // The use of tau is need do to a bug in mcfast that forgets
  // to fill t0 but does fill tau0. 
  // WARNING!! TOF is buggy for mcfast version 4.1 DO NOT USE!

  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD){
      Double_t gamma = GetTime(i)/GetTau(i);
      tof =  (GetTau(i) - GetTau(0))/gamma;
    }
    
    
  }
   return tof;
}
//____________________________________________________________________________
Double_t TMCFastTOF::FTOFmass(Int_t hep, TMCFastOfflineTrack &offtrk){
  // Calculate time-of-flight mass
  // Currently there is no smearing of time!!! (but soon should be implemented)
  //  m = p/(beta*gamma)
  //  mass = GetP(i)*TMath::Sqrt(1/beta*beta - 1.0);
  //

  Double_t mass=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD){
      // del_t = del_tau * gamma
      Double_t gamma = GetTime(i)/GetTau(i);

      /****** This beta is broken --bad time information
      Double_t tof = (GetTau(i) - GetTau(0))/gamma;
      Double_t beta1 = (GetPath(i)/tof)*(1/kSpeedOfLight);
      *******************/

      Double_t beta = TMath::Sqrt(1.0 - 1/(gamma*gamma));
      //cerr<<"\n beta1: "<<beta1<<" beta: "<<beta<<endl;
      mass =  offtrk.GetHepEvtP(hep)/(beta*gamma);
     
    }
  }
  return mass;
}

//____________________________________________________________________________
Double_t TMCFastTOF::FTOFmass(Int_t hep){
  // Calculate time-of-flight mass
  // Currently there is no smearing of time!!! (but soon should be implemented)
  //  m = p/(beta*gamma)
  //  mass = GetP(i)*TMath::Sqrt(1/beta*beta - 1.0);
  //

  Double_t mass=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD){
      // del_t = del_tau * gamma
      Double_t gamma = GetTime(i)/GetTau(i);
      /****** This beta is broken --bad time information
      Double_t tof = (GetTau(i) - GetTau(0))/gamma;
      Double_t beta1 = (GetPath(i)/tof)*(1/kSpeedOfLight);
       cerr<<"\n beta1: "<<beta;
       *******************/
      Double_t beta = TMath::Sqrt(1.0 - 1/(gamma*gamma));
      mass =  GetP(i)/(beta*gamma);
     
    }
  }
  return mass;
}


//____________________________________________________________________________
Double_t TMCFastTOF::GetR(Int_t i){
  // return TMath::Sqrt(GetX(i)*GetX(i) + GetY(i)*GetY(i));
  //
  Double_t r;
 
  r= TMath::Sqrt(GetX(i)*GetX(i) + GetY(i)*GetY(i));
  return r;
  
}


//____________________________________________________________________________
TMCFastTOF::~TMCFastTOF()
{
  // Clear()
  //
   Clear();
}

//____________________________________________________________________________
void TMCFastTOF::Print(ostream *os){
  // Prints TMCFastTOF object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << tof_trace;
  // 
  // where tof_trace is an instance of TMCFastTOF


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


ostream &operator<<(ostream &os, TMCFastTOF &tof){
  // overload the standard print operator
  tof.Print(&os);
  return os;
}
