//*-- Author :    Paul Eugenio 21-Jan-99

////////////////////////////////////////////////////////////////////////
// TMCesr
//
////////////////////////////////////////////////////////////////
//
//  TMCesr contains a TClonesArray of  TMCparticle
//
////////////////////////////////////////////////////////////////////////


#include "TMCesr.h"



ClassImp(TMCesr)


TClonesArray *TMCesr::fgParticles = 0;


//____________________________________________________________________________
TMCesr::TMCesr(){
  // Create the object 
  //  
  //
  if(!fgParticles) fgParticles = new TClonesArray("TMCParticle",10);
 
  fParticles = fgParticles;
  fnParticles=0;
}



//____________________________________________________________________________
TMCesr::TMCesr(TMCFastHepEvt &hepevt,TMCFastOfflineTrack &offtrk, 
       TLGDsmears &lgdsmears,TMCFastCalorimeter &bcal){
  Double_t res=-1;
  Fill(hepevt,offtrk,lgdsmears,bcal,res);
}
TMCesr::TMCesr(TMCFastHepEvt &hepevt,TMCFastOfflineTrack &offtrk, 
       TLGDsmears &lgdsmears,TMCFastCalorimeter &bcal,Double_t bcal_res){
  Fill(hepevt,offtrk,lgdsmears,bcal,bcal_res);
}
TMCesr::TMCesr(TMCFastHepEvt &hepevt){
  Fill(hepevt);
}
void TMCesr::Fill(TMCFastHepEvt &hepevt){
 fnParticles=0;
 if(!fgParticles) fgParticles = new TClonesArray("TMCParticle",10);
 fParticles = fgParticles;
 SetNparticles(makeParticles(hepevt));
 SetNLGDparticles(0);
 SetNBCALparticles(0);
 SetNOFFTRKparticles(0);
}

void TMCesr::Fill(TMCFastHepEvt &hepevt,TMCFastOfflineTrack &offtrk, 
       TLGDsmears &lgdsmears,TMCFastCalorimeter &bcal,
	       Double_t bcal_resolution){
  fnParticles=0;
  if(!fgParticles) fgParticles = new TClonesArray("TMCParticle",10);
  fParticles = fgParticles;
 
  SetNLGDparticles(makeParticles(hepevt,lgdsmears));

  SetNBCALparticles(makeParticles(hepevt,bcal,bcal_resolution));
 
  SetNOFFTRKparticles(makeParticles(hepevt,offtrk));
  SetNparticles(GetNLGDparticles()+GetNBCALparticles()+GetNOFFTRKparticles());
}


Int_t TMCesr::makeParticles(TMCFastHepEvt &hepevt,TMCFastCalorimeter &bcal,Double_t bcal_resolution){
  // Create a TMCparticle instance
  // from a TMCFastCalorimeter &bcal 
  // and add the instance to 
  // the  TClonesArray fParticles
  //
  TClonesArray &heparts = *fParticles;
  Int_t Ngammas=0,gammaHepIndex[20],n_made=0;
  Double_t e;
  
  for(Int_t i=0;i<hepevt.GetNhep();i++)
    if(hepevt.GetHepParticle(i+1).GetIdhep() == PDG_GAMMA)
      gammaHepIndex[Ngammas++]=i+1;
  
  for(Int_t i=0;i<Ngammas;i++){
    e=0;
    if(bcal.GetNhits()){
      TIter HitsIter(bcal.GetHits());
      while( TMCFastCalorHits *calhit = (TMCFastCalorHits *)HitsIter()){
	
	  TIter nextInfo(bcal.GetInfoTr());
	  while(TCalHitTracks* info = (TCalHitTracks *)nextInfo())
	    if(info->GetCalHitIndex() == calhit->GetHitIndex() &&
	      gammaHepIndex[i] == info->GetHepIndex() ){
	      e += info->GetEem() + info->GetEmip() + info->GetEhad() ;
	      // the gamma energy can be smeared by hadrons...
	      // Now we have a cal hit that belongs to
	      // the gamma -- there can be many hits to oner gamma.

	    }
	
      }
    }
    //
    // Scale the MCFast energies by a kludge factor.
    // Without kludge, piz mean is too small by 1/1.055
    // e *= 1.055;  THIS was need in the old MCFast calor code
    // The new calor code needs less of a correction
    // This value is based on the average correction needed to
    // get the correct pizero mass at B5:m1.4 and B12M2.0
    // for mcfast version 4_2  it it unknown for v4_4
    // e *= 1.03; 


    // e is now the total measured electroMagnetic energy for this gamma   
    if(e){
      TMCFastHepParticle heppart = hepevt.GetHepParticle(gammaHepIndex[i]);
       if(bcal_resolution>0)
	 new(heparts[fnParticles++]) TMCParticle(heppart,e,bcal_resolution);
       else
	 new(heparts[fnParticles++]) TMCParticle(heppart,e);
      n_made++;
    }
  }
  return n_made;
}

Int_t TMCesr::makeParticles(TMCFastHepEvt &hepevt,TLGDsmears &lgd){
  // Create  TMCparticle instances
  // from a TLGDsmears &lgdSmears
  // and add them  to 
  // the  TClonesArray fParticles
  //

  TClonesArray &parts = *fParticles;
  Int_t Ngammas=0,gammaIndex[20],n_made=0;
  
  // Get List of Gammas
  for(Int_t i=0;i<hepevt.GetNhep();i++)
    if(hepevt.GetHepParticle(i+1).GetIdhep() == PDG_GAMMA)
      gammaIndex[Ngammas++]=i+1;
  
  for(Int_t i=0;i<Ngammas;i++){
    if(lgd.GetNparts()){
      TIter ParticleIter(lgd.GetLgdParticles());
      while(TLGDparticle *lgdpart = (TLGDparticle *)ParticleIter()){
	if(gammaIndex[i] ==  lgdpart->GetHepIndex()){
	  new(parts[fnParticles++]) TMCParticle(*lgdpart);
	  n_made++;
	}
      }
    }
  }
  return n_made;
}

int TMCesr::makeParticles(TMCFastHepEvt &hepevt,TMCFastOfflineTrack &offtrk){
  // Create a TMCparticle instance
  // from a TMCFastOfflineTrack &offtrk
  // and add the instance to 
  // the  TClonesArray fParticles
  //

  TClonesArray &parts = *fParticles;
  Int_t n_made=0;

  for(Int_t j=0;j<offtrk.GetNtracks();j++){
    //Int_t idhep = hepevt.GetHepParticle(offtrk.GetHep(j)).GetIdhep();
    TMCFastHepParticle heppart = hepevt.GetHepParticle(offtrk.GetHep(j));
    new(parts[fnParticles++]) TMCParticle(heppart,offtrk,j);
    n_made++;
  }
  return n_made;
}

int TMCesr::makeParticles(TMCFastHepEvt &hepevt){
  // Create TMCparticle instances
  // from a TMCFastHepEvt &hepevt
  // and add the instances to 
  // the  TClonesArray fParticles
  //

  TClonesArray &parts = *fParticles;
  Int_t n_made=0;

  for(Int_t j=0;j<hepevt.GetNhep();j++){
    
    TMCFastHepParticle heppart = hepevt.GetHepParticle(j+1);
    new(parts[fnParticles++]) TMCParticle(heppart);
    n_made++;
  }
  return n_made;
}




//____________________________________________________________________________
void TMCesr::Clear()
{
  // Clear the TClonesArrays: this->GetLgdParticles()
  //
   this->GetParticles()->Clear();
}


//____________________________________________________________________________
TMCesr::~TMCesr()
{
   this->Clear();
}
//____________________________________________________________________________
int  gampID(int id);
void TMCesr::DumpGampFormat(ostream *os, Double_t kludge_beamE){
  // Print out the esr oject in gamp ascii format
  // which is used in PWA2000.  The format for each event is:
  // {# nparts} //nparticles where the beam is the first particle)
  // {gampID} {charge} {p.x} {p.y} {p.z} {p.t} // particle #0
  // ...
  // {gampID} {charge} {p.x} {p.y} {p.z} {p.t} // particle #(nparts-1)

  *os<<this->GetNparticles()+1<<endl; // add 1 for beam
  *os<<"1 0 0 0 "<<kludge_beamE<<" "<<kludge_beamE<<endl;
  if(this->GetNparticles()){
    TIter nextMC(this->GetParticles()); 
    while( TMCParticle *p = ( TMCParticle *)nextMC())
      *os<<gampID(p->GetIdHep())<<" "<< p->GetCharge()<<" "
	 <<p->GetPx()<<" "<<p->GetPy()<<" "<<p->GetPz()<<" "<<p->GetE()<<endl;

  }  
}


//____________________________________________________________________________
void TMCesr::Print(ostream *os){
  // Prints TMCesr object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << esr;
  // 
  // where esr is an instance of TMCesr

  *os<<"Number of MCparticles: "<< this->GetNparticles()<<endl;

  // Now Print the esr particles 

  if(this->GetNparticles()){
    TIter nextMC(this->GetParticles()); 
    while( TMCParticle *particle = ( TMCParticle *)nextMC())
      particle->Print(os);
    *os<<endl;
  }
}

ostream &operator<<(ostream &os, TMCesr &esr){
// overload the standard print operator
  esr.Print(&os);
  return os;
}

/********************
 * gampID(int pdgID)
 * The convention is that
 * followed in StdHep 4.02
 *******************/
#include"particleType.h"
int  gampID(int id){
  Particle_t p=Unknown;
  switch (id) {
  case 0:
    p=Unknown;
    break;
  case 22:
    p=Gamma;
    break;
  case -11:
    p=Positron;
    break;
  case 11:
    p=Electron;
    break;
  case 12:
    p=Neutrino;
    break;
  case -13:
    p=MuonPlus;
    break;
  case 13:
    p=MuonMinus;
    break;
  case 111:
    p=Pi0;
    break;
  case 211:
    p=PiPlus;
    break;
  case -211:
    p=PiMinus;
    break;
  case 130:
    p=KLong;
    break;
  case 321:
    p=KPlus;
    break;
  case -321:
    p=KMinus;
    break;
  case 2112:
    p=Neutron;
    break;
  case 2212:
    p=Proton;
    break;
  case -2212:
    p=AntiProton;
    break;
  case 310:
    p=KShort;
    break;
  case 221:
    p=Eta;
    break;
  case 3122:
    p=Lambda;
    break;
  case 3222:
    p=SigmaPlus;
    break;
  case 3212:
    p=Sigma0;
    break;
  case 3112:
    p=SigmaMinus;
    break;
  case 3322:
    p=Xi0;
  case 3312:
    p=XiMinus;
    break;
  case 3334:
    p=OmegaMinus;
    break;
  case -2112:
    p=AntiNeutron;
    break;
  case -3122:
    p=AntiLambda;
    break;
  case -3112:
    p=AntiSigmaMinus;
    break;
  case -3212:
    p=AntiSigma0;
    break;
  case -3222:
    p=AntiSigmaPlus;
    break;
  case -3322:
    p=AntiXi0;
    break;
  case -3312:
    p=AntiXiPlus;
    break;
  case -3334:
    p=AntiOmegaPlus;
    break;
  case 113:
    p=Rho0;
    break;  
  case 213:
    p=RhoPlus;
    break;
  case -213:
    p=RhoMinus;
    break;
  case 223:
    p=omega;
    break;
  case 331:
    p=EtaPrime;
    break;
  case 333:
    p=phiMeson;
    break;
  default:
    p=Unknown;
    break;
  }
  return((int)p);
}
