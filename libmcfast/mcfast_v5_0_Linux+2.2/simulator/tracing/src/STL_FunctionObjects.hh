#if !defined(TRACING_STL_FUNCTIONOBJECTS_H)
#define TRACING_STL_FUNCTIONOBJECTS_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      STL_FunctionObjects
// 
// Description: FunctionObjects for sorted insert operations
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Fri Aug 22 15:22:10 CDT 1997
//

// system include files

// user include files
#include "RSurface.hh"
#include "ZSurface.hh"
#include "Medium.hh"

// forward declarations

class GreaterInRadius
{
   public:
      GreaterInRadius( const RSurface& toCompareTo ) 
	 : m_toCompareTo( toCompareTo ) {}

      MCFBool operator()( Medium* medium ) {
	 return ((RSurface&)medium->surface()).radius()
	    > m_toCompareTo.radius();
      }

      MCFBool operator()( const Medium* medium ) {
	 return ((RSurface&)medium->surface()).radius()
	    > m_toCompareTo.radius();
      }

   private:
      const RSurface& m_toCompareTo;
};

class GreaterInZ
{
   public:
      GreaterInZ( const ZSurface& toCompareTo ) 
	 : m_toCompareTo( toCompareTo ) {}

      MCFBool operator()( Medium* medium ) {
	 return ((ZSurface&)medium->surface()).z()
	    > m_toCompareTo.z();
      }

      MCFBool operator()( const Medium* medium ) {
	 return ((ZSurface&)medium->surface()).z()
	    > m_toCompareTo.z();
      }

   private:
      const ZSurface& m_toCompareTo;
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
// Revision 1.2  1998/11/20 23:48:00  mkl
// switch Boolean to MCFBool to avoid clashes with other typedef-ed bool types
//
// Revision 1.1  1997/08/23  01:10:14  mkl
// toward volume-based tracing
//


#endif /* TRACING_STL_FUNCTIONOBJECTS_H */
