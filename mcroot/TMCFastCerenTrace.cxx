//*-- Author :    Paul Eugenio 126-Apr-1999

////////////////////////////////////////////////////////////////////////
// TMCFastCerenTrace
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
#include <stdlib.h>
#include "TMCFastCerenTrace.h"

ClassImp(TMCFastCerenTrace)

TMCFastCerenTrace::TMCFastCerenTrace(struct trace_t *trace){
  // Call  FIll()
  //
 
  this->Fill(trace);
 
}
//____________________________________________________________________________
TMCFastCerenTrace::~TMCFastCerenTrace()
{
  // Class destructor calls Clear()
  //
   Clear();
}
//_________________________________________________________
Double_t TMCFastCerenTrace::TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax){
  // Extend the trace to Rmax or Zmax and return
  // the total path length traversed in the annulus
  // defined by Rmin, Rmax, tracepoint Z (which is at the cerenkov face),
  // and Zmax.  This routine assumes no magnetic field.
  
  Int_t len=0,debug=0;
  Double_t R = this->GetR();
  Double_t R_sq = R*R;
  Double_t Rmin_sq = Rmin*Rmin;
  Double_t Rmax_sq = Rmax*Rmax;
  Double_t X= this->GetX();  
  Double_t Y= this->GetY();
  Double_t Z= this->GetZ();  
  Double_t Beta= GetP()/GetE();
  Double_t Betax= GetPx()/GetE();
  Double_t Betay= GetPy()/GetE();
  Double_t Betaz= GetPz()/GetE();
  Double_t t = 1.0/Beta; // step one cm at a time
  if (debug) 
    cerr<<"Starting Trace at: X Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  if(!Betaz>0){
    cerr<<"Particle is moving forward! Exiting in TMCFastCerenTrace::TraceTo()!\n";
    exit(-1);
  }
  if(!( (X<Rmax_sq && Y<Rmax_sq) || Z>Zmax))
    cerr<<"Warning in TMCFastCerenTrace::TraceTo()!!"
	<<" Initial track position is out of bounds\n";

  while(R_sq<Rmax_sq && Z<Zmax){
    X +=  Betax*t; // X = Xo + vt 
    Y +=  Betay*t;
    Z +=  Betaz*t;
    R_sq = X*X + Y*Y;
    if(R_sq>Rmin_sq)
      len++;// add to length only if inside of annulus
    //if (debug) 
    //  cerr<<"\tX Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  }
  if (debug) 
    cerr<<"Ending Trace at: X Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  return (Double_t)(len * Beta*t); // path length in cm
}

//_________________________________________________________
void TMCFastCerenTrace::TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax,
			       Int_t nSegments,Double_t *Segment){
  // Extend the trace to Rmax or Zmax and return
  // the total path length traversed in each segment of the annulus
  // defined by Rmin, Rmax, tracepoint Z (which is at the cerenkov face),
  // and Zmax.  This routine assumes no magnetic field. The segmentation
  // starts on the x-axis increasing to positive "y".
  
  Int_t *len,debug=0;
  len = new int[nSegments];
  for(Int_t i =0;i<nSegments;i++)
    len[i]=0;
  Double_t R = this->GetR();
  Double_t R_sq = R*R;
  Double_t Rmin_sq = Rmin*Rmin;
  Double_t Rmax_sq = Rmax*Rmax;
  Double_t X= this->GetX();  
  Double_t Y= this->GetY();
  Double_t Z= this->GetZ();  
  Double_t Beta= GetP()/GetE();
  Double_t Betax= GetPx()/GetE();
  Double_t Betay= GetPy()/GetE();
  Double_t Betaz= GetPz()/GetE();
  Double_t t = 1.0/Beta; // step one cm at a time
  Double_t phi_per_seg=2.0*TMath::Pi()/((Double_t)nSegments);

  if (debug) 
    cerr<<"Starting Trace at: X Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  if(!Betaz>0){
    cerr<<"Particle is moving forward! Exiting in TMCFastCerenTrace::TraceTo()!\n";
    exit(-1);
  }
  if(!( (X<Rmax_sq && Y<Rmax_sq) || Z>Zmax))
    cerr<<"Warning in TMCFastCerenTrace::TraceTo()!!"
	<<" Initial track position is out of bounds\n";

  while(R_sq<Rmax_sq && Z<Zmax){
    X +=  Betax*t; // X = Xo + vt 
    Y +=  Betay*t;
    Z +=  Betaz*t;
    R_sq = X*X + Y*Y;
    Double_t phi=TMath::ATan2(Y,X);
    if( phi<0)
      phi = 2.0*TMath::Pi() + phi;
    if(R_sq>Rmin_sq){
      Int_t Seg = (Int_t) TMath::Floor(phi/phi_per_seg);
      len[Seg]++;// add to length only if inside of annulus
      //cerr<<"phi, phi_per_seg "<<phi<<","<<phi_per_seg<<endl;
      //cerr<<"Seg is "<<Seg<<" len[Seg] is "<<len[Seg]<<endl;
    }
    //if (debug) 
    //  cerr<<"\tX Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  }
  if (debug) 
    cerr<<"Ending Trace at: X Y Z R_sq: "<<X<<" "<<Y<<" "<<Z<<" "<<R_sq<<endl;
  //Int_t nSegments,Double_t *Segment
  for(Int_t i=0;i<nSegments;i++){
    Segment[i] = (Double_t)(len[i] * Beta*t); // path length in cm 
    
  }
  delete[] len;
  
}

//____________________________________________________________
Int_t TMCFastCerenTrace::Npe(Double_t indexOfRefraction,Double_t PathLength){
  // Given the index of refraction and the particle path length in
  // the cerenkov (one can get this from TraceTo()) calculate
  // the mean number of photoelectrons that should be detected in
  // the cerenkov. 
  // from Review of Particle Physics [ The European Physical Journal C,
  //  Vol 3,Num 1-4 Sec 25.3 page 155 1998.]
  //
  // Npe = No * Length* <Sin^2(Theta_c)> 
  //       where No = 90/cm which assumes eff_collection ~= 90% and
  //       eff_photo_cathode = 27%.  Theta_c is the Cerenkov cone
  //       half-angle where Cos(Theta_c) = 1/(indexOfRefraction*Beta).
  //
  // It returns "0" if the particle is below threshold (i.e. negative 
  // Theta_c).

  Double_t Beta = this->GetBeta();
  Int_t Npe =
    (Int_t)(90*PathLength*(1.0 - 1.0/(indexOfRefraction*indexOfRefraction*Beta*Beta)));
  if(Npe<0)
    return 0;
  else
    return Npe;
}

//____________________________________________________________
Int_t TMCFastCerenTrace::Npe(Double_t indexOfRefraction,
			Double_t &Rmin, Double_t &Rmax, Double_t &Zmax){
  // Given the index of refraction, Rmin, Rmax, and Zmax return
  // the mean number of photoelectrons that should be detected in
  // the cverenkov. 
  // from Review of Particle Physics [ The European Physical Journal C,
  //  Vol 3,Num 1-4 Sec 25.3 page 155 1998.]
  //
  // Npe = No * Length* <Sin^2(Theta_c)> 
  //       where No = 90/cm which assumes eff_collection ~= 90% and
  //       eff_photo_cathode = 27%.  Theta_c is the Cerenkov cone
  //       half-angle where Cos(Theta_c) = 1/(indexOfRefraction*Beta).
  //
  // It returns "0" if the particle is below threshold (i.e. negative 
  // Theta_c).

  
  Double_t L = this->TraceTo(Rmin, Rmax,Zmax);
  Double_t Beta = this->GetBeta();
  
  Int_t Npe =
    (Int_t)(90*L*(1.0 - 1.0/(indexOfRefraction*indexOfRefraction*Beta*Beta)));
  if(Npe<0)
    return 0;
  else
    return Npe;
}


//____________________________________________________________________________
void TMCFastCerenTrace::Print(ostream *os){
  // Prints TMCFastCerenTrace object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << trace;
  // 
  // where trace is an instance of TMCFastCerenTrace
  
  TMCFastTrace::Print(os);

  Double_t R1=20,R2=95,Z2=550;
  //Int_t nseg=40;
  //Double_t seg[40];
  *os<<"\t\tR: "<<GetR()<<" Beta: "<<GetBeta()
     <<"\n\t\ttrace length inside of (R1=20,R2=95,Z1="<<GetZ()<<",Z2=550): "
     <<TraceTo(R1,R2,Z2)<<" cm"<< endl
     <<"\t\tNumber of photo electrons:"<<Npe(1.0014,R1,R2,Z2)<<endl;
  //TraceTo(R1,R2,Z2,nseg,seg);
  //for(Int_t i=0;i<nseg;i++)
  //   *os<<"seglen[seg="<<i<<"] "<<seg[i]<<endl;
}

ostream &operator<<(ostream &os, TMCFastCerenTrace &trace){
  // overload the standard print operator
  trace.Print(&os);
  return os;
}
