#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include "McfCalGeomDisplay.hh"

#ifndef _MCFPROJECTIVECAL_
#define  _MCFPROJECTIVECAL_
#include  "projectiveCalData.hh"
class McFProjectiveCal : public McfCalGeomDisplay
{
  public:
      projectiveCalData calData;
      double etaCal[2];  // eta at the edges of the calorimeter, calculated
                      // from radius and Z information
      float Deta;     // the size of the eta segments, calculated
      char *name;     // give the thing a name
      
      //use this constructor
      McFProjectiveCal(void);  
      McFProjectiveCal(float z0, float zlen, float radmin[2],
                       float radmax[2], int nphi, int neta,char *string);                       
                                              
      ~McFProjectiveCal();
      void 
      setFullRepresentation(SoSeparator *full);
      void 
      setPreviewRepresentation(SoSeparator *prev);
      void
      setCellIndices(int icr1, int icr2, SoCoordinate3 *coords);
      void
      setCellTransform(int icr1, int icr2, SoTransform *transform);
      void setDetectorTranslation(SoTransform *transform);

      void getThetaEdge(int ieta, double *theta);
      void setCalData(projectiveCalData data);
      virtual void 
      CheckCalEdges(double *theta, double *radius, double *zpos) = 0;
      
      virtual void 
      getNominalPositions(int ieta, double *theta, double *rnom, double *znom)= 0;
      virtual void findEtaAtBoundary(void) = 0;
      int nseg1(){return calData.nPhi;}
      int nseg2(){return calData.nEta;}
  protected:



};
#endif
