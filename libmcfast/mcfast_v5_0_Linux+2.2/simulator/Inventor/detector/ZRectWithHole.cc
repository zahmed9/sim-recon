#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoTransform.h>
#include <Inventor/fields/SoSFFloat.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "absZRectLayer.hh"
#include "ZRectWithHole.hh"
#include "hepvis/SoMcFBoxWithGap.hh"

SoSeparator *ZRectWithHole::makeSiZRectLayer(void)
{
    SoSeparator *sep = new SoSeparator;
    sep->ref();

//make the representation of the layer 
    SoMcFBoxWithGap *layer = new SoMcFBoxWithGap;
    layer->fDxInner.setValue(layerData.lenXGap/2.);
    layer->fDyInner.setValue(layerData.lenYGap/2.);
    layer->fDzInner.setValue(layerData.thick/2.);
    layer->fDxOuter.setValue(layerData.lenXLayer/2.);
    layer->fDyOuter.setValue(layerData.lenYLayer/2.);
    layer->fDzOuter.setValue(layerData.thick/2.);
    
    sep->addChild(layer);
    sep->unrefNoDelete();
    return sep;

}


int ZRectWithHole::findWaferXYPosition(int Icol, int Irow, 
                                  SilZRectLayerData layerData,
                                  SilZRectWaferData waferData,
                                  float &x, float &y)
{
//  This case is like that for a single plane, but with non-valid (x,y)
//  positions when the wafer is in the center.
   
//   This version does not take into account wafer1xlocal
//   and wafer1ylocal, but assumes that the
//   wafers start at the -x,-y edge of the layer.
   
   float xminGap = -layerData.lenXGap/2.;
   float xmaxGap = -xminGap;
   float yminGap = -layerData.lenYGap/2.;
   float ymaxGap = -yminGap;
   float xdir = layerData.startXWafer < 0. ? 1 : -1;
   float ydir = layerData.startYWafer < 0. ? 1 : -1;

   float deltaX = (layerData.lenXLayer-deadX(layerData,waferData))
                                     /layerData.nwaferX;
   float deltaY = (layerData.lenYLayer-deadY(layerData,waferData))
                                     /layerData.nwaferY;
   //position should be centered--add 1/2 distance
   x = layerData.startXWafer + xdir*(deltaX*Icol + deltaX/2.);
   y = layerData.startYWafer + ydir*(deltaY*Irow + deltaY/2.);
   if(x > xminGap && x < xmaxGap && y > yminGap && y < ymaxGap) return -1;
   if(x > layerData.lenXLayer) return -1;
   if(y > layerData.lenYLayer) return -1;
   return 0;
}
