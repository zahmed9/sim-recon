// -*- C++ -*-
//
// Package:     Tracing
// Module:      MaterialLookupTable
// 
// Description: is Container of Materials. 
//              A material can be found by name.
//              Implemented as Singleton.
//
// Implimentation:
//     <Notes on implimentation>
//
// Author:      Martin Lohner, Julia Yarba
// Created:     Aug 1, 1997
//

// system include files
#include <assert.h>
#include <string>
#include <map>

// user include files
#include "report.hh"
#include "MaterialLookupTable.hh"
// #include "Material.hh"
#include "RealMaterial.hh"


//
// constants, enums and typedefs
//
typedef map< string, Material*, less<string> > MapOfMaterials;

//
// static data member definitions
//
MaterialLookupTable* MaterialLookupTable::m_instance = 0;

extern "C" {
     void get_num_of_mat_( int& nMat ) ;
     void get_name_length_( const int& index,
                                  int& nameLength ) ;
     void get_name_material_(const int& index,
                                   char* name,
                                   int nameLength ) ;
}

//
// constructors and destructor
//
MaterialLookupTable::MaterialLookupTable()
{
// Needs to be filled up only once
      if (m_mapOfMaterials.empty())
      {

       int nMat ;     
       get_num_of_mat_( nMat ) ;
 
       if ( nMat != 0 ) 
       {
        int nameLength ;
        char* nameMat ;
        for (int imat=1; imat<=nMat; imat++ )
        {
         Material* material = new RealMaterial( imat ) ;
         get_name_length_( imat, nameLength ) ;
         nameMat = new char[nameLength+1] ;
         get_name_material_( imat, nameMat, nameLength ) ;
         *(nameMat+nameLength) = '\0' ;
         m_mapOfMaterials.insert( pair<const string, Material*>
                                            (nameMat, material) ) ;
         delete [] nameMat ;
        }
       }
      }
}

//MaterialLookupTable::MaterialLookupTable( const MaterialLookupTable& )
//{
//}

MaterialLookupTable::~MaterialLookupTable()
{
}

//
// assignment operators
//
// const MaterialLookupTable& MaterialLookupTable::operator=( const MaterialLookupTable& )
// {
// }

//
// member functions
//

//
// const member functions
//
const Material*
MaterialLookupTable::get( const string& name ) const
{
   const Material* returnValue = 0;

   MapOfMaterials::const_iterator iter = m_mapOfMaterials.find( name );
   if( m_mapOfMaterials.end() == iter )
   {
      report( ERROR ) << "MaterialLookupTable: can't find material " 
		      << name << endl;
   }
   else
   {
      returnValue = (*iter).second;
   }

   return returnValue;
}

// I/O
void
MaterialLookupTable::printOn( ostream& str ) const
{
   str << "\nMaterialLookupTable:\n";

   MapOfMaterials::const_iterator itEnd = m_mapOfMaterials.end();
   for( MapOfMaterials::const_iterator it = m_mapOfMaterials.begin();
	it != itEnd;
	++it )
   {
      str << "Material( " << (*it).first << " ):";
      str << (*it).second << "\n";
   }

}

//
// static member functions
//
MaterialLookupTable*
MaterialLookupTable::instance()
{
   if( 0 == m_instance )
   {
      m_instance = new MaterialLookupTable;
   }

   return m_instance;
}

void
MaterialLookupTable::destroy()
{
   delete m_instance;
   m_instance = 0;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:29  eugenio
// Initial revision
//
// Revision 1.4  1998/11/03 17:44:00  mkl
// changes to compile under egcs
//
// Revision 1.3  1997/11/12  22:04:25  yarba_j
// updated use of real materials for volume based tracing
//
// Revision 1.2  1997/08/02  19:38:43  mkl
// minor
//
// Revision 1.1  1997/08/01  20:48:00  mkl
// Map of Materials
//
//


