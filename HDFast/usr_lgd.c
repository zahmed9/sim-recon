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
#define LGD_X_LIMIT 122.0
#define LGD_Y_LIMIT 66.0
#define LGD_BEAMHOLE 8.0

int usr_lgd(void){  
  /*
   * This function must be called
   *  after calling the mcfast
   * tracking routines.
   */
  int i,j,k;
  double p[3],phep[20][3],cos_theta,x,y,z,vx,vy,vz;
  int hepGammaIndex[20],nHepGammas=0;
  int smearedGammaIndex[20],nSmearedGammas=0;
  int foundAll,found,nphep,dumpGamma;
  lgd_smearedpart_t part[20];
  extern int Debug;
  extern lgd_smearedparts_t *LgdParts;

  for(i=0,nphep=0;i< hepevt_.nhep;i++)
    if(hepevt_.idhep[i] == PDG_GAMMA){
      hepGammaIndex[nHepGammas++]= i+1;
      for(j=0;j<3;j++)/* get  the momentum */
	p[j]=hepevt_.phep[i][j];/* px,py,pz*/
      
      cos_theta = p[2]/sqrt( p[0]*p[0] + p[1]*p[1] + p[2]*p[2] );
      for(j=0;j<3;j++)/* copy p for debugging */
	phep[nHepGammas -1][j]=p[j];
      
      if(cos_theta >0.707 ){/* It's at least going forward (0.707=45deg) */
	/*
	 * Find x and y at the lgd face.
	 *
	 *
	 * If there are charged particles
	 * assume their production is
	 * the same for the gammas; else
	 * use center-of-target(x,y,z)= (0,0,50) cm
	 */ 
	if(trk_off1_.trk_off_num){ z= 487.5 - hepevt_.vhep[0][2];/* vhep[part#][x,y,z,t]*/
	  vx=hepevt_.vhep[0][0];
	  vy=hepevt_.vhep[0][1];
	  vz=hepevt_.vhep[0][2];
	}
	else{
	  vx=0.0;
	  vy=0.0;
	  vz=487.5-50.0;/* lgd_z - target */
	}
	z =  487.5 - vz;/* lgd_z - production_z */
	x = vx - z*p[0]/p[2];
	y = vy - z*p[1]/p[2];
	if(x*x <  LGD_X_LIMIT*LGD_X_LIMIT && 
	   y*y <  LGD_Y_LIMIT*LGD_Y_LIMIT && 
	   x*x > LGD_BEAMHOLE*LGD_BEAMHOLE && 
	   y*y > LGD_BEAMHOLE*LGD_BEAMHOLE){
	  /*
	   * Reject gamma if it also hits the barrel calorimeter
	   */
	  for(j=0,dumpGamma=0;j<MCFNumHitCal[0];j++)/* loop over cal hits */
	    for(k=0;k<MCFCalHits[0][j]->n_tracks; k++) /* loop over hit info's */
	      if( i+1 ==  (MCFCalHits[0][j]->info_tr)->tr_num)
		dumpGamma=1;
	  if(!dumpGamma){
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
      fprintf(stderr,"\thepGammaIndex[%d]: %d ",i,hepGammaIndex[i]);
      fprintf(stderr,"\tphep[%d] (px,py,pz): %lf %lf %lf\n",
	      i,phep[i][0],phep[i][1],phep[i][2]);
    }
    
    
    fprintf(stderr,"nSmearedGammas: %d ",nSmearedGammas);
    fprintf(stderr,"nBCALhits: %d \n",MCFNumHitCal[0]);
    for(i=0;i<nSmearedGammas;i++)
      fprintf(stderr,"smearedGammaIndex[%d]: %d ",i,smearedGammaIndex[i]);
    fprintf(stderr,"\n");
  }  
  

  foundAll=1;
  for(i=0;i<nHepGammas ;i++){
    found=0;
    /* check if LGD detected the  Hep gamma*/
    for(j=0;j<nSmearedGammas;j++){ /* was the hep gamma found in the LGD? */
      if(hepGammaIndex[i]==smearedGammaIndex[j])
	found=1;
    }
    /* check if Barrel Calorimeter detected the Hep gamma*/
    for(j=0;j<MCFNumHitCal[0];j++)
      for(k=0;k<MCFCalHits[0][j]->n_tracks; k++)
	if(hepGammaIndex[i]== (MCFCalHits[0][j]->info_tr)->tr_num){
	  found =1;
	  if(Debug==5)
	    fprintf(stderr,"hepGammaIndex[%d] found in MCFCalHits[0][%d]->tr_num: %d\n",
		    i,j,(MCFCalHits[0][j]->info_tr)->tr_num);
	}
    if(!found)
      foundAll=0;
  }

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
  eSigma = LgdRes*(0.06*sqrt(e)+0.02*e);
  eSmear=Gauss(0,eSigma);
  eSmeared = e+eSmear;
  for(i=0;i<3;i++)
    p[i] *= eSmeared/e;
}

double Gauss(double mean,double sigma){
  /*
   * This gaussian is lifted from ROOT's TRandom::Gauss()
   */
  double x,y,z,result;
  y=1.0*((double)(random()))/((double)(RAND_MAX));
  if(!y) y = 1.0*((double)(random()))/((double)(RAND_MAX));
  z=1.0*((double)(random()))/((double)(RAND_MAX));
  x=z*6.283185;
  result = mean+sigma*sin(x)*sqrt(-2.0*log(y));

  return result;
}
