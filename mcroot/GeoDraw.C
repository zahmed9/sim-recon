int GeoDraw(char *geoFile="../HDFast/HDFast.db", float x1=-200, float y1=-250, float x2=650, float y2=250){
/**********************************************************
 *
 * This ia a simple macro to read in and display
 * MCFast geometries.
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * Created: 12-Nov-98
 *
 *******************************************************/

 /*
   * You must first the includes (but only once)
   * before executing drawDet.C (just cut and paste the 3 line below)
   *
   #include <iostream.h>
   #include <string.h>
   .x drawDet.C
   *
   */

  //gROOT.Reset();
#include <iostream.h>
#include <string.h>


  // Open the Geo File
  cout << "Opening The Geo File : "<<  geoFile<< endl;
  ifstream dbFile(geoFile); 
  if(dbFile.bad()){
    cerr<< "Failed to open Geo file\n";
    exit(-1);
  }
  
  //  
  TCanvas *c1 = new TCanvas("c1","MCFast GeoReader",100,10,800,700);
  c1->SetFillColor(18);
  c1->Range(x1,y1,x2,y2); // Set to Experimental coordinates

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
  TText *rRefText = new TText(-175,-48,"r");
  zRefText->SetTextSize(0.03);
  rRefText->SetTextSize(0.03);
  zRefText->Draw();
  rRefText->Draw();
  TText *title = new TText(-70,220,"Hall D Meson Spectrometer");
  TText *subtitle = new TText(70,-220,"Stage 1");
  title->SetTextColor(4);
  subtitle->SetTextColor(4);
  title->Draw();
  subtitle->Draw();


  // Magnet Geometry
  TBox *solenoid,*solenoidR;

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
  


 // Read geo file and look to detector description
 dbFile >>word;
 while(strcmp(word,"end") != 0 ){ // not EOF
   if(strcmp(word,"make")==0|| strcmp(word,"!%")==0){
     if(strcmp(word,"!%")==0)
       dbFile >>word;
     dbFile >>word;
     if(strcmp(word,"Solenoid")==0){ // make magnet geometry
       dbFile.getline(line,sizeof(line));
       cout <<"Solenoid "<<line<<endl;
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
       cout<< "Solenoid rmin:rmax " <<rmin<<":"<<rmax<<" zCenter:zLength: "
	   <<zCenter<<":"<<zLength<<endl;
       // Set coordinates
       z1= zCenter - zLength/2.0;
       z2= zCenter + zLength/2.0;
       r1= rmax;
       r2= 2*rmax;

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
       cout<< "Drift rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;     
     }
     else if(strcmp(word,"SiDisk")==0 ){// read silicon disk z position
       dbFile.getline(line,sizeof(line));
       cout<<line<<endl;
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
       cout<<line<<endl;
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

       // hdds-mcfast lists sidisk info. in reverse order
       float zpos = -1000.0;
		 for(int ii=0;ii<NSiDisks;ii++){
		 	if(SiDisk[ii].index == ptr)zpos = SiDisk[ii].zpos;
		 }

       z1= zpos +  zCenter - rthick/2.0;
       z2= zpos +  zCenter + rthick/2.0;
       r1= rmin;
       r2= rmax; 
       

       SiLine[NsiLayer] = new TLine(z1,r1,z1,r2);
       SiLineR[NsiLayer] = new TLine(z1,-r1,z1,-r2);
       NsiLayer++;
     
       cout<<ptr<<" "<<"SiBox["<<NsiLayer<<"] ("
	   <<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;
     }
     else if(strcmp(word,"BeamVrtx")==0 ){// make kludged target
       dbFile.getline(line,sizeof(line));
       cout<<line<<endl;
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
       cout<<line<<endl;
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
       cout<< "Absorber rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl;     
     }
     else if(strcmp(word,"EMCal")==0|| strcmp(word,"CalorBox")==0  ){// make cyl calor
       // strcmp(word,"CalorBox")==0 
            dbFile.getline(line,sizeof(line));
       cout<<line<<endl;
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
       cout<<"zLen is "<<zLength<<endl;
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
       cout<< "Cylindrical Calorimeter rmin: "<<rmin<<" rmax: " <<rmax
	    <<" zCenter: "<<zCenter<<" zLength: "<<zLength
	    <<"("<<z1<<","<<r1<<";"<<z2<<","<<r2<<")"<<endl; 
     }
     else dbFile.getline(line,sizeof(line)); 
   }
   else dbFile.getline(line,sizeof(line)); 
   dbFile >>word;
   
 }
 
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

 return 0;
 

}
