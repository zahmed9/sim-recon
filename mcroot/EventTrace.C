{



 ////////////////////////////////////////
 // 
 // Get an event to display
 //
 ////////////////////////////////////

 // open the dat file
cout<<"Opening "<<rdtFile<<" for data input\n";
 TFile f(rdtFile);

 // get the event tree from the data file
 TTree *tree = (TTree*)f.Get("T");
 

 // get all branches
 TBranch *b1 = tree->GetBranch("hepevt");
//TBranch *b2 = tree->GetBranch("traces");
 TBranch *b3 = tree->GetBranch("offtrk");
 TBranch *b4 = tree->GetBranch("bcal");
 TBranch *b5 = tree->GetBranch("lgdSmears");
 Double_t parms[3];

 // define object pointers
 TMCFastHepEvt *hepevt;
// TMCFastTOF *trace; 
 TMCFastOfflineTrack *offtrk;  
 hepevt = new TMCFastHepEvt();
//trace = new TMCFastTOF();
 offtrk = new TMCFastOfflineTrack();
 bcal = new TMCFastCalorimeter();
 lgdSmears = new TLGDsmears();
 Int_t colNum=2;
 
 // tell the branch were to put the event objects 
 b1->SetAddress(&hepevt);
//b2->SetAddress(&trace);
 b3->SetAddress(&offtrk);
 b4->SetAddress(&bcal);
 b5->SetAddress(&lgdSmears); 
 
 Int_t nentries = (Int_t)tree->GetEntries();
 // get this event.
 
cout<<"tracing event number: "<<ev<<endl;
 tree->GetEvent(++ev);
 
 // make virtual branch from the other branches
 TMCesr *esr=0;
 esr = new TMCesr(*hepevt,*offtrk,*lgdSmears,*bcal);
 Int_t n_particles=esr->GetNparticles();
//cout<< n_particles <<endl;
 TIter nextMC(esr->GetParticles());
 
 Int_t nGammas=0,nCharged=0;

 Float_t tx[2],ty[2],tz[2];
        
 Int_t nPoints=80000;
 Float_t ctrk_z[80000],ctrk_x[80000],ctrk_y[80000];
 
 
 for(Int_t i=0;i<n_particles;i++){
   
   TMCParticle *particle = ( TMCParticle *)nextMC();
   //particle->Print(&cout);
   //
   // Get particle's vertex (Xo,Yo,Zo)
    //
   Double_t q= (Double_t)(particle->GetCharge());
   tz[0]= particle->GetZ();
   tx[0]= particle->GetX();
   ty[0]= particle->GetY();
   
   //cout<<"(z0,x0,z1,x1): ("<<tz[0]<<","<<tx[0]<<","<<tz[1]<<","
   //  <<tx[1]<<")"<<endl;
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
          
     if(xz_gammaTrack[nGammas])
       delete xz_gammaTrack[nGammas];
     if(yz_gammaTrack[nGammas])
       delete yz_gammaTrack[nGammas];
     if(xy_gammaTrack[nGammas])
       delete xy_gammaTrack[nGammas];
     c1->Update();
    

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
     //Double_t parms[3];
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
     int ctrk_nPoints=0;
     for(Int_t j=0;j<nPoints ;j++){
       ctrk_z[j] = ztrace->Eval(((Double_t)(j)) /1e10);
       ctrk_x[j] = Xc + xtrace->Eval(((Double_t)(j))/1e10);
       ctrk_y[j] = Yc + ytrace->Eval(((Double_t)(j))/1e10);
       ctrk_nPoints++;
       if( ctrk_z[j]> 600)
	 j=nPoints;
       /*
	 cout<<"j: "<<j<<" t: "<<((Double_t)(j))/1e9<<endl;
	 cout<<"(x,y,z) ("<<ctrk_x[j]<<","<<ctrk_y[j]<<","<<ctrk_z[j]<<")\n";
	 cout<<"(x,y,) ("<<R*cos(omega*( ((Double_t)(j))/1e9)+phi)
	 <<","<<R*sin(omega*( ((Double_t)(j))/1e9)+phi)
	 <<endl;
       */
       
     }
     
     if(xztrack[nCharged])
	delete xztrack[nCharged];
     if(yztrack[nCharged])
	delete yztrack[nCharged];
     if(xytrack[nCharged])
	delete xytrack[nCharged];

     c1->Update();
     
     
     
     xztrack[nCharged] = new TPolyLine(ctrk_nPoints,ctrk_z,ctrk_x);
     yztrack[nCharged] = new TPolyLine(ctrk_nPoints,ctrk_z,ctrk_y);
     xytrack[nCharged] = new TPolyLine(ctrk_nPoints,ctrk_x,ctrk_y);

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
 for(Int_t i=0;i<nCharged;i++){
   //ptrack[i]->Draw();
   yztrack[i]->Draw();
 }
 for(Int_t i=0;i<nGammas;i++)
   yz_gammaTrack[i]->Draw();

 ///////////////////////
 //  SETUP XZ PAD
 //////////////////////
 xy_pad->cd();

 
 for(Int_t i=0;i<nCharged;i++){
   //ptrack[i]->Draw();
   xytrack[i]->Draw();
 }
 for(Int_t i=0;i<nGammas;i++)
   xy_gammaTrack[i]->Draw();

//
// Add event dumper
//
c1->cd(); 
Char_t evtstr[50];
sprintf(evtstr,"Event: %d\0",ev);
TPaveLabel  evttxt(0.85,0.2,0.95,0.23,evtstr);
//evttxt.SetTextSize(0.03);
evttxt.SetTextColor(6);
evttxt.Draw();

TPad *dump_pad = new TPad("dump_pad","dumps",0.50,0.02,0.75,0.3,22);
dump_pad->Draw();
dump_pad->cd();
TButton *dumpButton = new TButton("Print Event Info",".x EventDump.C",0.05,0.80,0.95,0.95);
dumpButton->Draw();
TText itxt(0.1,0.75,"click on data groups to exclude");
itxt.SetTextSize(0.06);
itxt.Draw();
TText iitxt(0.1,0.05,"black box = on;  white box = off");
iitxt.SetTextSize(0.06);
iitxt.Draw();


Int_t sw_esr=0,esr_on=1;
Int_t sw_hepevt=0,hepevt_on=1;
Int_t sw_trace=0,trace_on=1;
Int_t sw_offtrk=0,offtrk_on=1;
Int_t sw_bcal=0,bcal_on=1;
Int_t sw_lgdSmears=0,lgdSmears_on=1;

TButton *esrCB = new TButton("esr","{esrCB->SetFillColor(esr_on=sw_esr++%2 );esrCB->SetTextColor(esr_on+4); }",0.1,0.6,0.35,0.7);
esrCB->SetFillColor(esr_on);
esrCB->SetTextColor(5);
esrCB->SetTextSize(0.5);
TButton *hepevtCB = new TButton("hepevt","{hepevtCB->SetFillColor(hepevt_on=sw_hepevt++%2 );hepevtCB->SetTextColor(hepevt_on+4); }",0.55,0.6,0.8,0.7);
hepevtCB->SetFillColor(hepevt_on);
hepevtCB->SetTextColor(5);
hepevtCB->SetTextSize(0.5);
TButton *traceCB = new TButton("traces","{traceCB->SetFillColor(trace_on=sw_trace++%2 );traceCB->SetTextColor(trace_on+4); }",0.1,0.4,0.35,0.5);
traceCB->SetFillColor(trace_on);
traceCB->SetTextColor(5);
traceCB->SetTextSize(0.5);
TButton *offtrkCB = new TButton("trks","{offtrkCB->SetFillColor(offtrk_on=sw_offtrk++%2 );offtrkCB->SetTextColor(offtrk_on+4); }",0.55,0.4,0.8,0.5);
offtrkCB->SetFillColor(offtrk_on);
offtrkCB->SetTextColor(5);
offtrkCB->SetTextSize(0.5);
TButton *bcalCB = new TButton("bcal","{bcalCB->SetFillColor(bcal_on=sw_bcal++%2 );bcalCB->SetTextColor(bcal_on+4); }", 0.1,0.2,0.35,0.3);
bcalCB->SetFillColor(bcal_on);
bcalCB->SetTextColor(5);
bcalCB->SetTextSize(0.5);
TButton *lgdSmearsCB = new TButton("lgd","{lgdSmearsCB->SetFillColor(lgdSmears_on=sw_lgdSmears++%2 );lgdSmearsCB->SetTextColor(lgdSmears_on +4); }",0.55,0.2,0.8,0.3);
lgdSmearsCB->SetFillColor(lgdSmears_on);
lgdSmearsCB->SetTextColor(5);
lgdSmearsCB->SetTextSize(0.5);

esrCB->Draw();
hepevtCB->Draw();
traceCB->Draw(); 
offtrkCB->Draw();
bcalCB->Draw();
lgdSmearsCB->Draw();

//TSlider *dump = new TSlider("dump","dumpMe",0.65,0.02,0.75,0.08);
//TText *dumptxt = new TText(0.65,0.09,"dump event");
//dumptxt->SetTextSize(0.03);
//dumptxt->Draw();
//dump->SetMethod(".x EventDump.C");

}
