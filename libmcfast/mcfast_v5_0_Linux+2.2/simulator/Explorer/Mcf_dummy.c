/*Standard includes*/
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <rpc/xdr.h>
#define MCFIO_GEOMETRY 880
#define MCFIO_DST 881

/*MCFIO includes */
/*#include "mcfastXDRinc.h"*/
#include "mcfio_Dict.h"
#include "mcf_xdr.h"
#include "mcfio_Block.h"
#include "mcfio_Direct.h"
#include "mcfio_Sequential.h"
#include "mcfio_Util1.h"
#include "stdhep.h"
#include "track_offline.h"
#include "new_hep_trace.h"
#include "new_trace.h"
bool_t xdr_mcfast_track_offline_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version);
bool_t geom_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char **version);
bool_t dst_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char **version);
bool_t xdr_stdhep_multi_(XDR *xdrs, int *blockid, int *ntot, char **version);
				
 				 
struct hepevt hepevt_;
struct hepev2 hepev2_;
struct trk_off1 trk_off1_;
struct trk_off2 trk_off2_;
struct trace_par_c trace_par_c_;
struct trace_par_c trace_par_c_;
struct hep_trace_c hep_trace_c_;
struct Position{
    float x;
    float y;
    float z;
};
struct Momentum{
     double px;
     double py;
     double pz;
};
enum {TRACE, TRACK, NEUTR};
/* definition statements */
int Mcf_ReadEvent(int stream,int *nevent);
int Mcf_ReadSpecEvent(int stream, int nevent);
int Mcf_OpenFile(char *filename);
void McfHepGenPosition(void);
void McfTracePosition(int PlotTrack, int PlotTrace, int PlotNeutr,
                      int PlotHit, double EtaMin, double EtaMax);
int McfTraceDisplay(int nvert, struct Position *pos, float *color, int id);
void Mcf_HepTrackDisplay(struct Position begin, struct Position end, 
                         float color[3]);
double Eta( double px, double py, double pz);
double d_sign(double arg);
int hepchg_ (int *id);
int Mcf_ReadEvent(int stream, int *nevent){
int status;
int inum, nblocks = 0;
int blkids[20];
/*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
/*   Read an event from an MCFIO file. Non-event records are read in and   */
/*   processed until an event record is read in.                           */
/*   Returns: the status of the file                                       */
/*   End of file  = -3                                                     */
/*   Open failure = -2                                                     */
/*   Read Failure = -1                                                     */
/*   OK           = 0                                                      */
/*   inputs: int stream                                                    */
/* >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*/
        printf (" Entering next event \n");
        status = mcfioC_NextEvent(stream);
        printf (" Status from NextEvent %d \n", status);
        mcfioC_InfoStreamInt(stream, MCFIO_STATUS, &inum);
        nevent = &inum;
          return 0;
}
int Mcf_OpenFile(char *filename){
      return mcfioC_OpenReadDirect(filename);
 }
void McfTracePosition(int PlotTrack, int PlotTrace, int PlotNeutr,
                      int PlotHit, double EtaMin, double EtaMax){
int ntrack = 0;
int hep = 0;
float *color;
/* counters:  ntrace  Number of points along a trace */
/*            nptracen Total number of neutral traces */
/*            nptraceq Total number of charged traces */
/*            nptrace  Total number of displayed traces */
int ncount = 0;
int icount = 0;
int itrace = 0;
int ntrace = 0;
int nptracen = 0;
int nptrace = 0;
int nptraceq = 0;
int nhit = 0;
int ihit = 0;
struct Momentum mom;
struct Position *station, *hit; 
int charge = 0;
int trace_type; 
double track_eta;
int etarange = 0;
   color = (float *) malloc(3*sizeof(float));
       ntrace = 100;
       station = (struct Position *) malloc(ntrace * sizeof( struct Position));      
        printf("trace stations--McfTracePosition\n");
        for(itrace = 0;
             itrace < ntrace;
             itrace++){
             station[itrace].x = 10.; 
             station[itrace].y = 10.;  
             station[itrace].z = itrace;
             printf("%d, %f,%f,%f\n",itrace,station[itrace].x,station[itrace].y,
                     station[itrace].z);
        }
            printf("end McfTracePosition\n");
               McfTraceDisplay(ntrace,station,color,icount);              
           free(station);
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
