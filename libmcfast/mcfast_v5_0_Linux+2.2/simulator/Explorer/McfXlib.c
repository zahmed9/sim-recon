#include <stdio.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xm/Xm.h>
#include <X11/Intrinsic.h>
#include <Xm/Xm.h>
#include <Xm/Form.h>
#include <Xm/Scale.h>
#include <Xm/Text.h>
#include <Xm/List.h>
#include <Xm/DrawingA.h>
 
#ifndef EXPLORER
#define EXPLORER
#include <cx/DataTypes.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/Geometry.h>
#endif



#include <cx/PortAccess.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/XtArea.h>
#include <stdarg.h>
/*#include "Mcf_Explorer_typedefs.h"*/
#ifndef Rgb
#define Rgb
typedef struct grRgb{
   double red;
   double green;
   double blue;
}grRgb;
#endif

void drawing_area_callback(Widget w, XtPointer client_data, XtPointer
                                                             call_data);
static Pixmap pixmap;

void McfDrawColor(long window,struct grRgb expColor)
{
        static Widget top;
        static Widget drawArea;
        Drawable drawBuf;
        Screen *screen;
        Display *display;
        XGCValues gcValues;
        XFontStruct *font_info;
        GC gc;
        Arg args[50];
        int ac;
        XmString s1;
        static int ffirst = 1;
        int screen_num;
        XVisualInfo visinfo;
        long ScaleBy = 0xffff;
        static XColor color;
        static ColorAlloc = 0;
        unsigned int display_width, display_height; 
        unsigned int planes = 0;
        
  

	if (ffirst) {
	    ffirst = 0;
	    printf ("Doing Initialization.. \n");
	    top = cxXtAreaInitialize();
	    cxXtAreaAttach(top,window);
            drawArea = XtVaCreateManagedWidget("Test of Draw Widget",
                                    xmDrawingAreaWidgetClass, top,
                                    XmNleftAttachment,  XmATTACH_FORM,
                                    XmNrightAttachment, XmATTACH_FORM,
                                    XmNtopAttachment,   XmATTACH_FORM,
                                    XmNbottomAttachment,XmATTACH_FORM,
                                    XmNdeleteResponse,  XmDO_NOTHING,
                                    NULL);
            XtAddCallback(drawArea, XmNexposeCallback, drawing_area_callback,
                                                       NULL);
            XtManageChild(drawArea);
        }
        screen = XtScreen(drawArea);
        drawBuf = XtWindow(drawArea);
        display = XtDisplay(drawArea);
        screen_num = DefaultScreen(display);
        display_width = DisplayWidth(display,screen_num);
        display_height = DisplayHeight(display,screen_num);
        pixmap = XCreatePixmap (display, RootWindowOfScreen(screen),
                                display_width, display_height,
                                DefaultDepthOfScreen(screen));
        gcValues.line_width = 0;
        gcValues.foreground = BlackPixelOfScreen(screen);
        gcValues.background = WhitePixelOfScreen(screen);
        gc = XCreateGC(display,drawBuf,(GCLineWidth|GCForeground|GCBackground),
                       &gcValues);
        if(XMatchVisualInfo(DisplayOfScreen(screen),
                            XScreenNumberOfScreen(screen),
                            DefaultDepthOfScreen(screen),
                            PseudoColor, &visinfo)){
           if(ColorAlloc){ /* be sure to free up old color */
             XFreeColors(display,DefaultColormap(display,screen_num),
                         &color.pixel, 1, planes);
             ColorAlloc = 0;
           }
           color.red = (int) (ScaleBy * expColor.red); 
           color.green = (int) (ScaleBy * expColor.green);
           color.blue = (int) (ScaleBy * expColor.blue);
           XAllocColor(display,DefaultColormapOfScreen(screen), &color);
           ColorAlloc = 1;
           XSetForeground(display, gc, color.pixel);
           XFillRectangle(display,pixmap,gc,0,0,120,120);           
        }else{
          printf("Sorry, only black and white on screen\n");
        }
        
        XCopyArea(display,pixmap, drawBuf,
                  gc,0,0,display_height,display_width,0,0);
        cxXtAreaResize(top, window);
 	return;
}
void drawing_area_callback(Widget w, XtPointer client_data,
                                     XtPointer call_data){

  XmDrawingAreaCallbackStruct *cbs = 
                              (XmDrawingAreaCallbackStruct *) call_data;
  XEvent *event = cbs -> event;
  Display *display = event->xany.display;
  GC gc;
  if(cbs->reason == XmCR_EXPOSE){
    XtVaGetValues(w, XmNuserData, &gc, NULL);
    /*XCopyArea(display,pixmap,event->xexpose.window,gc,0,0,event->xexpose.width,
                         event->xexpose.height,0,0);*/
  }                                                            
}
