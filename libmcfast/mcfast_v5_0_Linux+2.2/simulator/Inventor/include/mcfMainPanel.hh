#include "mcfWindow.hh"
#ifndef MCFMAINPANEL
#define MCFMAINPANEL
class mcfMainPanel : public mcfWindow
{
     private:
        Widget Shell;
        Widget leftArrow;
        Widget rightArrow;
        Widget eventText;
        static Widget scrolledList;
        ivMenuItem *menuItems;
     public:
        mcfMainPanel(Widget main)
        {
           Shell = main;
           makeMcfWindow( main );

        }
        static void AddPlotToList(char *plotName);
        static void RemovePlotFromList(char *plotName);
     protected:
        mcfMainPanel(void)
        {
           Shell = NULL;
           menuItems = NULL;
        };
        void makeMcfWindow(Widget main);
        static void decrementEventCB(Widget, XtPointer *userData, 
        XtPointer *);
        static void incrementEventCB(Widget, XtPointer *userData, 
        XtPointer *);
        static void specificEventCB(Widget, XtPointer *userData, 
        XtPointer *);
        
        static void mainPanelCB( Widget, XtPointer *data, XtPointer *);
        static void exitMcfIV(void)
        {
           exit(0);
        }

};
#endif
