#if !defined( TRACING_FUNCTIONS_H )
#define TRACING_FUNCTIONS_H

// AUTHOR: Martin Lohner
// DATE: Mar 14, 1997

// define max/min/abs as inline functions (safer than macros)
// can't use references here, since I want eg. max(1.,2.) to work

template <class T> 
inline 
T 
max( T a, T b ) 
{ 
   return (a>b)?a:b;  
}

template <class T> 
inline 
T 
min( T a, T b ) 
{ 
   return (a>b)?b:a;  
}

template <class T> 
inline 
T 
abs( T a ) 
{ 
   return (a>0)?a:-a; 
}

// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.2  1998/05/15 03:39:03  mkl
// inlined often-used functions to improve speed
//
// Revision 1.1  1997/07/03  03:34:00  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


#endif /* TRACING_FUNCTIONS_H */
