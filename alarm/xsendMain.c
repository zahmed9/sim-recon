#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <time.h>
#include "alarm.h"
#include "Fm.h"
#include <Xm/TextF.h>

Widget FmCreatexsend(char *,Widget,Arg *,Cardinal);
Widget toplevel,textW[4];
char name[100];
char subset[100];

void registerWidget(int i,Widget W)
{
  textW[i-1]=W;
}


main(int argc,char *argv[])
{
  toplevel = FmInitialize("Xsend","xsend",NULL,0,&argc,argv);
  FmCreatexsend("Xsend",toplevel,NULL,0);
  _daemonize(_DF_NOCHDIR | _DF_NOCLOSE,-1,-1,-1);
  sprintf(name,"Xsender");
  sprintf(subset,"");
  esend_setmode(3);
  eregister(name,subset);
  FmLoop();
  exit(0);
}
    
void buttonAction(int action)
{
  static char *n,*d;

  n = XmTextFieldGetString(textW[0]);
  d = XmTextFieldGetString(textW[3]);
  if(strcmp(name,n) || strcmp(subset,d)) {
    strcpy(name,n);
    strcpy(subset,d);
    eregister(name,subset);
  }
  XtFree(n);
  XtFree(d);

  switch(action) {
  case MCAST_UNKNOWN:
  case MCAST_WARNING:
  case MCAST_ERROR:  
  case MCAST_FATAL:  
    n = XmTextFieldGetString(textW[1]);
    d = XmTextFieldGetString(textW[2]);
    esend(action,n,"%s",d);
    XtFree(n);
    XtFree(d);
    break;
  case MCAST_RED:
  case MCAST_YELLOW:
  case MCAST_GREEN: 
  case MCAST_REMOVE:
    n = XmTextFieldGetString(textW[1]);
    esend_color(action,n);
    XtFree(n);
    break;
  case MCAST_RED1:   
  case MCAST_YELLOW1:
  case MCAST_GREEN1: 
  case MCAST_GR_YEL1: 
  case MCAST_REMOVE1:
  case MCAST_RED2:   
  case MCAST_YELLOW2:
  case MCAST_GREEN2: 
  case MCAST_GR_YEL2: 
  case MCAST_REMOVE2:
    esend_color12(action);
    break;
  }
}
