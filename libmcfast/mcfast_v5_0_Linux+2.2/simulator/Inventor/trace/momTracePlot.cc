#include <math.h>
#include <Inventor/nodes/SoCone.h>
#include <Inventor/nodes/SoMaterial.h>
#include <Inventor/nodes/SoTranslation.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoRotation.h>
#include <Inventor/nodes/SoRotationXYZ.h>
#include <Inventor/nodes/SoSwitch.h>
#include "momTracePlot.hh"
#include "traceCommon.hh"
SoSwitch *momTracePlot::makeTraceSegment(int ihep, myRGB color)
{
   int ntrace, firstTrace;
    char name[132];

   SoSwitch *trace = new SoSwitch;

   ntrace =  NumTracePoints(ihep);
     return trace;


}
