//*-- Author :    Paul Eugenio 2-Nov-98

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastOfflineTrack   MCFast Offline Track (Smeared ) Class          //
//                                                                      //
// This is port of MCFast Trace Common Block to ROOT                    //
//
// More information see Tracking in MCFast doc at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//                                                                      
//////////////////////////////////////////////////////////////////////////

#include "TMCFastOfflineTrack.h"

ClassImp(TMCFastOfflineTrack)


//____________________________________________________________________________
Double_t TMCFastOfflineTrack::GetHepEvtP(Int_t hep){
  // Return the smeared momentum of the particle with
  // the HepEvt index "hep"

  Double_t p=-1000.0; // -1 TeV should indicate a problem...
  
  for(Int_t i=0; i< GetNtracks();i++){
    if(GetHep(i) == hep)
      p = GetP(i);

   
  }
  if( p==-1000.0 ){
    cerr<<"ERROR! TMCFastOfflineTrack::GetHepEvtP(Int_t hep)\n";
    cerr<<"is returning -1 TeV which means that the offline track\n";
    cerr<<"for HepEvt["<<hep<<"] particle is missing!\n";
    cerr<<"\n\n Aborting\n\n";
    exit(-1);
  }
  return p;
}


//____________________________________________________________________________
TMCFastOfflineTrack::TMCFastOfflineTrack(struct ntrkoff_t *trk_off){
  // Call Fill()
  //
  Fill(trk_off);
}

//____________________________________________________________________________
void TMCFastOfflineTrack::Fill(struct ntrkoff_t *trk_off){
  // Fill the TMCFastOfflineTrack object 
  // using mcfast common block information
  //
  SetNtracks(trk_off->ntracks);
  
  for(Int_t i=0;i< this->GetNtracks();i++){
    SetPx(i,trk_off->trk_off[i].w.px);
    SetPy(i,trk_off->trk_off[i].w.py);
    SetPz(i,trk_off->trk_off[i].w.pz);
    SetE(i,trk_off->trk_off[i].w.E) ;
    SetX(i,trk_off->trk_off[i].w.x) ;
    SetY(i,trk_off->trk_off[i].w.y) ;
    SetZ(i,trk_off->trk_off[i].w.z) ;
    SetPt(i,trk_off->trk_off[i].w.pt);
    SetP(i,trk_off->trk_off[i].w.p) ;
    SetQ(i,trk_off->trk_off[i].w.q) ;
    SetMass(i,trk_off->trk_off[i].mass) ;    
    for(Int_t j=0;j<7;j++)
      for(Int_t k=0;k<7;k++)
	SetCov(i,j,k,trk_off->trk_off[i].cov[j][k]) ;  
    SetChisq(i,trk_off->trk_off[i].chisq) ;        
    SetNhits(i,trk_off->trk_off[i].nhit) ; 
    SetNhitsSilicon(i,trk_off->trk_off[i].nhit_sil) ; 
    SetNhitsStereo(i,trk_off->trk_off[i].nhit_stereo) ;
    SetIcov(i, trk_off->trk_off[i].icov)  ; 
    SetHep(i, trk_off->trk_off[i].hep)  ; 
  }
  
}


//____________________________________________________________________________
TMCFastOfflineTrack::~TMCFastOfflineTrack()
{
  //Clear()
  //
   Clear();
}

//____________________________________________________________________________
void TMCFastOfflineTrack::Print(ostream *os){
  // Prints  TMCFastOfflineTrack object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << trkoff;
  // 
  // where trkoff is an instance of TMCFastOfflineTrack



  *os<<" Ntracks: "<< GetNtracks()<<endl;
 
  for(Int_t j=0;j< GetNtracks();j++){
    *os<<"Track["<<j<<"]"<<endl;
    // line 
    *os<<"\t P(x,y,z,t): ("<< 
      GetPx(j)<<","<<
      GetPy(j)<<","<<
      GetPz(j)<<","<<
      GetE(j) <<","<< ")"<<endl;
    // line
    *os<<"\t (x,y,z): ("<< 
      GetX(j)<<","<<
      GetY(j)<<","<<
      GetZ(j)<<","<< ")"<< endl;
    // line 
    *os<<"\t Pt "<<GetPt(j)<<" p "<<GetP(j)<<" q "<< 
      GetQ(j)<< " mass "<<GetMass(j)<<endl;
    // line 
    *os<<"\t cov[7][7] not shown..";
    /**************
    for(Int_t k=0;k<7;k++){
      *os<<"\n\t\t";
      for(Int_t l=0;l<7;l++)
      *os<< GetCov(j,k,l)<<" ";
      }
    ***********/
    *os<<endl;
    // line 
    *os<<"\t Chisq: "<<GetChisq(j)<<" icov: "<<GetIcov(j)
      <<" hepIndex: "<<GetHep(j)<<endl;
    // line
    *os<<"\t Nhits: "<<GetNhits(j)
      <<" NhitsSilicon: "<<GetNhitsSilicon(j)
	<<" NhitsStereo: "<<GetNhitsStereo(j)<<endl;


  }
}


ostream &operator<<(ostream &os, TMCFastOfflineTrack &offtrack){
  // overload the standard print operator
  offtrack.Print(&os);
  return os;
}
