#include <stdio.h>
#include <string.h>
#include <math.h>
#include <sys/param.h>
#include <rpc/types.h>
#include <sys/types.h>
#include <rpc/xdr.h>

/*MCFIO includes */
#include "mcf_xdr.h"
#include "mcfio_Block.h"
#include "mcfio_Dict.h"
#include "mcfio_Direct.h"
#include "mcfio_Sequential.h"
#include "mcfio_Util1.h"
#include "stdhep.h"
#include "track_offline.h"
#include "trace.h"

bool_t xdr_mcfast_stdhep_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version);
bool_t xdr_mcfast_track_offline_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version);
bool_t xdr_mcfast_trace_(XDR *xdrs, int *blockid,
 				 int *ntot, char** version);
 				 
struct hepevt hepevt_;
struct hepev2 hepev2_;
struct trk_off1 trk_off1_;
struct trk_off2 trk_off2_;
struct trace_comm1 trace_comm1_;
struct trace_comm2 trace_comm2_;
int Mcf_ReadSpecEvent(int stream, int nevent);
void McfStdDispInfo(int hep, long window);
int Mcf_OpenFile(char *filename);
int Mcf_ReadSpecEvent(int stream, int nevent){
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
        status = mcfioC_SpecificEvent(stream,nevent,0,0,0);
        mcfioC_InfoStreamInt(stream, MCFIO_STATUS, &inum);
        if (inum == MCFIO_EOF){
          /*mcfioC_RewindDirect(stream);*/
          printf ("Closing the stream, EOF reached \n");
          mcfioC_Close(stream);
          return -3;
        }
        if(status < 0){
           return -1;
        }else if (status > 0) {
          /*find out how many blocks to read*/
            mcfioC_InfoEventInt(stream,MCFIO_NUMBLOCKS,&inum);
            printf ("Entering InfoEventInt, inum = %d \n", inum);
            if(inum == 0){ 
                return - 1;
            }
            printf ("Entering InfoEventInt, ,blkids \n");
            mcfioC_InfoEventInt(stream,MCFIO_BLOCKIDS,blkids);
            while( nblocks < inum ) {              
              if( blkids[nblocks] == MCFIO_STDHEP){     
                 printf ("Entering mcfioC_Block, MCFIO_STDHEP \n");
                 status = mcfioC_Block(stream, MCFIO_STDHEP,
                      xdr_mcfast_stdhep_);
                 printf ("nhep found %d\n", hepevt_.nhep);
              }else if (blkids[nblocks] == MCFIO_OFFTRACKARRAYS) {
                 printf ("Entering mcfioC_Block, MCFIO_OFFTRACKARRAYS \n");
                status = mcfioC_Block(stream, MCFIO_OFFTRACKARRAYS,
                       xdr_mcfast_track_offline_);
              }else if (blkids[nblocks] == MCFIO_TRACEARRAYS) {
                 printf ("Entering mcfioC_Block, MCFIO_TRACEARRAYS \n");
                status = mcfioC_Block(stream, MCFIO_TRACEARRAYS,
                       xdr_mcfast_trace_);
              }else {
                printf(" MCFAST: MCFIO input has undefined block!\n");
                return -1;               
              }
              nblocks++;
            }
        }
        if (status < 0) {
          /*mcfioC_RewindDirect(stream);*/
          printf ("Closing the Stream I/O error in decoding.. \n");
          mcfioC_Close(stream);
          return -1;
        } 
          return 0;
}
void McfStdDispInfo(int hep, long window){
char *infostring;
int count;
     infostring = (char *)malloc(50*sizeof(char));
     sprintf(infostring,
            "\n Hep number = %d\n px = %f\n py = %f\n pz = %f\n",
            hep,
            hepevt_.phep[hep-1][0],
            hepevt_.phep[hep-1][1],
            hepevt_.phep[hep-1][2]);
            WindowMessage(window,infostring);
     return;
}
int Mcf_OpenFile(char *filename){
      return mcfioC_OpenReadDirect(filename);
 }
