// ----------------------------------------------------------------------
// StdRun.hh
// ----------------------------------------------------------------------

//  The basic I/O unit is a run
//  The run contains methods to get the next event

#ifndef STDRUN_HH
#define STDRUN_HH

#include <vector>

#include "StdEvent.hh"

namespace StdHep  {

class Run {

public:

  // ---  birth/death:
  //
  inline Run( int togen, int ngen, int nwrt, double com, double xsec );
  inline Run( );
  inline Run( Run const & orig );
  inline Run& operator=( Run const& );
  ~Run() { ; }

  // ---  accessors:
  //
  int      const    EventsToGenerate() const  {  return itsEventsToGenerate; }
  int      const    EventsGenerated()  const  {  return itsEventsGenerated; }
  int      const    EventsWritten()    const  {  return itsEventsWritten; }
  double   const    CoMEnergy()        const  {  return itsCoMEnergy; }
  double   const    CrossSection()     const  {  return itsCrossSection; }
  double   Seed( int i )   const  {  return itsSeedList[i]; }

  // ---  mutators:
  //
  void  setEventsToGenerate ( int togen )    { itsEventsToGenerate = togen; }
  void  setEventsGenerated  ( int ngen )     { itsEventsGenerated = ngen; }
  void  setEventsWritten    ( int nwrt )     { itsEventsWritten = nwrt; }
  void  setCoMEnergy        ( double com )   { itsCoMEnergy = com; }
  void  setCrossSection     ( double xsec )  { itsCrossSection = xsec; }
  void  appendSeed          ( double sd )    { itsSeedList.push_back( sd ); }
  
  // --- event access
  //
  int StdHepInitReadXDR( char*filename, int& ntries, int& istr );
  int StdHepOpenReadXDR( char*filename, int& ntries, int& istr );
  int StdHepReadXDR( int& ilbl, int istr, StdHep::Event* & evt );
  int StdHepReadMultiXDR( int& ilbl, int istr, StdHep::Event* & evt );
  int StdHepInitWriteXDR(char *filename, char *title, int ntries, int& ist);
  int StdHepWriteXDR(int ilbl, int ist, StdHep::Event* evnt );
  int StdHepWriteCMXDR(int ilbl, int ist );
  int StdHepWriteEventXDR(int ilbl, int ist, StdHep::Event* evt);
  void StdHepWriteEndXDR(int ist);

private:

  int    itsEventsToGenerate;
  int    itsEventsGenerated;
  int    itsEventsWritten;
  double itsCoMEnergy;
  double itsCrossSection;
  std::vector<double> itsSeedList;
  
};	// Run

Run::Run( int togen, int ngen, int nwrt, double com, double xsec )
: itsEventsToGenerate ( togen ),
  itsEventsGenerated  ( ngen ),
  itsEventsWritten    ( nwrt ),
  itsCoMEnergy        ( com ), 
  itsCrossSection     ( xsec )
{ ; }

Run::Run( )
: itsEventsToGenerate ( 0 ),
  itsEventsGenerated  ( 0 ),
  itsEventsWritten    ( 0 ),
  itsCoMEnergy        ( 0 ), 
  itsCrossSection     ( 0 ),
  itsSeedList         ( 0 )
{ ; }

Run::Run( Run const & orig )
: itsEventsToGenerate ( orig.itsEventsToGenerate ),
  itsEventsGenerated  ( orig.itsEventsGenerated ),
  itsEventsWritten    ( orig.itsEventsWritten ),
  itsCoMEnergy        ( orig.itsCoMEnergy ), 
  itsCrossSection     ( orig.itsCrossSection ),
  itsSeedList         ( orig.itsSeedList )
{ ; }

Run& Run::operator=( Run const & rhs )
{ if( this != & rhs )
  {
    itsEventsToGenerate = rhs.itsEventsToGenerate;
    itsEventsGenerated  = rhs.itsEventsGenerated;
    itsEventsWritten    = rhs.itsEventsWritten;
    itsCoMEnergy        = rhs.itsCoMEnergy; 
    itsCrossSection     = rhs.itsCrossSection;
    itsSeedList         = rhs.itsSeedList;
  }
  return *this;
}

}	// StdHep

#endif // STDRUN_HH
