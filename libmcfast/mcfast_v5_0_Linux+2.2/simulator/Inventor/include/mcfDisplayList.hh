#include "mcfPlotWindow.hh"
#include <Inventor/Xt/SoXt.h>
//linked list class to hold mcfDisplay list.  Switch to stl container when
//practical.
#ifndef MCFDISPLAYLIST
#define MCFDISPLAYLIST
class mcfPlotDefine;
class mcfDisplayList
{
   private:
        mcfDisplayList *pNextMcfDisplay;
        mcfDisplayList *pPreMcfDisplay;
        static mcfDisplayList *pHeadMcfDisplay;
        mcfPlotWindow *plot;
   public:
   mcfDisplayList(void)
   {
      pNextMcfDisplay = NULL;
      pPreMcfDisplay = NULL;
      plot = new mcfPlotWindow(SoXt::getTopLevelWidget());
      mcfDispAddToList( this );
      return;
   }

   mcfDisplayList(mcfPlotDefine &plotDefine)
   {
      pNextMcfDisplay = NULL;
      pPreMcfDisplay = NULL;
      plot = new mcfPlotWindow(SoXt::getTopLevelWidget(),plotDefine);
      mcfDispAddToList( this );
      return;
   }
   ~mcfDisplayList(void);
   static mcfDisplayList *mcfDispGetHead(void)
   {
       return pHeadMcfDisplay;
   }
   void mcfFreeList(void);
   void mcfDispAddToList( mcfDisplayList *temp );
   void mcfDisplayDeleteFromList(void);
   static mcfDisplayList *findDisplay(mcfPlotWindow *plot);
   static void deleteDisplay(mcfPlotWindow *plot);
   void mcfDisplayUpdateAllCal(void);
   static void mcfDisplayUpdateAll(displayType cdisp, displayType tdisp,
                                   displayType hdisp);
   
};
#endif
