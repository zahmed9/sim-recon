/*
 * alarmRelay.c  --- interchange alarm messages between computers
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <bstring.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <net/soioctl.h>
#include <sys/syssgi.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <time.h>
#include <sys/time.h>
#include <errno.h>
extern int errno;

#include "alarm.h"


#define MAX_RELAY 10
#define TIMEOUT 2

static MCAST_HEADER *buf_rcv,*buf_send;
static int multi_sock_rd,multi_sock_wr;
static int thisComputer;
static int relay_sock_rd,relay_sock_wr;
static struct sockaddr_in to[MAX_RELAY];
static int partners;
static char buf_read[3000],buf_write[3000];
static int in_write;
static time_t lastSend;

void readIt(void)
{
  int len,i;
  char *c;
  MCAST_HEADER h;
  struct sockaddr from;
  int fromlen;

  fromlen = sizeof(from);
  len = recvfrom(relay_sock_rd,(void*)buf_read,3000,0,&from,&fromlen);
  c = buf_read;
  while(len >= (int)sizeof(MCAST_HEADER)) {
    memcpy((void*)&h,c,sizeof(MCAST_HEADER));
    switch(h.code) {
    case MCAST_UNKNOWN:
    case MCAST_WARNING:
    case MCAST_ERROR:
    case MCAST_FATAL:
      i = sizeof(MCAST_HEADER) + strlen(c+sizeof(MCAST_HEADER)) + 1;
      break;
    default:
      i = sizeof(MCAST_HEADER);
    }
    if(h.computer != thisComputer && !strncmp(h.magic,"E852",4))
      write(multi_sock_wr,c,i);
    c += i;
    len -= i;
  }
}

void sendIt(void)
{
  int i,tolen;

  if(in_write && partners)
    for(i=0; i<partners; i++)
      sendto(relay_sock_wr,buf_write,in_write,0,(struct sockaddr *)&to[i],sizeof(to[i]));
  in_write = 0;
  lastSend = time(NULL);
}

void main(int argc,char *argv[])
{
  struct sockaddr_in from;
  int i, j, ours;
  unsigned int ourIP[10];
  struct hostent *hp;
  struct ifconf ifc;
  char **cp;
  int s,nfds;
  fd_set fdset;
  struct timeval timeout = { TIMEOUT,0 };

  setbuf(stdout,NULL);
  setbuf(stderr,NULL);

  if(argc > 1 && argv[1][0] == '-') {
    fprintf(stderr,"The purpose of this program is to interchange alarm messages\n");
    fprintf(stderr,"between different computers. Usage:\n");
    fprintf(stderr,"\talarmRelay [IPname1] [IPname2] ...,\n");
    fprintf(stderr,"where IPname - computer(s) where partner alarmRelay is running.\n");
    fprintf(stderr,"If none is specified then host list from /home/lemond/e852/alarmHelp/.alarmRelay is used\n");
    exit(1);
  }
  if(argc-1 > MAX_RELAY) {
    fprintf(stderr,"alarmRelay: Only %i hosts are allowed\n",MAX_RELAY);
    exit(1);
  }

  sprintf(buf_read,"ps -e | grep -v %u | egrep -s ' alarmRel$'",getpid());
  if(system(buf_read) == 0) {
    fprintf(stderr,"alarmRelay is running already.\n");
    exit(0);
  }

  if((s = socket(AF_INET,SOCK_DGRAM,0)) < 0) {
    perror("alarmRelay: creating socket");
    exit(1);
  }
  ours = 0;
  ifc.ifc_len = sizeof(buf_read);
  ifc.ifc_buf = buf_read;
  if(ioctl(s, SIOCGIFCONF, (char*)&ifc) >= 0) {
    struct ifreq *ifr;
    int n;
    long *c;
    ifr = ifc.ifc_req;
    for(n=ifc.ifc_len/sizeof(struct ifreq); --n>=0; ifr++) {
      if(ifr->ifr_addr.sa_family == AF_INET) {
	c = (long *)(ifr->ifr_addr.sa_data + 2);
	ourIP[ours++] = (unsigned int)htonl(*c);
      }
    }
  }
  close(s);
  if(ours == 0) {
    fprintf(stderr,"alarmRealy: no IP interfaces was found on this host. Exiting...\n");
    exit(1);
  }

  partners = 0;
  if(argc > 1) {
    for(i=0; i<argc-1; i++) {
      bzero(&to[partners],sizeof(struct sockaddr_in));
      to[partners].sin_family = AF_INET;
      to[partners].sin_port = MCAST_RELAY_PORT;
      if((to[partners].sin_addr.s_addr = inet_addr(argv[i+1])) == -1) {
	if((hp = gethostbyname(argv[i+1])) == NULL) {
	  fprintf(stderr,"alarmRelay: unknown host %s - skipping it...\n",argv[i+1]);
	  continue;
	}
	cp = hp->h_addr_list;
	memcpy((char*)&to[partners].sin_addr,*cp,hp->h_length);
      }
      for(j=0; j<ours; j++)
	if(to[partners].sin_addr.s_addr == ourIP[j])
	  break;
      if(j == ours)
	partners++;
    }
  }
  else {
    FILE *f;
    static char rlist[] = "/home/lemond/e852/alarmHelp/.alarmRelay";

    if((f = fopen(rlist,"r")) == NULL) {
      fprintf(stderr,"alarmRelay: Can't open file %s. Exiting...\n",rlist);
      exit(1);
    }
    while(fgets(buf_read,100,f)) {
      if((j = strlen(buf_read)) == 0)
	continue;
      if(buf_read[j-1] == '\n')
	buf_read[j-1] = '\0';
      bzero(&to[partners],sizeof(struct sockaddr_in));
      to[partners].sin_family = AF_INET;
      to[partners].sin_port = MCAST_RELAY_PORT;
      if((to[partners].sin_addr.s_addr = inet_addr(buf_read)) == -1) {
	if((hp = gethostbyname(buf_read)) == NULL) {
	  fprintf(stderr,"alarmRelay: unknown host %s - skipping it...\n",buf_read);
	  continue;
	}
	cp = hp->h_addr_list;
	memcpy((char*)&to[partners].sin_addr,*cp,hp->h_length);
      }
      for(j=0; j<ours; j++)
	if(to[partners].sin_addr.s_addr == ourIP[j])
	  break;
      if(j == ours)
	partners++;
      if(partners >= MAX_RELAY)
	break;
    }
    fclose(f);
  }
  if(partners == 0) {
    fprintf(stderr,"alarmRelay: no alarmRelay partners on remote hosts were specified. Exiting...\n");
    exit(1);
  }
  fprintf(stderr,"alarmRelay: exchanging messages with %i remote hosts.\n",partners);

  eregister("alarmRelay","");
  eregister_get();
  esend_setmode(0);
  eget_internals(&multi_sock_rd,&multi_sock_wr,&buf_rcv,&buf_send);
  thisComputer = buf_send->computer;

  if((relay_sock_rd = socket(AF_INET,SOCK_DGRAM,0)) < 0) {
    perror("alarmRelay: creating relay socket");
    exit(1);
  }
  bzero(&from,sizeof(from));
  from.sin_family = AF_INET;
  from.sin_addr.s_addr = htonl(INADDR_ANY);
  from.sin_port = htons(MCAST_RELAY_PORT);
  if(bind(relay_sock_rd,&from,sizeof(from)) < 0) {
    perror("alarmRelay: binding relay socket");
    exit(1);
  }
  if((relay_sock_wr = dup(relay_sock_rd)) < 0) {
    perror("alarmRelay: duplicating relay socket");
    exit(1);
  }

  _daemonize(_DF_NOCHDIR | _DF_NOCLOSE,-1,-1,-1);


  in_write = 0;
  while(1) {
    FD_ZERO(&fdset);
    FD_SET(multi_sock_rd,&fdset);
    FD_SET(relay_sock_rd,&fdset);
    nfds = multi_sock_rd;
    if(relay_sock_rd > nfds)
      nfds = relay_sock_rd;
    nfds++;
    timeout.tv_sec = TIMEOUT;
    s = select(nfds,&fdset,NULL,NULL,&timeout);
    if(in_write)
      if(difftime(time(NULL),lastSend) > (TIMEOUT+1))
	sendIt();
    if(s == 0) {
      if(in_write)
	sendIt();
    }
    else if(s > 0) {
      if(FD_ISSET(multi_sock_rd,&fdset)) {
	if((s = ereceive()) > 0)
	  if(buf_rcv->computer == thisComputer) {
	    memcpy(buf_write+in_write,(char*)buf_rcv,s);
	    in_write += s;
	  }
      }
      if(FD_ISSET(relay_sock_rd,&fdset))
	readIt();
      if(in_write > 1000)
	sendIt();
    }
  }
}
