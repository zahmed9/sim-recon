#include <X11/StringDefs.h>
#include <X11/Intrinsic.h>
#include <X11/Xatom.h>

#include <Xm/Xm.h>
#include <Xm/RowColumn.h>
#include <Xm/BulletinB.h>
#include <Xm/CascadeB.h>
#include <Xm/CascadeBG.h>
#include <Xm/FileSB.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/FileSB.h>
#include <Xm/PushB.h>
#include <Xm/PushBG.h>
#include <Xm/SeparatoG.h>
#include <Xm/Text.h>
#include <Xm/ToggleB.h>
#include <Xm/ToggleBG.h>
#include "displayTypes.hh"
#include "mcfDisplay.hh"

#ifndef MCFPLOTMODIFY
#define MCFPLOTMODIFY
//Set up information for call backs
struct plotModifyCbData
{
   class mcfPlotWindow *plot;
   PlotCatagory type;
   class mcfPlotModify *panel;
};


class mcfPlotModify
{
   friend void plotModifyCB(Widget, XtPointer *data, XtPointer);
   friend void dismissCB(Widget, XtPointer *data, XtPointer);
   private:
       plotModifyCbData *cbData;
   public:
        mcfPlotModify(Widget parent, mcfPlotWindow *win)
        {
           displayPlotModifyDialog(parent, win);
        }
        void displayPlotModifyDialog(Widget parent, mcfPlotWindow *win);
        ~mcfPlotModify(void)
        {
           delete [] cbData;
        }
   protected:
        mcfPlotModify(void);

};
#endif
