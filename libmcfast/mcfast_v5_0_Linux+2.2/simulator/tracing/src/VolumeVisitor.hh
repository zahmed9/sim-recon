#if !defined(TRACING_VOLUMEVISITOR_H)
#define TRACING_VOLUMEVISITOR_H
// -*- C++ -*-
//
// Package:     <Tracing>
// Module:      VolumeVisitor
// 
// Description: Visitor Pattern to keep from cluttering Volume interface!
//
//              Abstract Class!
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Mon Aug 25 12:09:42 CDT 1997
//

// system include files
#include <vector>

// user include files

// forward declarations
class Medium;
class Tube;
class AlignedBox;

class VolumeVisitor
{
      // friend classses and functions

   public:
      // constants, enums and typedefs

      // Constructors and destructor
      VolumeVisitor( Medium& medium,
		     vector<Medium*>& iRMedia,
		     vector<Medium*>& iZMedia,
		     vector<Medium*>& iXMedia,
		     vector<Medium*>& iYMedia 
	 )
	 : m_medium( medium  ),
	   m_rMedia( iRMedia ), 
	   m_zMedia( iZMedia ), 
	   m_xMedia( iXMedia ), 
	   m_yMedia( iYMedia ) {}

      virtual ~VolumeVisitor() {}

      // member functions
      virtual void visitTube( Tube& ) = 0;
      virtual void visitAlignedBox( AlignedBox& ) = 0;

      // const member functions

      // static member functions

   protected:
      // protected member functions

      // give access to references to media containers
      // only to derived members!
      Medium& medium();

      vector<Medium*>& rMedia();
      vector<Medium*>& zMedia();
      vector<Medium*>& xMedia();
      vector<Medium*>& yMedia();

      // protected const member functions

      // protected data members

   private:
      // Constructors and destructor
      VolumeVisitor( const VolumeVisitor& );

      // assignment operator(s)
      const VolumeVisitor& operator=( const VolumeVisitor& );

      // private member functions

      // private const member functions

      // data members
      
      // remember: these are only references to the real things
      //           (e.g. CompositeMedium)
      Medium& m_medium;

      vector<Medium*>& m_rMedia;
      vector<Medium*>& m_zMedia;
      vector<Medium*>& m_xMedia;
      vector<Medium*>& m_yMedia;

      // static data members

};

// inline function definitions

inline
Medium&
VolumeVisitor::medium()
{
   return m_medium;
}

inline
vector<Medium*>&
VolumeVisitor::rMedia()
{
   return m_rMedia;
}

inline
vector<Medium*>&
VolumeVisitor::zMedia()
{
   return m_zMedia;
}

inline
vector<Medium*>&
VolumeVisitor::xMedia()
{
   return m_xMedia;
}

inline
vector<Medium*>&
VolumeVisitor::yMedia()
{
   return m_yMedia;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:33  eugenio
// Initial revision
//
// Revision 1.5  1998/11/04 23:19:16  mkl
// bug fix: VolumeVisitor made copy, but should only hold reference
//
// Revision 1.4  1998/11/03  17:43:37  mkl
// changes to compile under egcs
//
// Revision 1.3  1997/11/11  01:17:45  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.2  1997/08/27  03:31:46  mkl
// moved 'contains( particle )' to 'contains( wtrack )' and added Volume::distanceToExit()
//
// Revision 1.1  1997/08/25  19:23:05  mkl
// new Visitor classes to keep from cluttering volume class
//


#endif /* TRACING_VOLUMEVISITOR_H */
