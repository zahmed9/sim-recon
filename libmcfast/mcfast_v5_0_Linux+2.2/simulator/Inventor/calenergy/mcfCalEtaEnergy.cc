#include "eventInformation.hh"
#include "mcfCalEtaEnergy.hh"
#include "calorCommon.hh"
mcfCalEtaEnergy::mcfCalEtaEnergy(void)
        {
           nhit = 0;
           address = NULL;
           pMinEnergy = NULL;
           pHadEnergy = NULL;
           pEmEnergy = NULL;
           fillCalEnergy();
           
        }

void mcfCalEtaEnergy::fillCalEnergy(void)
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
       (address+ nhit)->ical = energy->CalOfHit(ihit);
       (address+ nhit)->ieta = energy->EtaOfHit(ihit);
       ical = (address+nhit)->ical;

       if( energy->PhiOfHit(ihit) < getNPhiSegments(ical)/2 )
       {
           (address+ nhit)->iphi = 0;
       }
       else
       {
           (address+ nhit)->iphi = getNPhiSegments(ical)/2;
       }
       for(jhit = ihit; jhit < totHits; jhit++)
       {
          if(!used[jhit])
          {
            if( ( energy->CalOfHit(ihit) == energy->CalOfHit(jhit) ) &&
        	( energy->EtaOfHit(ihit) == energy->EtaOfHit(jhit) ) )
            {
               if( ( energy->PhiOfHit(ihit) < getNPhiSegments(ical)/2  &&
                     energy->PhiOfHit(jhit) < getNPhiSegments(ical)/2 ) ||
                   ( energy->PhiOfHit(ihit) >= getNPhiSegments(ical)/2  &&
                     energy->PhiOfHit(jhit) >= getNPhiSegments(ical)/2 ) )
               {
                  used[jhit] = 1;

        	  *(pMinEnergy+nhit) += energy->energyMin(jhit);
        	  *(pHadEnergy+nhit) += energy->energyHad(jhit);
        	  *(pEmEnergy+nhit)  += energy->energyEm(jhit);

              }  

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
