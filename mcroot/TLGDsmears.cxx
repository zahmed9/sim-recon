//*-- Author :    Paul Eugenio 21-Jan-99

////////////////////////////////////////////////////////////////////////
// TLGDsmears
//
// 
// Because MCFast does not yet impiment forward calorimeters
// in it's latest version (the older mcfast code also seemed to
// have some troubles with the forward calorimetry), we have
// implemented our own lgd simulation.
//
// Currently only the gamma energy is smeared.
// This means that there is no smearing of the 
// position. A full treatment should use the 
// the e852 shower library and clusterizer.(future plans) 
//
// The paramters for the smearing were taken from the LGD NIM paper, p. 390:
//   "A 3000 Element Lead Glass Electromagnetic Calorimeter"
//   Nucl. Instrum. Methods A387 (1997) 377-394.
//
// Energy resolution = 6%sqrt(E) + 2%E
//
// The above equation is then multiplied by a factor (LgdRes) to
// make the squaw CL distributions more realistic. The LGD errors               
// are underestimated unless a factor of about 2.36 is used.
//
// The actuall code with does the smearing is located in the 
// HDFast subsystem in usr_lgd.c
////////////////////////////////////////////////////////////////
//
//  TLGDsmears contains a TClonesArray of  TLGDparticle
//
////////////////////////////////////////////////////////////////////////


#include "TLGDsmears.h"


ClassImp(TLGDsmears)


TClonesArray *TLGDsmears::fgLgdParticles = 0;


//____________________________________________________________________________
TLGDsmears::TLGDsmears(lgd_smearedparts_t *lgd){
  // Create the object 
  // and fill it using  FIll(lgd_smearedparts_t *lgd) 
  //
  if(!fgLgdParticles) fgLgdParticles = new TClonesArray("TLGDparticle",10);
 
  fLgdParticles = fgLgdParticles;
  Fill(lgd);
}

TLGDsmears::TLGDsmears(){
  fnParticles=0;
  if(!fgLgdParticles) fgLgdParticles = new TClonesArray("TLGDparticle",10);
  fLgdParticles = fgLgdParticles;
  
}


//____________________________________________________________________________
void TLGDsmears::AddPart(lgd_smearedpart_t *lgdpart){
  // Create a TLGDparticle instance
  // from the c struct lgd_smearedpart_t and add the instance to 
  // the  TClonesArray fLgdParticle
  //
  TClonesArray &parts = *fLgdParticles;
  
  new(parts[fnParticles++]) TLGDparticle(lgdpart);

}


//____________________________________________________________________________
void  TLGDsmears::Fill(lgd_smearedparts_t *lgdSmearedparts){
  // Fill the object using a c 
  // struct lgd_smearedparts_t *lgd
  // 
  fnParticles=0;

  for(Int_t i =0; i< lgdSmearedparts->nparts;i++)
    this->AddPart(&(lgdSmearedparts->part[i]));
    
  
  if(lgdSmearedparts->nparts != this->GetNparts()){
    cerr<< "ERROR!! TClonesArray TLGDsmears GetNparts!=lgd->nparts \n";
  }
 
}
//____________________________________________________________________________
void TLGDsmears::Clear()
{
  // Clear the TClonesArrays: this->GetLgdParticles()
  //
   this->GetLgdParticles()->Clear();
}


//____________________________________________________________________________
TLGDsmears::~TLGDsmears()
{
   this->Clear();
}

//____________________________________________________________________________
void TLGDsmears::Print(ostream *os){
  // Prints TLGDsmears object
  //
  // This function is also used
  // to  overload  &operator<< 
  // 
  // For example;
  // cout << lgdsmears;
  // 
  // where lgdsmears is an instance of TLGDsmears

  *os<<"NsmearedLGDparticles: "<< this->GetNparts()<<endl;

  // Now Print the lgd smeared particles 

  if(this->GetNparts()){
    TIter nextLGD(this->GetLgdParticles()); 
    while( TLGDparticle *lgdpart = ( TLGDparticle *)nextLGD())
      lgdpart->Print(os);
    *os<<endl;
  }
}

ostream &operator<<(ostream &os, TLGDsmears &lgdsmears){
// overload the standard print operator
  lgdsmears.Print(&os);
  return os;
}
