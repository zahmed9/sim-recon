#include "towerHit.hh"
#include "calDisplayInfo.hh"
#ifndef MCFCALENERGY
#define MCFCALENERGY
class mcfCalEnergy
{
   protected:
         int nhit;
         towerHit *address;
         float *pMinEnergy;
         float *pHadEnergy;
         float *pEmEnergy;
   public:
        mcfCalEnergy(void)
        {
           nhit = 0;
           address = NULL;
           pMinEnergy = NULL;
           pHadEnergy = NULL;
           pEmEnergy = NULL;
           fillCalEnergy();
           
        }
        ~mcfCalEnergy(void)
        {
          if (address != NULL)    delete [] address;
          if (pMinEnergy != NULL) delete [] pMinEnergy;
          if (pHadEnergy != NULL) delete [] pHadEnergy;
          if (pEmEnergy != NULL)  delete [] pEmEnergy;
        }
        virtual void fillCalEnergy(void);

        int NumberOfHits(void)
        {
          return nhit;
        }
        towerHit *AddressOfHits(void)
        {
          return address;
        }
        towerHit *AddressOfHit(int ihit)
        {
          return (address + ihit);
        }
        int CalOfHit(int ihit)
        {
          return (address+ihit)->ical;
        }
        int PhiOfHit(int ihit)
        {
          return (address+ihit)->iphi;
        }
        int EtaOfHit(int ihit)
        {
          return (address+ihit)->ieta;
        }
        float energyMin(int ihit)
        {
          return *(pMinEnergy+ihit);
        }
        float energyHad(int ihit)
        {
          return *(pHadEnergy+ihit);
        }
        float energyEm(int ihit)
        {
          return *(pEmEnergy+ihit);
        }
        float energy(int ihit, calDispInfo Info);
        float transEnergy(float energy, towerHit *address);  
                                         //for first implementation, take
                                         //orgin at (0,0,0)
};
#endif
