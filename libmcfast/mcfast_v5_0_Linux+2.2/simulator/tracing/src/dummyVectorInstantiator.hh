#if !defined(TRACING_DUMMYVECTORINSTANTIATOR_H)
#define TRACING_DUMMYVECTORINSTANTIATOR_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      DummyVectorInstantiator
// 
// Description: g++ needs this to be forced to instantiate:
//      vector<Trace, const HitStruct*>& 
//      vector<Trace, const HitStruct*>::operator=
//          ( const vector<Trace, const HitStruct*> );
// 
// this is definitely needed for g++; don't know about other compilers yet
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997
// RCS(Id)
//
// Revision history
//
// RCS(Log)

// system include files

// user include files

// forward declarations

//inline 
static void dummyVectorInstantiator()
{
   const vector<Trace> dummy1;
   vector<Trace> dummy2;
   dummy2 = dummy1;

   //const vector<const HitStruct*> dummy3;
   //vector<const HitStruct*> dummy4;
   //dummy4 = dummy3;

   const vector<int> dummy5;
   vector<int> dummy6;
   dummy6 = dummy5;
}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.1.1.1  1997/03/14 22:52:34  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_DUMMYVECTORINSTANTIATOR_H */
