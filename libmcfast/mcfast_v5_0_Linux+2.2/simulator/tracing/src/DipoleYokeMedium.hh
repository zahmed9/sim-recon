#if !defined(TRACING_DIPOLEYOKEMEDIUM_H)
#define TRACING_DIPOLEYOKEMEDIUM_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      DipoleYokeMedium
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 16:45:38 CDT 1997
//

// system include files

// user include files
#include "DenseMedium.hh"

// forward declarations

class DipoleYokeMedium : public DenseMedium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs
      // kZeroHalf is the main bfield cage, the others are the dipole yokes
      enum WhichHalf { kZeroHalf=0, kFirstHalf, kSecondHalf, kNumberOfHalfs };

      // Constructors and destructor
      DipoleYokeMedium( int iFortranIndex = 0, WhichHalf whichHalf=kZeroHalf );
      virtual ~DipoleYokeMedium();

      // member functions

      // const member functions
      virtual MCFBool implementReactTo( MCParticle& particle ) const;

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      DipoleYokeMedium( const DipoleYokeMedium& );

      // assignment operator(s)
      const DipoleYokeMedium& operator=( const DipoleYokeMedium& );

      // private member functions

      // private const member functions

      // data members
      WhichHalf m_whichHalf;

      // static data members

};

// inline function definitions




// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.4  1998/11/20 23:47:52  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.3  1998/02/16  18:23:14  mkl
// override DenseMedium::implementReactTo
//
// Revision 1.2  1997/11/11  01:17:32  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.1  1997/08/23  01:10:11  mkl
// toward volume-based tracing
//


#endif /* TRACING_DIPOLEYOKEMEDIUM_H */
