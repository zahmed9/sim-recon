#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include "McfCalGeomDisplay.hh"
#include "boxCalData.hh"

#ifndef _MCFBOXCAL_
#define  _MCFBOXCAL_
#include  "projectiveCalData.hh"
class McFBoxCal : public McfCalGeomDisplay
{
  public:
      boxCalData calData;
      
      //use this constructor
      McFBoxCal(void);  
                                                
      ~McFBoxCal();
      void 
      setFullRepresentation(SoSeparator *full);
      void 
      setPreviewRepresentation(SoSeparator *prev);
      void
      setCellIndices(int icr1, int icr2, SoCoordinate3 *coords);
      void
      setCellTransform(int icr1, int icr2, SoTransform *transform);
      void setDetectorTranslation(SoTransform *transform);

      void setCalData(boxCalData data);
      int nseg1(){return calData.nSeg1;}
      int nseg2(){return calData.nSeg2;}
  protected:



};
#endif
