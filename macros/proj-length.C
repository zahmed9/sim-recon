{
//***********************************************
//** length-proj.C : Root Macro
//**
//** Author:        Curtis A. Meyer
//** Creation Date: 25 February 1999
//**
//***********************************************

//
//Begin_Html
/*
<a href= "smearedTOF.gif" >
Here is the output using smeared momentum in the calculation</a>
<a href= "tracedTOF.gif" >
Here is the output for using the trace point momentum   </a>

*/
//End_Html

gROOT->Reset();
gSystem->Load("libTMCFast.so"); 
#include <iostream.h>
#include <string.h>

//** Set some global graphics options:

gStyle.SetPadBottomMargin(0.15);  //** Leave a bit extra space on the bottom.
gStyle.SetPadLeftMargin(0.15);    //** Leave a bit extra space on the left
gStyle.SetPadRightMargin(0.05);    //** Leave a bit extra space on the left
gStyle.SetTitleOffset(1.5,"X");   //** 
gStyle.SetTitleOffset(1.5,"Y");   //** 
gStyle.SetTitleOffset(1.5,"Z");   //** 
gStyle.SetOptTitle(1);            //** Turn on histogram titles:

//** Open the histogram file: 

TFile f("leng-hist.root");

// book histograms for storing the tracked information:

TPaveLabel *title;   // Create a pave lable for global titles

Float_t tof_er[10] = { 0,0,0,0,0,0,0,0,0,0 };

//**   sigma are the error in path length (cm)

Float_t sigma[10]  = { 0, .25 , .5 , .75, 1 , 1.25, 1.5 , 2 , 2.5 , 5 };

Float_t sig_plt[10];
for ( Int_t i=0; i<10; i++){sig_plt[i] = sigma[i];}

Int_t type=111;  //portrait  ps
//Int_t type=112;  //landscape ps
//Int_t type=113;  //eps

//** Set the limits for plotting resolution as a function of
//** tof resolution.

Float_t min_avg[6],max_avg[6];
min_avg[0] = 0.00; max_avg[0]=0.50;
min_avg[1] = 0.40; max_avg[1]=0.90;
min_avg[2] = 0.80; max_avg[2]=1.20;
min_avg[3] = 0.00; max_avg[3]=0.50;
min_avg[4] = 0.40; max_avg[4]=0.90;
min_avg[5] = 0.80; max_avg[5]=1.20;

Float_t min_sig[6],max_sig[6];
min_sig[0] = 0.00; max_sig[0]=0.30;
min_sig[1] = 0.00; max_sig[1]=0.30;
min_sig[2] = 0.00; max_sig[2]=0.30;
min_sig[3] = 0.00; max_sig[3]=0.30;
min_sig[4] = 0.00; max_sig[4]=0.30;
min_sig[5] = 0.00; max_sig[5]=0.30;

//** Create and array of colors for the histograms:

Int_t color[10] = {4,46,2,3,4,7,8,6,5,9};

//** Create an array of markers for the histograms:

Int_t marker[10] = {21,21,21,21,21,21,21,21,21,21};

//** Create arrays to store the sigmas in:

Float_t sig_k_c[10],sig_p_c[10],sig_n_c[10];
Float_t sig_k_f[10],sig_p_f[10],sig_n_f[10];

//** Create arrays to store the means in:

Float_t avg_k_c[10],avg_p_c[10],avg_n_c[10];
Float_t avg_k_f[10],avg_p_f[10],avg_n_f[10];

//** Create arrays to keep track of statistics in:

Float_t good_k_c[10],good_p_c[10],good_n_c[10];  //** Number of events
Float_t good_k_f[10],good_p_f[10],good_n_f[10];

Float_t proj_k_c[10],proj_p_c[10],proj_n_c[10];  //** Number that look like
Float_t proj_k_f[10],proj_p_f[10],proj_n_f[10];  //** kaons via mass window.
Float_t erproj_k_c[10],erproj_p_c[10],erproj_n_c[10];  //** Number that look like
Float_t erproj_k_f[10],erproj_p_f[10],erproj_n_f[10];  //** kaons via mass window.

Double_t par[3];

char hname[32];
char htitle[32];
char cut1[128],cut1k[128];
char cut2[128],cut2k[128];
char cut3[128],cut3k[128];
char cut4[128];
char var[4];

//** Set up arrays of 1d histograms:

TH1F *kch[10],*pch[10],*nch[10],*ach[10];
TH1F *kfh[10],*pfh[10],*nfh[10],*afh[10];

for ( Int_t i=0; i<10; i++) {

  sprintf(hname,  "ck%d",i);
  sprintf(htitle, "Central Kaon [%d.d cm]",sigma[i]);
  
  kch[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  kch[i]->SetMarkerColor(color[i]);
  kch[i]->SetLineColor(color[i]);
  kch[i]->SetMarkerStyle(marker[i]);
  kch[i]->SetMarkerSize(0.5);

  sprintf(hname,  "cp%d",i);
  sprintf(htitle, "Central Pion [%d.d cm]",sigma[i]);

  pch[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  pch[i]->SetMarkerColor(color[i]);
  pch[i]->SetLineColor(color[i]);
  pch[i]->SetMarkerStyle(marker[i]);
  pch[i]->SetMarkerSize(0.5);

  sprintf(hname,  "cn%d",i);
  sprintf(htitle, "Central Proton [%d.d cm]",sigma[i]);

  nch[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  nch[i]->SetMarkerColor(color[i]);
  nch[i]->SetLineColor(color[i]);
  nch[i]->SetMarkerStyle(marker[i]);
  nch[i]->SetMarkerSize(0.5);

  sprintf(hname,  "ca%d",i);
  sprintf(htitle, "All Central [%d.d cm]",sigma[i]);

  ach[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  ach[i]->SetMarkerColor(color[i]);
  ach[i]->SetLineColor(color[i]);
  ach[i]->SetMarkerStyle(marker[i]);
  ach[i]->SetMarkerSize(0.5);

  sprintf(hname,  "fk%d",i);
  sprintf(htitle, "Forward Kaon [%d.d cm]",sigma[i]);
  
  kfh[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  kfh[i]->SetMarkerColor(color[i]);
  kfh[i]->SetLineColor(color[i]);
  kfh[i]->SetMarkerStyle(marker[i]);
  kfh[i]->SetMarkerSize(0.5);

  sprintf(hname,  "fp%d",i);
  sprintf(htitle, "Forward Pion [%d.d cm]",sigma[i]);

  pfh[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  pfh[i]->SetMarkerColor(color[i]);
  pfh[i]->SetLineColor(color[i]);
  pfh[i]->SetMarkerStyle(marker[i]);
  pfh[i]->SetMarkerSize(0.5);

  sprintf(hname,  "fn%d",i);
  sprintf(htitle, "Forward Proton [%d.d cm]",sigma[i]);

  nfh[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  nfh[i]->SetMarkerColor(color[i]);
  nfh[i]->SetLineColor(color[i]);
  nfh[i]->SetMarkerStyle(marker[i]);
  nfh[i]->SetMarkerSize(0.5);

  sprintf(hname,  "fa%d",i);
  sprintf(htitle, "All Forward [%d.d cm]",sigma[i]);

  afh[i] = new TH1F(hname,htitle,100, 0.00, 1.30);
  afh[i]->SetMarkerColor(color[i]);
  afh[i]->SetLineColor(color[i]);
  afh[i]->SetMarkerStyle(marker[i]);
  afh[i]->SetMarkerSize(0.5);

}

//** Create a dummy histogram for counting "kaons"

TH1F *kaons = new TH1F("kaons","Kaon Window",100,0.40,0.60);

//** Create a gaussian gunction for fitting.

g1 = new TF1("g1","gaus");

//**
//** Set up a loop over all the data, and project out things
//**

for ( Int_t i=0; i<10; i++){

  sprintf(var   , "mc%d",i);
  sprintf(cut1  , "((id==211)||(id==-211))&&(mc%d >0)&&(mc%d <2)",i,i);
  sprintf(cut2  , "((id==321)||(id==-321))&&(mc%d >0)&&(mc%d <2)",i,i);
  sprintf(cut3  , "(id==2212)&&(mc%d >0)&&(mc%d <2)",i,i);
  sprintf(cut4  , "(mc%d >0)&&(mc%d <2)",i,i);
  sprintf(cut1k , "((id==211)||(id==-211))&&(mc%d >0.4)&&(mc%d <0.6)",i,i);
  sprintf(cut2k , "((id==321)||(id==-321))&&(mc%d >0.4)&&(mc%d <0.6)",i,i);
  sprintf(cut3k , "(id==2212)&&(mc%d >0.4)&&(mc%d <0.6)",i,i);


  //** Project out the masses in the central region, and at the 
  //** same time, fit each histogram to a Gaussiam and then save
  //** the means and sigmas.

  sprintf(hname, "ck%d",i);
  ms_tup.Project(hname,var,cut2);

  kch[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_k_c[i]  = (Float_t)par[1];
  sig_k_c[i]  = (Float_t)par[2];
  good_k_c[i] = (Float_t)kch[i].GetEntries(); 

  ms_tup.Project("kaons",var,cut2k);
  proj_k_c[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "cp%d",i);
  ms_tup.Project(hname,var,cut1);

  pch[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_p_c[i] = (Float_t)par[1];
  sig_p_c[i] = (Float_t)par[2];
  good_p_c[i] = (Float_t)pch[i].GetEntries(); 

  kaons.Reset();
  ms_tup.Project("kaons",var,cut1k);
  proj_p_c[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "cn%d",i);
  ms_tup.Project(hname,var,cut3);

  nch[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_n_c[i] = (Float_t)par[1];
  sig_n_c[i] = (Float_t)par[2];
  good_n_c[i] = (Float_t)nch[i].GetEntries(); 

  kaons.Reset();
  ms_tup.Project("kaons",var,cut3k);
  proj_n_c[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "ca%d",i);
  ms_tup.Project(hname,var,cut4);

  sprintf(var   , "mf%d",i);
  sprintf(cut1  , "((id==211)||(id==-211))&&(mf%d >0)&&(mf%d <2)",i,i);
  sprintf(cut2  , "((id==321)||(id==-321))&&(mf%d >0)&&(mf%d <2)",i,i);
  sprintf(cut3  , "(id==2212)&&(mf%d >0)&&(mf%d <2)",i,i);
  sprintf(cut4  , "(mf%d >0)&&(mf%d <2)",i,i);
  sprintf(cut1k , "((id==211)||(id==-211))&&(mf%d >0.4)&&(mf%d <0.6)",i,i);
  sprintf(cut2k , "((id==321)||(id==-321))&&(mf%d >0.4)&&(mf%d <0.6)",i,i);
  sprintf(cut3k , "(id==2212)&&(mf%d >0.4)&&(mf%d <0.6)",i,i);

  
  //** Project out the masses in the forward region:
  
  sprintf(hname, "fk%d",i);
  ms_tup.Project(hname,var,cut2);

  kfh[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_k_f[i] = (Float_t)par[1];
  sig_k_f[i] = (Float_t)par[2];
  good_k_f[i] = (Float_t)kfh[i].GetEntries(); 

  kaons.Reset();
  ms_tup.Project("kaons",var,cut2k);
  proj_k_f[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "fp%d",i);
  ms_tup.Project(hname,var,cut1);

  pfh[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_p_f[i] = (Float_t)par[1];
  sig_p_f[i] = (Float_t)par[2];
  good_p_f[i] = (Float_t)pfh[i].GetEntries(); 

  kaons.Reset();
  ms_tup.Project("kaons",var,cut1k);
  proj_p_f[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "fn%d",i);
  ms_tup.Project(hname,var,cut3);

  nfh[i].Fit("g1","N");
  g1.GetParameters(&par[0]);
  avg_n_f[i] = (Float_t)par[1];
  sig_n_f[i] = (Float_t)par[2];
  good_n_f[i] = (Float_t)nfh[i].GetEntries(); 

  kaons.Reset();
  ms_tup.Project("kaons",var,cut3k);
  proj_n_f[i] = (Float_t)kaons.GetEntries();

  sprintf(hname, "fa%d",i);
  ms_tup.Project(hname,var,cut4);
  
}
// now create some pads to put the histo's

c1 = new TCanvas("c1","Halld Time-of-Flight",100,10,700,700);
c1->SetFillColor(19);

//** Open a Postscript file for the Figures:

TPostScript *ps = new TPostScript("central-tof.ps",type);
ps->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.51,0.49,0.98,21);
pad2 = new TPad("pad2","Pad 2",0.51,0.51,0.95,0.98,21);
pad3 = new TPad("pad3","Pad 3",0.02,0.02,0.49,0.49,21);
pad4 = new TPad("pad4","Pad 4",0.51,0.02,0.98,0.49,21);

pad1->SetFillColor(18);
pad2->SetFillColor(18);
pad3->SetFillColor(18);
pad4->SetFillColor(18);

pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();

// Now draw the histograms

pad1->cd();
pch[1].Draw("p");
pch[2].Draw("p same ");
pch[3].Draw("p same ");
pch[4].Draw("p same ");
pch[5].Draw("p same ");
pch[6].Draw("p same ");
pch[7].Draw("p same ");
pch[8].Draw("p same ");
pch[9].Draw("p same ");

pad2->cd();
kch[1].Draw("p");
kch[2].Draw("p same ");
kch[3].Draw("p same ");
kch[4].Draw("p same ");
kch[5].Draw("p same ");
kch[6].Draw("p same ");
kch[7].Draw("p same ");
kch[8].Draw("p same ");
kch[9].Draw("p same ");

pad3->cd();
nch[1].Draw("p");
nch[2].Draw("p same ");
nch[3].Draw("p same ");
nch[4].Draw("p same ");
nch[5].Draw("p same ");
nch[6].Draw("p same ");
nch[7].Draw("p same ");
nch[8].Draw("p same ");
nch[9].Draw("p same ");

pad4->cd();
ach[1].Draw("p");
ach[2].Draw("p same ");
ach[3].Draw("p same ");
ach[4].Draw("p same ");
ach[5].Draw("p same ");
ach[6].Draw("p same ");
ach[7].Draw("p same ");
ach[8].Draw("p same ");
ach[9].Draw("p same ");

c1.Update();
ps->NewPage();
c1.Clear();

pad1 = new TPad("pad1","Pad 1",0.02,0.51,0.49,0.98,21);
pad2 = new TPad("pad2","Pad 2",0.51,0.51,0.95,0.98,21);
pad3 = new TPad("pad3","Pad 3",0.02,0.02,0.49,0.49,21);
pad4 = new TPad("pad4","Pad 4",0.51,0.02,0.98,0.49,21);

pad1->SetFillColor(18);
pad2->SetFillColor(18);
pad3->SetFillColor(18);
pad4->SetFillColor(18);

pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();

// Now draw the histograms

pad1->cd();
pfh[1].Draw("p");
pfh[2].Draw("p same ");
pfh[3].Draw("p same ");
pfh[4].Draw("p same ");
pfh[5].Draw("p same ");
pfh[6].Draw("p same ");
pfh[7].Draw("p same ");
pfh[8].Draw("p same ");
pfh[9].Draw("p same ");

pad2->cd();
kfh[1].Draw("p");
kfh[2].Draw("p same ");
kfh[3].Draw("p same ");
kfh[4].Draw("p same ");
kfh[5].Draw("p same ");
kfh[6].Draw("p same ");
kfh[7].Draw("p same ");
kfh[8].Draw("p same ");
kfh[9].Draw("p same ");

pad3->cd();
nfh[1].Draw("p");
nfh[2].Draw("p same ");
nfh[3].Draw("p same ");
nfh[4].Draw("p same ");
nfh[5].Draw("p same ");
nfh[6].Draw("p same ");
nfh[7].Draw("p same ");
nfh[8].Draw("p same ");
nfh[9].Draw("p same ");

pad4->cd();
afh[1].Draw("p");
afh[2].Draw("p same ");
afh[3].Draw("p same ");
afh[4].Draw("p same ");
afh[5].Draw("p same ");
afh[6].Draw("p same ");
afh[7].Draw("p same ");
afh[8].Draw("p same ");
afh[9].Draw("p same ");

Int_t n=8;
TGraph *t_sig[6], *t_avg[6];

t_avg[0] = new TGraph(n,sig_plt,avg_p_c);
t_avg[1] = new TGraph(n,sig_plt,avg_k_c);
t_avg[2] = new TGraph(n,sig_plt,avg_n_c);
t_avg[3] = new TGraph(n,sig_plt,avg_p_f);
t_avg[4] = new TGraph(n,sig_plt,avg_k_f);
t_avg[5] = new TGraph(n,sig_plt,avg_n_f);

t_sig[0] = new TGraph(n,sig_plt,sig_p_c);
t_sig[1] = new TGraph(n,sig_plt,sig_k_c);
t_sig[2] = new TGraph(n,sig_plt,sig_n_c);
t_sig[3] = new TGraph(n,sig_plt,sig_p_f);
t_sig[4] = new TGraph(n,sig_plt,sig_k_f);
t_sig[5] = new TGraph(n,sig_plt,sig_n_f);

for ( Int_t i=0;i<6;i++ ){
  t_avg[i]->SetLineColor(30);
  t_avg[i]->SetMarkerColor(8);
  t_avg[i]->SetMarkerStyle(20);
  t_avg[i]->SetMinimum(min_avg[i]);
  t_avg[i]->SetMaximum(max_avg[i]);
  if ( i==0 ) { t_avg[i]->SetTitle("Central `p# Mean Mass");}
  if ( i==1 ) { t_avg[i]->SetTitle("Central K Mean Mass");}
  if ( i==2 ) { t_avg[i]->SetTitle("Central p Mean Mass");}
  if ( i==3 ) { t_avg[i]->SetTitle("Forward `p# Mean Mass");}
  if ( i==4 ) { t_avg[i]->SetTitle("Forward K Mean Mass");}
  if ( i==5 ) { t_avg[i]->SetTitle("Forward p Mean Mass");}

  t_sig[i]->SetLineColor(28);
  t_sig[i]->SetMarkerColor(48);
  t_sig[i]->SetMarkerStyle(22);
  t_sig[i]->SetMinimum(min_sig[i]);
  t_sig[i]->SetMaximum(max_sig[i]);
  if ( i==0 ) { t_sig[i]->SetTitle("Central `p# Mass Reolution");}
  if ( i==1 ) { t_sig[i]->SetTitle("Central K Mass Reolution");}
  if ( i==2 ) { t_sig[i]->SetTitle("Central p Mass Reolution");}
  if ( i==3 ) { t_sig[i]->SetTitle("Forward `p# Mass Reolution");}
  if ( i==4 ) { t_sig[i]->SetTitle("Forward K Mass Reolution");}
  if ( i==5 ) { t_sig[i]->SetTitle("Forward p Mass Reolution");}
}

//** Draw the plots:

//** Generate a series of Graphs to contain the data:

c1.Update();
ps->NewPage();
c1.Clear();

pad1 = new TPad("pad1","Pad 1",0.02,0.67,0.49,0.98,21);
pad2 = new TPad("pad2","Pad 2",0.51,0.67,0.98,0.98,21);
pad3 = new TPad("pad3","Pad 3",0.02,0.34,0.49,0.65,21);
pad4 = new TPad("pad4","Pad 4",0.51,0.34,0.98,0.65,21);
pad5 = new TPad("pad5","Pad 5",0.02,0.02,0.49,0.32,21);
pad6 = new TPad("pad6","Pad 6",0.51,0.02,0.98,0.32,21);

pad1->SetFillColor(18);
pad2->SetFillColor(18);
pad3->SetFillColor(18);
pad4->SetFillColor(18);
pad5->SetFillColor(18);
pad6->SetFillColor(18);

pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();
pad5->Draw();
pad6->Draw();

pad1->cd();
pad1->GetFrame()->SetBorderSize(5);
t_sig[0]->Draw("ACP");
c1->Update();
t_sig[0]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[0]->GetHistogram()->SetYTitle("Mass Resolution [GeV/c^2!]");
pad2->cd();
pad2->GetFrame()->SetBorderSize(5);
t_avg[0]->Draw("ACP");
c1->Update();
t_avg[0]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[0]->GetHistogram()->SetYTitle("Mass [GeV/c^2!]");
pad3->cd();
pad3->GetFrame()->SetBorderSize(5);
t_sig[1]->Draw("ACP");
c1->Update();
t_sig[1]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[1]->GetHistogram()->SetYTitle("Mass Resolution [GeV/c^2!]");
pad4->cd();
pad4->GetFrame()->SetBorderSize(5);
t_avg[1]->Draw("ACP");
c1->Update();
t_avg[1]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[1]->GetHistogram()->SetYTitle("Mass [GeV/c^2!]");
pad5->cd();
pad5->GetFrame()->SetBorderSize(5);
t_sig[2]->Draw("ACP");
c1->Update();
t_sig[2]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[2]->GetHistogram()->SetYTitle("Mass Resolution [GeV/c^2!]");
pad6->cd();
pad6->GetFrame()->SetBorderSize(5);
t_avg[2]->Draw("ACP");
c1->Update();
t_avg[2]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[2]->GetHistogram()->SetYTitle("Mass [GeV/c^2!]");

c1.Update();
ps->NewPage();
c1.Clear();

//** Generate a series of Graphs to contain the data:

pad1 = new TPad("pad1","Pad 1",0.02,0.67,0.49,0.98,21);
pad2 = new TPad("pad2","Pad 2",0.51,0.67,0.98,0.98,21);
pad3 = new TPad("pad3","Pad 3",0.02,0.34,0.49,0.65,21);
pad4 = new TPad("pad4","Pad 4",0.51,0.34,0.98,0.65,21);
pad5 = new TPad("pad5","Pad 5",0.02,0.02,0.49,0.32,21);
pad6 = new TPad("pad6","Pad 6",0.51,0.02,0.98,0.32,21);

pad1->SetFillColor(18);
pad2->SetFillColor(18);
pad3->SetFillColor(18);
pad4->SetFillColor(18);
pad5->SetFillColor(18);
pad6->SetFillColor(18);

pad1->Draw();
pad2->Draw();
pad3->Draw();
pad4->Draw();
pad5->Draw();
pad6->Draw();

pad1->cd();
pad1->GetFrame()->SetBorderSize(5);
t_sig[3]->Draw("ACP");
c1->Update();
t_sig[3]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[3]->GetHistogram()->SetYTitle("Mass Resolution [GeV/c^2!]");
pad2->cd();
pad2->GetFrame()->SetBorderSize(5);
t_avg[3]->Draw("ACP");
c1->Update();
t_avg[3]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[3]->GetHistogram()->SetYTitle("Mass [GeV^2!]");
pad3->cd();
pad3->GetFrame()->SetBorderSize(5);
t_sig[4]->Draw("ACP");
c1->Update();
t_sig[4]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[4]->GetHistogram()->SetYTitle("Mass Resolution [GeV^2!]");
pad4->cd();
pad4->GetFrame()->SetBorderSize(5);
t_avg[4]->Draw("ACP");
c1->Update();
t_avg[4]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[4]->GetHistogram()->SetYTitle("Mass [GeV^2!]");
pad5->cd();
pad5->GetFrame()->SetBorderSize(5);
t_sig[5]->Draw("ACP");
c1->Update();
t_sig[5]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_sig[5]->GetHistogram()->SetYTitle("Mass Resolution [GeV^2!]");
pad6->cd();
pad6->GetFrame()->SetBorderSize(5);
t_avg[5]->Draw("ACP");
c1->Update();
t_avg[5]->GetHistogram()->SetXTitle("Length Resolution [cm]");
t_avg[5]->GetHistogram()->SetYTitle("Mass [GeV^2!]");

c1.Update();
ps->Close();
c1.Clear();

//** Create and encapsulated PostScript File:
type=113;

TPostScript *eps1 = new TPostScript("Fig1.eps",type);
eps1->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();

title = new TPaveLabel(0.90, 1.22, 2.00, 1.29,
		       "12.0 GeV (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);


TGraphErrors *grphpc = new TGraphErrors(n,sig_plt,avg_p_c,tof_er,sig_p_c);
grphpc->SetTitle("Central Mass Reolution");
grphpc->SetLineColor(38);
grphpc->SetMarkerColor(4);
grphpc->SetMarkerStyle(22);
grphpc->SetMinimum(0);
grphpc->SetMaximum(1.2);

TGraphErrors *grphkc = new TGraphErrors(n,sig_plt,avg_k_c,tof_er,sig_k_c);
grphkc->SetTitle("Central Mass Reolution");
grphkc->SetLineColor(46);
grphkc->SetMarkerColor(4);
grphkc->SetMarkerStyle(22);
grphkc->SetMinimum(0);
grphkc->SetMaximum(1.2);

TGraphErrors *grphnc = new TGraphErrors(n,sig_plt,avg_n_c,tof_er,sig_n_c);
grphnc->SetTitle("Central Mass Reolution");
grphnc->SetLineColor(30);
grphnc->SetMarkerColor(3);
grphnc->SetMarkerStyle(21);
grphnc->SetMinimum(0);
grphnc->SetMaximum(1.2);

grphpc->Draw("ALP");
c1->Update();
grphpc->GetHistogram()->SetTitleOffset(1.5,"X");
grphpc->GetHistogram()->SetTitleOffset(1.5,"Y");
grphpc->GetHistogram()->SetXTitle("Length Resolution [cm]");
grphpc->GetHistogram()->SetYTitle("Mass [GeV^2!]");
grphkc->Draw("LP");
grphnc->Draw("LP");

TText *ss = new TText();
ss->SetTextSize(0.045);
ss->SetTextColor(6);
ss->DrawText(0.1,1.1,"~l# Kaons");
ss->SetTextColor(4);
ss->DrawText(0.80,1.1,"~s# Pions");
ss->SetTextColor(3);
ss->DrawText(1.5,1.1,"~n# Protons");

title->Draw();

c1.Update();
eps1->Close();

c1.Clear();
TPostScript *eps2 = new TPostScript("Fig2.eps",type);
eps2->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();

title = new TPaveLabel(0.90,1.22,2.00,1.29,
		       "12.0 GeV (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);


TGraphErrors *grphpf = new TGraphErrors(n,sig_plt,avg_p_f,tof_er,sig_p_f);
grphpf->SetTitle("Forward Mass Reolution");
grphpf->SetLineColor(38);
grphpf->SetMarkerColor(4);
grphpf->SetMarkerStyle(22);
grphpf->SetMinimum(0);
grphpf->SetMaximum(1.2);

TGraphErrors *grphkf = new TGraphErrors(n,sig_plt,avg_k_f,tof_er,sig_k_f);
grphkf->SetTitle("Forward Mass Reolution");
grphkf->SetLineColor(46);
grphkf->SetMarkerColor(6);
grphkf->SetMarkerStyle(22);
grphkf->SetMinimum(0);
grphkf->SetMaximum(1.2);

TGraphErrors *grphnf = new TGraphErrors(n,sig_plt,avg_n_f,tof_er,sig_n_f);
grphnf->SetTitle("Forward Mass Reolution");
grphnf->SetLineColor(0);
grphnf->SetMarkerColor(3);
grphnf->SetMarkerStyle(21);
grphnf->SetMinimum(0);
grphnf->SetMaximum(1.2);

grphpf->Draw("ALP");
c1->Update();
grphpf->GetHistogram()->SetTitleOffset(1.5,"X");
grphpf->GetHistogram()->SetTitleOffset(1.5,"Y");
grphpf->GetHistogram()->SetXTitle("Time Resolution [ns]");
grphpf->GetHistogram()->SetYTitle("Mass [GeV^2!]");
grphkf->Draw("LP");
grphnf->Draw("LP");

TText *ts = new TText();
ts->SetTextSize(0.045);
ts->SetTextColor(6);
ts->DrawText(0.1,1.1,"~l# Kaons");
ts->SetTextColor(4);
ts->DrawText(0.8,1.1,"~s# Pions");
ts->SetTextColor(3);
ts->DrawText(1.5,1.1,"~n# Protons");

title->Draw();


//** Produce the overlap plots. First compute fractions for
//** the overlaps:

for ( Int_t i=0; i<10; i++ ) {

  erproj_p_c[i] = sqrt(proj_p_c[i])/good_p_c[i];
  erproj_k_c[i] = sqrt(proj_k_c[i])/good_k_c[i];
  erproj_n_c[i] = sqrt(proj_n_c[i])/good_n_c[i];

  erproj_p_f[i] = sqrt(proj_p_f[i])/good_p_f[i];
  erproj_k_f[i] = sqrt(proj_k_f[i])/good_k_f[i];
  erproj_n_f[i] = sqrt(proj_n_f[i])/good_n_f[i];

  proj_p_c[i] = proj_p_c[i]/good_p_c[i];
  proj_k_c[i] = proj_k_c[i]/good_k_c[i];
  proj_n_c[i] = proj_n_c[i]/good_n_c[i];

  proj_p_f[i] = proj_p_f[i]/good_p_f[i];
  proj_k_f[i] = proj_k_f[i]/good_k_f[i];
  proj_n_f[i] = proj_n_f[i]/good_n_f[i];

}

//** Now define the six needed graphs:

TGraphErrors *overlap[6];

overlap[0] = new TGraphErrors(n,sig_plt,proj_p_c,tof_er,erproj_p_c);
overlap[1] = new TGraphErrors(n,sig_plt,proj_k_c,tof_er,erproj_k_c);
overlap[2] = new TGraphErrors(n,sig_plt,proj_n_c,tof_er,erproj_n_c);
overlap[3] = new TGraphErrors(n,sig_plt,proj_p_f,tof_er,erproj_p_c);
overlap[4] = new TGraphErrors(n,sig_plt,proj_k_f,tof_er,erproj_k_c);
overlap[5] = new TGraphErrors(n,sig_plt,proj_n_f,tof_er,erproj_n_c);

for ( Int_t i=0; i<6; i++ ) {
  overlap[i]->SetMinimum(0);
  overlap[i]->SetMaximum(1);
  if ( i<3 ) {  overlap[i]->SetTitle("Central Fraction Seen as Kaons");}
  if ( i>2 ) {  overlap[i]->SetTitle("Forward Fraction Seen as Kaons");}
  if ( i==0 || i==3 ) { 
    overlap[i]->SetLineColor(38);
    overlap[i]->SetMarkerColor(4);
    overlap[i]->SetMarkerStyle(22);
  }    
  if ( i==1 || i==4 ) { 
    overlap[i]->SetLineColor(46);
    overlap[i]->SetMarkerColor(6);
    overlap[i]->SetMarkerStyle(20);
  }    
  if ( i==2 || i==5 ) { 
    overlap[i]->SetLineColor(30);
    overlap[i]->SetMarkerColor(3);
    overlap[i]->SetMarkerStyle(21);
  }    
}

c1.Update();
eps2->Close();

c1.Clear();
TPostScript *eps3 = new TPostScript("Fig3.eps",type);
eps3->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();

title = new TPaveLabel(1.10,1.04,2.10,1.10,
		       "12.0 GeV (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);


overlap[0]->Draw("ALP");
c1.Update();
overlap[0]->GetHistogram()->SetTitleOffset(1.5,"X");
overlap[0]->GetHistogram()->SetTitleOffset(1.5,"Y");
overlap[0]->GetHistogram()->SetXTitle("Length Resolution [cm]");
overlap[0]->GetHistogram()->SetYTitle("Kaon Overlap (percent)");
overlap[1]->Draw("LP");
overlap[2]->Draw("LP");

TText *t = new TText();
t->SetTextSize(0.045);
t->SetTextColor(6);
t->DrawText(0.2,0.80,"~l# Kaons");
t->SetTextColor(4);
t->DrawText(0.2,0.70,"~s# Pions");
t->SetTextColor(3);
t->DrawText(0.2,0.60,"~n# Protons");

title->Draw();

c1.Update();
eps3->Close();

c1.Clear();
TPostScript *eps4 = new TPostScript("Fig4.eps",type);
eps4->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();

title = new TPaveLabel(1.1,1.04,2.10,1.10,
		       "12.0 GeV (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);

overlap[3]->Draw("ALP");
c1.Update();
overlap[3]->GetHistogram()->SetTitleOffset(1.5,"X");
overlap[3]->GetHistogram()->SetTitleOffset(1.5,"Y");
overlap[3]->GetHistogram()->SetXTitle("Length Resolution [cm]");
overlap[3]->GetHistogram()->SetYTitle("Kaon Overlap (percent)");
overlap[4]->Draw("LP");
overlap[5]->Draw("LP");

TText *tt = new TText();
tt->SetTextSize(0.045);
tt->SetTextColor(6);
tt->DrawText(0.2,0.80,"~l# Kaons");
tt->SetTextColor(4);
tt->DrawText(0.2,0.70,"~s# Pions");
tt->SetTextColor(3);
tt->DrawText(0.2,0.60,"~n# Protons");

title->Draw();

c1.Update();
eps4->Close();

c1.Clear();
TPostScript *eps5 = new TPostScript("Fig5.eps",type);
eps5->NewPage();

gStyle.SetOptTitle(0);            //** Turn off histogram titles:

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();
gStyle->SetOptStat(0);

title = new TPaveLabel(0.0 , 15100 , 1.3 , 16100 ,
		       "12.0 GeV Central (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);

ach[1].SetMinimum(0);
ach[1].SetMaximum(15000);

ach[1].Draw("p");
ach[1].Draw("same");
ach[1]->SetTitleOffset(1.5,"X");
ach[1]->SetTitleOffset(1.9,"Y");
ach[1]->SetXTitle("Mass [GeV/c^2!]");
ach[1]->SetYTitle("Entries per 0.013 GeV/c^2!");
ach[2].Draw("p same");
ach[2].Draw("same");
ach[3].Draw("p same");
ach[3].Draw("same");
ach[4].Draw("p same");
ach[4].Draw("same");
ach[5].Draw("p same");
ach[5].Draw("same");
ach[6].Draw("p same");
ach[6].Draw("same");
ach[7].Draw("p same");
ach[7].Draw("same");
ach[8].Draw("p same");
ach[8].Draw("same");
ach[9].Draw("p same");
ach[9].Draw("same");

TText *aa = new TText();
aa->SetTextSize(0.040);
aa->SetTextColor(46);
aa->DrawText(0.10,14000,"~n# 0.25 cm");
aa->SetTextColor(2);
aa->DrawText(0.10,13200,"~n# 0.50 cm");
aa->SetTextColor(3);
aa->DrawText(0.10,12400,"~n# 0.75 cm");
aa->SetTextColor(4);
aa->DrawText(0.10,11600,"~n# 1.00 cm");
aa->SetTextColor(7);
aa->DrawText(0.10,10800,"~n# 1.25 cm");
aa->SetTextColor(8);
aa->DrawText(0.10,10000,"~n# 1.50 cm");
aa->SetTextColor(6);
aa->DrawText(0.10,9200,"~n# 2.00 cm");
aa->SetTextColor(5);
aa->DrawText(0.10,8400,"~n# 2.50 cm");
aa->SetTextColor(9);
aa->DrawText(0.10,7600,"~n# 5.00 cm");

title->Draw();

c1.Update();
eps5->Close();

c1.Clear();
TPostScript *eps6 = new TPostScript("Fig6.eps",type);
eps6->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();
gStyle->SetOptStat(0);

title = new TPaveLabel( 0.0 , 15100 , 1.3 , 16100 ,
			"12.0 GeV Forward (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);

afh[1].SetMinimum(0);
afh[1].SetMaximum(15000);

afh[1].Draw("p");
afh[1].Draw("same");
afh[1]->SetTitleOffset(1.5,"X");
afh[1]->SetTitleOffset(1.9,"Y");
afh[1]->SetXTitle("Mass [GeV/c^2!]");
afh[1]->SetYTitle("Entries per 0.013 GeV/c^2!");
afh[2].Draw("p same");
afh[2].Draw("same");
afh[3].Draw("p same");
afh[3].Draw("same");
afh[4].Draw("p same");
afh[4].Draw("same");
afh[5].Draw("p same");
afh[5].Draw("same");
afh[6].Draw("p same");
afh[6].Draw("same");
afh[7].Draw("p same");
afh[7].Draw("same");
afh[8].Draw("p same");
afh[8].Draw("same");
afh[9].Draw("p same");
afh[9].Draw("same");

TText *af = new TText();
af->SetTextSize(0.040);
af->SetTextColor(46);
af->DrawText(0.90,14000,"~n# 0.25 cm");
af->SetTextColor(2);
af->DrawText(0.90,13200,"~n# 0.50 cm");
af->SetTextColor(3);
af->DrawText(0.90,12400,"~n# 0.75 cm");
af->SetTextColor(4);
af->DrawText(0.90,11600, "~n# 1.00 cm");
af->SetTextColor(7);
af->DrawText(0.90,10800, "~n# 1.25 cm");
af->SetTextColor(8);
af->DrawText(0.90,10000, "~n# 1.50 cm");
af->SetTextColor(6);
af->DrawText(0.90,9200,"~n# 2.00 cm");
af->SetTextColor(5);
af->DrawText(0.90,8400,"~n# 2.50 cm");
af->SetTextColor(9);
af->DrawText(0.90,7600,"~n# 5.00 cm");

title->Draw();

c1.Update();
eps6->Close();

c1.Clear();
TPostScript *eps7 = new TPostScript("Fig7.eps",type);
eps7->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();
gStyle->SetOptStat(0);

title = new TPaveLabel(0.1 , 25400 , 1.2 , 27000 ,
		       "12.0 GeV Central (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);

ach[0].SetMinimum(0);
ach[0].SetMaximum(25000);

ach[0].Draw("p");
ach[0].Draw("same");
ach[0]->SetTitleOffset(1.5,"X");
ach[0]->SetTitleOffset(2.0,"Y");
ach[0]->SetXTitle("Mass [GeV/c^2!]");
ach[0]->SetYTitle("Entries per 0.013 GeV/c^2!");
title->Draw();

c1.Update();
eps7->Close();

c1.Clear();
TPostScript *eps8 = new TPostScript("Fig8.eps",type);
eps8->NewPage();

pad1 = new TPad("pad1","Pad 1",0.02,0.02,0.98,0.98,21);
pad1->SetFillColor(18);
pad1->Draw();
pad1->cd();
gStyle->SetOptStat(0);

title = new TPaveLabel( 0.10 , 25400 , 1.1 , 27000 ,
			"12.0 GeV Forward (`g#p'5#K^+!K^-!`p#^+!`p#^-!p)"); 
title->SetFillColor(21);
title->SetTextColor(4);

afh[0].SetMinimum(0);
afh[0].SetMaximum(25000);

afh[0].Draw("p");
afh[0].Draw("same");
afh[0]->SetTitleOffset(1.5,"X");
afh[0]->SetTitleOffset(2.0,"Y");
afh[0]->SetXTitle("Mass [GeV/c^2!]");
afh[0]->SetYTitle("Entries per 0.013 GeV/c^2!");
title->Draw();

c1.Update();
eps8->Close();

gStyle.SetOptTitle(1);            //** Turn on histogram titles:

return 0;
}








