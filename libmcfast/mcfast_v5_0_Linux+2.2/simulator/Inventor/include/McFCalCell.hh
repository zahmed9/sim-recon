#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#include "hepvis/SoCalCellKit.hh"

#include "McFProjectiveCal.hh"

#ifndef _MCFCALCELL_
#define  _MCFCALCELL_
class McFCalCell
{
  public:
      double cellEnergy;
      int cellIeta;
      int cellIphi;
      SoMcFCalCellKit *CellKit;
      McFCalCell(void);
      McFCalCell(double energy, int ieta, int iphi);
      void generateCellRepresentation(McFProjectiveCal *Calorimeter,
      int ieta, int iphi);
      void setCellVertices(McFProjectiveCal *Calorimeter, int ieta);
};
#endif
