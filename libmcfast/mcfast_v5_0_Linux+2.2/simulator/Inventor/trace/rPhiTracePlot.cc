#include <Inventor/SbLinear.h>
#include <Inventor/fields/SoMFVec3f.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoPointSet.h>
#include <Inventor/nodes/SoMaterial.h>
#include "rPhiTracePlot.hh"
#include "pointsStruct.hh"
#include "traceCommon.hh"
#include "hepvis/SoMcFTraceKit.hh"

SoSwitch *rPhiTracePlot::makeTraceSegment(int ihep, myRGB color)
{
   Points *trPoints = NULL;
   int  nstation = NumTracePoints(ihep);
   char name[132];

   SoSwitch *trace = new SoSwitch;
   trace->ref();

   if( NumTracePoints(ihep) > 0 )
   {

       SoMcFTraceKit *traceKit = new SoMcFTraceKit();
       SoCoordinate3 *traceCoords = (SoCoordinate3 *)
	   traceKit->getPart("Coord3", TRUE);
       SoPointSet *tracePoint = (SoPointSet *)
	   traceKit->getPart("PointSet", TRUE);
       traceKit->traceid = ihep;
       traceKit->generateAlternateRep();

       trPoints = new Points[NumTracePoints(ihep)];
       GetTracePoint(ihep, trPoints);
       for(int i = 0; i < NumTracePoints(ihep); i++)
       {
	  traceCoords -> point.set1Value(i,trPoints[i].x, trPoints[i].y,
	  0.0);
       }

       tracePoint ->numPoints.setValue(nstation);

       SoMaterial *tMaterial = (SoMaterial *)
	      traceKit->getPart("Appearance.material",TRUE);
       tMaterial->diffuseColor.setValue(color.red,color.green,color.blue);

       trace->addChild(traceKit); 
       sprintf(name, "ihep_%d",ihep);
       SbName *traceName = new SbName(name);
       trace->setName(*traceName);
    }
    trace->unrefNoDelete();
    return trace;


}
