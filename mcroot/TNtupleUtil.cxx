//*-- Author :    Paul Eugenio 22-Feb-1999

////////////////////////////////////////////////////////////////////////
// TNtupleUtil
//
////////////////////////////////////////////////////////////////



#include "TNtupleUtil.h"


Char_t *TntpNames::gfnames=0;

TntpNames::~TntpNames(){
  /*  if(flength !=0){
    delete[] fnames;
    flength=0;
    }*/
}

TntpNames::TntpNames(){
  fNlabels=0;
  //if(!gfnames) gfnames = new char[1];
  //fnames=gfnames;
}


void TntpNames::Print(void){
  cerr<<fnames<<endl;
}

void TntpNames::Add(Char_t *string){
  char *tempstr=0; 
  cerr<<"Adding new label " <<string<<endl;
  Int_t lstr= strlen(string);
  Int_t length = strlen(fnames);
  tempstr = new char[length+1];
  /*** 
  sprintf(tempstr,"%s",fnames);
  delete[] fnames;
  if(fNlabels){
    fnames = new char[length+lstr+1];
    sprintf(fnames,"%s:%s",tempstr,string);
  }
  else{
    fnames = new char[lstr+1];
    sprintf(fnames,"%s",string);
  }
  *************/
  if(fNlabels){
    sprintf(tempstr,"%s",fnames);
    if((length+lstr+1)>2000){
      cerr<<"You must increase TntpNames::fname array size\nExiting\n";
      exit(-1);
    }
    sprintf(fnames,"%s:%s",tempstr,string);
  }
  else
    sprintf(fnames,"%s",string);
  

  fNlabels++;
  delete [] tempstr;
}

