#if !defined(TRACING_ASSOCIATEDMATERIAL_H)
#define TRACING_ASSOCIATEDMATERIAL_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      AssociatedMaterial
//
// Description: encompasses material properties and behavior
//              based on scatter surfaces:
//              this means that "dedx" is really dedxOfMaterial*thickness.
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files

// user include files
#include "cc_fortran_types.hh"
#include "Material.hh"

// forward declarations
class MCParticle;


class AssociatedMaterial : public Material
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      AssociatedMaterial( const AssociatedMaterial& );
      virtual ~AssociatedMaterial();

      // sets new radiation or interaction lengths
      void setRadLength ( float radL ) { m_radiationLength=radL; }
      void setDedx      ( float dedx ) { m_dedx=dedx; }
      void setCollLength( float coll ) { m_collisionLength=coll; }
      void setAbsLength ( float abs  ) { m_absorptionLength=abs; }

      // member functions

      // const member functions
      
      virtual AssociatedMaterial* clone() const;

      MCFBool interactWith( MCParticle& particle ) const;

      //MCFBool isVacuum() const { return ((m_radLength==0) ? true:false); }

      float radLength()  const { return m_radiationLength; }
      float dedx()       const { return m_dedx; }
      float collLength() const { return m_collisionLength; }
      float absLength()  const { return m_absorptionLength; }

      virtual void printOn( ostream& os = cout ) const;
      virtual const char* nameOf() const { return "AssociatedMaterial"; }

      // static member functions
      static AssociatedMaterial* createMaterial( float radl=0, 
						 float dedx=0,
						 float coll=0,
						 float absp=0 );

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      AssociatedMaterial( float radl=0, float dedx=0, 
			  float coll=0, float absp=0 ); 

      // assignment operator(s)
      //const AssociatedMaterial& operator=( const AssociatedMaterial& );

      // private member functions
      MCFBool doElossAndMScat ( MCParticle& particle ) const;
      MCFBool doBremsStrahlung( MCParticle& particle ) const;
      MCFBool doPairConversion( MCParticle& particle ) const;
      MCFBool do2ndInteraction( MCParticle& particle ) const;

      // private const member functions

      // data members

      float m_radiationLength;      // radiation length
      float m_dedx;                 // constants used by dedx
      float m_collisionLength;      // collision length
      float m_absorptionLength;     // absorption length

      // static data members

};

// inline function definitions
// inline function definitions

inline
ostream&
operator<<( ostream& os, const AssociatedMaterial& m )
{
   m.printOn(os);
   return os;
}

inline
ostream&
operator<<( ostream& os, const AssociatedMaterial* m )
{
   m->printOn(os);
   return os;
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:31  eugenio
// Initial revision
//
// Revision 1.4  1998/11/20 23:47:43  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/02/16  04:33:40  mkl
// first version of 2ndary interactions
//
// Revision 1.2  1997/11/11  20:14:20  mkl
// doCorrections --> interactWith
//
// Revision 1.1  1997/08/02  02:59:53  mkl
// RealMaterial and AssociatedMaterial derive from placeholder Material
//
// Revision 1.3  1997/08/01  20:56:32  mkl
// forward declare stl containers
//
// Revision 1.2  1997/03/15  19:02:21  mkl
// moved src/tracing/Types.hh to inc/event/cc_fortran_types.hh.
// fixed commend headers for .inc files from # to c.
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_ASSOCIATEDMATERIAL_H */

