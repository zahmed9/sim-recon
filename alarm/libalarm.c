#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>

static const char sccsid[] = "@(#)"__FILE__"\t5.2\tCreated 7/27/97 20:20:00, \tcompiled "__DATE__;

#ifdef sgi

#include <fcntl.h>
#include <string.h>
#include <bstring.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <net/if.h>
#include <net/soioctl.h>
#include <sys/syssgi.h>
#include <errno.h>
extern int errno;

unsigned int sysid(unsigned char);

#include "alarm.h"

static MCAST_HEADER *buf_send;
static MCAST_HEADER *buf_rcv;
static int multi_sock_rd,multi_sock_wr;
static int registered = 0, registered_get = 0;
static int esend_mode = 2;

void eget_internals(int *msrd,int *mswr,MCAST_HEADER **br,MCAST_HEADER **bs)
{
  *msrd = multi_sock_rd;
  *mswr = multi_sock_wr;
  *br   = buf_rcv;
  *bs   = buf_send;
}

void receive_socket(void)
{
  static int one = 1;
  static struct sockaddr_in from;
  static struct ip_mreq mreq;
  
  bzero(&from,sizeof(from));
  from.sin_family = AF_INET;
  from.sin_addr.s_addr = htonl(INADDR_ANY);
  from.sin_port = htons(MCAST_PORT);
  multi_sock_rd = socket(AF_INET,SOCK_DGRAM,0);
  fcntl(multi_sock_rd,F_SETFL,FNDELAY);
  setsockopt(multi_sock_rd,SOL_SOCKET,SO_REUSEADDR,&one,sizeof(one));
  one = 1;
  setsockopt(multi_sock_rd,SOL_SOCKET,SO_REUSEPORT,&one,sizeof(one));
  bind(multi_sock_rd,&from,sizeof(from));
  mreq.imr_multiaddr.s_addr = (unsigned int)htonl(MCAST_GROUP);
  mreq.imr_interface.s_addr = (unsigned int)htonl(INADDR_LOOPBACK);
  setsockopt(multi_sock_rd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq));
  {
    struct ifconf ifc;
    char buf[1000];

    ifc.ifc_len = sizeof(buf);
    ifc.ifc_buf = buf;
    if(ioctl(multi_sock_rd, SIOCGIFCONF, (char*)&ifc) >= 0) {
      struct ifreq *ifr;
      int n;
      long *c;
      ifr = ifc.ifc_req;
      for(n=ifc.ifc_len/sizeof(struct ifreq); --n>=0; ifr++) {
	if(ifr->ifr_addr.sa_family == AF_INET) {
	  c = (long *)(ifr->ifr_addr.sa_data + 2);
	  mreq.imr_multiaddr.s_addr = (unsigned int)htonl(MCAST_GROUP);
	  mreq.imr_interface.s_addr = (unsigned int)htonl(*c);
	  setsockopt(multi_sock_rd,IPPROTO_IP,IP_ADD_MEMBERSHIP,&mreq,sizeof(mreq));
	}
      }
    }
  }
}

void send_socket(void)
{
  int s,i;
  struct sockaddr_in to;
  ulong addr;
  static u_char ttl = 5;

  bzero(&to,sizeof(to));
  to.sin_family = AF_INET;
  to.sin_addr.s_addr = (unsigned int)htonl(MCAST_GROUP);
  to.sin_port = htons(MCAST_PORT);
  multi_sock_wr = socket(AF_INET,SOCK_DGRAM,0);
  fcntl(multi_sock_wr,F_SETFL,FNDELAY);
  addr = htonl(INADDR_LOOPBACK);
  setsockopt(multi_sock_wr,IPPROTO_IP,IP_MULTICAST_IF,&addr,sizeof(addr));
  setsockopt(multi_sock_wr,IPPROTO_IP,IP_MULTICAST_TTL,&ttl,sizeof(ttl));
  connect(multi_sock_wr,&to,sizeof(to));
}

int ecompress(const char *str)
/*Compress string to pseudo unique int for this string*/
{
  static int i,ret,ret1;

  i = ret = ret1 = 0;
  while((int)(*(str+i)) != (int)('\0')) {
    ret  += (int)(*(str+i)) * (i+1);
    ret1 += (256 - (int)(*(str+i))) * (i+1);
    i++;
  }
  ret += ret1<<16;
  return(ret);
}

void eregister(const char *name,const char *subset)
{
  if(!registered) {
    send_socket();
    buf_send = (MCAST_HEADER *)malloc(MCAST_BUFFER_SIZE + 500);
    strncpy(buf_send->magic,"E852",4);
    buf_send->pid = (int)getpid();
    buf_send->computer = (int)sysid(NULL);
    buf_send->n = 0;
    buf_send->relay_pid = 0;
    registered = 1;
    if(strlen(name) > 0)
      esend_mode |= 1;
  }
  strncpy(buf_send->name,name,31);
  buf_send->name[31] = '\0';
  strcpy(buf_send->name,buf_send->name+strspn(buf_send->name," \t,"));
  buf_send->name[strcspn(buf_send->name," \t,")] = '\0';
  if(strlen(buf_send->name) == 0) {
    strcpy(buf_send->name,"Unknown");
    syssgi(SGI_RDNAME,getpid(),buf_send->name,32);
    buf_send->name[31] = '\0';
  }
  buf_send->iname = ecompress(buf_send->name);
  strncpy(buf_send->subset,subset,15);
  buf_send->subset[15] = '\0';
  strcpy(buf_send->subset,buf_send->subset+strspn(buf_send->subset," \t,"));
  buf_send->subset[strcspn(buf_send->subset," \t,")] = '\0';
  if(strlen(buf_send->subset) == 0)
    strcpy(buf_send->subset,"<blank>");
  buf_send->isubset = ecompress(buf_send->subset);
}

void eregister_get(void)
{
  if(!registered_get) {
    receive_socket();
    buf_rcv = (MCAST_HEADER *)malloc(MCAST_BUFFER_SIZE);
    registered_get = 1;
  }
}

void esay(int msg,int repeat_limit)
{
  if(!registered)
    eregister("","");
  buf_send->code = MCAST_AUDIO;
  buf_send->n++;
  buf_send->id = (msg & 0xFFFF) | ((repeat_limit & 0xFFFF)<<16);
  if(esend_mode & 1)
    write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
}

void esend(int status,const char *id,const char *fmt,...)
{
  va_list ap;

  if(!registered)
    eregister("","");
  if(esend_mode & 1) {
    switch(status) {
    case MCAST_WARNING:
    case MCAST_ERROR:
    case MCAST_FATAL:
      buf_send->code = status;
      break;
    default:
      buf_send->code = MCAST_UNKNOWN;
      break;
    }
    buf_send->n++;
    buf_send->id = ecompress(id);
    sprintf((char*)buf_send+sizeof(MCAST_HEADER),"%s: ",id);
    if((fmt != NULL) && strlen(fmt)) {
      va_start(ap,fmt);
      vsprintf((char*)buf_send+sizeof(MCAST_HEADER)+strlen(id)+2,fmt,ap);
      va_end(ap);
    }
    else
      *((char*)buf_send+sizeof(MCAST_HEADER)+strlen(id)) = '\0';
    *((char*)buf_send+MCAST_BUFFER_SIZE-1) = '\0';
    write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER)+
	  strlen((char*)buf_send+sizeof(MCAST_HEADER))+1);
  }
}

void esendp(int status,const char *id,const char *fmt,...)
{
  va_list ap;

  if(!registered)
    eregister("","");
  if(esend_mode) {
    switch(status) {
    case MCAST_WARNING:
    case MCAST_ERROR:
    case MCAST_FATAL:
      buf_send->code = status;
      break;
    default:
      buf_send->code = MCAST_UNKNOWN;
      break;
    }
    buf_send->n++;
    buf_send->id = ecompress(id);
    sprintf((char*)buf_send+sizeof(MCAST_HEADER),"%s: ",id);
    if((fmt != NULL) && strlen(fmt)) {
      va_start(ap,fmt);
      vsprintf((char*)buf_send+sizeof(MCAST_HEADER)+strlen(id)+2,fmt,ap);
      va_end(ap);
    }
    else
      *((char*)buf_send+sizeof(MCAST_HEADER)+strlen(id)) = '\0';
    *((char*)buf_send+MCAST_BUFFER_SIZE-1) = '\0';
    if(esend_mode & 1)
      write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER)+
	    strlen((char*)buf_send+sizeof(MCAST_HEADER))+1);
    if(esend_mode & 2) {
      switch(buf_send->code) {
      case MCAST_UNKNOWN:
	fprintf(stderr,"UNKNOWN: ");
	break;
      case MCAST_WARNING:
	fprintf(stderr,"WARNING: ");
	break;
      case MCAST_ERROR:
	fprintf(stderr,"ERROR: ");
	break;
      case MCAST_FATAL:
	fprintf(stderr,"FATAL: ");
	break;
      }
      fprintf(stderr,"%s: %s\n",buf_send->name,(char*)buf_send+sizeof(MCAST_HEADER));
    }
  }
}

void esend_color(int code,const char *id)
{
  switch(code) {
  case MCAST_RED:
  case MCAST_YELLOW:
  case MCAST_GREEN:
  case MCAST_REMOVE:
    buf_send->code = code;
    buf_send->n++;
    buf_send->id = ecompress(id);
    write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
  }
}

void esend_color_id(int code,int id)
{
  switch(code) {
  case MCAST_RED:
  case MCAST_YELLOW:
  case MCAST_GREEN:
  case MCAST_REMOVE:
    buf_send->code = code;
    buf_send->n++;
    buf_send->id = id;
    write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
  }
}

void esend_color12(int code)
{
  switch(code) {
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
    buf_send->code = code;
    buf_send->n++;
    write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
  }
}

void esend_query(void)
{
  buf_send->code = MCAST_QUERY;
  buf_send->n++;
  write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
}

void esend_relay(int ip_address)
{
  buf_send->code = MCAST_RELAY;
  buf_send->n++;
  buf_send->id = ip_address;
  write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
}

void esend_relay_quit(int ip_address)
{
  buf_send->code = MCAST_RELAY_QUIT;
  buf_send->n++;
  buf_send->id = ip_address;
  write(multi_sock_wr,buf_send,sizeof(MCAST_HEADER));
}

int ereceive(void)
/*>0 - length of received message, 0 - nothing in the queue*/
{
  static int ret,i;
  static int last[20][3];	/* pid,computer,n of 20 last messages*/
                                /* Don't ask me why it's 20 */
  static int oldest;		/* The oldest one among these 20 */

  if(!registered_get)
    eregister_get();

  do {
    ret = (int)read(multi_sock_rd,buf_rcv,MCAST_BUFFER_SIZE);
    if((ret==0) || ((ret<0) && ((errno == EWOULDBLOCK) || (errno == EAGAIN))))
      return(0);		      	/*Nothing in the queue*/
    if((ret >= sizeof(MCAST_HEADER)) && 
       !strncmp(buf_rcv->magic,"E852",4)) {  /*Looks like right message*/
      for(i=0; i<20; i++)
	if((last[i][0] == buf_rcv->pid) && (last[i][1] == buf_rcv->computer)
	   && (last[i][2] == buf_rcv->n))
	  break;			/*We have got this message already*/
      if(i == 20) {			/*New message*/
	last[oldest][0] = buf_rcv->pid;
	last[oldest][1] = buf_rcv->computer;
	last[oldest][2] = buf_rcv->n;
	oldest++;
	if(oldest >= 20)
	  oldest = 0;
	return(ret);
      }
    }
  } while(ret);
  return(ret);
}

void esend_setmode(int mode)
/* 0 - don't send and don't print, 1 - send only, 2 - print only, 3 - send and print*/ 
{
  if((mode >= 0) && (mode <=3))
    esend_mode = mode;
}

#else

void eregister(const char *name,const char *subset)
{
}

void esend(int status,const char *id,const char *fmt,...)
{
}

void esendp(int status,const char *id,const char *fmt,...)
{
}

void esend_setmode(int mode)
{
}

#endif

/* end file */
