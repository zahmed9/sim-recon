#include <math.h>
#include "McFBarrelCal.hh"

McFBarrelCal::McFBarrelCal(float pos, float zlen, float radmin[2],
                       float radmax[2], int nphi, int neta) :
              McFProjectiveCal(pos, zlen, radmin, radmax, nphi, neta,
              NULL)
{ 
    return;
}

void McFBarrelCal::findEtaAtBoundary(void)
{
    double thetaCal[2];
    double zmin, zmax;
    zmin = calData.z0 - calData.zLength/2.;
    zmax = calData.z0 + calData.zLength/2.;
    if( zmin < 0.0)
    {
      thetaCal[1] =  fabs( atan2( calData.rMin[0], zmin ) );
      etaCal[0] = - log( tan( thetaCal[1]/2. ) );
    }
    else if (zmin > 0.0)
    {
      thetaCal[1] = fabs( atan2( calData.rMax[0], zmin ) );
      etaCal[0] = - log( tan( thetaCal[1]/2. ) );
    }
    else
    {
      etaCal[0] = 0.0;
    }  
    if( zmax < 0)
    {
      thetaCal[0] =  fabs( atan2( calData.rMax[1], zmax) );
      etaCal[1] = - log( tan( thetaCal[0]/2. ) );
    }
    else if( zmax > 0)
    {
      thetaCal[0] =  fabs( atan2( calData.rMin[1], zmax) );
      etaCal[1] = - log( tan( thetaCal[0]/2. ) );
    }
    else
    {
      etaCal[1] = 0.0;
    }
    Deta = fabs( etaCal[1] - etaCal[0] );  

}

void McFBarrelCal::CheckCalEdges(double *theta, double *radius, double *zpos)
{
  float zmin, zmax;

  zmin = calData.z0 - calData.zLength/2.;
  zmax = calData.z0 + calData.zLength/2.;
  
  if(zmin < 0.0 && zmax > 0.0)
  {
      if( fabs( *zpos ) > (calData.zLength/2.))
      {
        *radius = calData.rMax[0] - fabs(tan( *theta) * 
                  ( calData.zLength/2. - fabs( *zpos ) ));
        if(*zpos < zmin) *zpos = zmin;
        if(*zpos > zmax) *zpos = zmax; 
      }

  }
  else if(  zmin < 0.0 && zmax <= 0.0  )
  {
    //account for round off in calculating
    if( *zpos/zmax > 0.9998 && *zpos/zmax < 1.0002 ) *zpos = zmax;
    if( *zpos/zmin > 0.9998 && *zpos/zmin < 1.0002 ) *zpos = zmin;
    if( *zpos < zmin )
    {
      *radius = calData.rMax[0] -
                fabs(tan( *theta) * 
                fabs( zmin - *zpos  ));
      *zpos = zmin;
    }
    else if( *zpos > zmax )
    {
      *radius = calData.rMin[0] +
                fabs(tan( *theta) * 
                fabs( zmax - *zpos  ));
      *zpos = zmax;
    }
  }
  else if(  zmin >= 0.0 && zmax > 0.0 )
  {
    //account for round off
    if( *zpos/zmax > 0.9998 && *zpos/zmax < 1.0002 ) *zpos = zmax;
    if( *zpos/zmin > 0.9998 && *zpos/zmin < 1.0002 ) *zpos = zmin;
    if( *zpos > zmax )
    {
      *radius = calData.rMax[0] -
                fabs(tan( *theta) * 
                fabs( zmax - *zpos  ));
      *zpos = zmax;
    }
    else if( *zpos < zmin )
    {
      *radius = calData.rMin[0] +
                fabs(tan( *theta) * 
                fabs( zmin - *zpos  ));
      *zpos = zmin;
    }
    
  }
  return;
}
void McFBarrelCal::getNominalPositions
            (int ieta, double *theta, double *rnom, double *znom)
{
    double zmin = calData.z0 - calData.zLength/2.,
           zmax = calData.z0 + calData.zLength/2.;
      if( ieta >= 0 )
      {
        znom[0] = calData.rMin[0] * tan( M_PI/2. - theta[0] );
        znom[1] = calData.rMin[0] * tan( M_PI/2. - theta[1] );    
        znom[2] = calData.rMax[0] * tan( M_PI/2. - theta[0] );    
        znom[3] = calData.rMax[0] * tan( M_PI/2. - theta[1] );
      }
      else
      {
        //Branch for generating 2d phi display
        znom[0] = calData.z0;  
        znom[1] = calData.z0;  
        znom[2] = calData.z0; 
        znom[3] = calData.z0;
       
      }
      if( calData.nEta == 1 )  //all the above won't work.
      {
        znom[0] = zmin;
        znom[1] = zmax;
        znom[2] = zmin;
        znom[3] = zmax;
      }
      rnom[0] = calData.rMin[0];
      rnom[1] = calData.rMin[0];
      rnom[2] = calData.rMax[0];
      rnom[3] = calData.rMax[0];
      return;

}

