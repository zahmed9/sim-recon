#include "McFProjectiveCal.hh"

#ifndef _MCFBARRELCAL_
#define  _MCFBARRELCAL_
class McFBarrelCal : public McFProjectiveCal
{
     public:
         McFBarrelCal():McFProjectiveCal()
         {
           return;
         }
         McFBarrelCal(float z0, float zlen, float radmin[2],
                      float radmax[2], int nphi, int neta);
         void CheckCalEdges(double *theta, double *radius, double *zpos);
         void getNominalPositions
            (int ieta, double *theta, double *rnom, double *znom);
         void findEtaAtBoundary(void);
     private:

};
#endif
