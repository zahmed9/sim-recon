//*-- Author :    Paul Eugenio 16-Mar-1999
//*-- CMZ : PME 16-Mar-1999

////////////////////////////////////////////////////////////////////////
// TMCFastHits
//
// This class is an object oriented version 
// of mcfast trace common block.
//
// More information see Tracking in MCFast doc at:
//Begin_Html
/*
<a href= "http://www-pat.fnal.gov/mcfast.html" >
http://www-pat.fnal.gov/mcfast.html </a>
*/
//End_Html
//
////////////////////////////////////////////////////////////////////////
//
//  TMCFastHits contains a TClonesArray of TMCFastHit
//
////////////////////////////////////////////////////////////////////////




#include "TMCFastHits.h"

ClassImp(TMCFastHits)
  
  TClonesArray *TMCFastHits::gfhits_1 = NULL;
  TClonesArray *TMCFastHits::gfhits_2 = NULL;
  TClonesArray *TMCFastHits::gfhits = NULL;
/*
  TClonesArray *TMCFastHits::gfhits[1] = 0;
  TClonesArray *TMCFastHits::gfhits[2] = 0;
  TClonesArray *TMCFastHits::gfhits[3] = 0;
  TClonesArray *TMCFastHits::gfhits[4] = 0;
*/
Int_t TMCFastHits::gfTClones_counter = 0;

//____________________________________________________________________________
TMCFastHits::TMCFastHits(dev_hits_t *hits){
  // Create the object 
  // and fill it using  FIll(dev_hits_t *hits)
  //
  
  if(!gfTClones_counter)
    gfhits=gfhits_1;
  else
    gfhits=gfhits_2;
  if(!gfhits) gfhits = new TClonesArray("TMCFastHit",5);
  fhits=gfhits;
  Fill(hits);
  gfTClones_counter++;
 
}

TMCFastHits::TMCFastHits(){
  fnhits=0;
  
  if(!gfTClones_counter)
    gfhits=gfhits_1;
  else
    gfhits=gfhits_2;
  if(!gfhits) gfhits = new TClonesArray("TMCFastHit",5);
  fhits=gfhits;
  gfTClones_counter++;
 
}

void TMCFastHits::AddHit(dev_hit_t *devhit){
  // Create a TMCFastHits instance
  // from the c struct dev_hit_t_t and add the instance to 
  // the  TClonesArray fhits
  //
  TClonesArray &hits = *fhits;
  
  new(hits[fnhits++]) TMCFastHit(devhit);

}


void  TMCFastHits::Fill(dev_hits_t *devhits){
  // Fill the object using a c 
  // struct dev_hits_t *devhits
  // 
  fnhits=0;

  for(Int_t i =0; i< devhits->nhits;i++)
    this->AddHit(&(devhits->devhit[i]));
    
  
  if(devhits->nhits != this->GetNhits()){
    cerr<< "ERROR!! TClonesArray  TMCFastHits GetNhits!=devhits->nhits \n";
  }
 
}

//____________________________________________________________________________
void TMCFastHits::Clear()
{
  // Clear the TClonesArrays: this->GetHits()
  //

  this->GetHits()->Clear();
}


//____________________________________________________________________________
TMCFastHits::~TMCFastHits()
{
  
  this->Clear();
}

void TMCFastHits::Print(ostream *os){
  // Prints TMCFastHits object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << hitss;
  // 
  // where hits is an instance of TMCFastHits

  *os<<"Nhits: "<< this->GetNhits()<<endl;

  // Now Print the hits 

  if(this->GetNhits()){
    TIter nextHit(this->GetHits()); 
    while( TMCFastHit *hit = (TMCFastHit *)nextHit())
      hit->Print(os);
    *os<<endl;
  }
}

ostream &operator<<(ostream &os, TMCFastHits &hits){
// overload the standard print operator
  hits.Print(&os);
  return os;
}

