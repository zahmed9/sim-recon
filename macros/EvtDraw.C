int EvtDraw(char *geoFile="tmp.db",Int_t ev=13){
/**********************************************************
 *
 * This ia a simple ROOT macro to read in and display
 * MCFast geometries and events.
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * Created: 4-Feb-1999
 *
 * **********************************************
 * To run this macro execute "root" and then from
 * the root prompt type ".x EvtDraw.C("halld_strawman.db",13)"
 * where halld_strawman.db is the HDFast goemetry file obtainable
 * from the HDFast cvs repository and 13 is just the event number
 * to look at --change this number to look at diferent events.
 *
 *A quick way to run the macro from a unix prompt is to type
 * " root .x  EvtDraw.C\(\"halld_strawman.db\",13\) "  Notice
 * that the backslashes are need so that the unix shell passes the
 *  "'s and ()'s to root.
 *
 * This macro runs only once! Due to some funny quirks in rootcint,
 * one must exit root and start over to view different events.
 *
 * One last point, the "next event" button does not work.
 *******************************************************/

 
  
  gROOT.Reset();
  gSystem->Load("libTMCFast.so");

  #include <iostream.h>
  #include <string.h>

  //////////////////////////////////////////
  //
  // SET UP THE GEOMETRY
  //
  //////////////////////////////////////////


  Int_t Dump=0; // set Dump to 1 for debug info

  // Open the Geo File
  if(Dump)
    cout << "Opening The Geo File : "<<  geoFile<< endl;
  ifstream dbFile(geoFile); 
  if(dbFile.bad()){
    cerr<< "Failed to open Geo file\n";
    exit(-1);
  }
  
  //  Open a ROOT window
  TCanvas *c1 = new TCanvas("c1","MCFast GeoReader",100,100,800,800);
  c1->SetFillColor(20);
  // create sub windows
  TPad *xz_pad = new TPad("xz_pad","The X-Z View",0.02,0.02,0.48,0.48,23);
  TPad *yz_pad = new TPad("yz_pad","The Y-Z View",0.02,0.52,0.48,0.98,23);
  TPad *xy_pad = new TPad("xy_pad","The X-Y View",0.52,0.33,0.98,0.83,23);
  xz_pad->Draw();
  yz_pad->Draw();
  xy_pad->Draw();

  // set Range to match the experimental coordinates
  xz_pad->Range(-200,-250,650,250);
  yz_pad->Range(-200,-250,650,250);
  xy_pad->Range(-250,-250,250,250);

  //
  // Set up some object pointers
  //
 
  // Magnet Geometry
  TBox *solenoid,*solenoidR;
  TEllipse *xy_solenoidHole,*xy_solenoid;

  // Target Geometry
  TLine *target;

  // Cylindrical Drift Geometry
  TBox *drift[20],*driftR[20],;
  Int_t driftNum=0;

  // Cylindrical Absorber Geometry
  TBox *absorber[100],*absorberR[100],;
  Int_t absorberNum=0;

  // Cylindrical Aclorimeter Geometry
  TBox *calor[100],*calorR[100],;
  Int_t calorNum=0;

  // SiDisks Geometry
  TLine *SiLine[100],*SiLineR[100],;
  struct SiDisk_t{
    int index;
    double zpos;
  }SiDisk[40];
  int NsiLayer=0;
  int NSiDisks=0;
  
  // local data types
  Double_t rmin,rmax,zLength,zCenter,rthick,xmin,xmax;
  Double_t z1,z2,r1,r2;
  char line[256],word[100],*token;
  

  //
  // Read geo file and setup detector parameters
  //

 dbFile >>word;
 while(strcmp(word,"end") != 0 ){ // not EOF
   if(strcmp(word,"make")==0|| strcmp(word,"!%")==0||){
     if(strcmp(word,"!%")==0)
       dbFile >>word;
     dbFile >>word;
     if(strcmp(word,"Solenoid")==0){ // make magnet geometry
       dbFile.getline(line,sizeof(line));
       if(Dump) cout <<"Solenoid "<<line<<endl;
       token = strtok(line," ");// Name
       token = strtok(NULL," ");// bfield
       token = strtok(NULL," "); // rmin
       rmin=  atof(token);
       token = strtok(NULL," "); // rmax
       rmax = atof(token);
       token = strtok(NULL," ");// zCenter
       zCenter= atof(token);
       token = strtok(NULL," ");// zLength
       zLength=atof(token);
       token = strtok(NULL," "); // fill
       token = strtok(NULL," "); // rthick1      
       token = strtok(NULL," "); // rthick2
       rthick=atof(token);
       if(Dump) cout << "Solenoid rmin:rmax " <<rmin<<":"<<rmax<<" zCenter:zLength: "
	   <<zCenter<<":"<<zLength<<endl;
       // Set coordinates
       z1= zCenter - zLength/2.0;
       z2= zCenter + zLength/2.0;
       r1= rmax;
       r2= 2*rmax;

       xy_solenoid = new TEllipse( 0.0,0.0,r2,r2 );
       xy_solenoid->SetFillColor(41);
       xy_solenoid->SetLineColor(41);
       xy_solenoidHole = new TEllipse( 0.0,0.0,r1,r1 );
       xy_solenoidHole->SetFillColor(23);
       xy_solenoidHole->SetLineColor(23);
       solenoid = new TBox(z1,r1,z2,r2);
       solenoid->SetFillColor(41);
       // Make Refelection below centerline
       solenoidR = new TBox(z1,-r1,z2,-r2); 
       solenoidR->SetFillColor(41);     

     }
     else if(strcmp(word,"Drift")==0 ){ // make cylindrical drift geometry
       dbFile.getline(line,sizeof(line));
       token = strtok(line," ");// num
       token = strtok(NULL," ");// "name"
       token = strtok(NULL," "); // num anode
       token = strtok(NULL," "); // num cath
       token = strtok(NULL," ");// rmin
       rmin = atof(token);
       token = strtok(NULL," ");// rmax
       rmax = atof(token);
       token = strtok(NULL," "); // zCenter
       zCenter =  atof(token);
       token = strtok(NULL," "); // zLength 
       zLength=atof(token);     
       rthick=atof(token);
       // set coordinates
       z1= zCenter - zLength/2.0;
       z2= zCenter + zLength/2.0;
       r1= rmin;
       r2= rmax; 
      
       drift[driftNum] = new TBox(z1,r1,z2,r2);
       driftR[driftNum] = new TBox(z1,-r1,z2,-r2);
       drift[driftNum]->SetFillColor(40+5*driftNum); 
       driftR[driftNum]->SetFillColor(40+5*driftNum); 
       driftNum++;
       if(Dump) cout<< "Drift rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;     
     }
     else if(strcmp(word,"SiDisk")==0 ){// read silicon disk z position
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// num
       SiDisk[NSiDisks].index = atoi(token);
       token = strtok(NULL," ");// "name"
       token = strtok(NULL," "); // nlayers
       token = strtok(NULL," "); // zpos
       SiDisk[NSiDisks].zpos = atof(token);
       NSiDisks++;
 
     } 
     else if(strcmp(word,"LayerSiDi")==0 ){// make silicon disk geometry
       // Sometimes the silicon disk geometry is used as a kludge
       // for forward planar-disk drift chambers
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// ptr
       int ptr = atoi(token);
       token = strtok(NULL," ");// layer
       token = strtok(NULL," "); // "fill"
       token = strtok(NULL," "); // nwed
       token = strtok(NULL," ");// zlocal
       zCenter = atof(token);
       token = strtok(NULL," "); // thickness
       rthick =  atof(token);
       token = strtok(NULL," ");// rmin
       rmin =  atof(token);
       token = strtok(NULL," "); // rmax
       rmax =  atof(token);

       z1= SiDisk[ptr-1].zpos +  zCenter - rthick;
       z2= SiDisk[ptr-1].zpos +  zCenter + rthick;
       r1= rmin;
       r2= rmax; 

       SiLine[NsiLayer] = new TLine(z1,r1,z1,r2);
       SiLineR[NsiLayer] = new TLine(z1,-r1,z1,-r2);
       NsiLayer++;
     
       if(Dump) cout<<"SiBox["<<NsiLayer<<"] ("
	   <<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;
     }
     else if(strcmp(word,"BeamVrtx")==0 ){// make kludged target
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// x 
       Double_t xTargetCenter = atof(token);
       token = strtok(NULL," ");// y
       Double_t yTargetCenter = atof(token);
       token = strtok(NULL," "); // z
       Double_t zTargetCenter = atof(token);
       token = strtok(NULL," "); // sigma x
       Double_t sigmaxTargetCenter = atof(token);
       token = strtok(NULL," "); // sigma y
       Double_t sigmayTargetCenter = atof(token);
       token = strtok(NULL," ");//  sigma z
       Double_t sigmazTargetCenter = atof(token);
       
       // set coordinates
       z1= 50.0 - 15.0; //zTargetCenter - sigmazTargetCenter;
       z2=  50.0 + 15.0; //zTargetCenter + sigmazTargetCenter;
	 r1= TMath::Sqrt(xTargetCenter*xTargetCenter+
			 yTargetCenter*yTargetCenter);
       r2=r1; 
       // the code is in but currently overridden
       target = new TLine(z1,r1,z2,r2);
       target->SetLineColor(2);
     }
     else if(strcmp(word,"Absorber")==0 || strcmp(word,"AbsorberBox")==0  ){
                                                   // make absorber geometry
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// name
       token = strtok(NULL," ");// shape  tube or Box only
       token = strtok(NULL," "); // type
       token = strtok(NULL," "); // rmin or xmin
       xmin =  atof(token);
       token = strtok(NULL," "); // rmin or xmax
       rmin =  atof(token);
       xmax = rmin;
       token = strtok(NULL," ");//  rmax
       token = strtok(NULL," ");//  rmax
       rmax =  atof(token);
       if( strcmp(word,"AbsorberBox")==0 ){
	token = strtok(NULL," ");// xlimit_gap 
	token = strtok(NULL," ");// xlimit_gap  
	token = strtok(NULL," ");// ylimit_gap  
	token = strtok(NULL," ");// ylimit_gap  
       }
       token = strtok(NULL," "); // z0
       zCenter =  atof(token);
       token = strtok(NULL," ");// zlen
       zLength =  atof(token);
       // set coordinates
       z1= zCenter - zLength/2.0;
       z2= zCenter + zLength/2.0;
       if( strcmp(word,"AbsorberBox")==0 ){
	 r1 = xmin;
	 r2 = xmax;
       }else{
	 r1= rmin;
	 r2= rmax; 
       }
       absorber[absorberNum] = new TBox(z1,r1,z2,r2);
       absorberR[absorberNum] = new TBox(z1,-r1,z2,-r2);
       absorber[absorberNum]->SetFillColor(5); 
       absorberR[absorberNum]->SetFillColor(5); 
       absorberNum++;
       if(Dump) cout<< "Absorber rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;     
     }
     else if(strcmp(word,"EMCal")==0|| strcmp(word,"CalorBox")==0  ){// make cyl calor
       // strcmp(word,"CalorBox")==0 
            dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// name
       token = strtok(NULL," ");// shape
       token = strtok(NULL," ");// type
       token = strtok(NULL," ");
       xmin =  atof(token);
       token = strtok(NULL," "); // rmin 
       rmin =  atof(token);
       xmax = rmin;
       token = strtok(NULL," ");//
       token = strtok(NULL," "); // rmax
       rmax =  atof(token);
       if( strcmp(word,"CalorBox")==0 ){
	 token = strtok(NULL," ");// xlimit_gap 
	 token = strtok(NULL," ");// xlimit_gap  
	 token = strtok(NULL," ");// ylimit_gap  
	 token = strtok(NULL," ");// ylimit_gap  
       }
       token = strtok(NULL," "); // z0
       zCenter =  atof(token);
       token = strtok(NULL," ");// zlen
       zLength =  atof(token);
       if(Dump) cout<<"zLen is "<<zLength<<endl;
       // set coordinates
       z1= zCenter - zLength/2.0;
       z2= zCenter + zLength/2.0;

       if( strcmp(word,"CalorBox")==0 ){
	 r1 = xmin;
	 r2 = xmax;
       }else{
	 r1= rmin;
	 r2= rmax; 
       }
       calor[calorNum] = new TBox(z1,r1,z2,r2);
       calorR[calorNum] = new TBox(z1,-r1,z2,-r2);
       calor[calorNum]->SetFillColor(6); 
       calorR[calorNum]->SetFillColor(6); 
       calorNum++;
       if(Dump) cout<< "Cylindrical Calorimeter rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl; 
     }
     else dbFile.getline(line,sizeof(line)); 
   }
   else dbFile.getline(line,sizeof(line)); 
   dbFile >>word;
   
 }
 //
 // End of detector description. 
 //




 ////////////////////////////////////////
 // 
 // Get an event to display
 //
 ////////////////////////////////////

 // open the dat file
 TFile f("test2.rdt");

 // get the event tree from the data file
 TTree *tree = (TTree*)f.Get("T");
 

 // get all branches
 TBranch *b1 = tree->GetBranch("hepevt");
 TBranch *b2 = tree->GetBranch("tof_trace");
 TBranch *b3 = tree->GetBranch("offtrk");
 TBranch *b4 = tree->GetBranch("bcal");
 TBranch *b5 = tree->GetBranch("lgdSmears");

 // define object pointers
 TMCFastHepEvt *hepevt;
 TMCFastTOF *trace; 
 TMCFastOfflineTrack *offtrk;  
 hepevt = new TMCFastHepEvt();
 trace = new TMCFastTOF();
 offtrk = new TMCFastOfflineTrack();
 bcal = new TMCFastCalorimeter();
 lgdSmears = new TLGDsmears();
 Int_t colNum=2;
 
 // tell the branch were to put the event objects 
 b1->SetAddress(&hepevt);
 b2->SetAddress(&trace);
 b3->SetAddress(&offtrk);
 b4->SetAddress(&bcal);
 b5->SetAddress(&lgdSmears); 
 
 Int_t nentries = (Int_t)tree->GetEntries();
 // get this event.
 tree->GetEvent(ev);
 
 // make virtual branch from the other branches
 TMCesr *esr=0;
 esr = new TMCesr(*hepevt,*offtrk,*lgdSmears,*bcal);
 Int_t n_particles=esr->GetNparticles();
 cout<< n_particles <<endl;
 TIter nextMC(esr->GetParticles());
 
 // define a place to put the particle trajectories
 TLine *xz_gammaTrack[10];
 TLine *yz_gammaTrack[10];
 TLine *xy_gammaTrack[10];
 TPolyLine *ptrack[10];
 TPolyLine *xztrack[10];
 TPolyLine *yztrack[10];
 TPolyLine *xytrack[10];
 
 Float_t tx[2],ty[2],tz[2];
        
 Int_t nPoints=1000;
 Float_t ctrk_z[1000],ctrk_x[1000],ctrk_y[1000];
 Int_t nGammas=0,nCharged=0;
 
 for(Int_t i=0;i<n_particles;i++){
   
   TMCParticle *particle = ( TMCParticle *)nextMC();
   particle->Print(&cout);
   //
   // Get particle's vertex (Xo,Yo,Zo)
    //
   Double_t q= (Double_t)(particle->GetCharge());
   tz[0]= particle->GetZ();
   tx[0]= particle->GetX();
   ty[0]= particle->GetY();
   
   cout<<"(z0,x0,z1,x1): ("<<tz[0]<<","<<tx[0]<<","<<tz[1]<<","
       <<tx[1]<<")"<<endl;
   //
   // Trace Gammas
   //
   if(particle->GetIdHep()==22){ // PDG_ID for a gamma
     //
     // Track the gammas
     if(!(q==0)){
       cerr<< "ERROR! gamma has charge!\nExiting\n";
       exit(-1);
     }
     Double_t grsq=0;
     
     tx[1]=tx[0];
     ty[1]=ty[0];
     tz[1]=tz[0];
     for(Int_t nn = 1; nn<60 ; nn++ ){
       if( tz[1]<0 || (tz[1]<450 && grsq>85.0*85.0))
	 break;
       tz[1]=tz[0] + nn*15.0*particle->GetPz()/particle->GetP();
       tx[1]=tx[0] + nn*15.0*particle->GetPx()/particle->GetP();
       ty[1]=ty[0] + nn*15.0*particle->GetPy()/particle->GetP();
       grsq = tx[1]*tx[1]+ty[1]*ty[1];
     }
     
     xz_gammaTrack[nGammas] = new TLine(tz[0],tx[0],tz[1],tx[1]);
     xz_gammaTrack[nGammas]->SetLineStyle(2);
     xz_gammaTrack[nGammas]->SetLineColor(nGammas);
     yz_gammaTrack[nGammas] = new TLine(tz[0],ty[0],tz[1],ty[1]);
     yz_gammaTrack[nGammas]->SetLineStyle(2);
     yz_gammaTrack[nGammas]->SetLineColor(nGammas);
     xy_gammaTrack[nGammas] = new TLine(tx[0],ty[0],tx[1],ty[1]);
     xy_gammaTrack[nGammas]->SetLineStyle(2);
     xy_gammaTrack[nGammas]->SetLineColor(nGammas);
     nGammas++;
   }
   else{
   //
   // Trace charged particles in the solenoid
   //
     
     
     //    track[i] = new TLine(tz0,tx0,tz1,tx1);
     Int_t n=2;
     //ptrack[i] = new TPolyLine(n,tz,tx);
     Double_t Xo=tx[0],Yo=ty[0];
     Double_t parms[3];
     Double_t pt = TMath::Sqrt(particle->GetPx()*particle->GetPx() +
			       particle->GetPy()*particle->GetPy());
     Double_t R = 100*(3.33)*pt/(2.24);/* in cm */ 
     Double_t omega = q*(9e7)*(2.24)/(particle->GetE());
     const Double_t cHALF_PI = 1.5707963;
     Double_t thetaPt= TMath::ATan2(particle->GetPy(),particle->GetPx());
     Double_t phi = thetaPt + q*cHALF_PI;
     Double_t Xc = Xo - R*TMath::Cos(phi);
     Double_t Yc = Yo - R*TMath::Sin(phi);
     Double_t zVel =(100.0)*(3e8)*(particle->GetPz())/particle->GetE();
     Double_t zPos0 = tz[0];
     /*
       cout<<"R: "<<R<<" Pt: "<<pt<<" omega: "<<omega
       <<" phi:"<<phi<<" zVel:"<<zVel<<endl;
       cout<<"\tX:"<<tx[0]<<" Z:"<<zPos0<<endl;
       cout<<"\tXo: "<<Xo<<" Xc: "<<Xc<<" Yo: "<<Yo<<" Yc: "<<Yc<<endl;
     */
     TFormula *xtrace = new TFormula("xtrace","[0]*cos([1]*x +[2])");
     parms[0]=R;
     parms[1]=omega;
     parms[2]=phi;
     xtrace->SetParameters(parms);
     TFormula *ytrace = new TFormula("ytrace","[0]*sin([1]*x +[2])");
     parms[0]=R;
     parms[1]=omega;
     parms[2]=phi;
     ytrace->SetParameters(parms);
     TFormula *ztrace = new TFormula("ztrace","[0]*x+[1]");
     parms[0]=zVel;
     parms[1]=zPos0;
     ztrace->SetParameters(parms);
     
     for(Int_t j=0;j<nPoints ;j++){
       ctrk_z[j] = ztrace->Eval(((Double_t)(j)) /1e9);
       ctrk_x[j] = Xc + xtrace->Eval(((Double_t)(j))/1e9);
       ctrk_y[j] = Yc + ytrace->Eval(((Double_t)(j))/1e9);
       if( ctrk_z[j]> 600)
	 nPoints=j;
       /*
	 cout<<"j: "<<j<<" t: "<<((Double_t)(j))/1e9<<endl;
	 cout<<"(x,y,z) ("<<ctrk_x[j]<<","<<ctrk_y[j]<<","<<ctrk_z[j]<<")\n";
	 cout<<"(x,y,) ("<<R*cos(omega*( ((Double_t)(j))/1e9)+phi)
	 <<","<<R*sin(omega*( ((Double_t)(j))/1e9)+phi)
	 <<endl;
       */
       
     }
     
     xztrack[nCharged] = new TPolyLine(nPoints,ctrk_z,ctrk_x);
     yztrack[nCharged] = new TPolyLine(nPoints,ctrk_z,ctrk_y);
     xytrack[nCharged] = new TPolyLine(nPoints,ctrk_x,ctrk_y);
     xztrack[nCharged]->SetLineColor(colNum);
     yztrack[nCharged]->SetLineColor(colNum);
     xytrack[nCharged++]->SetLineColor(colNum++);
     
   }
 }
 ///////////////////////////////////////////////// 



 ///////////////////////
 //  SETUP XZ PAD
 //////////////////////
 xz_pad->cd();
   // Make center line with mark at zero
  TLine *centerLine = new TLine(-200,0,500,0);
  TLine *centerMark = new TLine(50,-1,50,1);
  centerLine->SetLineColor(1);
  centerMark->SetLineColor(1);
  centerLine->Draw();
  centerMark->Draw();
  TArrow *zRef = new TArrow(-190,-100,-140,-100,0.01); // 0.5 meter
  TArrow *rRef = new TArrow(-190,-100,-190,-50,0.01); // 0.5 meter
  zRef->Draw();
  rRef->Draw();
  TText *zRefText = new TText(-136,-105,"z");
  TText *rRefText = new TText(-175,-48,"x");
  zRefText->SetTextSize(0.03);
  rRefText->SetTextSize(0.03);
  zRefText->Draw();
  rRefText->Draw();


 // Now have the objects draw themselves
 solenoid->Draw();
 solenoidR->Draw();
 target->Draw();
 for(int j=0;j< driftNum;j++){
   drift[j]->Draw();
   driftR[j]->Draw();
 }
 for(int j=0;j< NsiLayer ;j++){
   SiLine[j]->Draw(); 
   SiLineR[j]->Draw(); 
 }
  for(int j=0;j< calorNum;j++){
   calor[j]->Draw();
   calorR[j]->Draw();
 }
 for(int j=0;j< absorberNum;j++){
   absorber[j]->Draw();
   absorberR[j]->Draw();
 }
 for(Int_t i=0;i<nCharged;i++){
   //ptrack[i]->Draw();
   xztrack[i]->Draw();
 }
 for(Int_t i=0;i<nGammas;i++){
   xz_gammaTrack[i]->Draw();
   //xz_gammaTrack[i]->Dump();
 }

 ///////////////////////
 //  SETUP YZ PAD
 //////////////////////
 yz_pad->cd();
   // Make center line with mark at zero
  TLine *centerLine = new TLine(-200,0,500,0);
  TLine *centerMark = new TLine(50,-1,50,1);
  centerLine->SetLineColor(1);
  centerMark->SetLineColor(1);
  centerLine->Draw();
  centerMark->Draw();
  TArrow *zRef = new TArrow(-190,-100,-140,-100,0.01); // 0.5 meter
  TArrow *rRef = new TArrow(-190,-100,-190,-50,0.01); // 0.5 meter
  zRef->Draw();
  rRef->Draw();
  TText *zRefText = new TText(-136,-105,"z");
  TText *rRefText = new TText(-175,-48,"y");
  zRefText->SetTextSize(0.03);
  rRefText->SetTextSize(0.03);
  zRefText->Draw();
  rRefText->Draw();

 // Now have the objects draw themselves
 solenoid->Draw();
 solenoidR->Draw();
 target->Draw();
 for(int j=0;j< driftNum;j++){
   drift[j]->Draw();
   driftR[j]->Draw();
 }
 for(int j=0;j< NsiLayer ;j++){
   SiLine[j]->Draw(); 
   SiLineR[j]->Draw(); 
 }
  for(int j=0;j< calorNum;j++){
   calor[j]->Draw();
   calorR[j]->Draw();
 }
 for(int j=0;j< absorberNum;j++){
   absorber[j]->Draw();
   absorberR[j]->Draw();
 }
 for(Int_t i=0;i<nCharged;i++){
   //ptrack[i]->Draw();
   yztrack[i]->Draw();
 }
 for(Int_t i=0;i<nGammas;i++)
   yz_gammaTrack[i]->Draw();

 ///
 /// Added detector labels
 ///
 TText *title = new TText(-70,220,"Hall D Meson Spectrometer");
 TText *subtitle = new TText(70,-220,"Stage 1");
 title->SetTextColor(4);
 subtitle->SetTextColor(4);
 title->Draw();
 subtitle->Draw();
 TText *soleTag = new TText(180,120,"solenoid");
 soleTag->Draw();
 TText *bcalTag = new TText(220,70,"BCAL");
 bcalTag->SetTextSize(0.03);
 bcalTag->Draw();  
 TText *cdcTag = new TText(50,20,"CDC");
 cdcTag->SetTextSize(0.03);
 cdcTag->Draw();  
 TText *vtxTag = new TText(5,5,"VTX");
 vtxTag->SetTextSize(0.03);
 vtxTag->Draw();  
 TText *bvtTag = new TText(195,1,"BVT");
 bvtTag->SetTextSize(0.025);
 bvtTag->Draw();  
 TText *fdcTag = new TText(460,50,"FDC");
 fdcTag->SetTextSize(0.03);
 fdcTag->Draw();  
 TText *ftofTag = new TText(495,120,"FTOF");
 ftofTag->SetTextSize(0.03);
 ftofTag->Draw();
 TText *lgdTag = new TText(569,100,"LGD");
 lgdTag->SetTextSize(0.03);
 lgdTag->Draw();

 ///////////////////////
 //  SETUP XZ PAD
 //////////////////////
 xy_pad->cd();
 
 
 TArrow *zRef = new TArrow(-225,-100,-175,-100,0.01); // 0.5 meter
 TArrow *rRef = new TArrow(-225,-100,-225,-50,0.01); // 0.5 meter
 zRef->Draw();
 rRef->Draw();
 TText *zRefText = new TText(-170,-105,"x");
 TText *rRefText = new TText(-225,-48,"y");
 zRefText->SetTextSize(0.03);
 rRefText->SetTextSize(0.03);
 zRefText->Draw();
 rRefText->Draw();
 
 TText *xy_soletxt = new TText(-50,-140,"solenoid");
 
 xy_solenoid->Draw();
 xy_solenoidHole->Draw();
 xy_soletxt->Draw();
 
 for(Int_t i=0;i<nCharged;i++){
   //ptrack[i]->Draw();
   xytrack[i]->Draw();
 }
 for(Int_t i=0;i<nGammas;i++)
   xy_gammaTrack[i]->Draw();
 
 /////////////////////////
 // Add Title
 ///////////////////////////

 c1->cd();


 TText *txt = new TText(0.70,0.95,"Hall D ");
 txt->Draw();
 TText *txt = new TText(0.55,0.90,"Meson Spectrometer");
 txt->Draw();
 
 TText *txt = new TText(0.7,0.85,"Stage 1");
 txt->SetTextSize(0.03);
 txt->Draw();
 
 //TButton *next = new TButton("next event","txt->Dump()",0.6,0.1,0.8,0.15);
 // next->Draw();
 
 dbFile.close();
 f.Close();
 return 0;
 
 
}
