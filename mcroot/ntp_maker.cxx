//*-- Author :    Paul Eugenio  22-Feb-1999
//Modified:         Paul Eugenio  13-May-2004  FSU
////////////////////////////////////////////////////////////////////////
//
//             Make an Ntuple from a Hall D rdt file
//             ========================================
//
//
//  
////////////////////////////////////////////////////////////////////////

#include <stdlib.h>
#include <iostream>
#include <string.h>

#include "TROOT.h"
#include "TFile.h"
#include "TRandom.h"
#include "TTree.h"
#include "TBranch.h"
#include "TClonesArray.h"
#include "TStopwatch.h"
#include "TSystem.h"
#include "TNtuple.h"
#include "TLorentzVector.h"

#include "TMCFastHepEvt.h"
#include "TMCFastTraceEvent.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h"
#include "TLGDsmears.h"
#include "TMCesr.h"
#include "TNtupleUtil.h"

using namespace std;

//______________________________________________________________________________

TROOT ntpmaker("ntpmaker","Ntuple Maker");
TFile *rdtfile;

void PrintUsage(char *processName)
{
  cerr << processName << " usage: [switches] inputfile > ntuple-labels.txt" <<endl;
  cerr << "\t-o<name>    Save output as <name>.root (default: halld.root).\n";
  cerr << "\t-c          Book four-momenta components.\n";
  cerr << "\t-e          Make esr from TMCFastHepEvt only\n";
  cerr << "\t-n<nevents> The number of event to read (default all).\n";
  cerr << "\t-s<nevents> The number of events to skip before reading(default=0).\n";
  cerr<< "\t-B<energy>  Add kludged beam (default is 8 GeV)\n";
  cerr << "\t-b<bcal_zres> Add z position smearing to the BCAL(default none).\n";
  cerr<<"\t-D Print DEBUG information\n";
  cerr<<"\t-h Print this help message\n\n";
  cerr<<"\tNote: The Ntuple label definitions are sent to the stdout for \n\t"
      <<"redirecting into a label.txt file.\n\n\n";
}



int main(int argc, char **argv)
{
  
  Char_t *argptr,rootfile[50],outputfile[50],ntpTitle[50];
  Int_t nevents=0;
  Int_t debug =0;
  Int_t skipEvents=0,Book_Four_Components=0,MakeHepEvtEsr=0;
  sprintf(rootfile,"Event.rdt");
  sprintf(outputfile,"halld.root");
  sprintf(ntpTitle,"Hall  Ntuple");
  Double_t bcal_zresolution=-1; // -1 = no z-position smearing
  Double_t beamE = 8.0;

  /*
   * Read the command line switches
   */

  if (argc == 1){
    PrintUsage(argv[0]);
    exit (0);
  }
  else {
    for (Int_t i=1; i<argc; i++) {
      argptr = argv[i];
      if ((*argptr == '-') && (strlen(argptr) > 1)) {
        argptr++;
        switch (*argptr) {
	case 'D':
	  debug =1;
	  break;
	case 'o':
	  sprintf(outputfile,"%s.root",++argptr);
	  cerr<<"Saveing output in file: "<<outputfile<<endl;
	  break;
	case 'e':
	  cerr<<"Making esr from hepevt objects only!\n";
	  MakeHepEvtEsr=1;
	  break;
	case 'c':
	  Book_Four_Components=1;
	  cerr<<"Booking four-momenta components\n";
	  break;
	case 'B':
	  beamE = atof(++argptr);
	  break;
	case 's':
	  skipEvents=atoi(++argptr);
	  cerr<<"Skipping "<<skipEvents<<" events\n";
	  break;
        case 'n':
	  nevents =atoi(++argptr);
	  cerr<<"Dumping "<<nevents<<" events\n";
	  break;
	case 'b':
	  bcal_zresolution = atof(++argptr);
	  cerr<<"Smearing BCAL z by "<< bcal_zresolution<<" cm\n";
	  break;
	case 'h':
	  PrintUsage(argv[0]);    
          exit(1);
	break;
	default:
          cerr<<"Unrecognized argument -"<< argptr<< "\n\n";
          PrintUsage(argv[0]);    
          exit(-1);
          break;
        }
      }
      else{
	strcpy(rootfile ,argptr);
	cerr<< "Opening "<< rootfile << " for input\n";
      }
    }
  }

  /*
   *  Open the output file.
   */
  Int_t comp   = 1; // compress levels from 0 to 9 (none to most)
  TFile *ntpfile=0;
  ntpfile = new TFile(outputfile,"RECREATE","A Hall D Ntuple");
  ntpfile->SetCompressionLevel(comp);
  


  
  // open input file and set tree branches
  cerr.flush();
  
  rdtfile = new TFile(rootfile);
  TBranch *b[10];
  Int_t nbranches=0;
  TTree *tree ;
  tree = (TTree*)rdtfile->Get("T");// This is the tree that HDFast created
  // HDFast objects
  //
  // These are the objects (leaves) contained in the tree
  //

  TMCFastHepEvt *hepevt = new TMCFastHepEvt();
  TMCFastTraceEvent *traces = new TMCFastTraceEvent();
  TMCFastOfflineTrack *offtrk = new TMCFastOfflineTrack();
  TMCFastCalorimeter *bcal = new TMCFastCalorimeter();
  TLGDsmears *lgdSmears = new TLGDsmears();
  // set branch addresses
  cerr<<"setting Branches\n";
 
  
  // List and link the Branches
  cout<< "Branch list:\n";
  TIter next(tree->GetListOfBranches());
  TBranch *branch;
  while((branch= (TBranch *)next())){
    cout<< "\t"<<branch->GetName()<<endl;
    b[nbranches] = tree->GetBranch(branch->GetName());// link all branches
    const Text_t * bname=branch->GetName();

   if(strcmp(bname,"hepevt")==0)
     b[nbranches]->SetAddress(&hepevt);
   if(strcmp(bname,"traces")==0)
     b[nbranches]->SetAddress(&traces);
   if(strcmp(bname,"offtrk")==0)
     b[nbranches]->SetAddress(&offtrk);
      if(strcmp(bname,"bcal")==0)
     b[nbranches]->SetAddress(&bcal);
   if(strcmp(bname,"lgdSmears")==0)
     b[nbranches]->SetAddress(&lgdSmears);
   nbranches++;
  }
 
  //
  // define a TNtuple 
  //
  TNtuple *ntp=0;
  TntpNames *vnames= new TntpNames();
  Int_t n_vectors;
  Float_t values[200];
  Char_t label[50];

  Int_t nentries = (Int_t)tree->GetEntries();
  cout<<"The Tree contains "<<nentries<<" events\n";
  Bool_t firstEvent=kTRUE;


  Int_t nparticlesFirstEvent=0; // for creating Ntuple labels
  Int_t nparticles = 0;

  if(nevents == 0) 
    nevents =nentries-skipEvents;
  else
    nevents +=skipEvents+1; 
  //  skipping the 1st because of missing TCloneArray problem
 
  //
  // Now loop over the events in the file
  //
  cerr<<"Looping over Events\n";
  int ecounter=0;
  for (Int_t ev = 1+skipEvents; ev < nevents; ev++) {
    if(ecounter++%100==0)
      cerr<<"Events Processed: "<<ecounter<<"\r";

    // get only needed branches from the data tree
    for(Int_t i=0;i<nbranches;i++)
      b[i]->GetEvent(ev); 
      
    
    //  
    // OK we now have an event
    //
    n_vectors=0;// same as number of labels

    //
    // Create an event summary record from the event branches
    TMCesr *esr=0;
    if(MakeHepEvtEsr)
      esr = new TMCesr(*hepevt);
    else
      esr = new TMCesr(*hepevt,*offtrk,*lgdSmears,*bcal,bcal_zresolution);
    
    // some indexology
    Int_t nparts=0,n,i,j,k,l;

    // define a particle list
    Int_t gamma[10],ngamma,piplus[10],npiplus,piminus[10],npiminus,
      Kplus[10],nKplus,Kminus[10],nKminus,proton[10],nproton;
    ngamma=0;
    npiplus=0;
    npiminus=0;
    nKplus=0;
    nKminus=0;
    nproton=0;

    // book event number
    values[n_vectors++] = hepevt->GetNevhep();
    // book esr summary
    values[n_vectors++] = esr->GetNLGDparticles();
    values[n_vectors++] = esr->GetNBCALparticles();
    values[n_vectors++] = esr->GetNOFFTRKparticles();
    if(firstEvent){
      cout<<"\n\n\nNTuple label definitions\n\n";
      nparticlesFirstEvent=esr->GetNparticles();
      sprintf(label,"eventNo");
      vnames->Add(label);
      cout<<"eventNo:\t\t Event Number\n";
      sprintf(label,"Nlgd");
      vnames->Add(label);
      cout<<"Nlgd:\t\t Number of LGD hits\n";
      sprintf(label,"Nbcal");
      vnames->Add(label);
      cout<<"Nbcal:\t\t Number of BCAL hits\n";
      sprintf(label,"Nchtrk");
      vnames->Add(label);
      cout<<"Nchtrk:\t\t Number of charged particle tracks\n";
    }
    //
    // Book the number of BCAL particle hits per cell 
    //
    // Remember that the bcal has only one cell
    // in the z (or eta) direction so it is more likely
    // that a calorimeter hit could result from two
    // or more particle hits; i.e. from multiple gammas or gammas & hadrons
    // in the same cell.
    TIter nextBCALhit(bcal->GetHits()); 
    Int_t ntracks=0,nhits=0;
    while(TMCFastCalorHits *bcalhit = (TMCFastCalorHits *)nextBCALhit()){
      // Get the number of tracks which contribute to this bcal hit.
      ntracks += bcalhit->GetNtracks(); 
      nhits++;
    }
    if(nhits==0)// don't divide by zero
      values[n_vectors++] = 0; 
    else
      values[n_vectors++] = ntracks/nhits; 
    if(firstEvent){
      sprintf(label,"bcal_tracks_per_hit");
      vnames->Add(label);
      cout<<"bcal_tracks_per_hit:\t\t  number of BCAL particle hits per cell \n";
    }

    //
    // Define some four-vectors
    TLorentzVector sum4v,X4v,P4vector[40],proton4v;
    Double_t px=0,py=0,pz=0,E=0;
    
    
    if((nparticles=esr->GetNparticles())){
      TIter nextesr(esr->GetParticles()); 
      while( TMCParticle *particle = ( TMCParticle *)nextesr()){
	Int_t hepIndex =  particle->GetHepIndex();
	TMCFastHepParticle hepParticle =  hepevt->GetHepParticle(hepIndex);

	// book particle maker
	values[n_vectors++] = particle->GetMaker();
	if(firstEvent){
	  sprintf(label,"DETid%d",nparts);
	  vnames->Add(label);
	  cout<<"DETid{int}:\t\t Particle maker's ID(i.e.: lgd gamma, bcal gamma, or charged track\n";
	}

	// book particle ID
	Int_t PDGid =  particle->GetIdHep();
	values[n_vectors++] = PDGid;
	if(firstEvent){
	  sprintf(label,"PDGid%d",nparts);
	  vnames->Add(label);
	  cout<<"PDGid{int}:\t\t PDG Geant ID for the {int}th particle\n";
	}
	// book vertex info for each particle
	values[n_vectors++] = particle->GetX();
	values[n_vectors++] = particle->GetY();
	values[n_vectors++] = particle->GetZ();
	if(firstEvent){
	  sprintf(label,"v%d_x",nparts);
	  vnames->Add(label);
	  cout<<"v{int}_x:\t\t production vertex component for each particle\n";
	  sprintf(label,"v%d_y",nparts);
	  vnames->Add(label);
	  cout<<"v{int}_y:\t\t production vertex component for each particle\n";
	  sprintf(label,"v%d_z",nparts);
	  vnames->Add(label);
	  cout<<"v{int}_z:\t\t production vertex component for each particle\n";
	}
	// get the four-momentum
	px= particle->GetPx();
	py= particle->GetPy();
	pz= particle->GetPz();
	E= particle->GetE();

	//
	// book smearing of the components
	values[n_vectors++] = (px - hepParticle.GetPx())/hepParticle.GetPx();
	values[n_vectors++] = (py - hepParticle.GetPy())/hepParticle.GetPy();
	values[n_vectors++] = (pz - hepParticle.GetPz())/hepParticle.GetPz();
	values[n_vectors++] = (E - hepParticle.GetE())/hepParticle.GetE();

	if(firstEvent){
	    sprintf(label,"SmearP%d_x",nparts);
	    vnames->Add(label);
	    cout<<"SmearP{int}_x:\t\t (px - hepParticle.GetPx())/hepParticle.GetPx() for each particle\n";
	    sprintf(label,"SmearP%d_y",nparts);
	    vnames->Add(label);
	    cout<<"SmearP{int}_x:\t\t (py - hepParticle.GetPy())/hepParticle.GetPy() for each particle\n";
	    sprintf(label,"SmearP%d_z",nparts);
	    vnames->Add(label);
	    cout<<"SmearP{int}_x:\t\t (pz - hepParticle.GetPz())/hepParticle.GetPz() for each particle\n";
	    sprintf(label,"SmearP%d_t",nparts);
	    vnames->Add(label);
	    cout<<"SmearP{int}_x:\t\t (E - hepParticle.GetE())/hepParticle.GetE() for each particle\n";
	  }

  
       	if(Book_Four_Components){

	  values[n_vectors++] = particle->GetP();
	  values[n_vectors++] = px;
//	  cout << "px: " << px << endl;
	  values[n_vectors++] = py;
//	  cout << "py: " << py << endl;
	  values[n_vectors++] = pz;
//	  cout << "pz: " << pz << endl;
	  values[n_vectors++] = E;
	  if(firstEvent){
	    sprintf(label,"p%d_p",nparts);
	    vnames->Add(label);
	    cout<<"p{int}_p:\t\t particle's momentum magnitude\n";
	    sprintf(label,"p%d_x",nparts);
	    vnames->Add(label);
	    cout<<"p{int}_x:\t\t particle's \"x\" momentum component\n";
	    sprintf(label,"p%d_y",nparts);
	    vnames->Add(label);
	    cout<<"p{int}_y:\t\t particle's \"y\" momentum component\n";
	    sprintf(label,"p%d_z",nparts);
	    vnames->Add(label);
	    cout<<"p{int}_z:\t\t particle's \"z\" momentum component\n";
	    sprintf(label,"p%d_E",nparts);
	    vnames->Add(label);
	    cout<<"p{int}_E:\t\t particle's energy\n";
	  }
	 }

	//
	// Fill the particle list
	//
	switch(PDGid){
	case 22 /*gamma*/:
	  gamma[ngamma++] = nparts;
	  break;
	case 211 /*piplus*/:
	  piplus[npiplus++] = nparts;
	  break;
	case -211 /*piminus*/:
	  piminus[npiminus++] = nparts;
	  break;
	case 321 /*Kplus*/:
	  Kplus[nKplus++] = nparts;
	  break;
	case -321 /*Kminus*/:
	  Kminus[nKminus++] = nparts;
	  break;
	case 2212 /*proton*/:
	case 2112 /*neutron*/:
	  proton[nproton++] = nparts;
	  break;
	case 11: // electron
	case -11: // positron
	  break;
	default:
	  cerr<<"Unknown particle id\n"
	      <<"\tEvent# "<<ev<<"\tPDGid "<<PDGid<<endl
	      <<"Exiting!\n";
	  exit(-1);
	}
	// set the particle four-vector
	if(PDGid != 2212 && PDGid != 2112 ){// It's not a proton or neutron
	  P4vector[nparts].SetXYZT(px,py,pz,E);
	  X4v += P4vector[nparts];
	  //nparts++;
	}else{
	  proton4v.SetXYZT(px,py,pz,E);
	  if(nproton>1){
	    cerr<<"There is more than one proton!\n"
		<<"Exiting!\n";
	    exit(-1);
	  }
	}
	nparts++;
      }
    ///////////////////////
      // t distribution
      //////////////////////
      TLorentzVector beam4v(0,0,beamE,beamE);
      TLorentzVector target4v(0,0,0,0.938);// proton target
      Double_t t = (beam4v - X4v).Mag2();
      if(firstEvent){
	sprintf(label,"t");
	vnames->Add(label);
	cout<<"t:\t\t four-momentum transfer(absolute value)\n";
      } 
      values[n_vectors++] = -t;

      //////////////////////
      // missing xmass
      /////////////////////
      if(nproton==1){
	Double_t mXm = (beam4v + target4v - proton4v).Mag2();

	if(firstEvent){
	  sprintf(label,"mXm");
	  vnames->Add(label);
	  cout<<"mXm:\t\t missing X mass^2 = (beam4v + target4v - proton4v).Mag2()\n";
	} 
	values[n_vectors++] = mXm;
  
      }


 
      /////////////////////////////////
      // Now book some effective masses
      /////////////////////////////////
      
      // X mass & total mass
      values[n_vectors++] = X4v.Mag();; 
      
      if(firstEvent){
	sprintf(label,"XMass");
	vnames->Add(label);
	cout<<"XMass:\t\t Meson System Mass = Total effective mass excluding protons and/or neutrons\n";
      } 
   
      if(nproton){
	if(firstEvent){
	  sprintf(label,"TotalMass");
	  vnames->Add(label);
	  cout<<"TotalMass:\t\t (X4v + recoil-baryon4v).Mag()\n"; 
	} 
	values[n_vectors++] = (X4v + proton4v).Mag(); 
      }
			      
      Int_t nn=0;
      Int_t mm=0;

      ////////////////////////////////
      //
      // Book masses with gammas
      //
      /////////////////////////////////
      if (ngamma > 1) {
	//
	// total gamma mass 
	sum4v.SetXYZT(0.0,0.0,0.0,0.0);
	for (i = 0; i < ngamma; ++i) 
	  sum4v += P4vector[gamma[i]];
	values[n_vectors++] = sum4v.Mag();
	if(firstEvent){
	  sprintf(label,"TotalGamma");
	  vnames->Add(label);
	  cout<<"TotalGamma:\t\t Mass(all gammas)\n";
	}
	//
	// total gamma + 1 pi+ mass
	for(k=0;k<npiplus;k++){
	  values[n_vectors++] = (sum4v + P4vector[piplus[k]]).Mag();
	  if(firstEvent){
	    sprintf(label,"totg1pip_%d",k);
	    vnames->Add(label);
	    cout<<"totg1pip_{int}:\t\t Mass(all gammas + 1 piplus) \n";
	  } 
	}
	//
	//  total gamma + pi- mass
	for(k=0;k<npiminus;k++){
	  values[n_vectors++] = (sum4v + P4vector[piminus[k]]).Mag();
	  if(firstEvent){
	    sprintf(label,"totg1pim_%d",k);
	    vnames->Add(label);
	    cout<<"totg1pim_{int}:\t\t Mass(all gammas + 1 piminus)\n ";
	  } 
	}
	// total gamma +  pi+ pi- mass
	for(k=0;k<npiminus;k++)
	  for(l=0;l<npiplus;l++){
	    values[n_vectors++] = (sum4v + 
				    P4vector[piminus[k]]
				    + P4vector[piplus[l]]).Mag();
	    if(firstEvent){
	      sprintf(label,"totg1pim1pip_%d",nn++);
	      vnames->Add(label);
	      cout<<"totg1pim1pip_{int}:\t\t Mass(all gammas + piplus piminus \n";
	    } 
	  }
	//
	// total_gamma 2pi+ pi- mass
	if(npiplus>1)
	  for(k=0;k<npiminus;k++)
	    for(l=0;l<npiplus-1;++l)
	      for(Int_t m = l+1;m<npiplus;++m){
		values[n_vectors++] = (sum4v + 
					P4vector[piminus[k]]
					+ P4vector[piplus[l]]
					+ P4vector[piplus[m]]).Mag();
		if(firstEvent){
		  sprintf(label,"totg1pim2pip_%d",mm++);
		  vnames->Add(label);
		  cout<<"totg1pim2pip_{int}:\t\t Mass(all gammas + 2 piplus piminus \n";
		} 
	      }
	
	
	
	//
	// 2gamma masses
	sum4v.SetXYZT(0.0,0.0,0.0,0.0);
	n=0;
	nn=0;
	mm=0;
	for (i = 0; i < ngamma - 1; ++i){
	  for (j = i + 1; j < ngamma; ++j){ 
	    sum4v = P4vector[gamma[i]] + P4vector[gamma[j]];
	    values[n_vectors++] = sum4v.Mag();
	    if(firstEvent){
	      sprintf(label,"2g_%d",n++);
	      vnames->Add(label);
	      cout<<"2g_{int}:\t\t Mass(2 gamma)  \n";
	    } 
	    //
	    // 2gamma pi+ mass
	    for(k=0;k<npiplus;k++){
	      values[n_vectors++] = (sum4v + P4vector[piplus[k]]).Mag();
	      if(firstEvent){
		sprintf(label,"2g1pip_%d",k);
		vnames->Add(label);
		cout<<"2g1pip_{int}:\t\t Mass(2 gamma + 1 piplus)  \n";
	      } 
	    }
	    // 2gamma pi- mass
	    for(k=0;k<npiminus;k++){
	      values[n_vectors++] = (sum4v + P4vector[piminus[k]]).Mag();
	      if(firstEvent){
		sprintf(label,"2g1pim_%d",k);
		vnames->Add(label);
		cout<<"2g1pim_{int}:\t\t Mass(2gamma + 1 piminus)  \n";
	      } 
	    }
	    // 2 gamma pi+ pi- mass
	    for(k=0;k<npiminus;k++)
	      for(l=0;l<npiplus;l++){
		values[n_vectors++] = (sum4v + 
					P4vector[piminus[k]]
					+ P4vector[piplus[l]]).Mag();
		if(firstEvent){
		  sprintf(label,"2g1pim1pip_%d",nn++);
		  vnames->Add(label);
		  cout<<"2g1pim1pip_{int}:\t\t Mass(2gamma + piplus piminus)\n";
		} 
	      }
	    // 2gamma 2pi+ pi-
	    if(npiplus>1)
	      for(k=0;k<npiminus;k++)
		for(l=0;l<npiplus-1;++l)
		  for(Int_t m = l+1;m<npiplus;++m){
		    values[n_vectors++] = (sum4v + 
					    P4vector[piminus[k]]
					    + P4vector[piplus[l]]
					    + P4vector[piplus[m]]).Mag();
		    if(firstEvent){
		      sprintf(label,"2g1pim2pip_%d",mm++);
		      vnames->Add(label);
		      cout<<"2g1pim2pip_{int}:\t\t Mass(2gamma + 2piplus piminus) \n";
		    } 
		  }
	    
	    
	  }
	} // end of 2 gamma masses
      }// end of we have gammas
      
      /////////////////////////////
      //
      // Charged pion masses
      //
      ////////////////////////////
      
      //
      // pi+ pi- mass
      nn=0;
      for(k=0;k<npiminus;k++)
	for(l=0;l<npiplus;l++){
	  values[n_vectors++] = (P4vector[piminus[k]]
				  + P4vector[piplus[l]]).Mag();
	  if(firstEvent){
	    sprintf(label,"1pim1pip_%d",nn++);
	    vnames->Add(label);
	    cout<<"1pim1pip_{int}:\t\t Mass(1 piplus + 1 piminus) \n";
	  } 
	}
      //
      //  2pi+ pi- mass
      mm=0;
	for(k=0;k<npiminus;k++)
	  for(l=0;l<npiplus-1;++l)
	    for(Int_t m = l+1;m<npiplus;++m){
	      values[n_vectors++] = (  P4vector[piminus[k]]
				      + P4vector[piplus[l]]
				      + P4vector[piplus[m]]).Mag();
	      if(firstEvent){
		sprintf(label,"1pim2pip_%d",mm++);
		vnames->Add(label);
		cout<<"1pim2pip_{int}:\t\t Mass(2 piplus + 1 piminus)  \n";
	      } 
	    }
	//
	//  pi+ 2pi- mass
	mm=0;
	for(k=0;k<npiplus;k++)
	  for(l=0;l<npiminus-1;++l)
	    for(Int_t m = l+1;m<npiminus;++m){
	      values[n_vectors++] = (P4vector[piplus[k]]
				      + P4vector[piminus[l]]
				      + P4vector[piminus[m]]).Mag();
	      if(firstEvent){
		sprintf(label,"2pim1pip_%d",mm++);
		vnames->Add(label);
		cout<<"2pim1pip_{int}:\t\t Mass(1 piplus + 2 piminus)  \n";
	      } 
	    }
	//
	// 2pi+ 2pi-
	mm=0;
	for(j=0;j<npiplus;j++)
	  for(k=j+1;k<npiplus-1;k++)
	    for(l=0;l<npiminus-1;++l)
	      for(Int_t m = l+1;m<npiminus;++m){
		values[n_vectors++] = ( P4vector[piplus[j]]
					+ P4vector[piplus[k]]
					+ P4vector[piminus[l]]
					+ P4vector[piminus[m]]).Mag();
		if(firstEvent){
		  sprintf(label,"2pim2pip_%d",mm++);
		  vnames->Add(label);
		  cout<<"2pim2pip_{int}:\t\t Mass(2 piplus + 2 piminus) \n";
		} 
	      }
	
      /////////////////////////////
      //
      // Charged kaon masses
      //
      ////////////////////////////

      //
      // K+ K- mass
      nn=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<nKplus;l++){
	  values[n_vectors++] = (P4vector[Kminus[k]]
				  + P4vector[Kplus[l]]).Mag();
	  if(firstEvent){
	    sprintf(label,"1Km1Kp_%d",nn++);
	    vnames->Add(label);
	    cout<<"1Km1Kp_{int}:\t\t Mass(1 Kminus + 1 Kplus)\n";
	  } 
	}
      //
      //  2K+ K- mass
      mm=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<nKplus-1;++l)
	  for(Int_t m = l+1;m<nKplus;++m){
	    values[n_vectors++] = (P4vector[Kminus[k]]
				    + P4vector[Kplus[l]]
				    + P4vector[Kplus[m]]).Mag();
	    if(firstEvent){
	      sprintf(label,"1Km2Kp_%d",mm++);
	      vnames->Add(label);
	      cout<<"1Km2Kp_{int}:\t\t Mass(1 Kminus + 2 Kplus)\n";
	    } 
	  }
      //
      //  K+ 2K- mass
      mm=0;
      for(k=0;k<nKplus;k++)
	for(l=0;l<nKminus-1;++l)
	  for(Int_t m = l+1;m<nKminus;++m){
	    values[n_vectors++] = ( P4vector[Kplus[k]]
				     + P4vector[Kminus[l]]
				     + P4vector[Kminus[m]]).Mag();
	    if(firstEvent){
	      sprintf(label,"2Km1Kp_%d",mm++);
	      vnames->Add(label);
	      cout<<"2Km1Kp_{int}:\t\t Mass(2 Kminus + 1 Kplus)\n";
	    } 
	  }
      //
      // 2K+ 2K-
      mm=0;
      for(j=0;j<nKplus;j++)
	for(k=j+1;k<nKplus-1;k++)
	  for(l=0;l<nKminus-1;++l)
	    for(Int_t m = l+1;m<nKminus;++m){
	      values[n_vectors++] = (P4vector[Kplus[j]]
				      + P4vector[Kplus[k]]
				      + P4vector[Kminus[l]]
				      + P4vector[Kminus[m]]).Mag();
	      if(firstEvent){
		sprintf(label,"2Km2Kp_%d",mm++);
		vnames->Add(label);
		cout<<"2Km2Kp_{int}:\t\t Mass(2 Kminus + 2 Kplus)\n";
	      } 
	    }
      
      ////////////////////////////////////////
      //
      // Mixed charged kaon and pion  masses
      //
      ///////////////////////////////////////
      
      //
      // K+ pi- mass
      nn=0;
      for(k=0;k<npiminus;k++)
	for(l=0;l<nKplus;l++){
	  values[n_vectors++] = (P4vector[piminus[k]]
				  + P4vector[Kplus[l]]).Mag();
	  if(firstEvent){
	    sprintf(label,"1pim1Kp_%d",nn++);
	    vnames->Add(label);
	    cout<<"1pim1Kp_{int}:\t\t Mass(1 Kplus + 1 piminus) \n";
	  } 
	}
      //
      // K- pi+ mass
      nn=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<npiplus;l++){
	  values[n_vectors++] = (P4vector[Kminus[k]]
				  + P4vector[piplus[l]]).Mag();
	  if(firstEvent){
	    sprintf(label,"1Km1pip_%d",nn++);
	    vnames->Add(label);
	    cout<<"1Km1pip_{int}:\t\t Mass(1 piplus + 1 Kminus) \n";
	  } 
	}
      //
      //  2pi+ K- mass
      mm=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<npiplus-1;++l)
	  for(Int_t m = l+1;m<npiplus;++m){
	    values[n_vectors++] = (P4vector[Kminus[k]]
				    + P4vector[piplus[l]]
				    + P4vector[piplus[m]]).Mag();
	    if(firstEvent){
	      sprintf(label,"1Km2pip_%d",mm++);
	      vnames->Add(label);
	      cout<<"1Km2pip_{int}:\t\t Mass(1 Kminus + 2 piplus)  \n";
	    } 
	  }
      //
      //  K+ 2pi- mass
      mm=0;
      for(k=0;k<nKplus;k++)
	for(l=0;l<npiminus-1;++l)
	  for(Int_t m = l+1;m<npiminus;++m){
	    values[n_vectors++] = (P4vector[Kplus[k]]
				    + P4vector[piminus[l]]
				    + P4vector[piminus[m]]).Mag();
	    if(firstEvent){
	      sprintf(label,"2pim1Kp_%d",mm++);
	      vnames->Add(label);
	      cout<<"2pim1Kp_{int}:\t\t Mass(1 Kplus + 2 piminus)  \n";
	    } 
	  }
      //
      // K+ K- pi+ pi-
      mm=0;
      for(j=0;j<nKplus;j++)
	for(k=0;k<npiplus;k++)
	  for(l=0;l<nKminus;++l)
	    for(Int_t m = 0;m<npiminus;++m){
	      values[n_vectors++] = (P4vector[Kplus[j]]
				      + P4vector[piplus[k]]
				      + P4vector[Kminus[l]]
				      + P4vector[piminus[m]]).Mag();
	      if(firstEvent){
		sprintf(label,"KmKppimpip_%d",mm++);
		vnames->Add(label);
		cout<<"KmKppimpip_{int}:\t\t Mass(Kplus Kminus piplus piminus) \n";
	      } 
	    }
      

      ///////////////////////////
      // 
      //  Physics Angles
      //
      ///////////////////////////

      
      TVector3 x,y,z;
      //Boost to CM frame
      TLorentzVector CM4v = beam4v + target4v ;
      TLorentzVector beam4v_temp = beam4v;
      TVector3 beta;
      
      beta = CM4v.BoostVector();
      CM4v.Boost(-beta);
      if(debug){
	cerr<<"Dumping CM after boost to CM\n";
	CM4v.Dump();
      }
      for(int i=0;i<nparts;i++)
	P4vector[i].Boost(-beta);
      beam4v.Boost(-beta);
      X4v.Boost(-beta);
      
      // now boost to X Rest frame
      beta = X4v.BoostVector();
      y = ((beam4v.Vect()).Cross(X4v.Vect())).Unit();
      X4v.Boost(-beta);// this should be at rest now
      if(debug){
	cerr<<"Dumping X after boost to X RF\n";
	X4v.Dump();
      }
      beam4v.Boost(-beta);
      for(int i=0;i<nparts;i++)
	P4vector[i].Boost(-beta);
      z = (beam4v.Vect()).Unit();
      x = y.Cross(z); // right handed system
      double costheta = z *  P4vector[0].Vect().Unit();
      
      
      values[n_vectors++] = costheta;
      if(firstEvent){
	sprintf(label,"cosGJ_%d",0);
	vnames->Add(label);
	cout<<"cosGJ_{int}:\t\t GJ Cos(theta) using particle {int} as the analyzer \n";
      } 
      
      double phiTY =  TMath::ATan2( y *  P4vector[0].Vect(),
				    x *  P4vector[0].Vect());
      values[n_vectors++] =  phiTY;
      if(firstEvent){
	sprintf(label,"phiGJ_%d",0);
	vnames->Add(label);
	cout<<"phiTY_{int}:\t\t GJ phi using particle {int} as the analyzer \n";
      } 
      
      
      
      
      
      
    }//////  end of we have particles //////////
    


    

    if(firstEvent){
      if(vnames->GetNlabels() != n_vectors){
	cerr<<"Error! vnames->GetNlabels()  !=  n_vectors\nExiting\n"
	    <<vnames->GetNlabels()<<"="<<n_vectors<<endl;
       
	exit(-1);
      }
      // Now create the ntuple
      Char_t *vectorNames = vnames->GetNames();
      cerr<<"Creating Ntuple\n\tTitle: "
          <<ntpTitle<<"\n\tVectorNames: "
	  <<vectorNames<<endl;
      ntpfile->cd();// create the ntuple in this file
      ntp = new TNtuple("ntp",ntpTitle,vectorNames);
      firstEvent=kFALSE;
	  
    }
    
    if(nparticlesFirstEvent == nparticles)
      ntp->Fill(values);
    else{ // Warning!!
      cerr<<"nparticlesFirstEvent != nparticles "
	  <<nparticlesFirstEvent<<"!="<< nparticles
	  <<" Event: "<<ev<<endl;
      
    }
    delete esr;
    hepevt->Clear();
    traces->Clear();
    offtrk->Clear();
    bcal->Clear();
    lgdSmears->Clear();
  }
  

  rdtfile->Close();
  ntpfile->Write();
  ntpfile->Close();
  cerr<<endl;
  return 0;
}

