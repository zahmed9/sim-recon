#include "McFBoxCal.hh"
#include "calorBoxCommon.hh"
#include <Inventor/fields/SoSFFloat.h>
#include "hepvis/SoMcFBoxWithGap.hh"
#include <Inventor/nodes/SoTransform.h>
McFBoxCal::McFBoxCal(void)
{
//nominal calorimeter

      calData.z0 = 0.;

      calData.xLenInner = 10.;
      calData.yLenInner = 10.;
      calData.xLenOuter = 20.;
      calData.yLenOuter = 20. ;

      calData.zLenInner = 100.;
      calData.zLenOuter = 100.;
      calData.nSeg1 = 1;
      calData.nSeg2 = 1;

}
void McFBoxCal::setCalData(boxCalData data)
{
      calData.z0 = data.z0;

      calData.xLenInner = data.xLenInner;
      calData.yLenInner = data.yLenInner;
      calData.xLenOuter = data.xLenOuter;
      calData.yLenOuter = data.yLenOuter ;

      calData.zLenInner = data.zLenInner;
      calData.zLenOuter = data.zLenOuter;
      calData.nSeg1 = data.nSeg1;
      calData.nSeg2 = data.nSeg2;

}
void McFBoxCal::setFullRepresentation(SoSeparator *full)
{
}
void McFBoxCal::setPreviewRepresentation(SoSeparator *prev)
{
    SoMcFBoxWithGap *Block = new SoMcFBoxWithGap;
    Block->fDxOuter.setValue(calData.xLenOuter); 
    Block->fDyOuter.setValue(calData.yLenOuter); 
    Block->fDzOuter.setValue(calData.zLenOuter); 
    Block->fDxInner.setValue(calData.xLenInner); 
    Block->fDyInner.setValue(calData.yLenInner); 
    Block->fDzInner.setValue(calData.zLenInner); 
    Block->generateAlternateRep();
    
}
void McFBoxCal::setCellIndices(int icr1, int icr2, SoCoordinate3 *coords)
{
     float dx = calData.xLenOuter/calData.nSeg1;
     float dy = calData.xLenOuter/calData.nSeg1;
     float x[8], y[8], z[8];
       x[0] = (icr1+.5)*dx;
       y[0] = (icr2+.5)*dy;
       z[0] = calData.zLenOuter;
     
       y[1] = - y[0]; x[1] = x[0]; z[1] = z[0]; 
       
       x[4] =  (icr1+.5)*dx;
       y[4] =  (icr2+.5)*dy;
       z[4] =  -calData.zLenOuter;
     
       y[5] = - y[4]; x[5] = x[4]; z[5] = z[4]; 
       
       x[3] = -(icr1+.5)*dx;
       y[3] = (icr2+.5)*dy;
       z[3] = calData.zLenOuter;
     
       y[2] = - y[3]; x[2] = x[3]; z[2] = z[3]; 

       x[7] = -(icr1+.5)*dx;
       y[7] = (icr2+.5)*dy;
       z[7] = -calData.zLenOuter;
     
       y[6] = - y[7]; x[6] = x[7]; z[6] = z[7]; 
       for (int i = 0; i < 8; i++)
          coords->point.set1Value(i,x[i],y[i],z[i]);
       return;
 
}
void McFBoxCal::setCellTransform(int icr1, int icr2, SoTransform *transform)
{
      float dx = calData.xLenOuter/calData.nSeg1;
      float dy = calData.yLenOuter/calData.nSeg2;
      
      transform->translation.setValue(0.0, 0.0, 0.0);
}
void McFBoxCal::setDetectorTranslation(SoTransform *transform)
{
      transform->translation.setValue(0.,0.0, this->calData.z0);
      return;

}
