#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Xm/Xm.h>
#include <X11/Intrinsic.h>
#include <Xm/Xm.h>
#include <Xm/Form.h>
#include <Xm/Scale.h>
#include <Xm/Text.h>
#include <Xm/List.h>

#include <cx/PortAccess.h>
#include <cx/DataAccess.h>
#include <cx/UserFuncs.h>
#include <cx/XtArea.h>
#include <stdarg.h>

#include "Mcf_Window_prototypes.h"

int WindowMessage(long window, char *string){
        Arg args[50];
        int ac;
        static Widget top;
        static Widget textList;
        static int first = 1;
        if(first == 1){
          first = 0;
  	  printf ("Initialization of Information Window \n"); 
    	  top = cxXtAreaInitialize();
	  cxXtAreaAttach(top,window);
          ac = 0;
          XtSetArg(args[ac], XmNrows, 10); ac++;
          XtSetArg(args[ac], XmNcolumns, 60); ac++;
          XtSetArg(args[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
          XtSetArg(args[ac], XmNrightAttachment, XmATTACH_FORM); ac++;
          XtSetArg(args[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
          XtSetArg(args[ac], XmNbottomAttachment, XmATTACH_FORM); ac++;
          XtSetArg(args[ac], XmNdeleteResponse, XmDO_NOTHING); ac++;
          textList = XmCreateScrolledText(top,
                                    "Scrolled Widget", args, ac);
          XtManageChild(textList);
          }
        XmTextSetString(textList, string);
        cxXtAreaResize(top, window);        
        return 0;
}
