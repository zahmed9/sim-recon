#ifndef __TNtupleUtil
#define __TNtupleUtil
//*-- Author :    Paul Eugenio 22-Feb-1999
//*-- CMZ : PME 22-Feb-1999

#include <iostream.h>
#include <string.h>
#include <Rtypes.h>

class TntpNames{
private: 
  Char_t fnames[1000];  // a place to put the vector labels 
  //Char_t *fnames;
  Int_t fNlabels;  // the number of fnames
  static Char_t *gfnames;
public:
  TntpNames();
  ~TntpNames();
  void Add(Char_t *string);
  Char_t * GetNames() {return fnames;}
  Int_t GetNlabels() {return fNlabels;}
  void Print(void);
};
 
#endif
