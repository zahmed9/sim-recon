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
#define MCFIO_CALHIT 701
/*************************************/
/* EXPLORER AND mcf_explorer INCLUDE FILES */
/*************************************/

/*MCFIO includes */
#include "const.h"
#include "mcfdatXDRinc.h"
#include "mcfio_Block.h"
#include "mcfio_Direct.h"
#include "mcfio_Sequential.h"
#include "mcfio_Util1.h"
#include "stdhep.h"
#include "cal_hit.h"
#include "McfReadEvent.h"
bool_t geom_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char **version);
bool_t dst_to_xdr_(XDR *xdrs, int *blockid, int *ntot, char **version);
bool_t xdr_stdhep_multi_(XDR *xdrs, int *blockid, int *ntot, char **version);
bool_t xdr_cal_hits_(XDR *xdrs, int *blockid,
                                 int *ntot, char** version);				
 				 
struct hepevt hepevt_;
struct hepev2 hepev2_;
/* definition statements */
int hepchg_ (int *id);
int Mcf_ReadEvent(int stream, int *nevent){
int status,inum;
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
        status = mcfioC_NextEvent(stream);
        mcfioC_InfoStreamInt(stream, MCFIO_STATUS, &inum);
        if (inum == MCFIO_EOF){
          printf ("Closing the stream, EOF reached \n");
          mcfioC_Close(stream);
          return -3;
        }
        if(status < 0){
           return -1;
        }else if (status > 0) {
            mcfioC_InfoEventInt(stream,MCFIO_EVENTNUMBER,nevent);
            status = Mcf_GetEvent(stream);
        }
        if (status < 0) {
          /*mcfioC_RewindDirect(stream);*/
          printf ("Closing the Stream I/O error in decoding.. \n");
          mcfioC_Close(stream);
          return -1;
        } 
          return 0;
}
int Mcf_ReadSpecEvent(int stream, int nevent){
int status, inum;
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
        mcfioC_Rewind(stream);
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
            status = Mcf_GetEvent(stream);
        }
        if (status < 0) {
          /*mcfioC_RewindDirect(stream);*/
          printf ("Closing the Stream I/O error in decoding.. \n");
          mcfioC_Close(stream);
          return -1;
        } 
          return 0;
}
int Mcf_GetEvent(int stream){
int status;
int inum, nblocks = 0;
int *pblkids;
int i;
             mcfioC_InfoEventInt(stream,MCFIO_NUMBLOCKS,&inum);
            if(inum == 0){ 
                return - 1;
            }
            pblkids = (int *)malloc(inum * sizeof(int));
            mcfioC_InfoEventInt(stream,MCFIO_BLOCKIDS,pblkids);
            while( nblocks < inum ) {              
              if( pblkids[nblocks] == MCFIO_STDHEPM){     
                 printf ("Entering mcfioC_Block, MCFIO_STDHEPM \n");
                 status = mcfioC_Block(stream, MCFIO_STDHEPM,
                      xdr_stdhep_multi_);
                 printf ("nhep found %d\n", hepevt_.nhep);
              }else if (pblkids[nblocks] == MCFIO_DST) {
                 printf ("Entering mcfioC_Block, MCFIO_DST \n");
                status = mcfioC_Block(stream,
                       MCFIO_DST, dst_to_xdr_);
              }else if (pblkids[nblocks] == MCFIO_GEOMETRY) {
                 printf ("Entering mcfioC_Block, MCFIO_GEOMETRY \n");
                status = mcfioC_Block(stream, 
                       MCFIO_GEOMETRY, geom_to_xdr_);
              }else if (pblkids[nblocks] == MCFIO_CALHIT) {
                 printf ("Entering mcfioC_Block, MCFIO_CALHIT \n");
                status = mcfioC_Block(stream, 
                       MCFIO_CALHIT, xdr_cal_hits_);
              }else {
                printf(" MCFAST: MCFIO input has undefined block!\n");
                printf(" Undefined Blockid = %d\n",pblkids[nblocks]); 
              }
              nblocks++;
            }
            free(pblkids);
            return 0;
}
int mcf_readevent_(int *stream, int *nevent){
   return Mcf_ReadEvent(*stream, nevent);
}
int Mcf_OpenFile(char *filename){
      get_commons_();
      return mcfioC_OpenReadDirect(filename);      
 }
int Mcf_ReadGeom(int stream){
int status,inum,nevent;
int nblocks = 0;
int *pblkids;
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
        status = mcfioC_NextEvent(stream);
        mcfioC_InfoStreamInt(stream, MCFIO_STATUS, &inum);
        if (inum == MCFIO_EOF){
          printf ("Closing the stream, EOF reached \n");
          mcfioC_Close(stream);
          return -3;
        }
        if(status < 0){
           return -1;
        }else if (status > 0) {
            mcfioC_InfoEventInt(stream,MCFIO_NUMBLOCKS,&inum);
            if(inum == 0){ 
                return - 1;
            }
            pblkids = (int *)malloc(inum * sizeof(int));
            mcfioC_InfoEventInt(stream,MCFIO_BLOCKIDS,pblkids);
            while( nblocks < inum ) {              
             if (pblkids[nblocks] == MCFIO_GEOMETRY) {
                 printf ("Entering mcfioC_Block, MCFIO_GEOMETRY \n");
                 status = mcfioC_Block(stream, 
                       MCFIO_GEOMETRY, geom_to_xdr_);
              }
              nblocks++;
            }
            free(pblkids);
            return 0;
 
        }
        if (status < 0) {
          /*mcfioC_RewindDirect(stream);*/
          printf ("Closing the Stream I/O error in decoding.. \n");
          mcfioC_Close(stream);
          return -1;
        } 
          return 0;
}
void Mcf_CloseStream(int stream){
    /*mcfioC_RewindDirect(stream);*/
    mcfioC_Close(stream);
}
