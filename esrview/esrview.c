#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <math.h>
#include <kinematics.h>
#include <itypes.h>
#include <string.h>
#include <disData.h>
#include <dataIO.h>
#include <esr.h>

#define ITAPE_BUF_SIZE 100000
#define RAD2DEG (180.0/3.14159)

/*------------ PAW DEFINES ----------------- */
#define MEMH 250000
#define LREC 1024 /* record length of hbook direct access file in WORDS */
#define LUN 3 /* logical unit number of hbook file */
#define ID 99 /* column-wise-ntuple id */

/* declare the hbook common */
float pawc_[MEMH];
float hcfitd_[25];
int quest_[100];

void PrintUsage(char *processName);
int ProcessEvent(itape_header_t *event);
int GetData(FILE *finput, itape_header_t *buffer);
void hini(char *out);
void book_histos();

int debug = 0;

void PrintUsage(char *processName)
{
  fprintf(stderr,"Usage: %s [-M] file1 [file2] etc....\n\n",processName);
  fprintf(stderr,"  Options:\n");
  fprintf(stderr,"\t-o<outfile>\tOutput file name def: esrview.hb4\n");
  fprintf(stderr,"\t-M[#]\t\tProcess only # number of events\n");
  fprintf(stderr,"\t-d\t\tdebug mode\n");
  fprintf(stderr,"\t-h\t\tPrint this message.\n\n");
  exit(0);
}


void main(int argc, char *argv[])
{
  int i;
  char *argptr;
  itape_header_t *event=NULL;
  int nevents=0;
  int maxevents=0;
  int currentrun=0;
  int done=0;
  int failMax=0;
  char *outFile=NULL;
  FILE *fpOUT=NULL;
  char *inFile=NULL;
  int nwrite = 0;
  
  if(argc==1)PrintUsage(argv[0]);

  for(i=1;i<argc;i++){
    if(*argv[i] == '-'){
      argptr = argv[i];
      switch(*(++argptr)){
      case 'M':
	maxevents= atoi(++argptr);
	fprintf(stderr,"Process %d events\n",maxevents);
	break;
      case 'd':
	debug = 1;
	break;
      case 'o':
	outFile = ++argptr;
	hini(outFile);
	break;
      case 'h':
	PrintUsage(argv[0]);
	break;
      default:
	PrintUsage(argv[0]);
	break;
      }
      
      
    }
  }

  if(!outFile) {
    fpOUT = stdout;
    fprintf(stderr, "writing to stdout\n");
  }

  event=(itape_header_t*)malloc(ITAPE_BUF_SIZE);

  for(i = 1;i < argc; ++i){
    argptr = argv[i];
    if(*argptr != '-'){
      FILE *fpIN=NULL;
      inFile = argv[i];
      if(!(fpIN=fopen(inFile,"r"))){
	/* failed to open for reading */
	fprintf(stderr,"\nfail to open %s for reading...exiting\n",inFile);
	exit(0);
      }
      else{
	printf("reading data from: %s\n",inFile);
	/* do stuff */
	while( (maxevents ? maxevents>nevents:1) && (GetData(fpIN, event) )){
	  ProcessEvent(event);
	  if(!(++nevents % 100)){	  
	    fprintf(stderr,"%d\r",nevents);
	  }
	  data_clean(event);
	}
      }
      fclose(fpIN);
      fpIN=NULL;
    }
  }
  
  fprintf(stderr, "Number of events read: %d, written: %d, %f accepted\n", nevents, nwrite, nwrite/(float)nevents);
  data_flush(fileno(fpOUT));
  fclose(fpOUT);
}


int ProcessEvent(itape_header_t *event){
  esr_nparticle_t *esr = data_getGroup(event, GROUP_ESR_NPARTICLE_MC);
  vector4_t vzero = {0,0,0,0};
  int i;

  if (!esr) esr = data_getGroup(event, GROUP_ESR_NPARTICLE); 
  
  if (esr){
    if (debug) fprintf(stderr, "next event\n");
    for(i=0; i < esr->nparticles; i++){
      

    }
    return 1;
  }
  return 0;
}

int GetData(FILE *finput, itape_header_t *buffer)
{
  int ret = 0;
  int i;

  ret = data_read(fileno(finput),buffer,ITAPE_BUF_SIZE);
  if (ret<0){
    fprintf(stderr,"from_stdin: data_read() failed\n");
    return(0);
  }
  else if (ret == 0) {
    for (i=0; i < 10; i++){
      ret = data_read(fileno(finput),buffer,ITAPE_BUF_SIZE);
      if (ret == 1) return(1);
    }
  }
  if (ret == 2) return 0;
  if (ret>0){
    return 1;
  }
  return 0;
}

void hini(char *out)
{
  int lun = LUN, lrec = LREC, memh = MEMH;
  int istat;
  static char def_out[100];

  if(out == NULL) {
    sprintf(def_out,"esrview.hb4");
    out = &def_out[0];
    fprintf(stderr, "Output file name is: %s\n", out);
  }
  quest_[9] = 65000;
  hlimit_(&memh);
  hropen_(&lun, "esr", out , "N", &lrec, &istat, 3L, strlen(out), 1L);


  return;
}

void book_histos(){
  hbook1(1, "nesr", 10, -1.5, 8.5, 0);

}

int clean_up(){
  int icycle;

  hrout(0,icycle," ");
  hldir_(" ", " ", 1L, 1L); /* don't remove this line */
  hrend_("esr", 3L);

}
