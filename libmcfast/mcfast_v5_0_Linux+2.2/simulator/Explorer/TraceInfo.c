#include <ctype.h>
#include <cx/DataAccess.h>
#include <cx/cxLattice.h>
#include <cx/cxLattice.api.h>
#include <cx/cxPick.h>
#include <cx/cxPick.api.h>
#include "Mcf_Window_prototypes.h"
#include "McfEvent.h"
#include "TracePickInfo.h"
#define MAXNAME 20 
void AddNull(char *string);
void TraceInfo(long window, cxLattice *heplat, int hepnum);
void TraceInfo(long window, cxLattice *heplat, int hepnum){
  int	i; 		/* loop variable */
  int   ichar;
  static int first = 0;
  int count;
  int icount;
  int ipar;
  int nhep;
  int inum;
  char infostring[400];
  char *fstring;
  int *flen;
  char temp[30];
  float *latdata;
  cxErrorCode ec;
  if(first == 0){
      mcfioC_Init();      
      first = 1;
      return;
  }
   printf("hepnum = %d\n",hepnum);
/* set pointers to HEP info in the lattice */
   cxLatPtrGet(heplat,NULL,(void **)&latdata,NULL,NULL);
   nhep = (int) * cxLatticeDimensionsArrayGet(heplat,&ec);
   if(!nhep>0){
      printf("TraceInfo:  No HEP information!\n");
   }
   if(hepnum == NOTRACK) return;	
     for(icount = 0;
         icount<nhep;
         icount++){
           if(latdata[icount*HEPLATDATASIZE+HEP]==hepnum){
             ichar = 0;   
             count =  sprintf(temp,
              "Hep number = %f\n",latdata[icount*HEPLATDATASIZE+HEP]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "Hep id = %f\n",latdata[icount*HEPLATDATASIZE+HEP_ID]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             fstring = (char *) malloc(MAXNAME*sizeof(char));
             inum = latdata[icount*HEPLATDATASIZE+HEP_ID];
             hepnam_(&inum,fstring,flen);
             AddNull(fstring);
             count =  sprintf(temp,
              "Particle type = %s\n",fstring);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             inum = latdata[icount*HEPLATDATASIZE+HEP_PAR];            
             hepnam_(&inum,fstring,flen);             
             AddNull(fstring);
             count =  sprintf(temp,
              "Particle parent type = %s\n",fstring);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;             
             count =  sprintf(temp,
              "x = %f mm\n",latdata[icount*HEPLATDATASIZE+HEP_X]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "y = %f mm\n",latdata[icount*HEPLATDATASIZE+HEP_Y]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "z = %f mm\n",latdata[icount*HEPLATDATASIZE+HEP_Z]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "Px = %f GeV\n",latdata[icount*HEPLATDATASIZE+HEP_PX]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "Py = %f GeV\n",latdata[icount*HEPLATDATASIZE+HEP_PY]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             count =  sprintf(temp,
              "Pz = %f GeV\n",latdata[icount*HEPLATDATASIZE+HEP_PZ]);
             strcpy(&infostring[ichar],temp);
             ichar = ichar + count;
             if(latdata[icount*HEPLATDATASIZE+OFF_PX]<10000 &&
                latdata[icount*HEPLATDATASIZE+OFF_PY]>-10000){
                  count =  sprintf(temp,
                   "Offline Px = %f GeV\n",latdata[icount*HEPLATDATASIZE+OFF_PX]);
                  strcpy(&infostring[ichar],temp);
                  ichar = ichar + count;
                  count =  sprintf(temp,
                   "Offline Py = %f GeV\n",latdata[icount*HEPLATDATASIZE+OFF_PY]);
                  strcpy(&infostring[ichar],temp);
                  ichar = ichar + count;
                  count =  sprintf(temp,
                   "Offline Pz = %f GeV\n",latdata[icount*HEPLATDATASIZE+OFF_PZ]);
                  strcpy(&infostring[ichar],temp);
                  free (fstring);
            }
            WindowMessage(window,infostring);
            break;            
        }
     }
  return;
}
void AddNull(char* string){
int i;
             for(i=0; i<MAXNAME; i++){
               if(isspace(string[i])){
                 string[i] = NULL;
                 break;
               }
             }
}
