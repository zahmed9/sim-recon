#if !defined(TRACING_PROXYVISITOR_H)
#define TRACING_PROXYVISITOR_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      ProxyVisitor
// 
// Description: Concrete Visitor class to deal with Proxies
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Mon Aug 25 12:12:26 CDT 1997
//

// system include files

// user include files
#include "VolumeVisitor.hh"

// forward declarations
class Medium;
class Tube;
class AlignedBox;


class ProxyVisitor : public VolumeVisitor
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      ProxyVisitor( Medium& medium,
		    vector<Medium*>& iRMedia,
		    vector<Medium*>& iZMedia,
		    vector<Medium*>& iXMedia,
		    vector<Medium*>& iYMedia );
      virtual ~ProxyVisitor();

     // member functions
      virtual void visitTube( Tube& tube );
      virtual void visitAlignedBox( AlignedBox& );

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // protected const member functions

   private:
      // Constructors and destructor
      ProxyVisitor( const ProxyVisitor& );

      // assignment operator(s)
      const ProxyVisitor& operator=( const ProxyVisitor& );

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
// Revision 1.4  1998/11/03 17:43:33  mkl
// changes to compile under egcs
//
// Revision 1.3  1997/11/11  01:17:38  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:41  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/08/25  19:23:04  mkl
// new Visitor classes to keep from cluttering volume class
//


#endif /* TRACING_PROXYVISITOR_H */
