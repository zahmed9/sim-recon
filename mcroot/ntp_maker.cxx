//*-- Author :    Paul Eugenio  22-Feb-199

////////////////////////////////////////////////////////////////////////
//
//             Make an Ntuple from a Hall D rdt file
//             ========================================
//
//
//  
////////////////////////////////////////////////////////////////////////

#include <stdlib.h>
#include <iostream.h>
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

#include "TMCFastHepEvt.h"
#include "TMCFastTOF.h"
#include "TMCFastOfflineTrack.h"
#include "TMCFastCalorimeter.h"
#include "TLGDsmears.h"
#include "TMCesr.h"
#include "TNtupleUtil.h"

#include "Vec.h"
#include "lorentz.h"


//______________________________________________________________________________

TROOT ntpmaker("ntpmaker","Ntuple Maker");
TFile *rdtfile;

void PrintUsage(char *processName)
{
  cerr << processName << " usage: [switches] inputfile" <<endl;
  cerr << "\t-o<name>    Save output as <name>.root (default: halld.root).\n";
  cerr << "\t-c          Book four-momenta components.\n";
  cerr << "\t-e          Make esr from TMCFastHepEvt only\n";
  cerr << "\t-n<nevents> The number of event to read (default all).\n";
  cerr << "\t-s<nevents> The number of events to skip before reading(default=0).\n";
  cerr<< "\t-B<energy>  Add kludged beam (default is 8 GeV)\n";
  cerr << "\t-b<bcal_zres> Add z position smearing to the BCAL(default none).\n";
  cerr<<"\t-h Print this help message\n\n";
}



int main(int argc, char **argv)
{
  
  Char_t *argptr,rootfile[50],outputfile[50],ntpTitle[50];
  Int_t nevents=0;
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
  TMCFastTOF *tof_trace = new TMCFastTOF();
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
   if(strcmp(bname,"tof_trace")==0)
     b[nbranches]->SetAddress(&tof_trace);
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

  Int_t nparticlesFirstEvent=0; // used to create Ntuple labels
  Int_t nparticles = 0;

  if(nevents == 0) 
    nevents =nentries-skipEvents;
  else
    nevents +=skipEvents+1; 
  // I skipped the 1st because of missing TCloneArray problem
 
  //
  // Now loop over the events in the file
  //
  cerr<<"Looping over Events\n";
  for (Int_t ev = 1+skipEvents; ev < nevents; ev++) {
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
      nparticlesFirstEvent=esr->GetNparticles();
      sprintf(label,"eventNo");
      vnames->Add(label);
      sprintf(label,"Nlgd");
      vnames->Add(label);
      sprintf(label,"Nbcal");
      vnames->Add(label);
      sprintf(label,"Nofftrk");
      vnames->Add(label);
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
    }

    // define some libpp four-vectors
    fourVec sum4v,P4vector[20],proton4v;
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
	}

	// book particle ID
	Int_t PDGid =  particle->GetIdHep();
	values[n_vectors++] = PDGid;
	if(firstEvent){
	  sprintf(label,"PDGid%d",nparts);
	  vnames->Add(label);
	}
	// book vertex info for each particle
	values[n_vectors++] = particle->GetX();
	values[n_vectors++] = particle->GetY();
	values[n_vectors++] = particle->GetZ();
	if(firstEvent){
	  sprintf(label,"v%d.x",nparts);
	  vnames->Add(label);
	  sprintf(label,"v%d.y",nparts);
	  vnames->Add(label);
	  sprintf(label,"v%d.z",nparts);
	  vnames->Add(label);
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
	    sprintf(label,"SmearP%d.x",nparts);
	    vnames->Add(label);
	    sprintf(label,"SmearP%d.y",nparts);
	    vnames->Add(label);
	    sprintf(label,"SmearP%d.z",nparts);
	    vnames->Add(label);
	    sprintf(label,"SmearP%d.t",nparts);
	    vnames->Add(label);
	  }

	if(Book_Four_Components){
	  values[n_vectors++] = particle->GetP();	
	  values[n_vectors++] = px;
	  values[n_vectors++] = py;
	  values[n_vectors++] = pz;
	  values[n_vectors++] = E;
	  if(firstEvent){
	    sprintf(label,"p%d",nparts);
	    vnames->Add(label);
	    sprintf(label,"p%d.x",nparts);
	    vnames->Add(label);
	    sprintf(label,"p%d.y",nparts);
	    vnames->Add(label);
	    sprintf(label,"p%d.z",nparts);
	    vnames->Add(label);
	    sprintf(label,"E%d",nparts);
	    vnames->Add(label);
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
	  P4vector[nparts].set(E,threeVec(px,py,pz));
	  sum4v += P4vector[nparts];
	  //nparts++;
	}else{
	  proton4v.set(E,threeVec(px,py,pz));
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
      fourVec beam4v(beamE,threeVec(0,0,beamE));
      Double_t t = (beam4v - sum4v)*(beam4v - sum4v);
      if(firstEvent){
	sprintf(label,"t");
	vnames->Add(label);
      } 
      values[n_vectors++] = -t;

      //////////////////////
      // missing xmass
      /////////////////////
      if(nproton==1){
	fourVec target4v(0.938,threeVec(0,0,0));// proton target
	Double_t mXm = (beam4v + target4v - proton4v)*
	  (beam4v + target4v - proton4v);
	if(firstEvent){
	  sprintf(label,"mXm");
	  vnames->Add(label);
	} 
	values[n_vectors++] = mXm;
  
      }
      ///////////////////////////
      // Let's add some GJ angles
      ///////////////////////////

      // set the boost
      lorentzTransform L(sum4v);
      // z GJ is the boosted beam
      // y GJ is normal to production plane
      // get x GJ from right handed system
      threeVec xGJ,yGJ,zGJ;
      beam4v *= L; // boost beam to X restframe
      zGJ =  beam4v.V() * (1.0 /  beam4v.V().r());
     
      // copy and boost
      fourVec *P4boosted = new fourVec[20];
      threeVec X3vGJ(0,0,0);// init it
      for(i=0; i<nparts-1;i++){// the -1 subtracts 1 for the proton
	P4boosted[i]=  P4vector[i];
	P4boosted[i] *= L;// boost particles to X restframe
	values[n_vectors++] = (P4boosted[i].V() * zGJ) * (1.0/
	  P4boosted[i].V().r()) ;// Cos theta GJ
	if(firstEvent){
	  sprintf(label,"cosGJ.%d",i);
	  vnames->Add(label);
	} 
	X3vGJ +=P4vector[i].V();
      }
      
      for(i=0; i<nparts-1;i++){
	yGJ = (beam4v.V() / X3vGJ) * 
	  (1.0/(beam4v.V().r() * X3vGJ.r())) ; // cross product
	xGJ = yGJ / zGJ;
	values[n_vectors++] = TMath::ATan2( yGJ * P4boosted[i].V(),
					    xGJ * P4boosted[i].V());
	if(firstEvent){
	  sprintf(label,"phiGJ.%d",i);
	  vnames->Add(label);
	} 
      }
      
      
     
      
      /////////////////////////////////
      // Now book some effective masses
      /////////////////////////////////
      
      // X mass & total mass
      // note: ~(fourVec) returns the fourVec length (i.e. effective mass)
      values[n_vectors++] = ~sum4v; 
      
      if(firstEvent){
	sprintf(label,"XMass");
	vnames->Add(label);
      } 
   
      if(nproton){
	if(firstEvent){
	  sprintf(label,"TotalMass");
	  vnames->Add(label);
	} 
	values[n_vectors++] = ~(sum4v + P4vector[proton[0]])  ; 
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
	sum4v=fourVec(0.0,threeVec(0.0,0.0,0.0));
	for (i = 0; i < ngamma; ++i) 
	  sum4v += P4vector[gamma[i]];
	values[n_vectors++] = ~sum4v;
	if(firstEvent){
	  sprintf(label,"TotalGamma");
	  vnames->Add(label);
	}
	//
	// total gamma + 1 pi+ mass
	for(k=0;k<npiplus;k++){
	  values[n_vectors++] = ~(sum4v + P4vector[piplus[k]]);
	  if(firstEvent){
	    sprintf(label,"totg1pip.%d",k);
	    vnames->Add(label);
	  } 
	}
	//
	//  total gamma + pi- mass
	for(k=0;k<npiminus;k++){
	  values[n_vectors++] = ~(sum4v + P4vector[piminus[k]]);
	  if(firstEvent){
	    sprintf(label,"totg1pim.%d",k);
	    vnames->Add(label);
	  } 
	}
	// total gamma +  pi+ pi- mass
	for(k=0;k<npiminus;k++)
	  for(l=0;l<npiplus;l++){
	    values[n_vectors++] = ~(sum4v + 
				    P4vector[piminus[k]]
				    + P4vector[piplus[l]]);
	    if(firstEvent){
	      sprintf(label,"totg1pim1pip.%d",nn++);
	      vnames->Add(label);
	    } 
	  }
	//
	// total_gamma 2pi+ pi- mass
	if(npiplus>1)
	  for(k=0;k<npiminus;k++)
	    for(l=0;l<npiplus-1;++l)
	      for(Int_t m = l+1;m<npiplus;++m){
		values[n_vectors++] = ~(sum4v + 
					P4vector[piminus[k]]
					+ P4vector[piplus[l]]
					+ P4vector[piplus[m]]);
		if(firstEvent){
		  sprintf(label,"totg1pim2pip.%d",mm++);
		  vnames->Add(label);
		} 
	      }
	
	
	
	//
	// 2gamma masses
	sum4v=fourVec(0.0,threeVec(0.0,0.0,0.0));
	n=0;
	nn=0;
	mm=0;
	for (i = 0; i < ngamma - 1; ++i){
	  for (j = i + 1; j < ngamma; ++j){ 
	    sum4v = P4vector[gamma[i]] + P4vector[gamma[j]];
	    values[n_vectors++] = ~sum4v;
	    if(firstEvent){
	      sprintf(label,"2g.%d",n++);
	      vnames->Add(label);
	    } 
	    //
	    // 2gamma pi+ mass
	    for(k=0;k<npiplus;k++){
	      values[n_vectors++] = ~(sum4v + P4vector[piplus[k]]);
	      if(firstEvent){
		sprintf(label,"2g1pip.%d",k);
		vnames->Add(label);
	      } 
	    }
	    // 2gamma pi- mass
	    for(k=0;k<npiminus;k++){
	      values[n_vectors++] = ~(sum4v + P4vector[piminus[k]]);
	      if(firstEvent){
		sprintf(label,"2g1pim.%d",k);
		vnames->Add(label);
	      } 
	    }
	    // 2 gamma pi+ pi- mass
	    for(k=0;k<npiminus;k++)
	      for(l=0;l<npiplus;l++){
		values[n_vectors++] = ~(sum4v + 
					P4vector[piminus[k]]
					+ P4vector[piplus[l]]);
		if(firstEvent){
		  sprintf(label,"2g1pim1pip.%d",nn++);
		  vnames->Add(label);
		} 
	      }
	    // 2gamma 2pi+ pi-
	    if(npiplus>1)
	      for(k=0;k<npiminus;k++)
		for(l=0;l<npiplus-1;++l)
		  for(Int_t m = l+1;m<npiplus;++m){
		    values[n_vectors++] = ~(sum4v + 
					    P4vector[piminus[k]]
					    + P4vector[piplus[l]]
					    + P4vector[piplus[m]]);
		    if(firstEvent){
		      sprintf(label,"2g1pim2pip.%d",mm++);
		      vnames->Add(label);
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
	  values[n_vectors++] = ~(P4vector[piminus[k]]
				  + P4vector[piplus[l]]);
	  if(firstEvent){
	    sprintf(label,"1pim1pip.%d",nn++);
	    vnames->Add(label);
	  } 
	}
      //
      //  2pi+ pi- mass
      mm=0;
	for(k=0;k<npiminus;k++)
	  for(l=0;l<npiplus-1;++l)
	    for(Int_t m = l+1;m<npiplus;++m){
	      values[n_vectors++] = ~(  P4vector[piminus[k]]
				      + P4vector[piplus[l]]
				      + P4vector[piplus[m]]);
	      if(firstEvent){
		sprintf(label,"1pim2pip.%d",mm++);
		vnames->Add(label);
	      } 
	    }
	//
	//  pi+ 2pi- mass
	mm=0;
	for(k=0;k<npiplus;k++)
	  for(l=0;l<npiminus-1;++l)
	    for(Int_t m = l+1;m<npiminus;++m){
	      values[n_vectors++] = ~(P4vector[piplus[k]]
				      + P4vector[piminus[l]]
				      + P4vector[piminus[m]]);
	      if(firstEvent){
		sprintf(label,"2pim1pip.%d",mm++);
		vnames->Add(label);
	      } 
	    }
	//
	// 2pi+ 2pi-
	mm=0;
	for(j=0;j<npiplus;j++)
	  for(k=j+1;k<npiplus-1;k++)
	    for(l=0;l<npiminus-1;++l)
	      for(Int_t m = l+1;m<npiminus;++m){
		values[n_vectors++] = ~( P4vector[piplus[j]]
					+ P4vector[piplus[k]]
					+ P4vector[piminus[l]]
					+ P4vector[piminus[m]]);
		if(firstEvent){
		  sprintf(label,"2pim2pip.%d",mm++);
		  vnames->Add(label);
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
	  values[n_vectors++] = ~(P4vector[Kminus[k]]
				  + P4vector[Kplus[l]]);
	  if(firstEvent){
	    sprintf(label,"1Km1Kp.%d",nn++);
	    vnames->Add(label);
	  } 
	}
      //
      //  2K+ K- mass
      mm=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<nKplus-1;++l)
	  for(Int_t m = l+1;m<nKplus;++m){
	    values[n_vectors++] = ~(P4vector[Kminus[k]]
				    + P4vector[Kplus[l]]
				    + P4vector[Kplus[m]]);
	    if(firstEvent){
	      sprintf(label,"1Km2Kp.%d",mm++);
	      vnames->Add(label);
	    } 
	  }
      //
      //  K+ 2K- mass
      mm=0;
      for(k=0;k<nKplus;k++)
	for(l=0;l<nKminus-1;++l)
	  for(Int_t m = l+1;m<nKminus;++m){
	    values[n_vectors++] = ~( P4vector[Kplus[k]]
				     + P4vector[Kminus[l]]
				     + P4vector[Kminus[m]]);
	    if(firstEvent){
	      sprintf(label,"2Km1Kp.%d",mm++);
	      vnames->Add(label);
	    } 
	  }
      //
      // 2K+ 2K-
      mm=0;
      for(j=0;j<nKplus;j++)
	for(k=j+1;k<nKplus-1;k++)
	  for(l=0;l<nKminus-1;++l)
	    for(Int_t m = l+1;m<nKminus;++m){
	      values[n_vectors++] = ~(P4vector[Kplus[j]]
				      + P4vector[Kplus[k]]
				      + P4vector[Kminus[l]]
				      + P4vector[Kminus[m]]);
	      if(firstEvent){
		sprintf(label,"2Km2Kp.%d",mm++);
		vnames->Add(label);
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
	  values[n_vectors++] = ~(P4vector[piminus[k]]
				  + P4vector[Kplus[l]]);
	  if(firstEvent){
	    sprintf(label,"1pim1Kp.%d",nn++);
	    vnames->Add(label);
	  } 
	}
      //
      // K- pi+ mass
      nn=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<npiplus;l++){
	  values[n_vectors++] = ~(P4vector[Kminus[k]]
				  + P4vector[piplus[l]]);
	  if(firstEvent){
	    sprintf(label,"1Km1pip.%d",nn++);
	    vnames->Add(label);
	  } 
	}
      //
      //  2pi+ K- mass
      mm=0;
      for(k=0;k<nKminus;k++)
	for(l=0;l<npiplus-1;++l)
	  for(Int_t m = l+1;m<npiplus;++m){
	    values[n_vectors++] = ~(P4vector[Kminus[k]]
				    + P4vector[piplus[l]]
				    + P4vector[piplus[m]]);
	    if(firstEvent){
	      sprintf(label,"1Km2pip.%d",mm++);
	      vnames->Add(label);
	    } 
	  }
      //
      //  K+ 2pi- mass
      mm=0;
      for(k=0;k<nKplus;k++)
	for(l=0;l<npiminus-1;++l)
	  for(Int_t m = l+1;m<npiminus;++m){
	    values[n_vectors++] = ~(P4vector[Kplus[k]]
				    + P4vector[piminus[l]]
				    + P4vector[piminus[m]]);
	    if(firstEvent){
	      sprintf(label,"2pim1Kp.%d",mm++);
	      vnames->Add(label);
	    } 
	  }
      //
      // K+ K- pi+ pi-
      mm=0;
      for(j=0;j<nKplus;j++)
	for(k=0;k<npiplus;k++)
	  for(l=0;l<nKminus;++l)
	    for(Int_t m = 0;m<npiminus;++m){
	      values[n_vectors++] = ~(P4vector[Kplus[j]]
				      + P4vector[piplus[k]]
				      + P4vector[Kminus[l]]
				      + P4vector[piminus[m]]);
	      if(firstEvent){
		sprintf(label,"KmKppimpip.%d",mm++);
		vnames->Add(label);
	      } 
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
    tof_trace->Clear();
    offtrk->Clear();
    bcal->Clear();
    lgdSmears->Clear();
  }
  

  rdtfile->Close();
  ntpfile->Write();
  ntpfile->Close();
  return 0;
}

