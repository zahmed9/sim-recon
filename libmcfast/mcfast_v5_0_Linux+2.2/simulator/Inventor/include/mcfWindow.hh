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
#include <Inventor/Xt/SoXtRenderArea.h>
#include <string.h>

//This is the abstract base class for the windows created by the display
//program.  The member data includes the top level shell.  In the case of the
//main menu bar, that will be the application shell.  In the case of the
//plot windows, it will be the top-level detached shell.
//A pointer to the callback user data for the menus and buttons is also member
//data.  The initialization of the menus and buttons is handled
//in the constructors of the concrete classes.
//most of this code is taken from Jeff Kallenbach's modification of the
//ivview code.
#ifndef RENDERTYPE
#define RENDERTYPE
enum renderType {VIEWER, RENDER, WALK, FLY, PLANE};
#endif
#ifndef TOGNAMES
#define TOGNAMES
struct togNames  //This structure holds toggle button names
{
    char nameTog[15];
};
#endif

#ifndef TOGBUTTONCBDATA  
#define TOGBUTTONCBDATA
struct toggleButtonCbData //this structure holds toggle states
{
     mcfWindow *window;
     int setting;
};
#endif
 
#ifndef MCFWINDOW
#define MCFWINDOW
class mcfWindow
{
     protected: 
        Widget Shell;
        ivMenuItem *menuItems;
    
        Widget buildAndLayoutMenu(Widget parent, 
                                  ivMenu *pulldownData, 
                                  int numMenu,
                                  XtCallbackProc theCallbackProc);
        SoXtViewer *buildAndLayoutViewer(Widget parent, Widget menuWidget);
        SoXtRenderArea *buildAndLayoutViewer(Widget parent, 
                                               Widget menuWidget, 
                                               renderType type);
        Widget MakeForm(Widget parent, int width, int height);
        Widget MakeFormDialog(Widget parent, int width, int height,
                                 char *name);
        Widget MakeDetachedShell(Widget parent, char *name);
        Widget BuildAndLayoutText(Widget parent, Widget menuWidget );
        Widget BuildAndLayoutScrolledText(Widget parent, 
                                     Widget topAttach,
                                     Widget bottomAttach,
                                     int topOffset,
                                     int bottomOffset,
                                     char *name);
        Widget MakeDialogButton(Widget parent, char *name, 
                                   XtCallbackProc theCallbackProc,
                                   XtPointer *Data,
                                   Widget leftAttach,
                                   int leftOffset);
        Widget MakeScale(Widget parent, char *name, int min, int max,
                         int value, int decPoint);
        Widget BuildAndLayoutRowCol(Widget parent, char *name,
                                       Widget topAttach,
                                       Widget leftAttach, int topOffset,
                                       int leftOffset, 
                                       int ncol );
        
        Widget BuildRadioBox(Widget parent, char *name, int nToggles,
                                togNames *togName, int *set,
                                XtCallbackProc theCallbackProc,
                                toggleButtonCbData *cbData);
        Widget BuildScrolledWidget(Widget parent, char *name, 
                                   int width, int height, 
                                   Widget topAttach,
                                   Widget bottomAttach,
                                   Widget leftAttach,
                                   Widget rightAttach,
                                   int topOffset, int bottomOffset,
                                   int leftOffset, int rightOffset);
        Widget BuildTreeWidget(Widget parent, char *name, int borderWidth,
                               int width, int height);
        void SetTopShellColors(Widget topShell);

        void changeTitle(Widget shell, char *title);
        virtual void makeMcfWindow(Widget main) = 0;

     public:
        void Show(void)
        {
           XtRealizeWidget(Shell);
        }
        void Hide(void)
        {
           XtUnrealizeWidget(Shell);
        }
        void Show(Widget w)
        {
           XtManageChild(w);
        }
        ~mcfWindow(void)
        {
          delete [] menuItems;
        }
};
#endif
