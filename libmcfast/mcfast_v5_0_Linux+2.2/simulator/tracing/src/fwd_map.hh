#if !defined(TRACING_FWD_MAP_H)
#define TRACING_FWD_MAP_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      fwd_map
// 
// Description: Handle the forward declaration of the STL map
//
// Usage:
//    include this file wherever you'd normally forward declare a STL map
//
// Author:      Martin Lohner
// Created:     Fri Aug 1 14:44:35 EDT 1997
//

template <class T> class less;
template < class Key, class T, class Compare = less< Key > > class map ;


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.1  1997/08/01 20:56:36  mkl
// forward declare stl containers
//
//

#endif /* TRACING_FWD_MAP_H */
