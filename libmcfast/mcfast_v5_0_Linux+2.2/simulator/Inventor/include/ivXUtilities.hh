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
#include "ivButton.hh"
#include <Inventor/Xt/SoXt.h>
#include <Inventor/Xt/viewers/SoXtViewer.h>
#include <Inventor/Xt/viewers/SoXtExaminerViewer.h>
Widget buildAndLayoutMenu (Widget parent, 
                                  ivMenu *pulldownData, 
                                  int numMenu,
                                  XtCallbackProc theCallbackProc);
SoXtViewer *buildAndLayoutViewer(Widget parent, Widget menuWidget);
Widget MakeForm(Widget parent, int width, int height);
static Widget MakeDetachedShell(Widget parent);
