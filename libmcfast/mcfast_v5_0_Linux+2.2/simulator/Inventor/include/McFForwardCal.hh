#include "McFProjectiveCal.hh"

#ifndef _MCFFORWARDCAL_
#define  _MCFFORWARDCAL_
class McFForwardCal : public McFProjectiveCal
{
     public:
         McFForwardCal():McFProjectiveCal()
         {
           return;
         }
         McFForwardCal(float z0, float zlen, float radmin[2],
                      float radmax[2], int nphi, int neta);
         void CheckCalEdges(double *theta, double *radius, double *zpos);
         void getNominalPositions
            (int ieta, double *theta, double *rnom, double *znom);

         void findEtaAtBoundary(void);
     private:
};
#endif
