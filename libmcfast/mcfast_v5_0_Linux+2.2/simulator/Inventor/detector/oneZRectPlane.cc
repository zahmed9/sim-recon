#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCube.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "oneZRectPlane.hh"


SoSeparator *oneZRectPlane::makeSiZRectLayer
                             (void)
{
//This type of McFRectLayer has one plane
   
    SoSeparator *sep = new SoSeparator;
    sep->ref();
    SoCube *layer = new SoCube;
    layer->width.setValue(layerData.lenXLayer);
    layer->height.setValue(layerData.lenYLayer );
    layer->depth.setValue(layerData.thick);
    sep->addChild(layer);
    sep->unrefNoDelete();
    return sep;
}
int oneZRectPlane::findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y)
{
//   This is the easy one! No gaps to worry about.

   float deltaX = (layerData.lenXLayer-deadX(layerData,waferData))
                                     /layerData.nwaferX;
   float deltaY = (layerData.lenYLayer-deadY(layerData,waferData))
                                     /layerData.nwaferY;

   float xdir = layerData.startXWafer < 0. ? 1 : -1;
   float ydir = layerData.startYWafer < 0. ? 1 : -1;
   //position should be centered--add 1/2 distance
   x = layerData.startXWafer + xdir*(deltaX*Icol + deltaX/2.);
   y = layerData.startYWafer + ydir*(deltaY*Irow + deltaY/2.);
   if(x > layerData.lenXLayer) return -1;
   if(y > layerData.lenYLayer) return -1;
   return 0;
}
