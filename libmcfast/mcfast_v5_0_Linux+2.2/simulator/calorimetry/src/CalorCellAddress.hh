#if !defined(CALORCELLADDRESS_H)
#define CALORCELLADDRESS_H

// -*- C++ -*-
//
// Package:     Calorimetry
// Module:      CalorCellAddress
// 
// Description: 
//
// Usage:
//    <usage>
//
// Author:      Julia Yarba
// Created:     Mon Jan11, 1999
// RCS(Id)
//
// Revision history
//
// RCS(Log)

struct CalorCellAddress
{
   int address[2] ;
   CalorCellAddress() ;
   CalorCellAddress( int , int ) ;
   CalorCellAddress( const CalorCellAddress& );
   const CalorCellAddress& operator=( const CalorCellAddress& ) ;
   bool operator==( const CalorCellAddress& ) const ;
} ;


inline
CalorCellAddress::CalorCellAddress()
{
   address[0] = address[1] = 0 ;
}

inline
CalorCellAddress::CalorCellAddress( int i, int j )
{
   address[0] = i ;
   address[1] = j ;
}
inline
CalorCellAddress::CalorCellAddress( const CalorCellAddress& cell)
{
   address[0] = cell.address[0] ;
   address[1] = cell.address[1] ;
}

inline
const CalorCellAddress&
CalorCellAddress::operator=( const CalorCellAddress& cell ) 
{
   if ( this != &cell )
   {
      address[0] = cell.address[0] ;
      address[1] = cell.address[1] ;
   }
   return *this ;
} 

inline
bool 
CalorCellAddress::operator==( const CalorCellAddress& cell ) const 
{
   return ( address[0] == cell.address[0] && address[1] == cell.address[1] ) ;
}
// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:09  eugenio
// Initial revision
//
// Revision 1.1  1999/09/23 15:56:25  yarba_j
// updated/modifed calorimtry classes moved from showering area + a new calss CalorSignalMC
//

#endif /* CALORCELLADDRESS_H */
