// StdHepDictionary.hh
//
// contains prototypes of StdHep c++ routines
//
#ifndef STDHEPDICTIONARY_HH
#define STDHEPDICTIONARY_HH

void PrintStdVersion();

void StdHepZero( StdHep::Event* & ep );
int StdHepTempCopy(int idir,int istr, StdHep::Event* & ep );
int StdHepFtoCXX(int istr, StdHep::Event* & ep );
int StdHepCXXtoF(int istr, StdHep::Event* & ep );
void StdHepFtoCM( StdHep::Run & thisrun );
void StdHepCMtoF( StdHep::Run & thisrun );

#endif
