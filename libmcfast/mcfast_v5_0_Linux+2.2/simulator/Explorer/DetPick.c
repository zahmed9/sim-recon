#include <cx/DataAccess.h>
#include <cx/cxLattice.h>
#include <cx/cxPick.h>
#include <cx/cxPick.api.h>

void DetPick(long detectors, cxPick *pick, cxParameter **pdet)
{
  int	i; 		/* loop variable */
  long	dims[1];	/* dimensions vector */
  long	id;		/* temporary variable for pick id */
  cxErrorCode ec;
  long *d;              /* data poointer */
  char label[30];
  char **plabel;
  static int first = 0;
  char ssides[30];
  int count;
  static char DetName[40] = NULL;
  char *pDetName = &DetName[0];
  char *Portname = "detectors";
  char *NewLine = "\n";

  if(first == 0){
      first = 1;
      cxInWdgtScrollListItemsDelete(Portname,"Item 1\n");    
      return;
  }  
/* don't output anything if the pick didn't hit anything */
  dims[0] = cxPickNumObjectHitsGet(pick,&ec);
  if ( dims[0] == 0 ){
    return;
  }    
    if(DetName != NULL){
       cxInWdgtScrollListItemsDelete(Portname,DetName);
    }
    *plabel = (char *)malloc(40 * sizeof(char));
/*Assume that the first detector hit is the detector desired */
    ec = cxPickHitGet(pick,0,
         &id,
         NULL,
         NULL,
         NULL,
         NULL,
         plabel,
         NULL,
         NULL,
         NULL);
        strcpy(pDetName,*plabel); strcat(pDetName,NewLine);
        cxInWdgtScrollListItemsInsert(Portname,pDetName,0);
        *pdet = cxParamStrNew(pDetName);
        if(*pdet == NULL){
           printf("Error allocating detector parameter\n");
        }
        free (*plabel);   
        return;
}
