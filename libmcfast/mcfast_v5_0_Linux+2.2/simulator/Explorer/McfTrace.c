/*Standard includes*/
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <rpc/xdr.h>
#include "mcfdatXDRinc.h"
#include "stdhep.h"
#include "track_offline.h"
struct hepevt hepevt_;
struct hepev2 hepev2_;
struct trk_off1 trk_off1_;
struct trk_off2 trk_off2_;
#define MOMENTUM 0
#include "TracePickInfo.h"
#include "Mcf_Explorer_typedefs.h"
#include "McfEvent.h"
/* static variables for keeping track of individual traces */
static grTrace *ptrace = NULL;
/* definition statements */
int hepchg_ (int *id);
void McfHepGenPosition(void){
int cPi = 211;
int nPi = 111;
int ele = 11;
int pho = 22;
int mu  = 12;
int npart = 0;
struct Momentum hep;
struct Position start;
struct Position end;
double ptot, theta, phi;
int icolor[3];
float color[3];
    npart = 0;
    printf("hepevt_.nhep = %d\n",hepevt_.nhep);
    while ( npart < hepevt_.nhep){
      if(abs(hepevt_.idhep[npart]) == cPi ||
         abs(hepevt_.idhep[npart]) == nPi ||
         abs(hepevt_.idhep[npart]) == ele ||
         abs(hepevt_.idhep[npart]) == pho ||
         abs(hepevt_.idhep[npart]) == mu  ){
         /* take initial position from the vertex information*/
           /*icolor[0] = hepevt_.idhep[npart]/100;
           icolor[1] = (hepevt_.idhep[npart]-icolor[0]*100)/10;
           icolor[2] = hepevt_.idhep[npart]-icolor[0]*100 -
                                             icolor[1]*10;*/
          /*printf("icolor = %d,%d,%d\n",icolor[0],icolor[1],icolor[2]);*/
           color[0] = 1.0;
           color[1] = 0.;
           color[2] = 0.;
           /*printf("color = %f,%f,%f\n",color[0],color[1],color[2]);*/
           start.x = hepevt_.vhep[npart][0]/1000.;
           start.y = hepevt_.vhep[npart][1]/1000.;
           start.z = hepevt_.vhep[npart][2]/1000.;
           hep.px  = hepevt_.phep[npart][0];          
           hep.py  = hepevt_.phep[npart][1];
           hep.pz  = hepevt_.phep[npart][2];
           printf("npart = %d\n",npart);
         /* calculate magnatude of momentum */
           ptot = sqrt(hep.px*hep.px + hep.py*hep.py + hep.pz*hep.pz);
           if(ptot > 0.5) {
           /*calculate theta and phi*/
             phi = atan2(hep.py,hep.px);
             theta = acos(hep.pz/ptot);
           /* calculate final position */
             end.x = 500.*sin(theta)*cos(phi);
             end.y = 500.*sin(theta)*sin(phi);
             end.z = 500.*cos(theta);
            /*printf("start=%f,%f,%f\n",start.x,start.y,start.z);*/
            /*printf("end=%f,%f,%f\n",end.x,end.y,end.z);*/
            /*Mcf_HepTrackDisplay(start,end,color);*/
           }
      }
      npart++;
    }
}
void McfTracePosition(int PlotTrack, int PlotTrace, int PlotNeutr,
                      int PlotHit, double EtaMin, double EtaMax,
                      int MomType, double MomMin, double radmax){ 
int ntrack = 0;
int hep = 0;
float *color;
/* counters:  ntrace  Number of points along a trace */
/*            nptracen Total number of neutral traces */
/*            nptraceq Total number of charged traces */
/*            nptrace  Total number of displayed traces */
int ncount = 0;
int icount = 0;
int first_trace = 0;
int itrace = 0;
int ntrace = 0;
int nptracen = 0;
int nptrace = 0;
int nptraceq = 0;
int nhit = 0;
int ihit = 0;
int nstation = 0;
struct Momentum mom;
struct Position *station, *hit; 
int charge = 0;
int trace_type; 
double track_eta, track_momentum, radius;
int etarange = 0;
int momrange = 0;
   color = (float *) malloc(3*sizeof(float));
   if(trace_par_c_.n_obj_trace_par == 0){
      printf("McfTracePosition:Event has no traces!\n");
      return;
   }
    for (  
          icount = 0;         
          icount < *n_obj_hep_trace; 
          icount++){
      ntrace =  hep_trace_c_.hep_trace[icount].ntrace;
      first_trace = hep_trace_c_.hep_trace[icount].first_trace;
      hep = icount + 1;
      if(ntrace > 0){
       /* calculate eta for particle */
           etarange = 0;
           momrange = 0;
          if((ptrace + icount) -> eta <= EtaMax &&
             (ptrace + icount) -> eta >= EtaMin){
              etarange = 1;
          }
           if(MomType == MOMENTUM &&
              (ptrace + icount) -> p >= MomMin ){
               momrange = 1;
           }else if ((ptrace + icount) -> pt >= MomMin ){
               momrange = 1;
           }
        /* is it a charged or neutral particle */
             if((ptrace + icount) -> charge == 0){
               nhit = 0;
               nptracen++;
             }else if((ptrace + icount) -> charge !=0){
               nptraceq++;
               nhit   =  hep_trace_c_.hep_trace[icount].nhit;
               if(nhit > 0){
                 hit = (struct Position *) 
                      malloc(nhit * sizeof(struct Position));
               }
             }
        station = (struct Position *) malloc(ntrace * sizeof( struct Position));      
        for(itrace = 0, ihit = 0,nstation = 0,
             ncount = hep_trace_c_.hep_trace[icount].first_trace;
             itrace < ntrace;
             itrace++,
             ncount++){
             radius = sqrt(trace_par_c_.trace_par[ncount-1].w.x*
                           trace_par_c_.trace_par[ncount-1].w.x+
                           trace_par_c_.trace_par[ncount-1].w.y*
                           trace_par_c_.trace_par[ncount-1].w.y);
                             
             if(radius < radmax){
               station[itrace].x = trace_par_c_.trace_par[ncount-1].w.x; 
               station[itrace].y = trace_par_c_.trace_par[ncount-1].w.y;  
               station[itrace].z = trace_par_c_.trace_par[ncount-1].w.z;
               nstation++;
               if(nhit > 0 && 
                 trace_par_c_.trace_par[ncount-1].hit > 0){
                 hit[ihit].x = trace_par_c_.trace_par[ncount-1].w.x; 
                 hit[ihit].y = trace_par_c_.trace_par[ncount-1].w.y;  
                 hit[ihit].z = trace_par_c_.trace_par[ncount-1].w.z;
                 ihit++;  
              }
           }
        }
            if((((ptrace + icount) -> trace_type == TRACE && PlotTrace == 1)  ||
                ((ptrace + icount) -> trace_type == TRACK && PlotTrack == 1)  ||
                ((ptrace + icount) -> trace_type == NEUTR && PlotNeutr == 1)) &&
                 etarange == 1 && momrange == 1 && 
                 (ptrace + icount) -> tracedisp == 1){
               nptrace++;
               color[0] = (ptrace + icount) -> tcolor.red;
               color[1] = (ptrace + icount) -> tcolor.green;
               color[2] = (ptrace + icount) -> tcolor.blue;
               McfTraceDisplay(nstation,station,color,hep);             
            }
            if(nhit > 0){            
             if(PlotHit == 1 || (ptrace + icount) -> hitdisp == 1){
               McfHitDisplay(nhit,hit);
               }
               free (hit);
             }
             free(station);
       }
    }
    free (color);
    printf("number of offline tracks = %d\n",trk_off1_.trk_off_num);
    printf("number of neutral traces = %d\n",nptracen);
    printf("number of charged particle traces = %d\n",nptraceq);
    printf("number of displayed traces = %d\n",nptrace);
    return;
}  
double Eta( double px, double py, double pz){
double pt;
double p;
double eta;
     pt = sqrt(px*px + py*py);
     if(pt == 0.0){
        eta = 100.; 
     }else{
       p = sqrt(pt*pt + pz*pz);
       eta = - log (pt / ( p + fabs(pz) ) );
     }
     eta = eta * d_sign(pz);
     return eta;
}
double d_sign(double arg){
double dummy;
       dummy = 1.;
       if(arg > 0){
         dummy = -1.;
       }
       return dummy;
}
void McfHepLattice(int *nhep, float **hepdata){
int icount = 0;
int ntrace = 0;
int ntrack = 0;
int hep = 0;
int *idhep;
int *idtrack;
    idhep   = (int *) malloc(*n_obj_hep_trace*sizeof(int));
    idtrack = (int *) malloc(*n_obj_hep_trace*sizeof(int));
/*only pass Hep information for displayed traces*/
    for ( *nhep = 0,
          icount = 0;         
          icount < *n_obj_hep_trace; 
          icount++){
      ntrace =  hep_trace_c_.hep_trace[icount].ntrace;
      if(ntrace>0){
         *(idhep + *nhep) = icount;
         *(idtrack + *nhep) = -99;
         for(ntrack = 0;
             ntrack < trk_off1_.trk_off_num;
             ntrack++){
              *(idtrack + *nhep) = -1;
              if(icount + 1 == trk_off2_.trk_off[ntrack].hep){
              *(idtrack + *nhep) = ntrack;
              break;
            }  
         }
         (*nhep)++;                  
      }
    }
      *hepdata = (float *)malloc(*nhep*HEPLATDATASIZE*sizeof(float));
      for(icount = 0;
          icount < *nhep;
          icount++){
          hep = *(idhep + icount) + 1;
          ntrack = *(idtrack + icount);
          *(*hepdata + icount*HEPLATDATASIZE + HEP)     =  hep;
          *(*hepdata + icount*HEPLATDATASIZE + HEP_PX)  =  hepevt_.phep[hep-1][0];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_PY)  =  hepevt_.phep[hep-1][1];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_PZ)  =  hepevt_.phep[hep-1][2];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_X)   =  hepevt_.vhep[hep-1][0];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_Y)   =  hepevt_.vhep[hep-1][1];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_Z)   =  hepevt_.vhep[hep-1][2];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_ID)  =  hepevt_.idhep[hep-1];
          *(*hepdata + icount*HEPLATDATASIZE + HEP_PAR) = 
                                         hepevt_.idhep[hepevt_.jmohep[hep-1][0]-1];                                                   
          if(ntrack >= 0){
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PX)  = trk_off2_.trk_off[ntrack].w.px;
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PY)  = trk_off2_.trk_off[ntrack].w.py;
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PZ)  = trk_off2_.trk_off[ntrack].w.pz;          
          }else {
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PX)  =  10000.0;
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PY)  = -10000.0;
           *(*hepdata + icount*HEPLATDATASIZE + OFF_PZ)  = 0.0;                    
          }
    }
      free(idhep);  free(idtrack);
      return;
}
int McfSetDisp(int reset, int pickinfo, int pickhep){
int icount = 0; 
static int oldpickinfo;
static int oldpickhep;
    if(pickinfo == JUSTINFO){
      return 0;
    }
    if(reset == 1 || pickinfo == RESET){
      oldpickinfo = 0; oldpickhep = 0;
      for ( 
            icount = 0;         
            icount < *n_obj_hep_trace; 
            icount++){
          (ptrace + icount) -> tracedisp = 1;
          (ptrace + icount) -> hitdisp   = 0;
      }
      return 1;      
    }
    if(pickhep == NOTRACK){
      return 0;
    }
    if(pickinfo == oldpickinfo &&
       pickhep  == oldpickhep){
         return 0;
    }
    if(pickinfo == HITPLOT){
      oldpickinfo = pickinfo;
      oldpickhep  = pickhep;
      (ptrace + (pickhep - 1)) -> hitdisp = 1;
    }
    if(pickinfo == NOTRACE){
      oldpickinfo = pickinfo;
      oldpickhep  = pickhep;
      (ptrace + (pickhep - 1)) -> tracedisp = 0;
    }
    return 1;
}
void McfDefineTrace(void){
int icount, ntrack;
int hep;
int ntrace, first_trace;
int trace_type;
int charge, stable;
struct grRgb color;
double track_eta, track_p, track_pt;
   if(trace_par_c_.n_obj_trace_par == 0){
      printf("McfDefineTrace:Event has no traces!\n");
      return;
   }
   if(ptrace != NULL){
      free (ptrace);
   }
   ptrace = (grTrace *) malloc(*n_obj_hep_trace*sizeof(grTrace));
   if(ptrace == NULL){
      printf("McfDefineTrace: Unable to allocate memory!\n");
      return;
    }
    for (  
          icount = 0;         
          icount < *n_obj_hep_trace; 
          icount++){
       ntrace =  hep_trace_c_.hep_trace[icount].ntrace;
       hep = icount + 1;
        if(ntrace > 0){
          trace_type = TRACE;
          for(ntrack = 0;
              ntrack < trk_off1_.trk_off_num;
              ntrack++){
              if(hep == trk_off2_.trk_off[ntrack].hep){
                trace_type = TRACK;
              }  
           }
         }else if(ntrace == 0) {
          trace_type = PARENT;
         }
           stable = FALSE;
           if (hepevt_.isthep[icount] == 1) stable = TRUE;
           charge = hepchg_(&hepevt_.idhep[icount]);
           if(charge == 0){
             trace_type = NEUTR;
           }
           track_eta = Eta(hepevt_.phep[icount][0],
                         hepevt_.phep[icount][1],
                         hepevt_.phep[icount][2] );
           track_p  = sqrt(
                            hepevt_.phep[icount][0]*hepevt_.phep[icount][0]+
                            hepevt_.phep[icount][1]*hepevt_.phep[icount][1]+
                            hepevt_.phep[icount][2]*hepevt_.phep[icount][2]);
           track_pt = sqrt(
                            hepevt_.phep[icount][0]*hepevt_.phep[icount][0]+
                            hepevt_.phep[icount][1]*hepevt_.phep[icount][1]);
         if(trace_type == NEUTR){
             color.red = 0.0; color.green = 0.0; color.blue = 1.0;
         }else if(trace_type == TRACK){
             color.red = 1.0; color.green = 0.0; color.blue = 0.0;
         }else if(trace_type == TRACE && charge > 0){
             color.red = 0.0; color.green = 1.0; color.blue = 0.0;
         }else if(trace_type == TRACE){
             color.red = 1.0; color.green = 1.0; color.blue = 0.0;
         }
         (ptrace + icount) -> id           = hepevt_.idhep[icount];
         (ptrace + icount) -> stable       = stable;
         (ptrace + icount) -> charge       = charge;
         (ptrace + icount) -> trace_type   = trace_type;
         (ptrace + icount) -> tracedisp    = 1;
         (ptrace + icount) -> hitdisp      = 0;
         (ptrace + icount) -> eta          = track_eta;
         (ptrace + icount) -> px           = hepevt_.phep[icount][0];
         (ptrace + icount) -> py           = hepevt_.phep[icount][1];
         (ptrace + icount) -> pz           = hepevt_.phep[icount][2];
         (ptrace + icount) -> mass         = hepevt_.phep[icount][4];
         (ptrace + icount) -> p            = track_p;
         (ptrace + icount) -> pt           = track_pt;
         (ptrace + icount) -> tcolor.red   = color.red;
         (ptrace + icount) -> tcolor.green = color.green;
         (ptrace + icount) -> tcolor.blue  = color.blue;
         (ptrace + icount) -> hcolor.red   = 1.0;
         (ptrace + icount) -> hcolor.green = 1.0;
         (ptrace + icount) -> hcolor.blue  = 1.0;
         (ptrace + icount) -> mother       = hepevt_.jmohep[icount][0];
         (ptrace + icount) -> firstdaughter= hepevt_.jdahep[icount][0];                  
         (ptrace + icount) -> lastdaughter = hepevt_.jdahep[icount][1];                  
         (ptrace + icount) -> userData     = icount;
       }
    return;
}
int McfStdParent(int *aid, int id){
/* The list of potential ancestors is specified in *aid, terminated by -1 */
/* The potential daughter is specified in id*/
/* The return value is the id of the first ancestor found */
/* appropriate, else the return value is -1*/
int i=0,j=0;
int nparent = 0;
int lsize;
int *parent_list;
    lsize = id;
    parent_list = (int *) malloc((lsize)*sizeof(int));
     nparent = StdParentList(id, &parent_list);
     for(i=0; i<nparent; i++){
        j=0;
        while(aid[j] != -1){
          if(aid[j] == parent_list[i]){
             free (parent_list);
             return aid[j];
          }
          j++;
        }    
     }
     return -1;     
}
int McfStdId(int hepid, int **aid){
/*find all particles with a given Hep identity*/
/* return the number of particles and an array with the
the position in the hep list*/
int i=0;
int npart=0;
int *temp;
    temp = (int *) malloc(hepevt_.nhep*sizeof(int));
    for (i=0; i<hepevt_.nhep; i++){
      if(hepevt_.idhep[i] == hepid){
        temp[npart] = i + 1;
        npart++;
      }
    }
    if(npart == 0 ) return npart;
    *aid = (int *) malloc ( (npart+1) * sizeof(int));
    for(i=0; i<npart; i++){
      *(*aid +i) = temp[i];
    }
    *(*aid + npart) = -1;
    free(temp);
    return npart;
}
void McfHeritageTest(void){
  int hep_id1 = 24;
  int hep_id2 = -24;
  int npart1=0;
  int npart2=0;
  int i;
  int *aid1,*aid2,*aidall;
  int mother;
  npart1 = McfStdId(hep_id1,&aid1);
  npart2 = McfStdId(hep_id2,&aid2);
  aidall = (int *) malloc((npart1 + npart2 + 1)*sizeof(int));
  for(i=0; i<npart1; i++){
      aidall[i] = aid1[i];
  }
  for(i=0; i < npart2; i++){
      aidall[npart1 + i] = aid2[i];
  }
  aidall[npart1 + npart2] = -1;
  free(aid1); free (aid2);
  for(i=0; i<hepevt_.nhep; i++){
    mother = McfStdParent(aidall,i);
    if(mother > 0)printf("The mother of i = %d is %d\n",i,mother);
  }
  return;
}
int StdParentList(int id, int **parentlist){
int nparent = 0;
int *temp;
int icount;
    if(hepevt_.jmohep[id-1][0] == 0){
        return nparent;
    }
    temp = (int *) malloc(hepevt_.nhep * sizeof(int));
    *temp = hepevt_.jmohep[id-1][0];
    nparent++;
    while(hepevt_.jmohep[*(temp+nparent-1)-1][0] > 0){
       *(temp+nparent) = hepevt_.jmohep[*(temp+nparent-1)-1][0];
       nparent++;
    }
    *parentlist = (int *) malloc(nparent * sizeof(int));
    for(icount = 0; icount < nparent; icount++){
      *(*parentlist + icount) = *(temp + icount);
    }
    free (temp);       
    return nparent;
}
