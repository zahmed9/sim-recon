#ifndef MCFASTDST
#define MCFASTDST
#include "mcfdat_dst.h"
#endif
#include "SiXYCommon.hh"
#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "hitsCommon.hh"
#include "pointsStruct.hh"
#include "SilBarrelHitData.hh" 
#include "SilDiskHitData.hh" 
#include "SilXYHitData.hh" 
#include "SilZRectHitData.hh" 
#include "mcfFile.hh"
#include "McfastHitTypes.hh"

static int nSilBarrelHits = 0;
static int nSilDiskHits   = 0;
static int nDrfBarrelHits = 0;
static int nDrfPlaneHits  = 0; 
static int nSilPixelHits  = 0;
static int nSilXYHits     = 0;
static int nSilZRectHits  = 0;
static int nPixelBarrel   = 0;
static int nMuon          = 0;
static int nWhoKnows      = 0;

void FindNumberOfDeviceHits(void)
{
    static int eveno = -999999;
    int i;
    if(mcfFile::getEventNumber() != eveno)
    {
      eveno = mcfFile::getEventNumber();
      nSilBarrelHits = 0;
      nSilDiskHits   = 0;
      nDrfBarrelHits = 0;
      nDrfPlaneHits  = 0;
      nSilPixelHits  = 0;
      nSilXYHits     = 0;
      nSilZRectHits  = 0;
      nPixelBarrel   = 0;
      nMuon          = 0;
      nWhoKnows      = 0;
      for(i = 0; i < *n_obj_hit_trk; i++)
      {
         if(hit_trk[i].chan.devtype == JDEV_SIBARREL)
         {
              nSilBarrelHits++;
         }
         else if(hit_trk[i].chan.devtype == JDEV_SILDISK) 
         {
              nSilDiskHits++;
         }
         else if(hit_trk[i].chan.devtype == JDEV_DRIFTBARREL) 
         {
              nDrfBarrelHits++;
         }
         else if(hit_trk[i].chan.devtype == JDEV_DRIFTPLANE) 
         {
              nDrfPlaneHits++;
         }
         else if(hit_trk[i].chan.devtype == JDEV_PIXELBARREL) 
         {
              nPixelBarrel++;
         }
         else if(hit_trk[i].chan.devtype == JDEV_PIXELPLANE) 
         {
              nSilPixelHits++;
    //Pixel hits can be either XY or zrect devices.  Since the XY device is
    //loaded first in Mcfast, they will be the first detectors
	      if(hit_trk[i].chan.devnum <= NumSilXY() )
	      {
	         nSilXYHits++;
	      }else
	      {
	         nSilZRectHits++;
	      }
         }
         else if(hit_trk[i].chan.devtype == JDEV_MUON) 
         {
              nMuon++;
         }
         else 
         {
              nWhoKnows++;
         } 
      }
       
    }
}
int GetSilBarrelHits(SilBarrelHitData *hitData)
{

   int ihit = 0;
   int i;
      FindNumberOfDeviceHits();
      if (nSilBarrelHits == 0) return nSilBarrelHits;
            
      for(i = 0; i < *n_obj_hit_trk; i++)
      {
         if(hit_trk[i].chan.devtype == JDEV_SIBARREL)
         {
          
            hitData[ihit].hitDetector = hit_trk[i].chan.devnum;
            hitData[ihit].hitLayer    = hit_trk[i].chan.devlayer;
            hitData[ihit].hitWafer    = hit_trk[i].chan.devwid[0];
            hitData[ihit].hitStrip    = hit_trk[i].chan.devwid[1];
            hitData[ihit].hitId       = i;
            ihit++;
         }
          
      }
      return nSilBarrelHits;
}
int NumSilBarrelHits(void)
{
    FindNumberOfDeviceHits();
    return nSilBarrelHits;
}
int GetSilDiskHits(SilDiskHitData *hitData)
{

   int ihit = 0;
   int i;
      FindNumberOfDeviceHits();
      if (nSilDiskHits == 0) return nSilDiskHits;
            
      for(i = 0; i < *n_obj_hit_trk; i++)
      {
         if(hit_trk[i].chan.devtype == JDEV_SILDISK)
         {
          
            hitData[ihit].hitDetector = hit_trk[i].chan.devnum;
            hitData[ihit].hitLayer    = hit_trk[i].chan.devlayer;
            hitData[ihit].hitWedge    = hit_trk[i].chan.devwid[0];
            hitData[ihit].hitStrip    = hit_trk[i].chan.devwid[1];
            hitData[ihit].hitId       = i;
            ihit++;
         }
          
      }
      return nSilDiskHits;
}
void GetTraceHits(int type, Points *trHits)
{
//Get the space points that correspond to the hits
  int trace;
  int ihit = 0;
  for(int i = 0; i < *n_obj_hit_trk; i++)
  {
     if(hit_trk[i].chan.devtype == type)
     {

        trace = hit_trk[i].trace-1;
        trHits[ihit].x = trace_par[trace].w.x;
        trHits[ihit].y = trace_par[trace].w.y;
        trHits[ihit].z = trace_par[trace].w.z; 
        ihit++; 
     }

  }
   
}
int NumSilDiskHits(void)
{
    FindNumberOfDeviceHits();
    return nSilDiskHits;
}
int NumSilXYHits(void)
{ 

    return nSilXYHits;
}
int NumSilZRectHits(void)
{ 
    FindNumberOfDeviceHits();
    return nSilZRectHits;
}
int GetSilZRectHits(SilZRectHitData *hitData)
{

   int ihit = 0;
   int i;
      FindNumberOfDeviceHits();
      if (nSilZRectHits == 0) return nSilZRectHits;
            
      for(i = 0; i < *n_obj_hit_trk; i++)
      {
         if(hit_trk[i].chan.devtype == JDEV_PIXELPLANE)
         {
	    if(hit_trk[i].chan.devnum > NumSilXY() )
            {
              hitData[ihit].hitDetector = hit_trk[i].chan.devnum;
              hitData[ihit].hitLayer    = hit_trk[i].chan.devlayer;
              hitData[ihit].hitWafer    = hit_trk[i].chan.devwid[0];
              hitData[ihit].hitIcolX    = hit_trk[i].chan.devwid[1];
              hitData[ihit].hitIrowY    = hit_trk[i].chan.devwid[2];
              hitData[ihit].hitId       = i;
              ihit++;
	    }
         }
          
      }
      return nSilXYHits;
}
int GetSilXYHits(SilXYHitData *hitData)
{

   int ihit = 0;
   int i;
      FindNumberOfDeviceHits();
      if (nSilXYHits == 0) return nSilXYHits;
            
      for(i = 0; i < *n_obj_hit_trk; i++)
      {
         if(hit_trk[i].chan.devtype == JDEV_PIXELPLANE)
         {
          
	    if(hit_trk[i].chan.devnum <= NumSilXY() )
            {
              hitData[ihit].hitDetector = hit_trk[i].chan.devnum;
              hitData[ihit].hitLayer    = hit_trk[i].chan.devlayer;
              hitData[ihit].hiticolX    = hit_trk[i].chan.devwid[0];
              hitData[ihit].hitirowY    = hit_trk[i].chan.devwid[1];
              hitData[ihit].hitId       = i;
            ihit++;
	    }
         }
          
      }
      return nSilXYHits;
}
char *hitMessage(int ihit)
{
    static char string[1000];
    ostrstream out(string, 1000);
    int trace = hit_trk[ihit].trace-1;

    if(ihit < 0 || ihit > *n_obj_hit_trk)
    {
       out << " Not a valid hit number!  Contact Amber !" << endl;
       out << '\000';
       return string;
    }

    out << "Hit Information" << endl
        << "Detector type = " << hit_trk[ihit].chan.devtype << endl
        << "Detector number = " << hit_trk[ihit].chan.devnum << endl
        << "Layer number = " << hit_trk[ihit].chan.devlayer << endl
        << "SubLayer number = " << hit_trk[ihit].chan.devwid[0] << endl
        << "Strip number  = " << hit_trk[ihit].chan.devwid[1] << endl
        << "Trace position (not exactly at the hit location" << endl
        << " (x, y, z) =  " << trace_par[trace].w.x << ", " 
                       << trace_par[trace].w.y << ", "
                       << trace_par[trace].w.z << endl;

   out << '\000';
   return string;
    
} 
