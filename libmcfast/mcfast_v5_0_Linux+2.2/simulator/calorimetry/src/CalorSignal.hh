#if !defined(CALORSIGNAL_H)
#define CALORSIGNAL_H
// -*- C++ -*-
//
// Package : Calorimetry
// Module:   CalorSignal
//
// Description :
//
// Author :  Julia Yarba
// Created : Sept.13, 1999
//

// system include files

// STL files

// user include files

// forward declarations

class CalorSignal
{
      // friend classes and functions
   
   public :
      // Constructor and destructor
      CalorSignal() : fEnergy(0) {} ;
      ~CalorSignal() {} ;

      // assignment operator
      const CalorSignal& operator=( const CalorSignal& ) ;
   
      // member functions
      virtual void clear() { fEnergy = 0 ; }
      virtual void update( double signal, int trackID=-1, int trackStatus=-1 ) { fEnergy += signal ; }
      
      // const member functions
              double getE() const { return fEnergy ; }

   protected :
      // protected data members
      double fEnergy;

   private :
      
      // static data members
} ;

// inline function definitions

inline
const CalorSignal& CalorSignal::operator=( const CalorSignal& hit )
{
   if ( this != &hit )
   {
      fEnergy = hit.fEnergy ;
   }
   return *this ;
}
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:09  eugenio
// Initial revision
//
// Revision 1.4  1999/10/04 21:56:01  yarba_j
// fixed constructor and implemented virtual void clear()
//
// Revision 1.3  1999/09/24  20:16:16  yarba_j
// more cleanup (agreed with Andreas on naming)
//
// Revision 1.2  1999/09/23  22:28:28  yarba_j
// minor modifications
//
// Revision 1.1  1999/09/23  15:56:26  yarba_j
// updated/modifed calorimtry classes moved from showering area + a new calss CalorSignalMC
//
//

#endif /* CALORSIGNAL_H */

