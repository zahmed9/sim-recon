#include "eventInformation.hh"
#include "mcfCalPhiEnergy.hh"
mcfCalPhiEnergy::mcfCalPhiEnergy(void)
        {
           nhit = 0;
           address = NULL;
           pMinEnergy = NULL;
           pHadEnergy = NULL;
           pEmEnergy = NULL;
           fillCalEnergy();
           
        }

void mcfCalPhiEnergy::fillCalEnergy(void)
{ 
  int ical;
  eventInformation *eventInfo = eventInformation::eventInfo();
  mcfCalEnergy *energy = eventInfo->calEnergy();

  int totHits = energy-> NumberOfHits();
  nhit = 0;
  address = new towerHit[totHits];
  pMinEnergy = new float[totHits];
  pHadEnergy = new float[totHits];
  pEmEnergy = new float[totHits];
  int *used =new int [totHits];
  
  
  int ihit, jhit;
  for(ihit = 0; ihit < totHits; ihit++) used[ihit] = 0;
  for(ihit = 0; ihit < totHits; ihit++) 
  {
     if(!used[ihit])
     {
       used[ihit] = 1;
        *(pMinEnergy+nhit) = energy->energyMin(ihit);
        *(pHadEnergy+nhit) = energy->energyHad(ihit);
        *(pEmEnergy+nhit)  = energy->energyEm(ihit);
       (address + nhit)->ical = energy->CalOfHit(ihit);
       (address + nhit)->iphi = energy->PhiOfHit(ihit);
       ical = (address+nhit)->ical;
       (address + nhit)->ieta = -1;

       for(jhit = ihit; jhit < totHits; jhit++)
       {
          if(!used[jhit])
          {
            if( ( energy->CalOfHit(ihit) == energy->CalOfHit(jhit) ) &&
        	( energy->PhiOfHit(ihit) == energy->PhiOfHit(jhit) ) )
            {
                  used[jhit] = 1;
        	  *(pMinEnergy+nhit) += energy->energyMin(jhit);
        	  *(pHadEnergy+nhit) += energy->energyHad(jhit);
        	  *(pEmEnergy+nhit)  += energy->energyEm(jhit);
            }
          }
       }
       nhit++;

     }       
  }
  
  // we need to keep this stuff accessable:  compress hits to save memory
    if(nhit < totHits)
  {
      towerHit *tmp1 = address;
      address = new towerHit[nhit];
      memcpy((void *) address, (void *) tmp1, 
        (nhit*sizeof(towerHit)));
      delete [] tmp1;

      float *tmp;
      tmp = pMinEnergy;
      pMinEnergy = new float[nhit];
      memcpy((void *) pMinEnergy, (void *) tmp, 
        (nhit*sizeof(float)));
      delete [] tmp;
      
      tmp = pHadEnergy;
      pHadEnergy = new float[nhit];
      memcpy((void *) pHadEnergy, (void *) tmp, 
        (nhit*sizeof(float)));
      delete [] tmp;

      tmp = pEmEnergy;
      pEmEnergy = new float[nhit];
      memcpy((void *) pEmEnergy, (void *) tmp, 
        (nhit*sizeof(float)));
      delete [] tmp;

  }

};
