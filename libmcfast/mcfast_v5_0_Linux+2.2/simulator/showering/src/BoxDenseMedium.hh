#if !defined(SHOWERING_BOXDENSEMEDIUMMEDIUM_H)
#define SHOWERING_BOXDENSEMEDIUMMEDIUM_H
// -*- C++ -*-
//
// Package:     <Showering>
// Module:      BoxDenseMedium
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Mon Feb 15 16:45:05 CDT 1998
//

// system include files

// user include files
#include "DenseMedium.hh"

// forward declarations

class BoxDenseMedium : public DenseMedium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      BoxDenseMedium( int iFortranIndex = 0 );
      virtual ~BoxDenseMedium();

      // member functions

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      BoxDenseMedium( const BoxDenseMedium& );

      // assignment operator(s)
      const BoxDenseMedium& operator=( const BoxDenseMedium& );

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
// Revision 1.1  2000/06/19 19:59:28  eugenio
// Initial revision
//
// Revision 1.2  1999/02/16 23:53:51  yarba_j
// minor cleanup
//
// Revision 1.1  1999/02/15  19:04:16  mkl
// added Box-shaped Calorimeters
//
//


#endif /* SHOWERING_BOXDENSEMEDIUMMEDIUM_H */
