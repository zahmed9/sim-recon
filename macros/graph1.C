{

//TCanvas *c = new TCanvas("c","Basic 1",200,10,700,900);
//c->SetFillColor(18);
//c->SetGridx();
//c->SetGridy();

Int_t n=6;
Float_t x[6],y[6];

x[0]=0;
x[1]=20;
x[2]=40;
x[3]=60;
x[4]=80;
x[5]=100;


y[0]=11;
y[1]=14;
y[2]=20;
y[3]=25;
y[4]=29;
y[5]=34;



TGraph *gr = new TGraph(n,x,y);
gr->SetTitle("Lower Mass Meson System");
TAxis *ax;

gr->SetMarkerStyle(21);
gr->Draw("APC");
}
