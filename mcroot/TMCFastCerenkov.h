#ifndef ROOT_TMCFastCerenkov
#define ROOT_TMCFastCerenkov
//*-- Author :    Paul Eugenio 08-Apr-1999
//*-- CMZ :  Paul Eugenio 26-Apr-1999

//////////////////////////////////////////////////////////////////////////
//                                                                      //
// TMCFastCerenkov                                                      //
//                                                                      //
// A collection of TMCFastTrace objects that hit the front absorber
// plane that defines the Cerenkov.                                     //
//                                                                      //
//////////////////////////////////////////////////////////////////////////

#include "TObject.h"
#include "TClonesArray.h"
#include "TMCFastTrace.h"

#include <iostream.h>


class TMCFastCerenkov: public TObject {
  
private:

  TClonesArray *ftrace_points;  // array of TMCFastTrace points
  static TClonesArray *fgtrace_points; // dummy needed to init TClonesArray 


public:
  TMCFastCerenkov();

  TMCFastCerenkov(struct traces_t *traces);
  void Fill(struct traces_t *traces);
  virtual ~TMCFastCerenkov() ;
  void Clear();
  TClonesArray *GetTraces() const { return ftrace_points; }
  Int_t GetNTraces() {return ftrace_points->GetEntriesFast();}

  void Print(ostream *os);
  ClassDef(TMCFastCerenkov,1)  //Needed by ROOT
};

ostream &operator<<(ostream &os,TMCFastCerenkov &ceren); 


#endif
