{
  cout<<"dumping event number:"<<ev<<endl;
  if(hepevt_on)
    hepevt->Print(&cout);
  if(trace_on){
    trace->Print(&cout);
    // dump both forward & central TOF for each particle
    for(Int_t i=0; i< hepevt->GetNhep();i++){
      cout << "CTOF["<<i+1<<"] mass: "<<trace->CTOFmass(i+1)
	   << " FTOF["<<i+1<<"] mass: "<< trace->FTOFmass(i+1)
	   <<endl;
    } 
  }
  if(offtrk_on)
    offtrk->Print(&cout);
  if(bcal_on)
    bcal->Print(&cout);
  if(lgdSmears_on)
    lgdSmears->Print(&cout);
   if(esr_on)
     esr->Print(&cout);
}
