/************************************************
 * usr_init.c 
 * This routine is called from mcfast to
 * perform initializations .
 * Paul Eugenio
 * Carnegie Mellon University
 * 28 Sept 98
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<string.h>
#define MAX_NTP_VARS 20


void hbookn_(int *, char *, int *, char *, int *, char [128][8],int , int, int);

/*
 * Map the mcp_hbook1 FORTRAN common block
 * to a C data structure
 */
struct mcp_hbook_t{
  char hbk_file[150];
  char hbk_topdir[150];
};

extern struct mcp_hbook_t mcp_hbook1_;

void usr_init_(void)
{
  int i,nChan=100,iD=10,hb_nt=1,n_vars=0,ic_1000=1000,len;
  float xMin=-0.05,xMax=0.05,zero=0.0;
  auto char ntp_names[MAX_NTP_VARS][8];

  fprintf(stderr,"Initializing Hbook items.\n");

  hbook1_(&iD,"Delta Px",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
 
  hbook1_(&iD,"Delta Py",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
  
  hbook1_(&iD,"Delta Pz",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);
 
  hbook1_(&iD,"Delta E",&nChan,&xMin,&xMax,&zero,8);
  fprintf(stderr,"Booking histogram id: %d\n",iD++);

  /*
   * Name the Ntuple variables (Must be 8 char exactly)
   */
  n_vars=0;
  strcpy(ntp_names[n_vars++],"gen.E   ");
  strcat(ntp_names[n_vars++],"gen.px  ");
  strcat(ntp_names[n_vars++],"gen.py  ");
  strcat(ntp_names[n_vars++],"gen.pz  ");
  strcat(ntp_names[n_vars++],"gen.pt  ");
  /*  strcat(ntp_names[n_vars++],"gen.cos ");*/
  /* strcat(ntp_names[n_vars++],"gen.rapy"); */
  strcat(ntp_names[n_vars++],"smr.E   ");
  strcat(ntp_names[n_vars++],"smr.px  ");
  strcat(ntp_names[n_vars++],"smr.py  ");
  strcat(ntp_names[n_vars++],"smr.pz  ");
  strcat(ntp_names[n_vars++],"smr.pt  ");
  /* strcat(ntp_names[n_vars++],"smr.cos "); */
  /* strcat(ntp_names[n_vars++],"smr.rapy"); */ 



  if(n_vars>MAX_NTP_VARS){
    fprintf(stderr,"Error: usr_init.c n_vars > MAX_NTP_VARS\n");
    exit(-1);
  }
  /*
   * Book the Ntuple
   */
  len=strlen(mcp_hbook1_.hbk_topdir);
  fprintf(stderr,"hbk_topdir: %s  len(hbk_topdir): %d\n",
	  mcp_hbook1_.hbk_topdir,len);
  hbookn_(&hb_nt, "mcfasted",&n_vars,mcp_hbook1_.hbk_topdir,&ic_1000, 
                    ntp_names,8,len,8);
  fprintf(stderr,"Booking ntuple id: %d\n",hb_nt);
 
  hcdir_("//PAWC"," ",6,1);
   
}
