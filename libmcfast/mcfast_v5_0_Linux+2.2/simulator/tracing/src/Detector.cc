// -*- C++ -*-
//
// Package:     Tracing
// Module:      Detector
// 
// Description: implements basic functionality of all derived detectors.
//
// Implimentation:
//     <Notes on implimentation>
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
#include "report.hh"

#include "Detector.hh"
#include "Medium.hh"

// list of all detector types
#include "DetBarrelSiliconLayer.hh"   
#include "DetDriftChamberAnode.hh"
#include "DetDriftChamberCathode.hh"
#include "DetForwardDriftChamber.hh"
#include "DetSiliconDiskLayer.hh"
#include "DetXYPixelPlane.hh"

#include "DetCalorimeter.hh"
#include "DetAbsorber.hh"

#include "BFieldBoundary.hh"

//
// constants, enums and typedefs
//
static const char* const kFacilityString = "Tracing.Detector";

//
// static data member definitions
//

//
// constructors and destructor
//
//Detector::Detector()
//{
//}

// Detector::Detector( const Detector& )
// {
// }

//Detector::~Detector()
//{
//}

//
// assignment operators
//
// const Detector& Detector::operator=( const Detector& )
// {
// }

//
// member functions
//

//
// const member functions
//

//
// static member functions
//
Detector*
Detector::createDetector( Medium::Type type )
{
   Detector *detector=0;

   switch( type ) {

      // first r planes
      case Medium::kDriftChamberAnode:
      {
	 detector = new DriftChamberAnode;
	 break;
      }
      case Medium::kDriftChamberCathode:
      {
	 detector = new DriftChamberCathode;
	 break;
      }
      case Medium::kBarrelSiliconLayer:
      {
	 detector = new BarrelSiliconLayer;
	 break;
      }
      case Medium::kRMaterial:
      {
	 detector = 0;
	 break;
      }
      case Medium::kRMagnet:
      {
	 detector = new BFieldBoundary;
	 break;
      }
      case Medium::kREMCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }
      case Medium::kRHadCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }

      // second z planes
      case Medium::kForwardDriftChamber:
      {
	 detector = new ForwardDriftChamber;
	 break;
      }
      case Medium::kSiliconDiskLayer:
      {
	 detector = new SiliconDiskLayer;
	 break;
      }
      case Medium::kZMaterial:
      {
	 detector = 0;
	 break;
      }
      case Medium::kZMagnet:
      {
	 detector = new BFieldBoundary;
	 break;
      }
      case Medium::kZEMCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }
      case Medium::kZHadCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }
      case Medium::kXYPixelPlane:
      {
	 detector = new XYPixelPlane;
	 break;
      }

      // boxes
      case Medium::kDipoleYoke:
      {
	 detector = new Absorber;
	 break;
      }
      case Medium::kBoxCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }

      case Medium::kDipoleMagnet:
      {
	 detector = new BFieldBoundary;
	 break;
      }

      // cylinders
      case Medium::kTubeCalorimeter:
      {
	 detector = new Calorimeter;
	 break;
      }

      default:
      {
	 report( ERROR, kFacilityString ) 
	    << "Detector: unknown detector type=" << int(type) << "\n";
	 detector=0;
	 break;
      }
   }

   return detector;
}


// ==================================================================
// Comments, suggestions, get on line 1!
//
// $Id$
// $Log$
// Revision 1.1  2000/06/19 19:59:32  eugenio
// Initial revision
//
// Revision 1.6  1999/02/15 19:03:31  mkl
// added Box-shaped Calorimeters
//
// Revision 1.5  1997/11/20  21:19:27  mkl
// new BFieldBoundary Detector to record traces on field boundaries
//
// Revision 1.4  1997/11/11  01:17:31  mkl
// Major rewrite: simplify tracing loops; add x-, y-tracing loops
//
// Revision 1.3  1997/08/23  01:10:11  mkl
// toward volume-based tracing
//
// Revision 1.2  1997/07/03  03:33:47  mkl
// new approach: surfaces vs volumes; box tracing
//
// Revision 1.1.1.1  1997/03/14  22:52:33  mkl
// Imported sources for Martin Lohner s new c++ tracing code
//


