// StdStreams.hh
//
// used internally to keep track of stream information
//
#ifndef STDSTREAMS_HH
#define STDSTREAMS_HH

#include <string>
#include <vector>

namespace StdHep  {

class StreamElement {

public:

  // ---  birth/death:
  //
  inline StreamElement( int stream, string xfile );
  inline StreamElement( );
  inline StreamElement( StreamElement const & orig );
  ~StreamElement() { ; }

  // ---  accessors:
  //
  int    const   XDRStream()  const  { return itsXDRStream; }
  string const   XDRFile()    const  { return itsXDRFile; }

  // ---  mutators:
  //
  void  setXDRStream ( int nmbr )    { itsXDRStream = nmbr; }
  void  setXDRFile ( string fl )     { itsXDRFile = fl; }

  // ---  forbidden operations:
  //
  StreamElement &  operator=( StreamElement const & ) { return *this; }

private:

  int     itsXDRStream;
  string  itsXDRFile;

};	// StreamElement

class Streams {

public:

  // ---  birth/death:
  //
  Streams( int nstr ): itsNumberOfStreams  ( nstr ) { ; }
  Streams( Streams const & orig ): itsNumberOfStreams ( orig.itsNumberOfStreams ) { ; }
  ~Streams() { ; }

  // ---  accessors:
  //
  int   const    NumberOfStreams()      const  {  return itsNumberOfStreams; }
  StreamElement  IOSreams( int i )      const  {  return itsStreamList[i]; }

  // ---  mutators:
  //
  void  setNumberOfStreams ( int nmbr )        { itsNumberOfStreams = nmbr; }
  void  appendStream       ( StreamElement c ) { itsStreamList.push_back( c ); }

private:

  int itsNumberOfStreams;
  std::vector<StreamElement> itsStreamList;

};	//Streams

// inline functions
StreamElement::StreamElement( int stream, string xfile )
: itsXDRStream    ( stream ),
  itsXDRFile      ( xfile )
{ ; }

StreamElement::StreamElement( )
: itsXDRStream    ( 0 ),
  itsXDRFile      ( 0 )
{ ; }

StreamElement::StreamElement( StreamElement const & orig )
: itsXDRStream    ( orig.itsXDRStream ),
  itsXDRFile      ( orig.itsXDRFile )
{ ; }

}	// StdHep

#endif // STDSTREAMS_HH
