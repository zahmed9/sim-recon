#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "alarm.h"

#define MAX_MSG 10000		/*maximum contents of catalog*/
#define MIN_TIME 20		/*don't repeat same message too frequently*/

int mc = 0,m[MAX_MSG];		/*messages' ids*/
time_t mt[MAX_MSG];		/*last time said*/

char audio_dir[] = "/usr/people/e852/audio";
char audio_sfx[] = ".aifc";

char com[200];
MCAST_HEADER *buf_rcv,*buf_send;
int multi_sock_rd,multi_sock_wr;

void main(void)
{
  int msg,limit;
  int ret,i;
  FILE *tmp;

  _daemonize(0,-1,-1,-1);
  sprintf(com,"ps -e | grep -v %u | egrep -s ' e852audiod$'",getpid());
  if(system(com) == 0)
    exit(1);		/*Another e852audio daemon is running now*/
  if(chdir(audio_dir) != 0)	/*Can't cd to proper directory*/
    exit(1);
  sprintf(com,"/bin/ls *%s >/tmp/e852audiotmp",audio_sfx);
  if(system(com))
    exit(1);		/*Can't scan this directory*/
  if((tmp=fopen("/tmp/e852audiotmp","r")) == NULL)
    exit(1);
  mc = 0;
  while(fgets(com,199,tmp) != NULL) {
    if(mc >= MAX_MSG)
      break;
    if(strchr(com,'\n') != 0)
      *strchr(com,'\n') = '\0';
    if(strcmp(com+strspn(com,"0123456789"),audio_sfx) != 0)
      continue;
    *(com+strspn(com,"0123456789")) = '\0';
    m[mc] = atoi(com);
    mt[mc++] = 0;
  }
  fclose(tmp);
  unlink("/tmp/e852audiotmp");
  if(mc <= 0)
    exit(1);		/*Nothing to say*/
  /*The list of possible messages is ready. Now go into loop*/
  eregister_get();
  eget_internals(&multi_sock_rd,&multi_sock_wr,&buf_rcv,&buf_send);
  while(1) {
    sginap(10);
    ret = ereceive();
    if((ret > 0) && (buf_rcv->code == MCAST_AUDIO)) {
      msg = buf_rcv->id &0xFFFF;
      limit = buf_rcv->id >>16;
      for(i=0; i<mc; i++)
	if(msg == m[i])
	  break;
      if(i == mc)
	continue;		/*unavailable message*/
      if(limit < MIN_TIME)
	limit = MIN_TIME;
      if(time(NULL) - mt[i] <= limit)
	continue;		/*this message was recently*/
      sprintf(com,"/usr/sbin/sfplay %i%s",m[i],audio_sfx);
      system(com);
      mt[i] = time(NULL);	/*set time of last play*/
    }
  }
}
