#include <Inventor/nodes/SoSeparator.h>
#include <Inventor/nodes/SoCube.h>
#include <math.h>
#include <stdio.h>
#include <iostream.h>
#include "SilZRectData.hh"  //includes both layer and global sil structures
#include "absZRectWafer.hh"
SoCube *absZRectWafer::MakeSiZRectWafer(SilZRectWaferData waferData)
{
    SoCube *Cube = new SoCube;
    Cube->ref();
    Cube->width.setValue(waferData.lenYWaf);
    Cube->height.setValue(waferData.lenYWaf);
    Cube->depth.setValue(waferData.thick);
    Cube->unrefNoDelete();
    return Cube;
}
float absZRectWafer::zTile(stagger Pattern, int icol, int irow)
{
  if(Pattern == XTILE) return (pow(-1.,(double)(icol)));
  if(Pattern == YTILE) return (pow(-1.,(double)(irow))); 
  if(Pattern == CHECKER)return (pow(-1.,(double) (icol)) *
                                           pow(-1.,(double) (irow)));
  return 1.;
   
}
int absZRectWafer::findPixelXYPosition(int IxPix, int IyPix,
                                       SilZRectWaferData waferData,
				       float &x, float &y)
{
    //startXPixel and startYPixel must be local to the wafer...
    
    float dirX = waferData.startXPixel < 0. ? 1 : -1;
    float dirY = waferData.startYPixel < 0. ? 1 : -1;
    
    x = waferData.startXPixel + dirX*((IxPix+0.5)*waferData.pitchX);
    y = waferData.startYPixel + dirY*((IyPix+0.5)*waferData.pitchY);
    return 1;
}
