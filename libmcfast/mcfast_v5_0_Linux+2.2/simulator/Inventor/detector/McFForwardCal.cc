#include <math.h>
#include "McFForwardCal.hh"

McFForwardCal::McFForwardCal(float pos, float zlen, float radmin[2],
                       float radmax[2], int nphi, int neta) :
                       McFProjectiveCal(pos, zlen, radmin, radmax, nphi, neta,
                       NULL)
{ 

    return;
}
void McFForwardCal::findEtaAtBoundary(void)
{
   double thetaCal[2];
   double zmin, zmax;
   zmin = calData.z0 - calData.zLength/2.;
   zmax = calData.z0 + calData.zLength/2.;
   if( zmin < 0. && zmax < 0.)
   {
      thetaCal[1] =   fabs( atan2( calData.rMin[1], zmax ) );    
      etaCal[0] = - log( tan( thetaCal[1]/2. ) );
      thetaCal[0] =   fabs( atan2( calData.rMax[1], zmax ) );    
      etaCal[1] = - log( tan( thetaCal[0]/2. ) );
   }
   else if( zmin > 0. && zmax > 0.)
   {
       thetaCal[1] =   fabs( atan2( calData.rMax[0], zmin ) );    
       etaCal[0] = - log( tan( thetaCal[1]/2. ) );
       thetaCal[0] =   fabs( atan2( calData.rMin[0], zmin ) );    
       etaCal[1] = - log( tan( thetaCal[0]/2. ) );
   }
   Deta = fabs( etaCal[1] - etaCal[0] );  

}
void McFForwardCal::CheckCalEdges(double *theta, double *radius, double *zpos)
{
   double slope, intercept;
   double zmin, zmax;

    zmin = calData.z0 - calData.zLength/2.;
    zmax = calData.z0 + calData.zLength/2.;

    if( *zpos == zmin && *radius < calData.rMax[0] ) return;
    if( *zpos == zmax && *radius < calData.rMax[1] ) return;

   //the radius can vary with z 
    slope = (calData.rMax[1] - calData.rMax[0])/(zmax-zmin);
    intercept = (calData.rMax[0]*zmax - calData.rMax[1]*zmin)
                       /(zmax-zmin);


    *zpos = intercept / ( tan( (*theta) ) - slope );
    *radius = slope * (*zpos) + intercept;
    return;
}
void McFForwardCal::getNominalPositions
            (int ieta, double *theta, double *rnom, double *znom)
{
    double zmin = calData.z0 - calData.zLength/2.,
           zmax = calData.z0 + calData.zLength/2.;

    if (ieta >= 0)
    {
	rnom[0] = zmin * tan( theta[0] );
	rnom[1] = zmin * tan( theta[1] );
	rnom[2] = zmax * tan( theta[0] );
	rnom[3] = zmax * tan( theta[1] );
	znom[0] = zmin;
	znom[1] = zmin;
	znom[2] = zmax;
	znom[3] = zmax;
 
    }
    else
    {
        //Branch for generating cell for Phi 2d display
        znom[0] = calData.z0; 
        znom[1] = calData.z0; 
        znom[2] = calData.z0; 
        znom[3] = calData.z0;
        rnom[0] = (calData.rMin[1] + calData.rMin[0])/2.;
        rnom[1] = rnom[0];
        rnom[2] = (calData.rMax[1] + calData.rMax[0])/2.;
        rnom[3] = rnom[2];
    }
    return;
}
