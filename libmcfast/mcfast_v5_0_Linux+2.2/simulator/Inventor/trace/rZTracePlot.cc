#include <math.h>
#include <Inventor/nodes/SoRotation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/SbLinear.h>
#include <Inventor/fields/SoMFVec3f.h>
#include <Inventor/nodes/SoCoordinate3.h>
#include <Inventor/nodes/SoSwitch.h>
#include <Inventor/nodes/SoLineSet.h>
#include <Inventor/nodes/SoMaterial.h>
#include "rZTracePlot.hh"
#include "pointsStruct.hh"
#include "traceCommon.hh"
#include "hepvis/SoMcFTraceKit.hh"

SoSwitch *rZTracePlot::makeTraceSegment(int ihep, myRGB color)
{
   Points *trPoints = NULL;
   int nstation = NumTracePoints(ihep);
   float radius;
    char name[132];

   SoSwitch *trace = new SoSwitch;
   trace->ref();
//   SoRotationXYZ *zRotation = new SoRotationXYZ;
//   zRotation->axis = SoRotationXYZ::Z;
//   zRotation->angle = PI/2.;
//   trace->addChild(zRotation);

//   SoRotationXYZ *Rotation = new SoRotationXYZ;
//   Rotation->axis = SoRotationXYZ::X;
//   Rotation->angle = PI/2.;



   if( NumTracePoints(ihep) > 0 )
   {

       SoMcFTraceKit *traceKit = new SoMcFTraceKit();
       SoCoordinate3 *traceCoords = (SoCoordinate3 *)
	   traceKit->getPart("Coord3", TRUE);
       SoLineSet *traceLine = (SoLineSet *)
	   traceKit->getPart("LineSet", TRUE);
       traceKit->traceid = ihep;
       traceKit->generateAlternateRep();


       SbVec3f axis;
       axis.setValue(0.0,0.,1.0);

       SoTransform *transform = (SoTransform *)
	   traceKit->getPart("Transform", TRUE);
       transform->rotation.setValue(axis,M_PI/2.);


       trPoints = new Points[NumTracePoints(ihep)];
       GetTracePoint(ihep, trPoints);
       for(int i = 0; i < NumTracePoints(ihep); i++)
       {
	  traceCoords -> point.set1Value(i,trPoints[i].x, trPoints[i].z,
	  0.0);
       }

       traceLine ->numVertices.setValues(0,1,&nstation);

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
