/*
 * alarm.c  --- the Alarm main program
*/

static const char sccsid[] = "@(#)"__FILE__"\t5.2\tCreated 7/27/97 20:19:22, \tcompiled "__DATE__;

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <bstring.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <signal.h>
#include <time.h>
#include "alarm.h"
#include "Fm.h"
#include <X11/IntrinsicP.h>
#include <Xm/PushB.h>
#include <Xm/ArrowB.h>
#include <Xm/Text.h>
#include <Xm/TextF.h>
#include <Xm/ScrolledW.h>
#include <X11/StringDefs.h>

#include "ProcessButton.h"
#include "MessageButton.h"


Widget FmCreatexalarm(char *,Widget,Arg *,Cardinal);

static int i;
static Widget wdgts[80];
static Display *display;
static Screen *screen;
static Dimension screen_width,screen_height;
static char scratch[200],zero[]="     0";
static XmString excl_0,excl_1,excl_3;
static Arg xargs[10];
static Cardinal xargn;
static char bestFont[100] = "*fontList: *fixed-bold-*-*--8-*";
static char helpDir[100] = "/home/lemond/e852/alarmHelp";
static char *buf_help = NULL;
static int freeMode = 1;

static MCAST_HEADER *buf_rcv,*buf_send;
static int multi_sock_rd,multi_sock_wr;

#define CODE_WHITE	0
#define CODE_GREEN	1
#define CODE_YELLOW	4
#define CODE_RED	7
#define CODE_WARNING	0
#define CODE_ERROR	1
#define CODE_FATAL	2
#define GET_SEVERITY(x) (x > 0 ? (x-1) % 3 : CODE_WARNING)
#define GET_COLOR(x)	(x > 0 ? x - (x-1) % 3 : CODE_WHITE)


typedef struct {
  int in_process;	  /*Negative if it's free*/
  Widget form;
  Widget b1;		  /*Four Buttons corresponding to message*/
  Widget b2;
  Widget b3;
  Widget b4;
} MESSAGE_BUTTON;

static struct {
  int allocated;
  int free;
  MESSAGE_BUTTON *start;
  MESSAGE_BUTTON *current;
} mbutton = { 0, 0, NULL, NULL};

typedef struct {
  int in_global;	  /*Negative if it's free*/
  Widget form;
  Widget b1;		  /*Three Buttons corresponding to this process */
  Widget b2;		  /*in the processes window*/
  Widget b3;
} PROCESS_BUTTON;

static struct {
  int allocated;
  int free;
  PROCESS_BUTTON *start;
  PROCESS_BUTTON *current;
} pbutton = { 0, 0, NULL, NULL};

typedef struct {
  int status;		  /*Status of this message:
			    0 - not decided yet;      1 - green warning;
                            2 - green error;          3 - green fatal;
			    4 - yellow warning;       5 - yellow error;
			    6 - yellow fatal;         7 - red warning;
			    8 - red error;            9 - red fatal */
  int treated;		  /*How to treat this message in the user's opinion:
			    0 - default;              1 - as warning;
                            2 - as error;             3 - as fatal; */
  int iname;		  /*Message string, compressed to int*/
  int count;		  /*Total count of this message so far*/
  int button;		  /*# of MESSAGE_BUTTON (if any)*/
  char *s2;		  /*Label strings for buttons 2 and 3*/
  char *s3;
  int in_help;		  /*Pointer on help text (if available)*/
} MESSAGE_STATE;
static MESSAGE_STATE *message;

typedef struct {
  int status;		  /*The highest priority of messages for this process:
			    0 - no messages (?);      1 - green warning;
			    2 - green error;          3 - green fatal;
			    4 - yellow warning;       5 - yellow error;
			    6 - yellow fatal;         7 - red warning;
			    8 - red error;	      9 - red fatal */
  int iname;		  /*Name of the process, compressed to int*/
  int count;		  /*Total count of this process messages so far*/
  int button;		  /*# of PROCESS_BUTTON*/
  char *s2;		  /*Label strings for last 2 buttons*/
  char *s3;
  int allocated;	  /*how many *MESSAGE_STATE will fit into currenly
			    allocated space for message pointers*/
  int now;		  /*how many MESSAGE_STATE actually exist now*/
  MESSAGE_STATE *space;   /*pointer on the MESSAGE_STATE's space */
} PROCESS_STATE;
static PROCESS_STATE *process;

typedef struct {
  int status;		  /*The highest priority of all messages:
			    0 - no messages at all;   1 - green warning;
			    2 - green error;          3 - green fatal;
			    4 - yellow warning;       5 - yellow error;
			    6 - yellow fatal;         7 - red warning;
			    8 - red error;	      9 - red fatal */
  int showing;		  /*Window currenly on the screen:
			    1 - small button;         2 - "red fatal" button;
			    3 - process window;	      4 - message window; */
  int allocated;	  /*how many *PROCESS_STATE will fit into currenly
			    allocated space for process pointers*/
  int now;		  /*how many PROCESS_STATE actually exist now*/
  int current; 		  /*and which one is current on the message screen)*/
  PROCESS_STATE *space;   /*pointer on the PROCESS_STATE's space */ 
} GLOBAL_STATE;
static GLOBAL_STATE *global;
static int in_global,in_process,save_showing;

typedef struct {
  int iname;		  /*iname of message string*/
  char fname[32];	  /*help file to open*/
  long int seek;	  /*where to fseek()*/
  int lines;		  /*how many lines to read*/
} HELP;
static HELP *help_start = NULL;
static int help_total,help_allocated;

typedef struct {
  char subset[16];	  /*name of Alarm group*/
  int isubset;		  /*name compressed to int*/
} SUBSET;
static SUBSET *subset_start;
static int subset_total = 0, subset_debug;
static int currentFilter = 0;
static XtInputId mcastInput;

/*************************************************************************/
/***************   Stuff to deal with pixmaps and colors   ***************/
/*************************************************************************/

#include "nothing.bm"
#include "warning.bm"
#include "error.bm"
#include "fatal.bm"
#include "question.bm"
#include "dog.bm"
#include "printer.bm"
static XImage ximage[7];	/*for 7 bitmaps above*/
static Pixmap pixmaps[4][4]; 	/*Nothing,warning,error,fatal (4 colors)*/
static Pixmap help1,help2;	/*Help for 2 help buttons*/

static struct {
  Pixel bg_color;
  Pixel fg_color;
  Pixel top_shadow;
  Pixel bottom_shadow;
  Pixel select_color;
} colors[4];	/*white,green,yellow,red*/

void initColors(void)
{
  static char *color_name[4] = {"white","green","yellow","red"};
  static Colormap cmap;

  printf("initialize colors...");

  XtVaGetValues(wdgts[0],XmNcolormap,&cmap,NULL);
  for(i=0; i<4; i++) {
    XtVaSetValues(wdgts[0],XtVaTypedArg,XmNbackground,XmRString,
		  color_name[i],strlen(color_name[i])+1,NULL);
    XtVaGetValues(wdgts[0],XmNbackground,&colors[i].bg_color,NULL);
    XmGetColors(screen,cmap,colors[i].bg_color,
		&colors[i].fg_color,&colors[i].top_shadow,
		&colors[i].bottom_shadow,&colors[i].select_color);
  }
}

void initPixmaps(void)
{
  printf("initialize pixmaps...");

  for(i=0; i<7; i++) {
    ximage[i].xoffset = 0;
    ximage[i].format = XYBitmap;
    ximage[i].byte_order = XImageByteOrder(display);
    ximage[i].bitmap_pad = 8;
    ximage[i].bitmap_bit_order = LSBFirst;
    ximage[i].bitmap_unit = 8;
    ximage[i].depth = 1;
    ximage[i].obdata = NULL;
    switch(i) {
    case 0:
      ximage[i].width = nothing_bm_width;
      ximage[i].height = nothing_bm_height;
      ximage[i].data = nothing_bm_bits;
      break;
    case 1:
      ximage[i].width = warning_bm_width;
      ximage[i].height = warning_bm_height;
      ximage[i].data = warning_bm_bits;
      break;
    case 2:
      ximage[i].width = error_bm_width;
      ximage[i].height = error_bm_height;
      ximage[i].data = error_bm_bits;
      break;
    case 3:
      ximage[i].width = fatal_bm_width;
      ximage[i].height = fatal_bm_height;
      ximage[i].data = fatal_bm_bits;
      break;
    case 4:
      ximage[i].width = question_bm_width;
      ximage[i].height = question_bm_height;
      ximage[i].data = question_bm_bits;
      break;
    case 5:
      ximage[i].width = dog_bm_width;
      ximage[i].height = dog_bm_height;
      ximage[i].data = dog_bm_bits;
      break;
    case 6:
      ximage[i].width = printer_bm_width;
      ximage[i].height = printer_bm_height;
      ximage[i].data = printer_bm_bits;
      break;
    }
    ximage[i].bytes_per_line = (ximage[i].width % ximage[i].bitmap_pad ?
				ximage[i].width/ximage[i].bitmap_pad + 1 :
				ximage[i].width/ximage[i].bitmap_pad);
    switch(i) {
    case 0:
      XmInstallImage(&ximage[i],"nothing.bm");
      pixmaps[i][0] = XmGetPixmap(screen,"nothing.bm",
				  colors[0].fg_color,colors[0].select_color);
      pixmaps[i][1] = XmGetPixmap(screen,"nothing.bm",
				  colors[1].fg_color,colors[1].select_color);
      pixmaps[i][2] = XmGetPixmap(screen,"nothing.bm",
				  colors[2].fg_color,colors[2].select_color);
      pixmaps[i][3] = XmGetPixmap(screen,"nothing.bm",
				  colors[3].fg_color,colors[3].select_color);
      break;
    case 1:
      XmInstallImage(&ximage[i],"warning.bm");
      pixmaps[i][0] = XmGetPixmap(screen,"warning.bm",
				  colors[0].fg_color,colors[0].bg_color);
      pixmaps[i][1] = XmGetPixmap(screen,"warning.bm",
				  colors[1].fg_color,colors[1].bg_color);
      pixmaps[i][2] = XmGetPixmap(screen,"warning.bm",
				  colors[2].fg_color,colors[2].bg_color);
      pixmaps[i][3] = XmGetPixmap(screen,"warning.bm",
				  colors[3].fg_color,colors[3].bg_color);
      break;
    case 2:
      XmInstallImage(&ximage[i],"error.bm");
      pixmaps[i][0] = XmGetPixmap(screen,"error.bm",
				  colors[0].fg_color,colors[0].bg_color);
      pixmaps[i][1] = XmGetPixmap(screen,"error.bm",
				  colors[1].fg_color,colors[1].bg_color);
      pixmaps[i][2] = XmGetPixmap(screen,"error.bm",
				  colors[2].fg_color,colors[2].bg_color);
      pixmaps[i][3] = XmGetPixmap(screen,"error.bm",
				  colors[3].fg_color,colors[3].bg_color);
      break;
    case 3:
      XmInstallImage(&ximage[i],"fatal.bm");
      pixmaps[i][0] = XmGetPixmap(screen,"fatal.bm",
				  colors[0].fg_color,colors[0].bg_color);
      pixmaps[i][1] = XmGetPixmap(screen,"fatal.bm",
				  colors[1].fg_color,colors[1].bg_color);
      pixmaps[i][2] = XmGetPixmap(screen,"fatal.bm",
				  colors[2].fg_color,colors[2].bg_color);
      pixmaps[i][3] = XmGetPixmap(screen,"fatal.bm",
				  colors[3].fg_color,colors[3].bg_color);
      break;
    case 4:
      XmInstallImage(&ximage[i],"question.bm");
      break;
    case 5:
      XmInstallImage(&ximage[i],"dog.bm");
      break;
    case 6:
      XmInstallImage(&ximage[i],"printer.bm");
      break;
    }
  }
}

void initPixmapHelp(void)
{
  sprintf(scratch,"%s/helpProcessButton.pixmap",helpDir);
  help1 = FmGetPixmap(wdgts[60],scratch);
  sprintf(scratch,"%s/helpMessageButton.pixmap",helpDir);
  help2 = FmGetPixmap(wdgts[70],scratch);
  if(help1 != XmUNSPECIFIED_PIXMAP)
    XtVaSetValues(wdgts[60],XmNlabelPixmap,help1,NULL);
  if(help2 != XmUNSPECIFIED_PIXMAP)
    XtVaSetValues(wdgts[70],XmNlabelPixmap,help2,NULL);
}

void setColor(Widget W,int color_code,int pixmap)
{
  switch(color_code) {
  case CODE_GREEN:
    i = 1;
    break;
  case CODE_YELLOW:
    i = 2;
    break;
  case CODE_RED:
    i = 3;
    break;
  default:
    i = 0;
    break;
  }
  XtVaSetValues(W,XmNbackground,colors[i].bg_color,
		XmNforeground,colors[i].fg_color,
		XmNtopShadowColor,colors[i].top_shadow,
		XmNbottomShadowColor,colors[i].bottom_shadow,
		XmNselectColor,colors[i].select_color,
		XmNarmColor,colors[i].select_color,
		XmNborderColor,colors[i].fg_color,NULL);
  if(pixmap >= 0)
    XtVaSetValues(W,XmNlabelPixmap,pixmaps[pixmap][i],
		  XmNarmPixmap,pixmaps[0][i],NULL);
}

void findBestFont(int argc,char *argv[])
{
  static char **list;
  static int actual;
  static char *fonts[] = {
    "*fixed-bold-r-normal--8*",
    "7x13bold",
    "screen-bold11",
    "-dec-terminal-bold-r-*-*-*-*-*-*-*-*-*-1",
    "-misc-fixed-bold-r-normal--13*",
    "*screen-bold-r-normal--9-*-m*",
    "-sgi-terminal-bold-r-normal--12*",
    "*screen-bold-r-normal--10-*-m*",
    "*screen-bold-r-normal--8-*-m*",
    "fixed",
    NULL };

  if(argc > 2)
    for(i=1; i<argc-1; i++)
      if(!strcmp(argv[i],"-display"))
	break;
  if(i != argc-1)
    display = XOpenDisplay(argv[i+1]);
  else
    display = XOpenDisplay(NULL);
  if(display != NULL) {
    i = 0;
    while(fonts[i] != NULL) {
      list = XListFonts(display,fonts[i],1000,&actual);
      XFreeFontNames(list);
      if(actual) {
	strcpy(bestFont+11,fonts[i]);
	break;
      }
      i++;
    }
    XCloseDisplay(display);
  }
}

/***************   End of pixmap and color stuff   ***********************/
/*************************************************************************/



/**************************************************************************/
/***************    Stuff to deal with widgets    *************************/
/**************************************************************************/

static int wasLeft, wasSystemwide;

void register_widget(Widget a,int n)
{
  if(wdgts[n] != NULL) {
    fprintf(stderr,"Bug: double widget registration: %i\n",n);
    exit(1);
  }
  wdgts[n] = a;
  switch(n) {
  case 5:	/* window with message help */
    a->core.height = screen_height - 100;
    a->core.width = screen_width - 100;
    break;
  }
}

char *myStringCreateSimple(char *s1)
{
  char *s = malloc(strlen(s1) + 1);
  strcpy(s, s1);
  return(s);
}

void analyzeButton(XEvent *event)
{
  if(event->xbutton.state & ControlMask)
    wasSystemwide = 1;
  else
    wasSystemwide = 0;
  if((event->xbutton.button == Button1) || (event->xbutton.button == Button2))
    wasLeft = 1;
  else
    wasLeft = 0;
}

void confirmQuit(void)
{
  static char a[] = "/usr/bin/X11/xconfirm -header Confirm -geom 180x100 -icon question -t \"Quit Alarm?\" -B No -b Yes 2>/dev/null | /bin/grep No 1>/dev/null 2>/dev/null";

  XBell(display,50);
  XFlush(display);
/*
  if(system(a))
*/
    exit(0);
}

int ecompress(char *);
int helpCompress(void)
{
  static char *c;

  c = buf_help+1;
  while((int)(*c) != (int)'\0') {
    if(((int)(*c) == (int)'"') || ((int)(*c) == (int)'\n')) {
      *c = '\0';
      break;
    }
    c++;
  }
  return(ecompress(buf_help+1));
}

void prepareMessageHelp(void)
{
  static FILE *pls,*fd;
  static long int seek_start;
  static int step,lines,first,j;

  printf("preparing help...");

  if(help_start)
    free(help_start);
  help_total = 0;
  help_allocated = 100;
  help_start = (HELP *)malloc(help_allocated*sizeof(HELP));
  if(buf_help == NULL)
    buf_help = (char *)malloc(50000);
  sprintf(scratch,"/bin/ls %s",helpDir);
  if((pls = popen(scratch,"r")) != NULL) {
    sprintf(scratch,"%s/",helpDir);
    j = strlen(scratch);
    while(fgets(scratch+j,50,pls) != NULL) {
      if(strchr(scratch+j,'\n'))
	*strchr(scratch+j,'\n') = '\0';
      if(strcmp(scratch+j,"helpProcessButton.pixmap") &&
	 strcmp(scratch+j,"helpMessageButton.pixmap"))
	if((fd = fopen(scratch,"r")) != NULL) {
	  seek_start = ftell(fd);
	  first = -1;
	  while(fgets(buf_help,5000,fd) != NULL)
	    switch((int)(*buf_help) == (int)'"') {
	    case 0:
	      step = 0;
	      seek_start = ftell(fd);
	      if(first != -1)
		lines++;
	      break;
	    default:
	      if((first != -1) && (step == 0)) {
		for(i=first; i<help_total; i++)
		  (help_start+i)->lines = lines;
		first = -1;
	      }
	      step = 1;
	      if(first == -1) {
		lines = 0;
		first = help_total;
	      }
	      lines++;
	      if(help_total >= help_allocated) {
		help_allocated += 100;
		help_start = (HELP *)realloc(help_start,help_allocated*
					     sizeof(HELP));
	      }
	      (help_start+help_total)->iname = helpCompress();
	      strcpy((help_start+help_total)->fname,scratch+j);
	      (help_start+help_total)->seek = seek_start;
	      help_total++;
	      break;
	    }
	  if(first != -1)
	    for(i=first; i<help_total; i++)
	      (help_start+i)->lines = lines;
	  fclose(fd);
	}
    }
    pclose(pls);
  }
  else
    fprintf(stderr,"Can't search %s\n. Help will be unavailable\n",helpDir);
}

int findMessageHelp(int id)
{
  static int j;

  j = help_total;
  if(help_total > 0)
    for(j=0; j<help_total; j++)
      if((help_start + j)->iname == id)
	break;
  if(j == help_total)
    j = -1;
  return(j);
}


static int quitHeight1 = 8, quitHeight2 = 10;

void configureShell(int which)
{
  static int first = 1;
  static Arg args[4];
  static Cardinal argn;
  static Dimension width,height;
  static Position x,y;
  static int width_new,height_new,x_new,y_new;
  static Window win;
  int maxwidth;
  int maxheight;

  if(first) {
    argn = 0;
    XtSetArg(args[argn],"width",&width); argn++;
    XtSetArg(args[argn],"height",&height); argn++;
    XtSetArg(args[argn],"x",&x); argn++;
    XtSetArg(args[argn],"y",&y); argn++;
    first = 0;
  }
  XFlush(display);
  XmUpdateDisplay(wdgts[0]);
  win = XtWindow(wdgts[which]);
  switch(which) {
  case 1:
    XtGetValues(wdgts[1],args,argn);
    if(((int)width != 28) || ((int)height != 28+quitHeight1))
      XResizeWindow(display,win,28,28+quitHeight1);
    break;
  case 2:
    XtGetValues(wdgts[2],args,argn);
    x_new = ((int)screen_width - 399)/2;
    y_new = ((int)screen_height - 418)/2;
    if(freeMode) {
      if(((int)width != 399) || ((int)height != 418+quitHeight2))
	XResizeWindow(display,win,399,418+quitHeight2);
    }
    else {
      if(((int)x != x_new) || ((int)y != y_new) || 
	 ((int)width != 399) || ((int)height != 418+quitHeight2))
	XMoveResizeWindow(display,win,x_new,y_new,399,418+quitHeight2);
    }
    break;
  case 3:
  case 4:
    XtGetValues(wdgts[10*which+1],args,argn);

    width_new = (int)width + 40;

    maxwidth  = 0.9 * screen_width;
    maxheight = 0.9 * screen_height;

    if (width_new > maxwidth)   width_new = maxwidth;

    height_new = (int)height + 80 + 30*(which-3);

    if (height_new > maxheight) height_new = maxheight;

    x_new = ((int)screen_width - width_new)/2;
    y_new = ((int)screen_height - height_new)/2;

    XtGetValues(wdgts[which],args,argn);

    if(freeMode) {
      if(((int)width < width_new) || ((int)height < height_new) ||
	 (width_new == maxwidth) || (height_new == maxheight)) {
	x_new = (int)x;
	y_new = (int)y;
	if(x_new < 0)
	  x_new = 0;
	if(y_new < 0)
	  y_new = 0;
	if(x_new+width_new > (int)screen_width)
	  x_new = (int)screen_width - width_new;
	if(y_new+height_new > (int)screen_height)
	  y_new = (int)screen_height - height_new;
	XtConfigureWidget(wdgts[which],x_new,y_new,width_new,height_new,0);
	XmUpdateDisplay(wdgts[which]);
      }
    }
    else {
      if(((int)x != x_new) || ((int)y != y_new) ||
	 ((int)width != width_new) || ((int)height != height_new) ||
	 (width_new == maxwidth) || (height_new == maxheight)) {
	XtConfigureWidget(wdgts[which],x_new,y_new,width_new,height_new,0);
	XmUpdateDisplay(wdgts[which]);
      }
    }
    break;
  case 5:
  case 6:
  case 7:
    XtGetValues(wdgts[which],args,argn);
    if((int)width < 500)
      width = 500;
    if((int)height < 300)
      height = 300;
    x_new = ((int)screen_width - (int)width)/2;
    y_new = ((int)screen_height - (int)height)/2;
    if(!freeMode)
      if(((int)x != x_new) || ((int)y != y_new))
	XMoveResizeWindow(display,win,x_new,y_new,width,height);
    break;
  }
  XFlush(display);
}

void configureShellForced(int which)
{
  static int modeSave;

  modeSave = freeMode;
  freeMode = 0;
  configureShell(which);
  freeMode = modeSave;
}

void mainButton(void)
/*Activate callback for the toplevel button*/
{
  if(global->showing == 1 || global->showing == 2)
    if(global->status) {
      configureShell(3);
      XtUnmapWidget(wdgts[global->showing]);
      XtMapWidget(wdgts[3]);
      global->showing = 3;
      XFlush(display);
    }
}

void doInput(void);
void otherButton(int which, XtPointer call_data)
/*Activate callback for the service buttons in process and message windows*/
{
  static int to, firstHelp = 1;
  XmPushButtonCallbackStruct *cbs = (XmPushButtonCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  switch(which) {
  case 30:	/*Return in the process window*/
    if(global->showing == 3) {
      if((GET_SEVERITY(global->status) == CODE_FATAL) &&
	 (GET_COLOR(global->status) == CODE_RED))

	/* Due to popular demands cute, nice bulldog has gone. Poor animal...
	   to = 2;
	   */
	to = 1;

      else
	to = 1;

      configureShellForced(to);

      XtUnmapWidget(wdgts[global->showing]);
      XtMapWidget(wdgts[to]);
      global->showing = to;
    }
    break;
  case 40:	/*Return in the message window*/
    if(global->showing == 4) {
      if(global->now)
	to = 3;
      else
	to = 1;

      configureShell(to);

      XtUnmapWidget(wdgts[global->showing]);
      XtMapWidget(wdgts[to]);
      global->showing = to;
      global->current = -1;
    }
    break;
  case 31:	/*Help in the process window*/
  case 41:	/*Help in the message window*/
    if(global->showing != 6 && global->showing != 7) {
      save_showing = global->showing;
      if(which == 31)
	global->showing = 6;
      else
	global->showing = 7;
      if(firstHelp) {
	initPixmapHelp();
	firstHelp = 0;
      }
      configureShellForced(global->showing);
      XtUnmapWidget(wdgts[save_showing]);
      XtMapWidget(wdgts[global->showing]);
      XFlush(display);
    }
    break;
  case 42:	/*Red->yellow*/
  case 43:	/*Yellow->green*/
  case 44:	/*Green->yellow*/
  case 45:	/*Green->white*/
    if(wasSystemwide) {
      buf_send->iname = (global->space + global->current)->iname;
      switch(which) {
      case 42:
	esend_color12(MCAST_YELLOW1);
	break;
      case 43:
	esend_color12(MCAST_GREEN1);
	break;
      case 44:
	esend_color12(MCAST_GR_YEL1);
	break;
      case 45:
	esend_color12(MCAST_REMOVE1);
	break;
      }
    }
    else {
      buf_rcv->iname = (global->space + global->current)->iname;
      switch(which) {
      case 42:
	buf_rcv->code = MCAST_YELLOW1;
	break;
      case 43:
	buf_rcv->code = MCAST_GREEN1;
	break;
      case 44:
	buf_rcv->code = MCAST_GR_YEL1;
	break;
      case 45:
	buf_rcv->code = MCAST_REMOVE1;
	break;
      }
      doInput();
    }
    break;
  }
  XFlush(display);
}

void helpReturn(void)
{
  if(global->showing == 5 || global->showing == 6 || global->showing == 7) {
    configureShell(save_showing);
    XtUnmapWidget(wdgts[global->showing]);
    XtMapWidget(wdgts[save_showing]);
    global->showing = save_showing;
    XFlush(display);
  }
}

void updateProcess(void);
void changeMessageTreated(Widget W,XtPointer client_data,XtPointer call_data)
{
  static int oldstatus;
  XmPushButtonCallbackStruct *cbs = (XmPushButtonCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  for(i=0; i<mbutton.allocated; i++) {
    mbutton.current = mbutton.start + i;
    if((mbutton.current)->in_process >= 0)
      if((mbutton.current)->b1 == W)
	break;
  }
  if(i < mbutton.allocated) {
    process = global->space + global->current;
    message = process->space + (mbutton.current)->in_process;
    if(wasLeft) {
      oldstatus = message->status;
      if(message->treated == 0)
	message->treated = GET_SEVERITY(oldstatus) + 1;
      message->treated++;
      if(message->treated > 3)
	message->treated = 1;
      message->status = GET_COLOR(oldstatus) + message->treated - 1;
      switch(GET_SEVERITY(message->status)) {
      case CODE_WARNING:
	XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_0,NULL);
	break;
      case CODE_ERROR:
	XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_1,NULL);
	break;
      case CODE_FATAL:
	XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_3,NULL);
	break;
      }
      if((message->status > process->status) ||
	 (oldstatus == process->status))
	updateProcess();
      configureShell(global->showing);
      XFlush(display);
    }
    else
      message->treated = 0;
  }
}

void clearMessageCount(Widget W,XtPointer client_data,XtPointer call_data)
{
  XmAnyCallbackStruct *cbs = (XmAnyCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  for(i=0; i<mbutton.allocated; i++) {
    mbutton.current = mbutton.start + i;
    if((mbutton.current)->in_process >= 0)
      if((mbutton.current)->b2 == W)
	break;
  }
  if(i < mbutton.allocated) {
    process = global->space + global->current;
    pbutton.current = pbutton.start + process->button;
    message = process->space + (mbutton.current)->in_process;
    process->count -= message->count;
    message->count = 0;
    free(message->s2);
    message->s2 = myStringCreateSimple(zero);
    XmTextFieldSetString((mbutton.current)->b2,message->s2);
    sprintf(scratch,"%6d",process->count);
    free(process->s2);
    process->s2 = myStringCreateSimple(scratch);
    XmTextFieldSetString((pbutton.current)->b2,process->s2);
    configureShell(global->showing);
    XFlush(display);
  }
}

void changeMessageColor(Widget W,XtPointer client_data,XtPointer call_data)
{
  XmAnyCallbackStruct *cbs = (XmAnyCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  for(i=0; i<mbutton.allocated; i++) {
    mbutton.current = mbutton.start + i;
    if((mbutton.current)->in_process >= 0)
      if((mbutton.current)->b3 == W)
	break;
  }
  if(i < mbutton.allocated) {
    process = global->space + global->current;
    message = process->space + (mbutton.current)->in_process;
    if(wasSystemwide) {
      buf_send->iname = process->iname;
      i = GET_COLOR(message->status);
      switch(i) {
      case CODE_RED:
	if(wasLeft)
	  esend_color_id(MCAST_YELLOW,message->iname);
	else
	  esend_color_id(MCAST_GREEN,message->iname);
	break;
      case CODE_YELLOW:
	esend_color_id(MCAST_GREEN,message->iname);
	break;
      case CODE_GREEN:
	if(wasLeft)
	  esend_color_id(MCAST_YELLOW,message->iname);
	else
	  esend_color_id(MCAST_REMOVE,message->iname);
	break;
      }
    }
    else {
      buf_rcv->iname = process->iname;
      buf_rcv->id = message->iname;
      i = GET_COLOR(message->status);
      switch(i) {
      case CODE_RED:
	if(wasLeft)
	  buf_rcv->code = MCAST_YELLOW;
	else
	  buf_rcv->code = MCAST_GREEN;
	break;
      case CODE_YELLOW:
	buf_rcv->code = MCAST_GREEN;
	break;
      case CODE_GREEN:
	if(wasLeft)
	  buf_rcv->code = MCAST_YELLOW;
	else
	  buf_rcv->code = MCAST_REMOVE;
	break;
      }  
      doInput();
    }
  }
}

int readHelp(void)
{
  static int ret;
  static FILE *fd;
  static HELP *p;
  static char *c;

  ret = -1;
  c = buf_help;
  p = help_start + message->in_help;
  sprintf(scratch,"%s/%s",helpDir,p->fname);
  if((fd = fopen(scratch,"r")) != NULL) {
    if(fseek(fd,p->seek,SEEK_SET) == 0) {
      for(i=0; i<p->lines; i++) {
	if(fgets(c,1000,fd) == NULL)
	  break;
	c += strlen(c);
      }
      ret = 0;
    }
    fclose(fd);
  }
  return(ret);
}

void showMessageHelp(Widget W,XtPointer client_data,XtPointer call_data)
{
  XmPushButtonCallbackStruct *cbs = (XmPushButtonCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  if(global->showing != 4)
    return;

  for(i=0; i<mbutton.allocated; i++) {
    mbutton.current = mbutton.start + i;
    if((mbutton.current)->in_process >= 0)
      if((mbutton.current)->b4 == W)
	break;
  }
  if(i < mbutton.allocated) {
    process = global->space + global->current;
    message = process->space + (mbutton.current)->in_process;
    if(message->in_help != -1) {
      if(readHelp() != -1) {
	XmTextSetString(wdgts[50],buf_help);
	save_showing = global->showing;
	global->showing = 5;
	configureShellForced(global->showing);
	XtUnmapWidget(wdgts[save_showing]);
	XtMapWidget(wdgts[global->showing]);
	XFlush(display);
	configureShellForced(global->showing);
      }
      else {
	message->in_help == -1;
	XtVaSetValues(W,XmNsensitive,0,NULL);
      }
      XFlush(display);
    }
  }
}


void makeNewMessageButtons(void)
{
  static int j;

  printf("creating message buttons...");

  if(mbutton.start == NULL)
    mbutton.start = (MESSAGE_BUTTON *)malloc(30*sizeof(MESSAGE_BUTTON));
  else
    mbutton.start = (MESSAGE_BUTTON *)realloc(mbutton.start,
		    (mbutton.allocated + 30)*sizeof(MESSAGE_BUTTON));
  for(j = mbutton.allocated; j<mbutton.allocated + 30; j++) {
    mbutton.current = mbutton.start + j;
    (mbutton.current)->in_process = -1;
    xargn = 0;
    (mbutton.current)->form = FmCreateMessageButton("MessageButton", wdgts[42], xargs, xargn);
    xargn = 0;
    XtSetArg(xargs[xargn],"status",&((mbutton.current)->b1)); xargn++;
    XtSetArg(xargs[xargn],"count",&((mbutton.current)->b2));  xargn++;
    XtSetArg(xargs[xargn],"name",&((mbutton.current)->b3));   xargn++;
    XtSetArg(xargs[xargn],"help",&((mbutton.current)->b4));   xargn++;
    XtGetValues((mbutton.current)->form, xargs, xargn);
    setColor((mbutton.current)->b4,CODE_WHITE,-1);
  }
  mbutton.allocated += 30;
  mbutton.free += 30;
}

void clearProcessCount(Widget W,XtPointer client_data,XtPointer call_data)
{
  XmAnyCallbackStruct *cbs = (XmAnyCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  for(i=0; i<pbutton.allocated; i++) {
    pbutton.current = pbutton.start + i;
    if((pbutton.current)->in_global >= 0)
      if((pbutton.current)->b2 == W)
	break;
  }
  if(i < pbutton.allocated) {
    in_global = (pbutton.current)->in_global;
    process = global->space + in_global;
    if(process->now)
      for(in_process=0; in_process<process->now; in_process++) {
	message = process->space + in_process;
	free(message->s2);
	message->s2 = myStringCreateSimple(zero);
	message->count = 0;
	if(message->button >= 0)
	  XmTextFieldSetString((mbutton.start+message->button)->b2,message->s2);
      }
    free(process->s2);
    process->s2 = myStringCreateSimple(zero);
    process->count = 0;
    XmTextFieldSetString((pbutton.current)->b2,process->s2);
    configureShell(global->showing);
    XFlush(display);
  }
}

int compMessage(const void *m1,const void *m2)
{
  const MESSAGE_STATE *mes1 = m1, *mes2 = m2;

  return(strcasecmp(mes1->s3,mes2->s3));
}

void updateMessageButton(void);
void showProcess(Widget W,XtPointer client_data,XtPointer call_data)
{
  static PROCESS_STATE *p;
  XmAnyCallbackStruct *cbs = (XmAnyCallbackStruct *)call_data;

  if(cbs->reason != XmCR_ACTIVATE || cbs->event->type != ButtonRelease)
    return;
  analyzeButton(cbs->event);

  if(global->showing != 3)
    return;

  for(i=0; i<pbutton.allocated; i++) {
    pbutton.current = pbutton.start + i;
    if((pbutton.current)->in_global >= 0)
      if((pbutton.current)->b3 == W)
	break;
  }
  if(i < pbutton.allocated) {
    in_global = (pbutton.current)->in_global;
    process = global->space + in_global;
    if(process->now > 0) {
      while(process->now > mbutton.allocated)
	makeNewMessageButtons();

      printf("sort...");

      qsort((void*)process->space,process->now,sizeof(MESSAGE_STATE),compMessage);

      printf("update buttons...");

      for(in_process=0; in_process<process->now; in_process++) {
	message = process->space + in_process;
	message->button = in_process;
	mbutton.current = mbutton.start + in_process;
	(mbutton.current)->in_process = in_process;
	XtManageChild((mbutton.current)->form);
	XtMapWidget((mbutton.current)->form);
	XmScrollVisible(wdgts[43],(mbutton.current)->form,0,0);
	updateMessageButton();
      }

      printf("unmanage extra buttons...");

      mbutton.free = mbutton.allocated - process->now;
      if(mbutton.free > 0)
	for(i=process->now; i<mbutton.allocated; i++) {
	  mbutton.current = mbutton.start + i;
	  (mbutton.current)->in_process = -1;
	  XtUnmanageChild((mbutton.current)->form);
	}
      global->current = in_global;
      setColor(wdgts[40],GET_COLOR(process->status),
	       GET_SEVERITY(process->status)+1);
      XmTextFieldSetString(wdgts[46],process->s3);

      if(process->status) {

	int newheight = (((mbutton.start)->form)->core.height+1)*process->now;

	XtResizeWidget(wdgts[42],wdgts[42]->core.width,newheight,0);
	XtResizeWidget(wdgts[41],wdgts[41]->core.width,newheight,0);

	XmUpdateDisplay(wdgts[41]);
	XmUpdateDisplay(wdgts[42]);

	configureShellForced(4);
	XmScrollVisible(wdgts[43],(mbutton.start+mbutton.allocated-1)->form,0,0);
	XmScrollVisible(wdgts[43],(mbutton.start)->form,0,0);
	XmScrolledWindowSetAreas(wdgts[43],NULL,NULL,wdgts[41]);

	XtUnmapWidget(wdgts[global->showing]);
	XtMapWidget(wdgts[4]);
	global->showing = 4;
	XFlush(display);
      }

      printf("update display...");

      XmUpdateDisplay(wdgts[4]);
      for(in_process=0; in_process<process->now; in_process++) {
	mbutton.current = mbutton.start + in_process;
	XtMapWidget((mbutton.current)->form);
      }
    }
  }
}

void makeNewProcessButtons(void)
{
  printf("creating process buttons...");

  if(pbutton.start == NULL)
    pbutton.start = (PROCESS_BUTTON *)malloc(10*sizeof(PROCESS_BUTTON));
  else
    pbutton.start = (PROCESS_BUTTON *)realloc(pbutton.start,
		    (pbutton.allocated + 10)*sizeof(PROCESS_BUTTON));
  for(i = pbutton.allocated; i<pbutton.allocated + 10; i++) {
    pbutton.current = pbutton.start + i;
    (pbutton.current)->in_global = -1;
    xargn = 0;
    (pbutton.current)->form = FmCreateProcessButton("ProcessButton", wdgts[32], xargs, xargn);
    xargn = 0;
    XtSetArg(xargs[xargn],"status",&((pbutton.current)->b1)); xargn++;
    XtSetArg(xargs[xargn],"count",&((pbutton.current)->b2));  xargn++;
    XtSetArg(xargs[xargn],"name",&((pbutton.current)->b3));   xargn++;
    XtGetValues((pbutton.current)->form, xargs, xargn);
  }
  pbutton.allocated += 10;
  pbutton.free += 10;
}

/***************   End of widgets  stuff   *******************************/
/*************************************************************************/



/**************************************************************************/
/***************    Stuff to deal with messages     ***********************/
/**************************************************************************/


void makeSubsetList(char *list)
{
  static char *c,*c1,*c2,*l;
  static SUBSET *s;

  if(subset_total)
    free(subset_start);
  subset_total = 1;
  c = list;
  while(c = strchr(c,',')) {
    subset_total++;
    c++;
  }
  subset_start = (SUBSET *)malloc(subset_total * sizeof(SUBSET));
  l = (char *)malloc(strlen(list)+1);
  strcpy(l,list);
  c1 = l;
  for(i=0; i<subset_total; i++) {
    s = subset_start + i;
    if(c = strchr(c1,',')) {
      if(c-c1 < 15) {
	strncpy(s->subset,c1,c-c1);
	s->subset[c-c1] = '\0';
      }
      else
	strncpy(s->subset,c1,15);
      c1 = c + 1;
    }
    else
      strncpy(s->subset,c1,15);
    s->subset[15] = '\0';
    strcpy(s->subset,s->subset+strspn(s->subset," "));
    if(c2 = strchr(s->subset,' '))
      *c2 = '\0';
    if(!strlen(s->subset))
      strcpy(s->subset,"<blank>");
    s->isubset = ecompress(s->subset);
  }
  free(l);
  if(subset_total) {
    fprintf(stderr,"Alarm was restricted to the following alarm groups:\n");
    for(i=0; i<subset_total; i++)
      fprintf(stderr,"%s\n",(subset_start+i)->subset);
  }
}

void createMessageButton(void)
{
  if(mbutton.free <= 0)
    makeNewMessageButtons();
  for(i=0; i<mbutton.allocated; i++)
    if((mbutton.start+i)->in_process < 0)
      break;
  message->button = i;
  mbutton.free--;
  mbutton.current = mbutton.start + i;
  (mbutton.current)->in_process = in_process;
  if(message->in_help != -1)
    XtVaSetValues((mbutton.current)->b4,XmNsensitive,1,NULL);
  else
    XtVaSetValues((mbutton.current)->b4,XmNsensitive,0,NULL);
  XtManageChild((mbutton.current)->form);
  XtMapWidget((mbutton.current)->form);

  {
    int newheight = (((mbutton.start)->form)->core.height+1)*process->now;

    XtResizeWidget(wdgts[42],wdgts[42]->core.width,newheight,0);
    XtResizeWidget(wdgts[41],wdgts[41]->core.width,newheight,0);
    XmScrolledWindowSetAreas(wdgts[43],NULL,NULL,wdgts[41]);
    XmScrollVisible(wdgts[43],(mbutton.current)->form,0,0);

    XmUpdateDisplay(wdgts[41]);
    XmUpdateDisplay(wdgts[42]);
  }

  configureShell(4);
}

void updateMessageButton(void)
{
  static int color, j;
  static Widget w;

  if(message->button >= 0) {
    mbutton.current = mbutton.start + message->button;
    switch(GET_SEVERITY(message->status)) {
    case CODE_WARNING:
      XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_0,NULL);
      break;
    case CODE_ERROR:
      XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_1,NULL);
      break;
    default:
      XtVaSetValues((mbutton.current)->b1,XmNlabelString,excl_3,NULL);
      break;
    }
    XmTextFieldSetString((mbutton.current)->b2,message->s2);
    XmTextFieldSetString((mbutton.current)->b3,message->s3);
    color = GET_COLOR(message->status);
    setColor((mbutton.current)->b1,color,-1);
    setColor((mbutton.current)->b2,color,-1);
    setColor((mbutton.current)->b3,color,-1);
    if(message->in_help != -1)
      XtVaSetValues((mbutton.current)->b4,XmNsensitive,1,NULL);
    else
      XtVaSetValues((mbutton.current)->b4,XmNsensitive,0,NULL);
  }
  XmUpdateDisplay(wdgts[4]);
}

void updateProcessButton(void)
{
  static int color;

  pbutton.current = pbutton.start + process->button;
  switch(GET_SEVERITY(process->status)) {
  case CODE_WARNING:
    XtVaSetValues((pbutton.current)->b1,XmNlabelString,excl_0,NULL);
    break;
  case CODE_ERROR:
    XtVaSetValues((pbutton.current)->b1,XmNlabelString,excl_1,NULL);
    break;
  default:
    XtVaSetValues((pbutton.current)->b1,XmNlabelString,excl_3,NULL);
    break;
  }
  color = GET_COLOR(process->status);
  setColor((pbutton.current)->b1,color,-1);
  setColor((pbutton.current)->b2,color,-1);
  setColor((pbutton.current)->b3,color,-1);
  if(in_global == global->current)
    setColor(wdgts[40],GET_COLOR(process->status),
	     GET_SEVERITY(process->status)+1);
}

void updateGlobalButton(void)
{
  if(global->status) {
    setColor(wdgts[30],GET_COLOR(global->status),
	     GET_SEVERITY(global->status)+1);
    setColor(wdgts[10],GET_COLOR(global->status),
	     GET_SEVERITY(global->status)+1);
  }
  else {
    setColor(wdgts[30],CODE_GREEN,CODE_WARNING+1);
    setColor(wdgts[10],CODE_GREEN,CODE_WARNING+1);
  }
  switch(global->showing) {
  case 1:
    if((GET_SEVERITY(global->status) == CODE_FATAL) &&
       (GET_COLOR(global->status) == CODE_RED)) {

/* Again, beautiful dog is not here anymore...
      configureShellForced(2);
      XtUnmapWidget(wdgts[1]);
      XtMapWidget(wdgts[2]);
      XRaiseWindow(display,XtWindow(wdgts[2]));
      global->showing = 2;
*/
      XtMapWidget(wdgts[1]);
      XRaiseWindow(display,XtWindow(wdgts[1]));

    }
    break;
  case 2:
    if((GET_SEVERITY(global->status) != CODE_FATAL) ||
       (GET_COLOR(global->status) != CODE_RED)) {
      configureShell(1);
      XtUnmapWidget(wdgts[2]);
      XtMapWidget(wdgts[1]);
      XFlush(display);
      global->showing = 1;
    }
    break;
  case 3:
    if(global->status == 0) {
      configureShell(1);
      XtUnmapWidget(wdgts[3]);
      XtMapWidget(wdgts[1]);
      XFlush(display);
      global->showing = 1;
    }
    break;
  }
}

void findMessage(int iname)
{
  if(process->now)
    for(in_process=0; in_process<process->now; in_process++) {
      message = process->space + in_process;
      if(message->iname == iname)
	break;
    }
  if(!process->now || (in_process == process->now)) {
    message = NULL;
    in_process = -3;
  }
}

void findProcess(int iname)
{
  if(global->now)
    for(in_global=0; in_global<global->now; in_global++) {
      process = global->space + in_global;
      if(process->iname == iname)
	break;
    }
  if(!global->now || (in_global == global->now)) {
    process = NULL;
    in_global = -2;
  }
}

void destroyMessage(void)
{
  process->count -= message->count;
  free(message->s3);
  free(message->s2);
  if((global->current == in_global) && (message->button >= 0)) {
    mbutton.current = mbutton.start + message->button;
    XtUnmanageChild((mbutton.current)->form);
    (mbutton.current)->in_process = -1;
    mbutton.free++;
  }
  process->now--;
  if(in_process < process->now) {
    bcopy(process->space + process->now, message, sizeof(MESSAGE_STATE));
    if(message->button >= 0)
      (mbutton.start+message->button)->in_process = in_process;
  }
}

void destroyProcess(void)
{
  while(process->now) {
    message = process->space + process->now - 1;
    destroyMessage();
  }
  free(process->s3);
  free(process->s2);
  pbutton.current = pbutton.start + process->button;
  XtUnmanageChild((pbutton.current)->form);
  (pbutton.current)->in_global = -1;
  pbutton.free++;
  free(process->space);
  global->now--;
  if(global->current == in_global) {
    global->current = -1;
    if(global->showing == 4) {
      if(global->now) {
	configureShell(3);
	XtUnmapWidget(wdgts[4]);
	XtMapWidget(wdgts[3]);
	global->showing = 3;
      }
      else {
	configureShell(1);
	XtUnmapWidget(wdgts[4]);
	XtMapWidget(wdgts[1]);
	global->showing = 1;
      }
    }
  }
  else if(global->current == global->now)
    global->current = in_global;
  if(in_global < global->now) {
    bcopy(global->space + global->now, process, sizeof(PROCESS_STATE));
    (pbutton.start+process->button)->in_global = in_global;
  }
}

void updateGlobal(void)
{
  static int oldstatus;

  oldstatus = global->status;
  global->status = 0;
  if(global->now)
    for(i=0; i<global->now; i++)
      if((global->space + i)->status > global->status)
	global->status = (global->space + i)->status;
  if(global->status != oldstatus)
    updateGlobalButton();
}

void updateProcess(void)
{
  static int oldstatus;

  oldstatus = process->status;
  process->status = 0;
  if(process->now)
    for(i=0; i<process->now; i++)
      if((process->space + i)->status > process->status)
	process->status = (process->space + i)->status;
  if(process->status == 0) {
    destroyProcess();
    updateGlobal();
  }
  else
    if(process->status != oldstatus) {
      updateProcessButton();
      updateGlobal();
      if((process->status > oldstatus) &&
	 (GET_COLOR(global->status) == CODE_RED))
	XRaiseWindow(display,XtWindow(wdgts[global->showing]));
    }
}

void changeMessageStatus(int code)
{
  static int severity,color,newcolor;

  color = GET_COLOR(message->status);
  severity = GET_SEVERITY(message->status);
  if(code == MCAST_REMOVE) {
    destroyMessage();
    sprintf(scratch,"%6d",process->count);
    free(process->s2);
    process->s2 = myStringCreateSimple(scratch);
    XmTextFieldSetString((pbutton.start+process->button)->b2,process->s2);
    if((color > GET_COLOR(process->status)) || 
       ((color == GET_COLOR(process->status)) && 
	(severity >= GET_SEVERITY(process->status))) ||
       (process->now == 0))
      updateProcess();
  }
  else {
    switch(code) {
    case MCAST_RED:
      newcolor = CODE_RED;
      break;
    case MCAST_YELLOW:
      newcolor = CODE_YELLOW;
      break;
    case MCAST_GREEN:
      newcolor = CODE_GREEN;
      break;
    }
    if(color != newcolor) {
      message->status = newcolor + severity;
      if(message->button >= 0) {
	mbutton.current = mbutton.start + message->button;
	setColor((mbutton.current)->b1,newcolor,-1);
	setColor((mbutton.current)->b2,newcolor,-1);
	setColor((mbutton.current)->b3,newcolor,-1);
      }
      if((newcolor > GET_COLOR(process->status)) ||
	 (color >= GET_COLOR(process->status)))
	updateProcess();
    }
  }
}

void changeMessagesStatusLoop(int code)
{
  static int j;

  if(process->now)
    for(j=process->now - 1; j>=0; j--) {
      message = process->space + j;
      switch(code) {
      case MCAST_RED1:
	if(GET_COLOR(message->status) == CODE_YELLOW)
	  changeMessageStatus(MCAST_RED);
	break;
      case MCAST_YELLOW1:
	if(GET_COLOR(message->status) == CODE_RED)
	  changeMessageStatus(MCAST_YELLOW);
	break;
      case MCAST_GREEN1:
	if(GET_COLOR(message->status) == CODE_YELLOW)
	  changeMessageStatus(MCAST_GREEN);
	break;
      case MCAST_GR_YEL1:
	if(GET_COLOR(message->status) == CODE_GREEN)
	  changeMessageStatus(MCAST_YELLOW);
	break;
      case MCAST_REMOVE1:
	if(GET_COLOR(message->status) == CODE_GREEN)
	  changeMessageStatus(MCAST_REMOVE);
	break;
      }
    }
}

void changeProcessesStatusLoop(int code)
{
  static int j;

  if(global->now)
    for(j=global->now - 1; j>=0; j--) {
      process = global->space + j;
      switch(code) {
      case MCAST_RED2:
	changeMessagesStatusLoop(MCAST_RED1);
	break;
      case MCAST_YELLOW2:
	changeMessagesStatusLoop(MCAST_YELLOW1);
	break;
      case MCAST_GREEN2:
	changeMessagesStatusLoop(MCAST_GREEN1);
	break;
      case MCAST_GR_YEL2:
	changeMessagesStatusLoop(MCAST_GR_YEL1);
	break;
      case MCAST_REMOVE2:
	changeMessagesStatusLoop(MCAST_REMOVE1);
	break;
      }
    }
}

void updateMessage(void)
{
  static char *c;

  c = (char*)buf_rcv + MCAST_BUFFER_SIZE - 1;
  *c = '\0';
  c = (char*)buf_rcv + sizeof(MCAST_HEADER);
  while((int)(*c) != (int)'\0') {
    if((int)(*c) == (int)'\n')
      *c = ' ';
    c++;
  }
  if(GET_COLOR(message->status) == CODE_GREEN)
    message->status = CODE_GREEN;
  else
    message->status = CODE_RED;
  if(message->treated)
    message->status += message->treated - 1;
  else
    switch(buf_rcv->code) {
    case MCAST_UNKNOWN:
    case MCAST_WARNING:
      message->status += CODE_WARNING;
      break;
    case MCAST_ERROR:
      message->status += CODE_ERROR;
      break;
    case MCAST_FATAL:
      message->status += CODE_FATAL;
      break;
    }
  process->count++;
  sprintf(scratch,"%6d",process->count);
  free(process->s2);
  process->s2 = myStringCreateSimple(scratch);
  XmTextFieldSetString((pbutton.start + process->button)->b2,process->s2);
  message->count++;
  sprintf(scratch,"%6d",message->count);
  free(message->s2);
  message->s2 = myStringCreateSimple(scratch);
  free(message->s3);
  message->s3 = myStringCreateSimple((char*)((char*)buf_rcv+sizeof(MCAST_HEADER)));
  if(in_global == global->current)
    updateMessageButton();
  if(message->status > process->status)
    updateProcess();
}

void newMessage(void)
{
  if(process->now >= process->allocated) {
    process->allocated += 30;
    process->space = (MESSAGE_STATE *)realloc(process->space,
		     (process->allocated)*sizeof(MESSAGE_STATE));
  }
  message = process->space + process->now;
  in_process = process->now;
  process->now++;
  message->status = 0;
  message->treated = 0;
  message->iname = buf_rcv->id;
  message->count = 0;
  message->s2 = myStringCreateSimple(zero);
  message->s3 = myStringCreateSimple(zero);
  message->in_help = findMessageHelp(buf_rcv->id);
  if(in_global == global->current)
    createMessageButton();
  else {
    message->button = -1;
  }
  updateMessage();
}

void newProcess(void)
{
  if(global->now >= global->allocated) {
    global->allocated += 10;
    global->space = (PROCESS_STATE *)realloc(global->space,
		    (global->allocated)*sizeof(PROCESS_STATE));
  }
  process = global->space + global->now;
  in_global = global->now;
  global->now++;
  process->status = 0;
  process->iname = buf_rcv->iname;
  process->count = 0;
  process->allocated = 30;
  process->space = (MESSAGE_STATE *)malloc((process->allocated)*
					   sizeof(MESSAGE_STATE));
  process->now = 0;
  process->s2 = myStringCreateSimple(zero);
  process->s3 = myStringCreateSimple(buf_rcv->name);
  if(pbutton.free <= 0)
    makeNewProcessButtons();
  for(i=0; i<pbutton.allocated; i++)
    if((pbutton.start+i)->in_global < 0)
      break;
  process->button = i;
  pbutton.free--;
  pbutton.current = pbutton.start + i;
  (pbutton.current)->in_global = in_global;

  XtVaSetValues((pbutton.current)->b1,XmNlabelString,excl_0,NULL);
  XmTextFieldSetString((pbutton.current)->b2,process->s2);
  XmTextFieldSetString((pbutton.current)->b3,process->s3);
  XtManageChild((pbutton.current)->form);
  XtMapWidget((pbutton.current)->form);

  newMessage();
}

int checkFilter(int code)
{
  switch(currentFilter) {
  case 1:
    if(code != MCAST_ERROR && code != MCAST_FATAL)
      return 0;
    break;
  case 2:
    if(code != MCAST_FATAL)
      return 0;
    break;
  }
  return 1;
}

void filterMessagesLoop(int code)
{
  if(process->now) {
    for(in_process=process->now - 1; in_process>=0; in_process--) {
      message = process->space + in_process;
      if(GET_SEVERITY(message->status) <= code)
	destroyMessage();
    }
    if(process->now) {
      sprintf(scratch,"%6d",process->count);
      free(process->s2);
      process->s2 = myStringCreateSimple(scratch);
      XmTextFieldSetString((pbutton.start+process->button)->b2,process->s2);
      updateProcess();
    }
    else
      destroyProcess();
  }
}

void filterProcessesLoop(int code)
{
  if(global->now)
    for(in_global=global->now - 1; in_global>=0; in_global--) {
      process = global->space + in_global;
      filterMessagesLoop(code);
    }
  updateGlobal();
}

void setFilter(int filter)
{
  if(filter > currentFilter) {
    switch(filter) {
    case 1:
      filterProcessesLoop(CODE_WARNING);
      break;
    case 2:
      filterProcessesLoop(CODE_ERROR);
      break;
    }
    configureShell(global->showing);
  }
  currentFilter = filter;
  return;
}

void doInput(void)
{
  switch(buf_rcv->code) {
  case MCAST_UNKNOWN:
  case MCAST_WARNING:
  case MCAST_ERROR:
  case MCAST_FATAL:
    if(subset_total) {
      for(i=0; i<subset_total; i++)
	if(buf_rcv->isubset == (subset_start+i)->isubset)
	  break;
      if(i == subset_total)
	break;
    }
    else if(buf_rcv->isubset == subset_debug)
      break;
    findProcess(buf_rcv->iname);
    if(process == NULL) {
      if(checkFilter(buf_rcv->code))
	newProcess();
    }
    else {
      findMessage(buf_rcv->id);
      if(message == NULL) {
	if(checkFilter(buf_rcv->code))
	  newMessage();
      }
      else
	updateMessage();
    }
    break;
  case MCAST_RED:
  case MCAST_YELLOW:
  case MCAST_GREEN:
  case MCAST_REMOVE:
    findProcess(buf_rcv->iname);
    if(process != NULL) {
      findMessage(buf_rcv->id);
      if(message != NULL)
	changeMessageStatus(buf_rcv->code);
    }	
    break;
  case MCAST_RED1:
  case MCAST_YELLOW1:
  case MCAST_GREEN1:
  case MCAST_GR_YEL1:
  case MCAST_REMOVE1:
    findProcess(buf_rcv->iname);
    if(process != NULL)
      changeMessagesStatusLoop(buf_rcv->code);
    break;
  case MCAST_RED2:
  case MCAST_YELLOW2:
  case MCAST_GREEN2:
  case MCAST_GR_YEL2:
  case MCAST_REMOVE2:
    changeProcessesStatusLoop(buf_rcv->code);
    break;
  }
  configureShell(global->showing);
  XFlush(display);
}

void flushXevents(void);

void messageInput(XtPointer client_data,int *fid,XtInputId *id)
{
  flushXevents();

  if(ereceive() > 0)
    doInput();
}

/***************   End of stuff for messages   ***********************/
/*************************************************************************/


void catch_usr1(void)
{
  int in_glb, in_prs;
  PROCESS_STATE *prs;
  MESSAGE_STATE *msg;
  MESSAGE_BUTTON *mbt;

  prepareMessageHelp();

  if(global->now)
    for(in_glb=0; in_glb<global->now; in_glb++) {
      prs = global->space + in_glb;
      if(prs->now)
	for(in_prs=0; in_prs<prs->now; in_prs++) {
	  msg = prs->space + in_prs;
	  msg->in_help = findMessageHelp(msg->iname);
	}
    }
  if(global->now && (global->current >= 0)) {
    prs = global->space + global->current;
    if(prs->now)
      for(in_prs=0; in_prs<prs->now; in_prs++) {
	msg = prs->space + in_prs;
	if(msg->button >= 0) {
	  mbt = mbutton.start + msg->button;
	  if(msg->in_help >= 0)
	    XtVaSetValues(mbt->b4,XmNsensitive,1,NULL);
	  else
	    XtVaSetValues(mbt->b4,XmNsensitive,0,NULL);
	}
      }
  }
  signal(SIGUSR1, catch_usr1);
}


void mainTimeout(void)
{
  static int blink;
  static XKeyboardControl kbd_c;
  static XKeyboardState kbd_s;
  static unsigned long mask = (KBBellPercent | KBBellPitch | KBBellDuration);

/*
  configureShell(global->showing);
*/
  XtMapWidget(wdgts[global->showing]);
  switch(global->showing) {
  case 1:
  case 2:
    if(global->status >= CODE_RED + CODE_ERROR) {
      if(global->showing == 1 || global->showing == 2) {
	switch(blink) {
	case 0:
	case 1:
	  if(!freeMode) {
	    XGetKeyboardControl(display,&kbd_s);
	    kbd_c.bell_percent  = 50;
	    kbd_c.bell_pitch    = 100;
	    kbd_c.bell_duration = 200;
	    XChangeKeyboardControl(display,mask,&kbd_c);
	    XBell(display,50);
	    kbd_c.bell_percent  = (int)kbd_s.bell_percent;
	    kbd_c.bell_pitch    = (int)kbd_s.bell_pitch;
	    kbd_c.bell_duration = (int)kbd_s.bell_duration;
	    XChangeKeyboardControl(display,mask,&kbd_c);
	  }
	  if(blink)
	       /***
	       XtMapWidget(wdgts[global->showing]);
	       New mode of annoyance  ***/
	    setColor(wdgts[10*global->showing],CODE_RED,GET_SEVERITY(global->status)+1);
	  else {
	       /***
	       XtUnmapWidget(wdgts[1]);
	       XtUnmapWidget(wdgts[2]);
	       ***/
	    setColor(wdgts[10*global->showing],CODE_WHITE,GET_SEVERITY(global->status)+1);
	  }
	case 2:
	case 3:
	case 4:
	  blink++;
	  break;
	case 5:
	  blink = 0;
	  break;
	}
      }
    }
    if(!freeMode)
      XRaiseWindow(display,XtWindow(wdgts[global->showing]));
    break;
  case 3:
  case 4:
    if(!freeMode)
      XRaiseWindow(display,XtWindow(wdgts[global->showing]));
    break;
  case 5:
  case 6:
  case 7:
    if(!freeMode)
      XRaiseWindow(display,XtWindow(wdgts[global->showing]));
    break;
  }
  XtAppAddTimeOut(XtWidgetToApplicationContext(wdgts[0]),1000,
		  (XtTimerCallbackProc)mainTimeout,NULL);
  XFlush(display);
}

void main(int argc,char *argv[])
{
  int j;
  static int argc1 = 5;

  static char *argv1[20] = {"Alarm","-xrm",bestFont,"-xrm","*background: magenta3"};

  setbuf(stdout,NULL);
  setbuf(stderr,NULL);

  if(getenv("ALARM_HELPDIR") != NULL)
    strcpy(helpDir,getenv("ALARM_HELPDIR"));
  subset_debug = ecompress("debug");
  if(getenv("ALARM_GROUP") != NULL)
    makeSubsetList(getenv("ALARM_GROUP"));
  if(argc > 1)
    for(j=1; j<argc; j++)
      if(!strcmp(argv[j],"-helpdir")) {
	j++;
	strcpy(helpDir,argv[j]);
      }
      else if(!strcmp(argv[j],"-group")) {
	j++;
	makeSubsetList(argv[j]);
      }
      else if(!strcmp(argv[j],"-force")) {
	freeMode = 0;
      }
      else if(!strcmp(argv[j],"-fn")) {
	j++;
	sprintf(bestFont,"*fontList: %s",argv[j]);
      }
      else if(!strncmp(argv[j],"-h",2)) {
	fprintf(stderr,"Usage: Alarm [-helpdir DIRECTORY] [-group GROUP] [-force] [-fn font] [-bg color]\n");
	fprintf(stderr," -helpdir : directory with help files (default is /home/lemond/e852/alarmHelp)\n");
	fprintf(stderr," -group   : comma-separated list of Alarm groups to monitor (default is all groups)\n");
	fprintf(stderr," -force   : run in extremly annoying mode\n");
	exit(1);
      }
  argv1[0] = argv[0];
  if(argc > 1)
    for(i=1; i<argc; i++)
      argv1[argc1+i-1] = argv[i];
  argc1 += argc - 1;
/*
  findBestFont(argc,argv);
*/
  for(i=0; i<80; i++)
    wdgts[i] = NULL;
  wdgts[0] = FmInitialize("Alarm","Alarm",NULL,0,&argc1,argv1);
  if(wdgts[0] == NULL)
    exit(1);
  display = XtDisplay(wdgts[0]);
  screen = XtScreen(wdgts[0]);
  if(DefaultDepthOfScreen(screen) < 2) {
    fprintf(stderr,"WARNING: Alarm works much more better on a color terminal!\n");
  }
  screen_width = (Dimension)screen->width;
  screen_height = (Dimension)screen->height;
  excl_0 = XmStringCreateSimple("   ");
  excl_1 = XmStringCreateSimple(" ! ");
  excl_3 = XmStringCreateSimple("!!!");

  initColors();
  initPixmaps();
  printf("creating widgets...");
  FmCreatexalarm("Alarm",wdgts[0],NULL,0);
  setColor(wdgts[10],1,1);
  configureShellForced(1);
  configureShellForced(2);
  configureShellForced(3);
  configureShellForced(4);
  configureShellForced(5);
  configureShellForced(6);
  configureShellForced(7);

  global = (GLOBAL_STATE *)malloc(sizeof(GLOBAL_STATE));
  global->status = 0;
  global->showing = 1;
  global->allocated = 10;
  global->space = (PROCESS_STATE *)malloc((global->allocated)*
					  sizeof(PROCESS_STATE));
  global->now = 0;
  global->current = -1;
  eregister("Alarm","");
  esend_setmode(1);
  eregister_get();
  eget_internals(&multi_sock_rd,&multi_sock_wr,&buf_rcv,&buf_send);
  makeNewProcessButtons();
  makeNewMessageButtons();
  prepareMessageHelp();
  mcastInput = XtAddInput(multi_sock_rd,(XtPointer)XtInputReadMask,
			  (XtInputCallbackProc)messageInput,NULL);
  XtAppAddTimeOut(XtWidgetToApplicationContext(wdgts[0]),1000,
		  (XtTimerCallbackProc)mainTimeout,NULL);
  if(!freeMode) {
    XtUnmanageChild(wdgts[11]);
    XtUnmanageChild(wdgts[21]);
    quitHeight1 = 0;
    quitHeight2 = 0;
    configureShellForced(1);
    configureShellForced(2);
  }
  XtMapWidget(wdgts[1]);

  printf("done\n");
  system("alarmRelay &");

  _daemonize(_DF_NOCHDIR | _DF_NOCLOSE,-1,-1,-1);
  signal(SIGUSR1, catch_usr1);

  XtMainLoop();
}

XtAppContext _XtDefaultAppContext(void);

void flushXevents(void)
{
  XtAppContext appContext = _XtDefaultAppContext();
  XtInputMask inputmask;

  while ( (inputmask = XtAppPending(appContext)) & XtIMXEvent)
    {
      /*printf("x");*/
      XtAppProcessEvent(appContext,XtIMXEvent);
    }
}

void setPause(int what)
{
  switch(what) {
  case 1:
    if(mcastInput)
      XtRemoveInput(mcastInput);
    break;
  default:
    mcastInput = XtAddInput(multi_sock_rd,(XtPointer)XtInputReadMask,
			    (XtInputCallbackProc)messageInput,NULL);
    break;
  }
}

void printAll(char *printer)
{
  FILE *fout;
  char command[80];
  int in_glb, in_prs;
  PROCESS_STATE *prs;
  MESSAGE_STATE *msg;
  time_t cur_time;

  if(global->now <= 0)
    return;
  sprintf(command,"lp -d%s -o\"-H\"",printer);
  if((fout = popen(command,"w")) != NULL) {
    cur_time = time(NULL);
    fprintf(fout,"       Alarm status at %s", ctime(&cur_time));
      for(in_glb=0; in_glb<global->now; in_glb++) {
	prs = global->space + in_glb;
	fprintf(fout,"=======================================================================\n");
	switch(GET_SEVERITY(prs->status)) {
	case CODE_WARNING:
	  fprintf(fout,"   ");
	  break;
	case CODE_ERROR:
	  fprintf(fout," ! ");
	  break;
	case CODE_FATAL:
	  fprintf(fout,"!!!");
	  break;
	}
	fprintf(fout," %s %s\n",prs->s2,prs->s3);
	fprintf(fout,"- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -\n");
	if(prs->now)
	  for(in_prs=0; in_prs<prs->now; in_prs++) {
	    msg = prs->space + in_prs;
	    switch(GET_SEVERITY(msg->status)) {
	    case CODE_WARNING:
	      fprintf(fout,"   ");
	      break;
	    case CODE_ERROR:
	      fprintf(fout," ! ");
	      break;
	    case CODE_FATAL:
	      fprintf(fout,"!!!");
	      break;
	    }
	    fprintf(fout," %s %s\n",msg->s2,msg->s3);
	  }
      }
    pclose(fout);
  }
}

/* end file */
