// ----------------------------------------------------------------------
//
// StdParticleData.hh
//
// ----------------------------------------------------------------------

#include <string>

namespace StdHep  {

class ParticleData  {

public:

  // ---  birth/death:
  //
  ParticleData( int ID, std::string const & ParticleName, int Charge,
                double Mass, double Width );
  ParticleData( );
  ParticleData( ParticleData const & orig );
  ~ParticleData();

  // ---  accessors:
  //
  int const            ID()              const;
  std::string const &  ParticleName()    const;
  int const            Charge()          const;
  double const         Mass()            const;
  double const         Width()           const;

  // ---  mutators:
  //
  void  setID( int ID );
  void  setCharge( int Charge );
  void  setMass( double mass );
  void  setWidth( double width );

private:

  // ---  class-specific data:
  //
  int          itsID;
  std::string  itsParticleName;
  int          itsCharge;
  double       itsMass;
  double       itsWidth;

  // ---  forbidden operations:
  //
  ParticleData &  operator=( ParticleData const & );

};  // ParticleData

}  // StdHep
