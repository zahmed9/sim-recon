//*-- Author :    Paul Eugenio 16-Mar-1999
//*-- CMZ : PME 16-Mar-1999

////////////////////////////////////////////////////////////////////////
// TMCFastTrace
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
#include "TMCFastTrace.h"

ClassImp(TMCFastTrace)

//____________________________________________________________________________
TMCFastTrace::TMCFastTrace(){
  // initialize all values to zero
  //
  SetHepIndex(0);
  SetType(0);
  SetPlane(0);
  SetHitIndex(0) ;
  SetPx(0);
  SetPy(0);
  SetPz(0);
  SetE(0) ;
  SetX(0) ;
  SetY(0) ;
  SetZ(0) ;
  SetPt(0);
  SetP(0) ;
  SetQ(0) ;
  for(Int_t j=0;j<3;j++)
    SetEta(j,0);
  SetPath(0); 
  SetTime(0); 
  SetTau(0) ; 
  SetMaterial(0); 
  SetRadl(0);  
  SetDedx(0) ; 
  
}

void TMCFastTrace::operator=(TMCFastTrace &source){
  //Assignment operator 
  //   
  // 1: don't assign to self
  //2. chain to base class assignment operator
  //3: chain to data members
  
  //1: don't assign to self
  if(this == &source) 
    return;

  //2. chain to base class assignment operator
  TObject::operator=(source);

  //3: chain to data members
  fhepIndex = source.fhepIndex;
  ftype= source.ftype;
  fplane = source.fplane;
  fhitIndex = source.fhitIndex;
  fpx = source.fpx;
  fpy = source.fpy;
  fpz = source.fpz;
  fE = source.fE;
  fx = source.fx;
  fy = source.fy;
  fz = source.fz;
  fpt = source.fpt;
  fp = source.fp;
  fq = source.fq;
  for(Int_t i=0;i<3;i++)
    feta[i] = source.feta[i];
  fpath = source.fpath;
  ftime = source.ftime;
  ftau = source.ftau;
  fmaterial = source.fmaterial;
  fradl = source.fradl;
  fdedx = source.fdedx;

}
 TMCFastTrace::TMCFastTrace(TMCFastTrace &source){ 
   // copy constructor
   //
   //1. all data members which
   // are instances of classes have been
   // automatically default constructed
   //
   //2. chain to class assignment operator

   TMCFastTrace::operator=(source);

 }
//____________________________________________________________________________
TMCFastTrace::TMCFastTrace(struct trace_t *trace){
  // Call FIll()
  //
  Fill(trace);
}

//____________________________________________________________________________
void  TMCFastTrace::Fill(struct trace_t *trace){
  // Fill the object info using a struct trace_t
  // with is a map of the common block information
  //
  
  SetHepIndex(trace->hep);
  SetType(trace->type);
  SetPlane(trace->plane);
  SetHitIndex(trace->hit) ;
  SetPx(trace->w.px);
  SetPy(trace->w.py);
  SetPz(trace->w.pz);
  SetE(trace->w.E) ;
  SetX(trace->w.x) ;
  SetY(trace->w.y) ;
  SetZ(trace->w.z) ;
  SetPt(trace->w.pt);
  SetP(trace->w.p) ;
  SetQ(trace->w.q) ;
  for(Int_t j=0;j<3;j++)
    SetEta(j,trace->eta[j]);
  SetPath(trace->path); 
  SetTime(trace->time); 
  SetTau(trace->tau) ; 
  SetMaterial(trace->material); 
  SetRadl(trace->radl);  
  SetDedx(trace->dedx) ; 
  
  
}

//____________________________________________________________________________
TMCFastTrace::~TMCFastTrace()
{
  // Class destructor calls Clear()
  //
   Clear();
}
//_________________________________________________________
Double_t TMCFastTrace::GetR(){
  // return the trace point radius
  // in lab frame coordinates 
  // r= sqrt(x*x+y*y) where z is along
  // the solenoidal axis and y points to the sky... ;-)
  Double_t R;
  Double_t X,Y;
  X = GetX();
  Y = GetY();
  R = TMath::Sqrt(X*X + Y*Y);
  
  return R;
}
//_________________________________________________________
Double_t TMCFastTrace::GetBeta(){
  // Return the beta of the particle
  // that is associated with this trace point.
  // beta = p/E;
  return GetP()/GetE();
}

//_________________________________________________________
Double_t TMCFastTrace::TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax){
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
void TMCFastTrace::TraceTo(Double_t &Rmin, Double_t &Rmax, Double_t &Zmax,
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
Int_t TMCFastTrace::Npe(Double_t indexOfRefraction,Double_t PathLength){
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
Int_t TMCFastTrace::Npe(Double_t indexOfRefraction,
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
void TMCFastTrace::Print(ostream *os){
  // Prints TMCFastTrace object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << trace;
  // 
  // where trace is an instance of TMCFastTrace

  *os<<"\t HepIndex: "<< this->GetHepIndex()<<" Type: "<< this->GetType();
  *os<<" Plane: "<< GetPlane()<<" HitIndex: "<< GetHitIndex()<<endl;
  // line 
  *os<<"\t\t P(x,y,z,t): ("<< 
    GetPx()<<","<<
    GetPy()<<","<<
    GetPz()<<","<<
    GetE() <<","<< ")"<<endl;
  // line
  *os<<"\t\t (x,y,z): ("<< 
    GetX()<<","<<
    GetY()<<","<<
    GetZ()<<","<< ")";
  *os<<" Pt "<<GetPt()<<" p "<<GetP()<<" q "<< GetQ()<< endl;
  // line 
  *os<<"\t";
  for(Int_t k=0;k<3;k++)
    *os<<"\t eta["<<k<<"]: "<< GetEta(k);
  *os<<endl;
  // line 
  *os<<"\t\t Path: "<<GetPath()<<" Time: "<<GetTime()
     <<" Tau: "<<GetTau()<<endl;
  // line 
  *os<<"\t\tMaterial: "<<GetMaterial()<<" Radl: "<<GetRadiationLength()
     <<" Dedx: "<<GetDedx()<< endl;
  
}



ostream &operator<<(ostream &os, TMCFastTrace &trace){
  // overload the standard print operator
  trace.Print(&os);
  return os;
}
