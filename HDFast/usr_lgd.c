/************************************************
 * usr_lgd.c 
 * This routine is called from usr_analysis.c 
 * to create smeared LDG gammas.
 *
 * Currently only the gamma energy is smeared.
 * This means that there is no smearing of the 
 * position. A full treatment should use the 
 * the e852 shower library and clusterizer.(future plans) 
 * 
 * MCFast seems to fail on forward calorimeters (the older
 * mcfast code) and forward calorimetry is not yet
 * implemented in the new calorimetry code)
 *
 * usr_lgd() allocates memory for lgd_smearedparts_t *lgdparts
 * so remember to free the memory later!!
 *
 * Paul Eugenio
 * Carnegie Mellon University
 * 27 JAN 1999
 **********************************************/

#include<stdio.h>
#include <stdlib.h>
#include<math.h>

#include<stdhep_alloc.h>
#include<stdlun.h>
#include<stdcnt.h>
#include<offline_track.h>
#include<trace.h>
#include<tof.h>
#include<cal_hit.h>
#include<usr_lgd.h>

/* PDG numbering scheme see PDG Review of Particle Physics */
#define PDG_GAMMA 22
#define LGD_X_LIMIT 86.0
#define LGD_Y_LIMIT 86.0
#define LGD_BEAMHOLE 8.0
#define LGD_Z_LOCATION  575.0 // zcenter - zlength/2 from the HDFast.db file


struct hepGamma_t{
  int index;
  int isaBCALgamma;
  double phep[3];
};

int isaBCALgamma(int );

int usr_lgd(void){  
  /*
   * This function must be called
   *  after calling the mcfast
   * tracking routines.
   */
  int i,j,k;
  struct hepGamma_t hepGamma[20];
  double p[3],cos_theta,x,y,z,vx,vy,vz;
  int nHepGammas=0,nBCALgammas=0;
  int smearedGammaIndex[20],nSmearedGammas=0;
  int foundAll,isaBCALgam;
  lgd_smearedpart_t part[20];
  extern int Debug;
  extern lgd_smearedparts_t *LgdParts;

  for(i=0;i< hepevt_.nhep;i++)
    if(hepevt_.idhep[i] == PDG_GAMMA){
      hepGamma[nHepGammas].index=i+1;
      hepGamma[nHepGammas].isaBCALgamma=
	isaBCALgamma(hepGamma[nHepGammas].index);
      for(j=0;j<3;j++){/* get  the momentum */
	hepGamma[nHepGammas].phep[j]=hepevt_.phep[i][j];/* px,py,pz*/
	p[j]=hepevt_.phep[i][j];/* copy momenta */
      }
      isaBCALgam = hepGamma[nHepGammas++].isaBCALgamma;
      cos_theta = p[2]/sqrt( p[0]*p[0] + p[1]*p[1] + p[2]*p[2] );
      nBCALgammas += isaBCALgam;
      if(cos_theta >0.707 && !isaBCALgam ){/* It's at least going forward (0.707=45deg), and it was not detected in the BCAL. */
	/*
	 * Find x and y at the lgd face.
	 *
	 *
	 * If there are charged particles
	 * assume their production is
	 * the same for the gammas; else
	 * use center-of-target(x,y,z)= (0,0,50) cm
	 */ 
	if(trk_off_c_.trk_off_num){ /* 
				    * vhep[part#][x,y,z,t]
				    * HEPEVT units are in mm and not cm 
				    */
	  vx=hepevt_.vhep[i][0]/10.0;
	  vy=hepevt_.vhep[i][1]/10.0;
	  vz=hepevt_.vhep[i][2]/10.0;
	}
	else{/* All neutrals use target center for production vertex */
	  vx=0.0;
	  vy=0.0;
	  vz=50.0;/* target center */
	}
	/*
	 * Get the triangular lengths.
	 */
	z =  LGD_Z_LOCATION - vz;/* lgd_z - production_z */
	x = z*p[0]/p[2];/* px/pz should equal x/z */
	y = z*p[1]/p[2];
	if(Debug==5)
	  fprintf(stderr,"Gamma trace2lgd (x,y,z): (%f,%f,%f)\n",x,y,z);
	if((x+vx)*(x+vx) <  LGD_X_LIMIT*LGD_X_LIMIT && 
	   (y+vy)*(y+vy) <  LGD_Y_LIMIT*LGD_Y_LIMIT && 
	   ((x+vx)*(x+vx) > LGD_BEAMHOLE*LGD_BEAMHOLE || 
	   (y+vy)*(y+vy) > LGD_BEAMHOLE*LGD_BEAMHOLE) ){
	  
	  
	  smearLGDgamma(p);
	  smearedGammaIndex[nSmearedGammas] = i+1;
	  /* make local lgd structure */
	  part[nSmearedGammas].hepIndex= i+1;
	  part[nSmearedGammas].type =1;
	  part[nSmearedGammas].xlocal = x;
	  part[nSmearedGammas].ylocal = y;
	  part[nSmearedGammas].px = p[0];
	  part[nSmearedGammas].py = p[1];
	  part[nSmearedGammas].pz = p[2];
	  part[nSmearedGammas].vx = vx;
	  part[nSmearedGammas].vy = vy;
	  part[nSmearedGammas++].vz = vz;
	}
      }
    }
  /*
   * Make lgd_smearedparts_t 
   */
  LgdParts = malloc(sizeof(lgd_smearedparts_t)+
		    sizeof(lgd_smearedpart_t)*(nSmearedGammas));
  LgdParts->nparts = nSmearedGammas;
 
  
  for(i=0;i<nSmearedGammas;i++){
    LgdParts->part[i].hepIndex = part[i].hepIndex;
    LgdParts->part[i].type =  part[i].type;
    LgdParts->part[i].xlocal= part[i].xlocal;
    LgdParts->part[i].ylocal= part[i].ylocal;
    LgdParts->part[i].px= part[i].px;
    LgdParts->part[i].py= part[i].py;
    LgdParts->part[i].pz= part[i].pz;
    LgdParts->part[i].vx= part[i].vx;
    LgdParts->part[i].vy= part[i].vy;
    LgdParts->part[i].vz= part[i].vz;
  }

  /*
   * Now check if all gammas where detected
   */ 

  if(Debug==5){  
    fprintf(stderr,"nHepGammas: %d \n",nHepGammas);
    for(i=0;i<nHepGammas;i++){
      fprintf(stderr,"\thepGamma[%d].index: %d ",i,hepGamma[i].index);
      fprintf(stderr,"\thepGamma[%d].phep (px,py,pz): %lf %lf %lf\n",
	      i,hepGamma[i].phep[0],hepGamma[i].phep[1],hepGamma[i].phep[2]);
    }    
    fprintf(stderr,"nSmearedGammas: %d ",nSmearedGammas);
    fprintf(stderr,"nBCALgammas: %d \n",nBCALgammas);
    for(i=0;i<nSmearedGammas;i++)
      fprintf(stderr,"smearedGammaIndex[%d]: %d ",i,smearedGammaIndex[i]);
    fprintf(stderr,"\n");
  }
  foundAll=0;
  if(nHepGammas == nBCALgammas + nSmearedGammas)
    foundAll=1;

  return foundAll;
}

void smearLGDgamma(double *p){
/*
 * This comes directly from the LGD NIM paper, p. 390:
 *   "A 3000 Element Lead Glass Electromagnetic Calorimeter"
 *   Nucl. Instrum. Methods A387 (1997) 377-394.
 *
 * Energy resolution = 6%sqrt(E) + 2%E
 *
 * The above equation is then multiplied by a factor (LgdRes) to
 * make the squaw CL distributions more realistic. The LGD errors               
 * are underestimated unless a factor of about 2.36 is used.
 *
 */
  int i;
  double e,eSigma,eSmear,eSmeared;
  const double LgdRes=2.36;

  e = sqrt(p[0]*p[0] + p[1]*p[1] + p[2]*p[2]);
  /* Use
   * eSigma = LgdRes*(0.06*sqrt(e)+0.02*e);
   * with the GEANT showers library otherwise use
   */
  eSigma = (0.06*sqrt(e)+0.02*e);
  eSmear=Gauss(0,eSigma);
  eSmeared = e+eSmear;
  for(i=0;i<3;i++)
    p[i] *= eSmeared/e;
}

double Gauss(double mean,double sigma){
  /*
   * This gaussian is lifted from ROOT's TRandom::Gauss() see:
   * http://root.cern.ch/root/html/src/TRandom.cxx.html#TRandom:Gaus .
   *
   * The random number generator was seeded in usr_main.cxx
   * using srand48(long now = time(NULL)))
   */

  double x,y,z,result;
  y=drand48();
  if(!y) y = drand48();/* what are the chances of two 0's in a row...*/
  z=drand48();
  x=z*6.283185;
  result = mean+sigma*sin(x)*sqrt(-2.0*log(y));

  return result;
}
