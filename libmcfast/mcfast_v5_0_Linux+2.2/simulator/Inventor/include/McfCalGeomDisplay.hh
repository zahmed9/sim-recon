#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCoordinate3.h>
#ifndef _MCFCALGEOMDISPLAY_
#define  _MCFCALGEOMDISPLAY_

class McfCalGeomDisplay
{
    public:
     virtual void 
      setFullRepresentation(SoSeparator *full) = 0;
     virtual void 
      setPreviewRepresentation(SoSeparator *prev) = 0;
     virtual void
      setCellIndices(int icr1, int icr2, SoCoordinate3 *coords) = 0;
     virtual void
      setCellTransform(int icr1, int icr2, SoTransform *transform) = 0;
     virtual void
      setDetectorTranslation(SoTransform *transform) = 0;
     virtual int nseg1() = 0;
     virtual int nseg2() = 0;

};
#endif
