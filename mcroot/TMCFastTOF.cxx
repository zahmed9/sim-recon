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
TMCFastTOF::TMCFastTOF(struct traces_t *traces){
  // Call FIll()
  //
  Fill(traces);
}

//____________________________________________________________________________
void  TMCFastTOF::Fill(struct traces_t *traces){
  // Fill the object info using 
  //common block information
  //
  SetNtraces(traces->ntraces);
  for(Int_t i=0;i< this->GetNtraces();i++){
    SetHep(i, traces->trace[i].hep)  ;
    SetType(i,traces->trace[i].type) ;
    SetPlane(i,traces->trace[i].plane);
    SetHits(i,traces->trace[i].hit) ;
    SetPx(i,traces->trace[i].w.px);
    SetPy(i,traces->trace[i].w.py);
    SetPz(i,traces->trace[i].w.pz);
    SetE(i,traces->trace[i].w.E) ;
    SetX(i,traces->trace[i].w.x) ;
    SetY(i,traces->trace[i].w.y) ;
    SetZ(i,traces->trace[i].w.z) ;
    SetPt(i,traces->trace[i].w.pt);
    SetP(i,traces->trace[i].w.p) ;
    SetQ(i,traces->trace[i].w.q) ;
    for(Int_t j=0;j<3;j++)
      SetEta(i,j,traces->trace[i].eta[j]);
    SetPath(i,traces->trace[i].path); 
    SetTime(i,traces->trace[i].time); 
    SetTau(i,traces->trace[i].tau) ; 
    SetMaterial(i,traces->trace[i].material); 
    SetRadl(i,traces->trace[i].radl);  
    SetDedx(i,traces->trace[i].dedx) ; 
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
  //  
  // tof = (GetTime(i) - GetTime(0));
  //


  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==CENTRAL){ 
      //tof =  (GetTau(i) - GetTau(0))*GetTime(i)/GetTau(i);
      tof =  (GetTime(i) - GetTime(0));
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
Double_t TMCFastTOF::GetMass(Int_t hep){
  // Calculate the mass from the local four-vector
  // This is not the smeared mass.
  //  
  //  mass = TMath::Sqrt((GetE(i)*GetE(i)) - (GetP(i)*GetP(i)));
  // where GetHep(i)==hep

  Double_t mass=-1; // default for no info
 
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep){
      mass =   TMath::Sqrt((GetE(i)*GetE(i)) - (GetP(i)*GetP(i)));
      break;
    }
  }
  return  mass;
}


//____________________________________________________________________________
Double_t TMCFastTOF::CTOFmass(Int_t hep){
  // Calculate time-of-flight mass
  // Currently there is no smearing!!!!! (but soon should be implemented)
  //
  //  m = p/(beta*gamma)
  // 
  //  beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
  //  tof = (GetTime(i) - GetTime(0));
  //

  Double_t mass=-1; // default for no info
 
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
   
    if(GetHep(i)==hep && GetType(i)==CENTRAL){
      Double_t tof = (GetTime(i) - GetTime(0));
      Double_t beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
      Double_t gamma = 1/(TMath::Sqrt( 1 - beta*beta));
      
       if(gamma!=gamma) // look for NaN this means beta=1
	mass =0;
      else
	mass =  GetP(i)/(beta*gamma);
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
  //  
  // beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
  // tof = (GetTime(i) - GetTime(0));
  //
  
  Double_t mass=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)== CENTRAL){
      Double_t tof = (GetTime(i) - GetTime(0));
      Double_t beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
      Double_t gamma = 1/(TMath::Sqrt( 1 - beta*beta));
      
       if(gamma!=gamma) // look for NaN this means beta=1
	mass =0;
      else
	mass =  offtrk.GetHepEvtP(hep)/(beta*gamma);
      
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
  //  
  // tof = (GetTime(i) - GetTime(0));
  
  Double_t tof=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD){
      //Double_t gamma = GetTime(i)/GetTau(i);
      tof =  (GetTime(i) - GetTime(0));
    }
    
    // WARNING!! TOF is buggy for mcfast version 4.1 DO NOT USE!   
  }
   return tof;
}
//____________________________________________________________________________
Double_t TMCFastTOF::FTOFmass(Int_t hep, TMCFastOfflineTrack &offtrk){
  // Calculate time-of-flight mass
  // Currently there is no smearing of time!!! (but soon should be implemented)
  //  m = p/(beta*gamma)
  //  mass = offtrk.GetHepEvtP(i)*TMath::Sqrt(1/beta*beta - 1.0);
  //
  // beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
  // tof = (GetTime(i) - GetTime(0));
  //
  Double_t mass=-1; // default for no info
  Int_t ntraces=GetNtraces();
  for(Int_t i=0;i<ntraces;i++){
    if(GetHep(i)==hep && GetType(i)==FORWARD){
      // del_t = del_tau * gamma
      //mcfast v4.1:: Double_t gamma = GetTime(i)/GetTau(i);

      Double_t tof = (GetTime(i) - GetTime(0));
      Double_t beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
      Double_t gamma = 1/(TMath::Sqrt( 1 - beta*beta));

      // mcfast v4.1:: Double_t beta = TMath::Sqrt(1.0 - 1/(gamma*gamma));
      //cerr<<"\n beta: "<<beta<<" gamma: "<<gamma<<endl;
      if(gamma!=gamma) // look for NaN this means beta=1
	mass =0;
      else
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
      Double_t tof = (GetTime(i) - GetTime(0));
      Double_t beta = (GetPath(i)/tof)*(1/kSpeedOfLight);
      Double_t gamma = 1/(TMath::Sqrt( 1 - beta*beta));
      //cout<<"beta: "<<beta<<" gamma: "<<gamma<<endl;
      if(gamma != gamma){ // look for NaN this means beta=1
	mass =0.0;
	//cout<<" beta is one\n";
      }
      else
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
