//*-- Author :    Paul Eugenio 21-Jan-99

////////////////////////////////////////////////////////////////////////
// TMCFastCalorimeter
//
// This class is an object oriented version of MCFast cal_hit structure.
// The cal_hit structure is filled by MCFast routines. An instance of
// TMCFastCalorimeter is created using this information and is save to Root
// Tree for I/O.
//
//  TMCFastCalorimeter contains a TClonesArray of  TMCFastCalorHits
//
// More information about MCfast calorimetry can be found at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////


#include "TMCFastCalorimeter.h"


ClassImp(TMCFastCalorimeter)


TClonesArray *TMCFastCalorimeter::fgCalorHits = 0;
TClonesArray *TMCFastCalorimeter::fginfo_tr = 0;

//____________________________________________________________________________
TMCFastCalorimeter::TMCFastCalorimeter(Int_t nhits,struct cal_hit_t **calor){
  // Create the object 
  // and fill it using  FIll(struct cal_hit_t **calor) 
  //
  if(!fgCalorHits) fgCalorHits = new TClonesArray("TMCFastCalorHits",10);
  if(!fginfo_tr) fginfo_tr = new TClonesArray("TCalHitTracks",1);
  fCalorHits = fgCalorHits;
  finfo_tr=fginfo_tr;
  Fill(nhits,calor);
}

TMCFastCalorimeter::TMCFastCalorimeter(){
  fnHits=0;
  fNinfo=0;
  if(!fgCalorHits) fgCalorHits = new TClonesArray("TMCFastCalorHits",10);
  if(!fginfo_tr) fginfo_tr = new TClonesArray("TCalHitTracks",1);
  fCalorHits = fgCalorHits;
  finfo_tr=fginfo_tr;
}


//____________________________________________________________________________
void TMCFastCalorimeter::AddHit(Int_t hitIndex,struct cal_hit_t *calorhit){
  // Create a TMCFastCalorHits instance
  // from the c struct cal_hit_t and add the instance to 
  // the  TClonesArray fCalorHits
  //
  TClonesArray &calhits = *fCalorHits;
  if(fnHits==0 && calorhit==NULL){
    new(calhits[fnHits++]) TMCFastCalorHits();
    cerr<<"Filled a NULL info\n";
  }else
    if(calorhit!=NULL)
      new(calhits[fnHits++]) TMCFastCalorHits(hitIndex,calorhit);
}

//____________________________________________________________________________
void  TMCFastCalorimeter::AddInfoTr(Int_t hitIndex,struct cal_hit_tracks_t *info){
  // Allocate structure memory 
  // and fill the structure.
  //
  TClonesArray &infoTr = *finfo_tr;

  if(fNinfo==0 && info==NULL){
    new(infoTr[fNinfo++]) TCalHitTracks();
    cerr<<"Filled a NULL info\n";
  }else
    if(info!=NULL)
      new(infoTr[fNinfo++]) TCalHitTracks(hitIndex,info);
}


//____________________________________________________________________________
void  TMCFastCalorimeter::Fill(Int_t nhits,struct cal_hit_t **calor){
  // Fill the object using a c 
  // struct cal_hit_t *calor
  // 
  fnHits=0;
  fNinfo=0;

  for(Int_t i =0; i< nhits;i++){
    this->AddHit(i,calor[i]);
    for(Int_t j=0;j< calor[i]->n_tracks;j++)
      this->AddInfoTr(i,&(calor[i]->info_tr[j]));
  }
  /*
  if(calor == NULL){
    this->AddHit(0,NULL);
    this->AddInfoTr(0,NULL);
  }
  */
  if(nhits != this->GetNhits()){
    cerr<< "ERROR!! TClonesArray TMCFastCalorimeter GetNhits!=nhits\n";
  }
 
}


//____________________________________________________________________________
void TMCFastCalorimeter::Clear()
{
  // Clear the TClonesArrays: fCalorHits, finfo_tr
  //
   fCalorHits->Clear();
   finfo_tr->Clear();
}


//____________________________________________________________________________
TMCFastCalorimeter::~TMCFastCalorimeter()
{
   this->Clear();
}

//____________________________________________________________________________
void TMCFastCalorimeter::Print(ostream *os){
  // Prints TMCFastCalorimeter object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << calor;
  // 
  // where calor is an instance of TMCFastCalorimeter

 

  *os<<"Calorimeter Nhits: "<< this->GetNhits()<<endl;

  // Now Print the calorimeter hits

  if(this->GetNhits()){
    TIter HitsIter(this->GetHits()); 
    while( TMCFastCalorHits *calhit = (TMCFastCalorHits *)HitsIter()){
      calhit->Print(os);
      TIter nextInfo(this->GetInfoTr());
      while(TCalHitTracks* info = (TCalHitTracks *)nextInfo())
	if(info->GetCalHitIndex() == calhit->GetHitIndex())
	  info->Print(os);
      
      *os<<endl;
    }
  }
  
}


ostream &operator<<(ostream &os, TMCFastCalorimeter &calor){
// overload the standard print operator
  calor.Print(&os);
  return os;
}
