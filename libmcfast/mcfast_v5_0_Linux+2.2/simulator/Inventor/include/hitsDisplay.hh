#include "hitsDisplayInfo.hh"
#include <Inventor/nodes/SoGroup.h>
#include <Inventor/nodes/SoSeparator.h>
#ifndef HITSDISPLAY
#define HITSDISPLAY
class hitsDisplay
{
    private:
      SoSeparator *hits;
    public:
      hitsDisplay(void)
      {
      }
      ~hitsDisplay(void)
      {
      }
      void makeHitsDisplay(SoSeparator *root, displayType plot,
                           hitsDispInfo hitsInfo);
      void updateHitsDisplay(SoSeparator *root,displayType plot,
                           hitsDispInfo hitsInfo);
};
#endif
