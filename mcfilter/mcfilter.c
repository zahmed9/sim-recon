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

void PrintUsage(char *processName);
int ProcessEvent(itape_header_t *event, float theta_cut);
int GetData(FILE *finput, itape_header_t *buffer);
void print_particle(FILE *fp, esr_particle_t p);

int debug = 0;

void PrintUsage(char *processName)
{
  fprintf(stderr,"Usage: %s [-M] file1 [file2] etc....\n\n",processName);
  fprintf(stderr,"  Options:\n");
  fprintf(stderr,"\t-o<outfile>\tOutput file name def: stdout\n");
  fprintf(stderr,"\t-M[#]\t\tProcess only # number of events\n");
  fprintf(stderr,"\t-t[#]\t\ttheta cut in degrees\n");
  fprintf(stderr,"\t-d[#]\t\tdebug mode\n");
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
  int fileNoOUT;
  char *inFile=NULL;
  float theta_cut = 0.0;
  int debug;

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
      case 't':
	theta_cut = atof(++argptr);
	break;
      case 'o':
	outFile = ++argptr;
	fprintf(stderr, "writing to output file: %s\n", outFile);
	if(!(fpOUT=fopen(outFile,"w"))){
	  fprintf(stderr,"\nfail to open %s for writing...exiting\n",outFile);
	  exit(0);
	}
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

  /*
  if(!outFile) {
    fpOUT = stdout;
    fprintf(stderr, "writing to stdout\n");
  }*/

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
	  if(ProcessEvent(event, theta_cut)){
	    data_write(fileno(fpOUT), event); /*NO ERROR CHECKING AT THE MOMENT...*/
	  }
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
  
  data_flush(fileno(fpOUT));
  fclose(fpOUT);
}

#define RAD2DEG (180.0/3.14159)
int ProcessEvent(itape_header_t *event, float theta_cut){
  esr_nparticle_t *esr = NULL;
  int i;

  if (esr = data_getGroup(event, GROUP_ESR_NPARTICLE)){
    for (i = 0; i < esr->nparticles; i++){
      float theta, phi;
      
      v3dir(esr->p[i].p.space, &theta, &phi);
      if(debug) fprintf(stderr, "theta: %f, theta_deg: %f, theta_cut: %f\n", theta, theta*RAD2DEG, theta_cut);
      if (fabs(theta) < theta_cut) return 0;
    }
    return 1;
  }
  return 0;
}

void print_particle(FILE *fp, esr_particle_t p){
  fprintf(fp, "charge: %d\n", p.charge);
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

