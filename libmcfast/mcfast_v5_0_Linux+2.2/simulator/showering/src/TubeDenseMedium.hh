#if !defined(SHOWERING_TUBECALORIMETERMEDIUM_H)
#define SHOWERING_TUBECALORIMETERMEDIUM_H
// -*- C++ -*-
//
// Package:     <Showering>
// Module:      TubeDenseMedium
// 
// Description: <one line class summary>
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Fri Aug 22 16:45:05 CDT 1997
//

// system include files

// user include files
#include "DenseMedium.hh"

// forward declarations

class TubeDenseMedium : public DenseMedium
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      TubeDenseMedium( int iFortranIndex = 0 );
      virtual ~TubeDenseMedium();

      // member functions

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      TubeDenseMedium( const TubeDenseMedium& );

      // assignment operator(s)
      const TubeDenseMedium& operator=( const TubeDenseMedium& );

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
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.3  1999/02/22 23:15:48  yarba_j
// handle hit generation in box-shaped calorimeters
//
// Revision 1.1  1998/02/17  23:38:19  mkl
// rename TubeCalorimeterMedium to TubeDenseMedium (Julia Yarba)
//
// Revision 1.1  1997/08/23  01:10:16  mkl
// toward volume-based tracing
//


#endif /* SHOWERING_TUBECALORIMETERMEDIUM_H */
