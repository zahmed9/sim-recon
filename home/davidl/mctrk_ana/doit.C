

void doit(void)
{
	gROOT->Reset();

	dp_over_p_vs_theta->FitSlicesY(0,1,50,0);

	TH1F *perr = new TH1F("perr","perr",40,0.0,160.0/57.3);

	int N = dp_over_p_vs_theta->GetNbinsX();
	int i;
	for(i=1;i<=N;i++){
		float sig1;
		
		sig1 = dp_over_p_vs_theta_1->GetBinContent(i);

		perr->SetBinContent(i,sig1);
		cout<<" "<<i<<" : "<<sig1<<endl;
	}
	
	perr->SetMarkerStyle(20);
	perr->SetMarkerColor(kRed);
	//dp_over_p_vs_theta->SetMarkerStyle(22);
	dp_over_p_vs_theta->SetMarkerColor(kBlack);
	
	TH2F *axes = new TH2F("axes",";#theta(radians);#Deltap/p",10,0.0,160.0/57.3,10,0.0,0.1);
	axes->Draw();
	dp_over_p_vs_theta->Draw("Psame");
	perr->Draw("Psame");
}

