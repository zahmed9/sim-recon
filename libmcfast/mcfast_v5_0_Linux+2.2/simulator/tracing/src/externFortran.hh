#if !defined(externFortran_H)
#define externFortran_H
// -*- C++ -*-
//
// Package:     Tracing
// Module:      externFortran
// 
// Description: header file contains all " extern \"C\" { fortran functions }"
//
// Usage:
//    <usage>
//
// Author:      Martin Lohner
// Created:     Jan 23, 1997

// system include files

// user include files
#include "cc_fortran_types.hh"

// forward declarations
struct WTrackStruct;
struct BFieldStruct;
struct PathStruct;
struct PlaneStruct;

// extern "C" prototypes

extern "C" {
   
   void path_update_( const WTrackStruct& m_wtrack, 
		      const DFLOAT& mass, 
		      const DFLOAT& step, 
		      PathStruct& path );

   void trk_next_bfield_( const WTrackStruct& w, 
			  BFieldStruct& bf );
 
   DFLOAT wtk_radius_curvature_( const WTrackStruct& w, 
				 const BFieldStruct& bf );

   integer move_wtk_arc_( const WTrackStruct& w, 
			  const DFLOAT& step, 
			  const BFieldStruct& bf, 
			  WTrackStruct& w2 );

   integer move_wtk_radius_( const WTrackStruct& w,
			     const DFLOAT& radius,
			     const Integer& direct,
			     const BFieldStruct& bf,
			     WTrackStruct& w2,
			     DFLOAT& arcLength );                

//   integer move_wtk_plane_( const WTrackStruct& wtrackIn, 
//			    const PlaneStruct& plane, 
//			    const Integer& direct, 
//			    const BFieldStruct& bf, 
//			    WTrackStruct& wtrackOut, 
//			    DFLOAT& arcLength );

   integer move_wtk_plane_direct_( const WTrackStruct& wtrackIn, 
				   const PlaneStruct& plane, 
				   const BFieldStruct& bf, 
				   const DFLOAT& iDistanceToBeat,
				   WTrackStruct& wtrackOut, 
				   DFLOAT& arcLength );

   integer move_wtk_zplane_( const WTrackStruct& w,
			     const DFLOAT& z,
			     const BFieldStruct& bf,
			     WTrackStruct& w2,
			     DFLOAT& arcLength );                

   integer move_wtk_xyplane_( const WTrackStruct& w,
			      const DFLOAT position[3], 
			      const DFLOAT eta[3], 
			      const BFieldStruct& bf, 
			      WTrackStruct& w2,
			      DFLOAT& arcLength );
   
   int trk_decay_( const integer& hepIndexF,
		   const WTrackStruct& wtrack,
		   const PathStruct& path );
}

// access functions for common block information
extern "C" {
   void volume_parms_( integer& dev, float& zmin, float& zmax );

   integer get_rplane_num_();
   integer get_zplane_num_();
   integer get_dipole_num_();
   integer get_emcal_num_();
   integer emcal_is_tube_( const integer& index );
   integer emcal_is_box_ ( const integer& index );

   void get_rplane_info_(
      const integer& index,
      integer& orderedIndex,
      char* name,
      integer& itype,
      real& radl, real& dedx, real& coll, real& absp,
      real& radius, real& zmin, real& zmax,
      integer& deviceIndexF, integer& layerIndexF, integer& wedgeIndexF,
      integer nameLength
      );
   
   void get_zplane_info_(
      const integer& index,
      integer& orderedIndex,
      char* name,
      integer& itype, integer& shape,
      real& radl, real& dedx, real& coll, real& absp,
      real& z, real& rmin, real& rmax, 
      real& xmin, real& xmax, real& ymin, real& ymax,
      integer& deviceIndexF, integer& layerIndexF, integer& wedgeIndexF,
      integer nameLength
      );

   void get_dipole_info_(
      const integer& index,
      char* name,
      real& xmin, real& xmax, real& ymin, real& ymax, real& zmin, real& zmax,
      real direction_cosines[3],
      integer nameLength
      );

   void get_detector_dimensions_( DFLOAT& rmax, DFLOAT& zmin, DFLOAT& zmax );
}



// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:34  eugenio
// Initial revision
//
// Revision 1.7  1999/04/22 01:29:03  mkl
// use a 'distanceToBeat' variable to speed up algorithm
//
// Revision 1.6  1999/02/15  19:03:33  mkl
// added Box-shaped Calorimeters
//
// Revision 1.5  1998/11/03  17:43:40  mkl
// changes to compile under egcs
//
// Revision 1.4  1998/02/16  04:33:44  mkl
// first version of 2ndary interactions
//
// Revision 1.3  1997/11/22  20:26:37  mkl
// keep track of fortran name of planes
//
// Revision 1.2  1997/08/23  01:10:18  mkl
// toward volume-based tracing
//
// Revision 1.1  1997/07/03  03:33:58  mkl
// new approach: surfaces vs volumes; box tracing
//
//


#endif /* ExternFortran_H */
