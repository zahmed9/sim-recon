#include "calInc.hh"
#include "math.h"
#include "mcfCalEnergy.hh"
#include "calorCommon.hh"
#include <iostream.h>
void mcfCalEnergy::fillCalEnergy(void)
{
// just fill up the energy for all calorimeters
  int ical, ihit, hitcounter;
  nhit = 0;
  hitcounter = 0;
  for (ical = 0; ical < NumCalorProj(); ical++)
  {
      nhit  = nhit + MCFNumHitCal[ical];
  }
  address = new towerHit[nhit];
  pMinEnergy = new float[nhit];
  pHadEnergy = new float[nhit];
  pEmEnergy = new float[nhit];
  for (ical = 0; ical < NumCalorProj(); ical++)
  {
      for(ihit = 0; ihit < MCFNumHitCal[ical]; ihit++)
      {
           (address + hitcounter)->ical = ical;
           (address + hitcounter)->ieta = 
                     MCFCalHits[ical][ihit]->icr2;
           (address + hitcounter)->iphi = 
                     MCFCalHits[ical][ihit]->icr1;
                     
           *(pMinEnergy + hitcounter) = MCFCalHits[ical][ihit]->e_mip; 
           *(pHadEnergy + hitcounter) = MCFCalHits[ical][ihit]->e_had; 
           *(pEmEnergy  + hitcounter) = MCFCalHits[ical][ihit]->e_em; 

           hitcounter++;
          
      }
  }
}
float mcfCalEnergy::energy(int ihit, calDispInfo Info)
{
   float energy = 0.0;
   if( Info.minEnergy == ON) energy += *(pMinEnergy + ihit);
   if( Info.hadEnergy == ON) energy += *(pHadEnergy + ihit);
   if( Info.emEnergy == ON)  energy += *(pEmEnergy + ihit);
   return energy;
}
float mcfCalEnergy::transEnergy(float energy, towerHit *address)
{
   //for this initial implementation, take the vertex at the orgin:
   
//   float eta=999.9, phi=999.9;
//   float transenergy = 0.0;
//   int ical = (address->ical) + 1;
//   int iphi = (address->iphi) + 1;
//   int ieta = (address->ical) + 1;
   
   
//   get_ceta_cphi_( &ical,  &ieta,  &iphi, &eta, &phi);
//   float theta = 2*atan( exp( fabs( eta ) ) );
//   if( eta > 0.0 ) theta = M_PI - theta;
   
//   return (transenergy = energy * sin(theta)) ;
     return energy;
}
