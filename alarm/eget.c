#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include "alarm.h"
MCAST_HEADER *buf_rcv,*buf_send;
int multi_sock_rd,multi_sock_wr;


main()
{
  int ret;

  eregister_get();
  eget_internals(&multi_sock_rd,&multi_sock_wr,&buf_rcv,&buf_send);
  while(1) {
    sginap(5);
    ret = ereceive();
    if(ret > 0) {
      printf("From:%s(%d,%d,%d,%d): ",buf_rcv->name,buf_rcv->iname,
	     buf_rcv->pid,buf_rcv->computer,buf_rcv->n);
      switch(buf_rcv->code) {
      case MCAST_UNKNOWN:
	printf("Unknown: %s[%d]",(char*)buf_rcv+sizeof(MCAST_HEADER),
	       buf_rcv->id);
      break;
      case MCAST_WARNING:
	printf("Warning: %s[%d]",(char*)buf_rcv+sizeof(MCAST_HEADER),
	       buf_rcv->id);
      break;
      case MCAST_ERROR:
	printf("Error: %s[%d]",(char*)buf_rcv+sizeof(MCAST_HEADER),
	       buf_rcv->id);
      break;
      case MCAST_FATAL:
	printf("Fatal: %s[%d]",(char*)buf_rcv+sizeof(MCAST_HEADER),
	       buf_rcv->id);
      break;
      case MCAST_AUDIO:
	printf("Audio: # %d, limit %d",buf_rcv->id & 0xFFFF, buf_rcv->id >>16);
	break;
      case MCAST_RED:    
	printf("Red: for %d",buf_rcv->id);
	break;
      case MCAST_YELLOW: 
	printf("Yellow: for %d",buf_rcv->id);
	break;
      case MCAST_GREEN:  
	printf("Green: for %d",buf_rcv->id);
	break;
      case MCAST_REMOVE: 
	printf("Remove: for %d",buf_rcv->id);
	break;
      case MCAST_RED1:   
	printf("Own Red");
	break;
      case MCAST_YELLOW1:
	printf("Own Yellow");
	break;
      case MCAST_GREEN1:
	printf("Own Green");
	break;
      case MCAST_GR_YEL1:
	printf("Own Gr_Yel");
	break;
      case MCAST_REMOVE1:
	printf("Own Remove");
	break;
      case MCAST_RED2:   
	printf("Global Red");
	break;
      case MCAST_YELLOW2:
	printf("Global Yellow");
	break;
      case MCAST_GREEN2: 
	printf("Global Green");
	break;
      case MCAST_GR_YEL2: 
	printf("Global Gr_Yel");
	break;
      case MCAST_REMOVE2:
	printf("Global Remove");
	break;
      case MCAST_QUERY:  
	printf("Query");
	break;
      case MCAST_RELAY:  
	printf("Relay: #%d",buf_rcv->id);
	break;
      default:
	printf("Spurious message: code %d",buf_rcv->code);
	break;
      }
      printf("\n");
    }
  }
}
