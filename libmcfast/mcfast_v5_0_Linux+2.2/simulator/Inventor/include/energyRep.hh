#include "towerHit.hh"
#include "hsv.hh"
#ifndef ENERGYREP
#define ENERGYREP
class energyRep
{
   private:
         int nhit;
         towerHit *address;
         float *penergy;
         myHSV *pcolor;
         float hottestTower;
   public:
        energyRep(void)
        {
           nhit = 0;
           address = NULL;
           penergy = NULL;
           pcolor     = NULL;
           hottestTower = 0.0;
        }
        energyRep(int ncal, int *pical, float *threshold)
        {
           fillEnergyRep(ncal, pical, threshold);
        }
        ~energyRep(void)
        {
          if (address != NULL) delete [] address;
          if (penergy != NULL) delete [] penergy;
          if (pcolor     != NULL) delete [] pcolor;
        }
        void fillEnergyRep(int ncal, int *pical, float *theshold);

        int NumberOfHits(void)
        {
          return nhit;
        }
        towerHit *AddressOfHits(void)
        {
          return address;
        }
        myHSV *Colors(void)
        {
          return pcolor;
        }
        int WhichCal(int ihit)
        {
          return (address+ihit)->ical;
        }
        int WhichPhi(int ihit)
        {
          return (address+ihit)->iphi;
        }
        int WhichEta(int ihit)
        {
          return (address+ihit)->ieta;
        }
        int Hottest(void)
        {
          return hottestTower;
        }
        energyRep *MakeEtaRep(int hemisphere);
};
#endif
