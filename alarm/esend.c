#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include "alarm.h"

main()
{
  int i;

  eregister("esend","test");
  esend_setmode(1);
  srand((unsigned int)time(NULL));
  i = 0;

  while(1) {
    sleep(1);
    i++;
    switch(rand() % MCAST_RELAY) {
    case MCAST_UNKNOWN:
      printf("%3d: Sending Unknown...\n",i);
      esend(ALARM_UNKNOWN,"Test Message","message # %d",i);
      break;
    case MCAST_WARNING:
      printf("%3d: Sending Warning...\n",i);
      esend(ALARM_WARNING,"Test Message","message # %d",i);
      break;
    case MCAST_ERROR:  
      printf("%3d: Sending Error...\n",i);
      esend(ALARM_ERROR,"Test Message","message # %d",i);
      break;
    case MCAST_FATAL:  
      printf("%3d: Sending Fatal...\n",i);
      esend(ALARM_FATAL,"Test Message","message # %d",i);
      break;
    case MCAST_AUDIO:
      printf("%3d: Sending Audio...\n",i);
      esay(i,20);
      break;
    case MCAST_RED:    
      printf("%3d: Sending Red...\n",i);
      esend_color(MCAST_RED,"Test Message");
      break;
    case MCAST_YELLOW: 
      printf("%3d: Sending Yellow...\n",i);
      esend_color(MCAST_YELLOW,"Test Message");
      break;
    case MCAST_GREEN:  
      printf("%3d: Sending Green...\n",i);
      esend_color(MCAST_GREEN,"Test Message");
      break;
    case MCAST_REMOVE: 
      printf("%3d: Sending Remove...\n",i);
      esend_color(MCAST_REMOVE,"Test Message");
      break;
    case MCAST_RED1:   
      printf("%3d: Sending own Red...\n",i);
      esend_color12(MCAST_RED1);
      break;
    case MCAST_YELLOW1:
      printf("%3d: Sending own Yellow...\n",i);
      esend_color12(MCAST_YELLOW1);
      break;
    case MCAST_GREEN1: 
      printf("%3d: Sending own Green...\n",i);
      esend_color12(MCAST_GREEN1);
      break;
    case MCAST_GR_YEL1: 
      printf("%3d: Sending own Gr->Yel...\n",i);
      esend_color12(MCAST_GR_YEL1);
      break;
    case MCAST_REMOVE1:
      printf("%3d: Sending own Remove...\n",i);
      esend_color12(MCAST_REMOVE1);
      break;
    case MCAST_RED2:   
      printf("%3d: Sending global Red...\n",i);
      esend_color12(MCAST_RED2);
      break;
    case MCAST_YELLOW2:
      printf("%3d: Sending global Yellow...\n",i);
      esend_color12(MCAST_YELLOW2);
      break;
    case MCAST_GREEN2: 
      printf("%3d: Sending global Green...\n",i);
      esend_color12(MCAST_GREEN2);
      break;
    case MCAST_GR_YEL2: 
      printf("%3d: Sending global Gr->Yel...\n",i);
      esend_color12(MCAST_GR_YEL2);
      break;
    case MCAST_REMOVE2:
      printf("%3d: Sending global Remove...\n",i);
      esend_color12(MCAST_REMOVE2);
      break;
    case MCAST_QUERY:  
      printf("%3d: Sending Query...\n",i);
      esend_query();
      break;
    }
  }
}
