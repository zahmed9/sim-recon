#include "towerHit.hh"
#include "hsv.hh"
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
class Calorimeter
{
  public:
       Calorimeter(void) {}
       SoSeparator *calFullView(int ncal, int *pical);
       SoSeparator *calEtaView(int ncal, int *pical);
       SoSeparator *calPhiView(int ncal, int *pical);
       //SoSeparator *cal3dHitsView(int *pical, int *pieta, int *pphi);// this
       //will change to a class of energy representation...
       //SoSeparator *calLegoView(void);
       SoSeparator *calSimpleView(int ncal);
       SoSeparator *calHitTowers(int nhits, towerHit *towers, myHSV *pcolor);
};
