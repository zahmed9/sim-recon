#if !defined(TRACING_ZMEDIUM_H)
#define TRACING_ZMEDIUM_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      ZMedium
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 15:39:27 CDT 1997
//

// system include files

// user include files
#include "Medium.hh"

// forward declarations

class ZMedium : public Medium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ZMedium( int iFortranIndex = 0 );
      virtual ~ZMedium();

      // member functions

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      ZMedium( const ZMedium& );

      // assignment operator(s)
      const ZMedium& operator=( const ZMedium& );

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
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.1  1997/08/23 01:10:17  mkl
// toward volume-based tracing
//


#endif /* TRACING_ZMEDIUM_H */
