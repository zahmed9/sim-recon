#if !defined(TRACING_RMEDIUM_H)
#define TRACING_RMEDIUM_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      RMedium
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 15:39:15 CDT 1997
//

// system include files

// user include files
#include "Medium.hh"

// forward declarations

class RMedium : public Medium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      RMedium( int iFortranIndex = 0 );
      virtual ~RMedium();

      // member functions

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      RMedium( const RMedium& );

      // assignment operator(s)
      const RMedium& operator=( const RMedium& );

      // private member functions

      // private const member functions

      // data members

      // static data members

};

// inline function definitions




// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.1  1997/08/23 01:10:14  mkl
// toward volume-based tracing
//


#endif /* TRACING_RMEDIUM_H */
