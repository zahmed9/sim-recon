#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/nodes/SoCube.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "twoYZRectPlanes.hh"

SoSeparator *twoYZRectPlanes::makeSiZRectLayer(void)
{
    SoSeparator *sep = new SoSeparator;
    sep->ref();
//make the representation of the layer 
    SoCube *layer = new SoCube;
    layer->width.setValue(layerData.lenXLayer);
    layer->height.setValue((layerData.lenYLayer-layerData.lenYGap)/2.);
    layer->depth.setValue(layerData.thick);
    
    SoSeparator *SepY1 = new SoSeparator;
    SoSeparator *SepY2 = new SoSeparator;
    
//put the halves of the layer separated by a gap
    SoTransform *transY1 = new SoTransform;
    transY1->translation.setValue(0.0 ,
                   -((layerData.lenYLayer - layerData.lenYGap)/4. +
                   layerData.lenYGap/2.),0.0);
    SepY1->addChild(transY1);
    SepY1->addChild(layer);
    
    SoTransform *transY2 = new SoTransform;
    transY2->translation.setValue(0.0,
    ((layerData.lenYLayer-layerData.lenYGap)/4. + layerData.lenYGap/2.),0.0);
    SepY2->addChild(transY2);
    SepY2->addChild(layer);

    sep->addChild(SepY1);
    sep->addChild(SepY2);
    sep->unrefNoDelete();
    return sep;
}
int twoYZRectPlanes::findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y)
{
// returns the CENTER of the wedge corresponding to this wafer
   
   float deltaX = (layerData.lenXLayer-deadX(layerData,waferData))
                   /layerData.nwaferX;
   float deltaY = (layerData.lenYLayer-layerData.lenYGap
                   -deadY(layerData,waferData))/layerData.nwaferY;

   float yLen = (layerData.lenYLayer-layerData.lenYGap)/2.;

   float xdir = layerData.startXWafer < 0. ? 1 : -1;
   float ydir = layerData.startYWafer < 0. ? 1 : -1;
   
   x = layerData.startXWafer + xdir*(deltaX*Icol + deltaX/2.);
   y = (deltaY*Irow + deltaY/2.) < yLen ?
       layerData.startYWafer + ydir*(deltaY*Irow + deltaY/2.) :
       layerData.startYWafer + ydir*(deltaY*Irow + deltaY/2. +
                         layerData.lenYGap);
   if(x > layerData.lenXLayer) return -1;
   if(y > layerData.lenYLayer) return -1;
   return 0;
}
