#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include "McfCalGeomDisplay.hh"

#ifndef _MCFRPHICAL_
#define  _MCFRPHICAL_
#include  "projectiveCalData.hh"
class McFRPhiCal : public McfCalGeomDisplay
{
  public:
      projectiveCalData calData;
      char *name;     // give the thing a name
      
      //use this constructor
      McFRPhiCal(void);  
      McFRPhiCal(float z0, float zlen, float radmin[2],
                       float radmax[2], int nphi, int neta,char *string);                       
                                              
      ~McFRPhiCal();
      void 
      setFullRepresentation(SoSeparator *full);
      void 
      setPreviewRepresentation(SoSeparator *prev);
      void
      setCellIndices(int icr1, int icr2, SoCoordinate3 *coords);
      void
      setCellTransform(int icr1, int icr2, SoTransform *transform);
      void setDetectorTranslation(SoTransform *transform);

      void setCalData(projectiveCalData data);
      
      int nseg1(){return calData.nPhi;}
      int nseg2(){return calData.nEta;} //in this case, nEta is nR
  protected:



};
#endif
