{

// now create some pads to plot in

TCanvas *c;
c = new TCanvas("c","Basic 4",200,10,700,900);
c->SetFillColor(18);
c->Divide(2,3);
/*
TPad *pad1,pad2,pad3,pad4;
p1 = new TPad("pad1","The pad for particle #1",0.05,0.55,0.45,0.95,21);
p2 = new TPad("pad2","The pad for particle #3",0.55,0.55,0.95,0.95,21);
p3 = new TPad("pad3","The pad for particle #2",0.05,0.05,0.45,0.45,21);
p4 = new TPad("pad4","The pad for particle #4",0.55,0.05,0.95,0.45,21);
*/
c_1->Draw();
c_2->Draw();
c_3->Draw();
c_4->Draw();
c_5->Draw();
c_6->Draw();

gStyle->SetOptFit(11);

TFile f("o0.root");
c_1->cd();
h1=new TH1F("h1","h1",100,0.08,0.18);
ntp.Project("h1","2g.0");
h1->Fit("gaus");
h1->Draw();

c_2->cd();
h2=new TH1F("h2","h2",100,0.08,0.18);
ntp.Project("h2","2g.0","Nbcal==0");
h2->Fit("gaus");
h2->Draw();

c_3->cd();
h3=new TH1F("h3","h3",100,0.08,0.18);
ntp.Project("h3","2g.0","Nlgd==0");
h3->Fit("gaus");
h3->Draw();

c_4->cd();
h4=new TH1F("h4","h4",100,0.08,0.18);
ntp.Project("h4","2g.0","Nlgd!=0&&Nbcal!=0");
h4->Fit("gaus");
h4->Draw();

c_5->cd();
ntp.Draw("Nbcal");

c_6->cd();
ntp.Draw("Nlgd");

}
