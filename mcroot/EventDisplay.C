{
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

   char *rdtFile="draw.rdt";
 
 char *geoFile="/home/halld/src/HDFast/HDFast.db";
  
//  gROOT.Reset();
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
  xz_pad->Range(-20,-250,650,250);
  yz_pad->Range(-20,-250,650,250);
  xy_pad->Range(-200,-200,200,200);

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

  // Cylindrical Calorimeter Geometry
  TBox *calor[100],*calorR[100],;
  Int_t calorNum=0;

  // Cerenkov
  TBox *cerenkov,*cerenkovR;

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
       token = strtok(NULL," "); // nlayer
       token = strtok(NULL," "); // zpos
       SiDisk[NSiDisks].zpos = atof(token);
       NSiDisks++;
 
     } 
     else if(strcmp(word,"KludgeAnnulus")==0 ){// read cerenkov parameters
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// "name"
       token = strtok(NULL," "); // Rmin
       rmin = atof(token);
       token = strtok(NULL," "); // Rmax
       rmax = atof(token);
       token = strtok(NULL," "); // zLength
       zLength = atof(token);
       token = strtok(NULL," "); // zCenter
       zCenter = atof(token);
       cerenkov = new TBox(zCenter-zLength/2.0,rmin,zCenter+zLength/2.0,rmax);
       cerenkov->SetFillColor(7);
       cerenkovR = new TBox(zCenter-zLength/2.0,-rmin,zCenter+zLength/2.0,-rmax);
       cerenkovR->SetFillColor(7);
       
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
       Int_t color = 5; //yellow
       dbFile.getline(line,sizeof(line));
       if(Dump) cout<<line<<endl;
       token = strtok(line," ");// name
       if(strcmp(token,"\"CERENKOV\"")==0 )
	 color = 7; //aqua
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
       absorber[absorberNum]->SetFillColor(color); 
       absorberR[absorberNum]->SetFillColor(color); 
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
  


 // Now have the objects draw themselves
 solenoid->Draw();
 solenoidR->Draw();
 target->Draw();
 cerenkov->Draw();
 cerenkovR->Draw();
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
   if(absorber[j]->GetFillColor() ==5){
     absorber[j]->Draw();
     absorberR[j]->Draw();
   }
 }

 TArrow *zRef = new TArrow(550,-225,600,-225,0.01); // 0.5 meter
 TArrow *rRef = new TArrow(550,-225,550,-175,0.01); // 0.5 meter 
 zRef->Draw();
 rRef->Draw();
 TText *zRefText = new TText(605,-225,"z");
 TText *rRefText = new TText(550,-170,"x");
 zRefText->SetTextSize(0.03);
 rRefText->SetTextSize(0.03);
 zRefText->Draw();
 rRefText->Draw();


 ///////////////////////
 //  SETUP YZ PAD
 //////////////////////
 yz_pad->cd();
   // Make center line with mark at zero
  TLine *centerLine = new TLine(-20,0,500,0);
  TLine *centerMark = new TLine(50,-1,50,1);
  centerLine->SetLineColor(1);
  centerMark->SetLineColor(1);
  centerLine->Draw();
  centerMark->Draw();
  

 // Now have the objects draw themselves
 solenoid->Draw();
 solenoidR->Draw();
 target->Draw();
 cerenkov->Draw();
 cerenkovR->Draw();
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
   if(absorber[j]->GetFillColor() ==5){
     absorber[j]->Draw();
     absorberR[j]->Draw();
   }
 }

 ///
 /// Added detector labels
 ///
//TText *title = new TText(-70,220,"Hall D Meson Spectrometer");
//TText *subtitle = new TText(70,-220,"Stage 1");
//title->SetTextColor(4);
//subtitle->SetTextColor(4);
//title->Draw();
//subtitle->Draw();
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
 TText *fdcTag = new TText(410,50,"FDC");
 fdcTag->SetTextSize(0.03);
 fdcTag->Draw(); 
 TText *cerenkovTag = new TText(470,50,"Ceren");
 cerenkovTag->SetTextSize(0.03);
 cerenkovTag->Draw(); 
 TText *ftofTag = new TText(495,120,"FTOF");
 ftofTag->SetTextSize(0.03);
 ftofTag->Draw();
 TText *lgdTag = new TText(569,100,"LGD");
 lgdTag->SetTextSize(0.03);
 lgdTag->Draw();

 TArrow *zRef = new TArrow(550,-225,600,-225,0.01); // 0.5 meter
 TArrow *rRef = new TArrow(550,-225,550,-175,0.01); // 0.5 meter 
 zRef->Draw();
 rRef->Draw();
 TText *zRefText = new TText(605,-225,"z");
 TText *rRefText = new TText(550,-170,"y");
 zRefText->SetTextSize(0.03);
 rRefText->SetTextSize(0.03);
 zRefText->Draw();
 rRefText->Draw();


 ///////////////////////
 //  SETUP XY PAD
 //////////////////////
 xy_pad->cd();
 
 TArrow *zRef = new TArrow(-180,-180,-130,-180,0.01); // 0.5 meter
 TArrow *rRef = new TArrow(-180,-180,-180,-130,0.01); // 0.5 meter

 zRef->Draw();
 rRef->Draw();
 TText *zRefText = new TText(-125,-180,"x");
 TText *rRefText = new TText(-180,-125,"y");
 zRefText->SetTextSize(0.03);
 rRefText->SetTextSize(0.03);
 zRefText->Draw();
 rRefText->Draw();
 
 TText *xy_soletxt = new TText(-50,-140,"solenoid");
 
 xy_solenoid->Draw();
 xy_solenoidHole->Draw();
 xy_soletxt->Draw();

 
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

//TButton *next = new TButton("next event",".q",0.6,0.1,0.8,0.15);
//next->Draw();
 
 dbFile.close();
 Int_t ev =0;
 // define a place to put the particle trajectories
 TLine *xz_gammaTrack[10];
 TLine *yz_gammaTrack[10];
 TLine *xy_gammaTrack[10];

 TPolyLine *xztrack[10];
 TPolyLine *yztrack[10];
 TPolyLine *xytrack[10];

for (Int_t i=0; i<10;i++){
  xz_gammaTrack[i]=0;
  yz_gammaTrack[i]=0;
  xy_gammaTrack[i]=0;
  xztrack[i]=0;
  yztrack[i]=0;
  xytrack[i]=0;
}


TButton *evtButton = new TButton("Get Event",".x EventTrace.C",0.8,0.02,0.98,0.08);
evtButton->Draw();

//TSlider *xslider = new TSlider("xslider","xxxxxx",0.8,0.02,0.98,0.08);
//TText *xslidertxt = new TText(0.85,0.09,"next event");
// xslidertxt->SetTextSize(0.03);
//xslidertxt->Draw();
//xslider->SetMethod(".x EventTrace.C");
  c1->SetEditable(kIsNotEditable);
}
