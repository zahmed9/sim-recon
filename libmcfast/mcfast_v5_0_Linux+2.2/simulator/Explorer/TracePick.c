#include <cx/DataAccess.h>
#include <cx/cxLattice.h>
#include <cx/cxLattice.api.h>
#include <cx/cxPick.h>
#include <cx/cxPick.api.h>
#include "TracePickInfo.h"
void TracePick(cxPick *pick, cxParameter **hepnum, int TraceInfoChanged);
void TracePick(cxPick *pick, cxParameter **hepnum, int TraceInfoChanged){
  int	i; 		/* loop variable */
  int   ichar;
  long	dims[1];	/* dimensions vector */
  long	id;		/* temporary variable for pick id */
  cxErrorCode ec;
  int err;
  long *d;              /* data poointer */
  char label[30];
  char *plabel;
  static int first = 0;
  char temp[30];
  int hep;
  if(first == 0){
      first = 1;
      return;
  }
  if(TraceInfoChanged == 1){
    hep = NOTRACK;
    *hepnum = cxParamLongNew(hep);
    return;     
  }
  plabel = (char *) malloc(30*sizeof(char));                  
/* don't write anything if the pick didn't hit anything */
  dims[0] = cxPickNumObjectHitsGet(pick,&ec);
  if ( dims[0] == 0 )
    return;
/* loop over the hits */
  for ( i = 0; i < dims[0]; i++ )
  {
    ec = cxPickHitGet(pick,i,
         &id,
         NULL,
         NULL,
         NULL,
         NULL,
         &plabel,
         NULL,
         NULL,
         NULL);
         err = sscanf(plabel,"%d",&hep);
  }
  *hepnum = cxParamLongNew(hep);
  return;
}
