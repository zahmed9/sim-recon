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

typedef struct {
  float c_low; /* charged angle cut in theta*/
  float p_high; /* gamma angle cut in theta (high side)*/
  float p_low; /* gamma angle cut in theta (low side)*/
  int resoloution; /* Distort 4-vectors by resoloution */
} cuts_t;

void PrintUsage(char *processName);
int ProcessEvent(itape_header_t *event, cuts_t cuts);
int GetData(FILE *finput, itape_header_t *buffer);
void print_particle(FILE *fp, esr_particle_t p);
void distort_npart(esr_nparticle_t *esr);
int angular_acceptance(esr_nparticle_t *esr, cuts_t cuts);
void v4_to_arr(vector4_t vec, float arr[4]);
vector4_t arr2v4(float arr[4])l


int debug = 0;

void PrintUsage(char *processName)
{
  fprintf(stderr,"Usage: %s [-M] file1 [file2] etc....\n\n",processName);
  fprintf(stderr,"  Options:\n");
  fprintf(stderr,"\t-o<outfile>\tOutput file name def: stdout\n");
  fprintf(stderr,"\t-M[#]\t\tProcess only # number of events\n");
  fprintf(stderr,"\t-t[#]\t\tcharged theta cut in degrees\n");
  fprintf(stderr,"\t-p[l,h]\t\tneutral theta cut in degrees\n");
  fprintf(stderr,"\t   l[#]\t\t- low angle gamma cut\n");
  fprintf(stderr,"\t   h[#]\t\t- high angle gamma cut\n");
  fprintf(stderr,"\t-R\t\tDistort 4-vectors by Resoloution\n");
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
  cuts_t cuts;
  int nwrite = 0;
  
  cuts.p_low = cuts.c_low = 0.0;
  cuts.p_high = 180.0;
  cuts.resoloution = 0;

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
	cuts.c_low = atof(++argptr);
	break;
      case 'p':
	switch(*(++argptr)){
	case 'l':
	  cuts.p_low = atof(++argptr);
	  fprintf(stderr, "low angle gamma cut of %f deg\n", cuts.p_low);
	  break;
	case 'h':
	  cuts.p_high = atof(++argptr);
	  fprintf(stderr, "high angle gamma cut of %f deg\n", cuts.p_high);
	  break;
	default:
	  PrintUsage(argv[0]);
	  break;
	}
	break;
      case 'R':
	cuts.reloution = 1;
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
	  if(ProcessEvent(event, cuts)){
	    data_write(fileno(fpOUT), event); /*NO ERROR CHECKING AT THE MOMENT...*/
	    nwrite++;
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
  
  fprintf(stderr, "Number of events read: %d, written: %d, %f accepted\n", nevents, nwrite, nwrite/(float)nevents);
  data_flush(fileno(fpOUT));
  fclose(fpOUT);
}


int ProcessEvent(itape_header_t *event, cuts_t cuts){
  esr_nparticle_t *esr = data_getGroup(event, GROUP_ESR_NPARTICLE_MC);
  int i;

  if (!esr) esr = data_getGroup(event, GROUP_ESR_NPARTICLE); 
  
  if (esr){
    vector4_t sum = {0,0,0,0};
    if (debug) fprintf(stderr, "next event\n");
    if (!(angular_acceptance(esr, cuts))) return 0;
    if (cuts.resoution) distort_npart(esr);
    return 1;
  }
  return 0;
}


/* returns 1 if all particles pass angle cuts 0 if any one fails*/
int angular_acceptance(esr_nparticle_t *esr, cuts_t cuts){
  int i;
  
  for (i = 0; i < esr->nparticles; i++){
    float theta, phi;
    v3dir(esr->p[i].p.space, &theta, &phi);
    switch (abs(esr->p[i].particleType)){
    case Gamma:
      if (theta*RAD2DEG > cuts.p_high) return 0;	
      if (theta*RAD2DEG < cuts.p_low ) return 0;	
      break;
    case PiPlus:
    case PiMinus:
    case KPlus:
    case KMinus:
      if(debug) fprintf(stderr, "theta: %f, theta_deg: %f, theta_cut: %f\n", theta, theta*RAD2DEG, cuts.c_low);
      if ( theta*RAD2DEG < cuts.c_low ) return 0;
      break;
    case Neutron:
    case Proton:
      break;
    default:
      fprintf(stderr, "ERROR unknown particle type: %d\n",esr->p[i].particleType);
      break;
    }
    
  }
  return 1;
}

void distort_npart(esr_nparticle_t *esr){
  if (esr){
    esr->beam = newbeam(esr->beam);
    for (i=0; i < esr->nparticles; i++){
      switch(abs(esr->p[i].particleType)){
      case Gamma:
	esr->p[i].p = newgamma(esr->p[i].p);
	break;
      case PiPlus:
      case PiMinus:
      case KPlus:
      case KMinus:	
	esr->p[i].p = newcharged(esr->p[i].p);
	break;
      }
    }
  }
  
}


vector4_t newcharged(vector4_t charged){
  float arr[4];
  v4_to_arr(charged, arr);
  newcharged_(arr);
  return (arr2v4(arr));
}

vector4_t newbeam(vector4_t beam){
  float arr[4];
  v4_to_arr(beam, arr);
  newbeam_(arr);
  return (arr2v4(arr));
}

void v4_to_arr(vector4_t vec, float arr[4]){
  float arr[4];
  arr[0] = beam.space.x; arr[1] = beam.space.y; arr[2] = beam.space.z;
  arr[3] = beam.t;
}

vector4_t arr2v4(float arr[4]){
  vector4_t vec;
  vec.t = arr[3];
  vec.space.x = arr[0]; vec.space.y = arr[1]; vec.space.z = arr[2];
  return vec;
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

