#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCube.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "twoXZRectPlanes.hh"

SoSeparator *twoXZRectPlanes::makeSiZRectLayer(void)
{
//This type of McFRectLayer has two planes separated by a gap in X
    SoSeparator *sep = new SoSeparator;
    sep->ref();
//make the representation of the layer 
    SoCube *layer = new SoCube;
    layer->width.setValue((layerData.lenXLayer-layerData.lenXGap)/2.);
    layer->height.setValue(layerData.lenYLayer);
    layer->depth.setValue(layerData.thick);
    
    SoSeparator *SepX1 = new SoSeparator;
    SoSeparator *SepX2 = new SoSeparator;
    
//put the halves of the layer separated by a gap
    SoTransform *transX1 = new SoTransform;
    transX1->translation.setValue
        (-((layerData.lenXLayer-layerData.lenXGap)/4. + layerData.lenXGap/2.),
         0.0,0.0);
    SepX1->addChild(transX1);
    SepX1->addChild(layer);
    
    SoTransform *transX2 = new SoTransform;
    transX2->translation.setValue(
       ((layerData.lenXLayer-layerData.lenXGap)/4. + layerData.lenXGap/2.),
       0.0,0.0);
    SepX2->addChild(transX2);
    SepX2->addChild(layer);

    sep->addChild(SepX1);
    sep->addChild(SepX2);
    sep->unrefNoDelete();
    return sep;
    
}
int twoXZRectPlanes::findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y)
{
// returns the CENTER of the wedge corresponding to this wafer
      
   float deltaX = (layerData.lenXLayer-layerData.lenXGap 
                   - deadX(layerData,waferData))/layerData.nwaferX;
   
   float deltaY = (layerData.lenYLayer-deadY(layerData,waferData))
                                     /layerData.nwaferY;

   float xLen = (layerData.lenXLayer-layerData.lenXGap)/2.;

   float xdir = layerData.startXWafer < 0. ? 1 : -1;
   float ydir = layerData.startYWafer < 0. ? 1 : -1;

   
   x =  (deltaX*Icol + deltaX/2.) > xLen ?
       layerData.startXWafer + xdir*(deltaX*Icol + deltaX/2.) :
       layerData.startXWafer + xdir*(deltaX*Icol + deltaX/2. +
                         layerData.lenXGap);
			 
   y = layerData.startYWafer + ydir*(deltaY*Irow + deltaY/2.);
   if(x > layerData.lenXLayer) return -1;
   if(y > layerData.lenYLayer) return -1;
   return 0;
}
