#include <Inventor/SbLinear.h>
#include <Inventor/fields/SoMFVec3f.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodes/SoCone.h>
#include "threeDTracePlot.hh"
#include "hepvis/SoMcFTraceKit.hh"
#include "pointsStruct.hh"
#include "traceCommon.hh"
#include <math.h>

SoSwitch *threeDTracePlot::makeTraceSegment(int ihep, myRGB color)
{
   Points *trPoints = NULL;
   int nstation = NumTracePoints(ihep);
   SoSwitch *trace = new SoSwitch;
   trace->ref();

   if(NumTracePoints(ihep) > 0 )
   {
       SoMcFTraceKit *traceKit = new SoMcFTraceKit();
       SoCoordinate3 *traceCoords = (SoCoordinate3 *)
	   traceKit->getPart("Coord3", TRUE);
       SoLineSet *traceLine = (SoLineSet *)
	   traceKit->getPart("LineSet", TRUE);
       traceKit->traceid = ihep;
       traceKit->generateAlternateRep();

       trPoints = new Points[NumTracePoints(ihep)];
       GetTracePoint(ihep, trPoints);
       for(int i = 0; i < NumTracePoints(ihep); i++)
       {
	  traceCoords -> point.set1Value(i,trPoints[i].x, trPoints[i].y,
	  trPoints[i].z);
       }

       traceLine -> numVertices.setValues(0,1,&nstation);

       SoMaterial *tMaterial = (SoMaterial *)
	      traceKit->getPart("Appearance.material",TRUE);
       tMaterial->diffuseColor.setValue(color.red,color.green,color.blue);
       trace->addChild(traceKit);
       delete [] trPoints;

    }
    trace->unrefNoDelete();
    return trace;


}
