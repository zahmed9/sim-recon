/*

    Fill histograms about the residuals for the track pointed to
    be Kp_start.

 */

#include <sys/types.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include "const.h"
#include "klm_node_struct.h"
#include "devtype.h"

void klm_ftk_res_diag_ ( int *id_err, int *id, Kptr Kp_first ){

  /* Pointer to the current node in the loop over nodes. */
  Kptr       Kp;

  /* Pointers to hit and smoother info for the current node. */
  hit_trk_s *Hp;
  Sptr       Sp;

  /* The normalized residual at this hit. */
  float      res;

  /* Histogram ID's to be filled. */
  int        id1 = *id;
  int        id2 = *id+1;
  int        id3 = *id+2;
  int        id4 = *id+3;

  /* Some symbolic constants. */
  const float one        =  1.0;
  const float bad_stat   =  6.;
  const float bad_pix    =  7.;
  const float bad_sil    =  8.;
  const float bad_drf    =  9.;
  const float bad_other  = 10.;

  /* Loop over all nodes. */
  for ( Kp=Kp_first; Kp; Kp = Kp->next ){

    /* Select nodes which have hits and which have smoother information. */
    if ( (Sp = Kp->sp) && (Hp = Kp->hp) ){

      /* Check error code. */
      if ( Sp->error ) {
	hf1_ ( id_err, &bad_stat, &one );
      }
      else {

	if ( Hp->chan.devtype == jdev_pixelplane ){

	  if ( Sp->sr2[0][0] > 0 ) {
	    res = Sp->r2[0]/sqrt(Sp->sr2[0][0]);
	    hf1_ ( &id1, &res, &one );
	  }
	  else{
	    hf1_ ( id_err, &bad_pix, &one );
	  }
	  
	  if ( Sp->sr2[1][1] > 0 ) {
	    res = Sp->r2[1]/sqrt(Sp->sr2[1][1]);
	    hf1_ ( &id1, &res, &one );
	  }
	  else{
	    hf1_ ( id_err, &bad_pix, &one );
	  }
	  
	}
	
	else if ( Hp->chan.devtype == jdev_silplane ){
	  if ( Sp->sr1 > 0 ) {
	    res = Sp->r1/sqrt(Sp->sr1);
	    hf1_ ( &id2, &res, &one );
	  }
	  else{
	    hf1_ ( id_err, &bad_sil, &one );
	  }

	}

	else if ( Hp->chan.devtype == jdev_driftplane ){
	  if ( Sp->sr1 > 0 ) {
	    res = Sp->r1/sqrt(Sp->sr1);
	    hf1_ ( &id3, &res, &one );
	  }
	  else{
	    hf1_ ( id_err, &bad_drf, &one );
	  }
	}

	else{
	  if ( Sp->sr1 > 0 ) {
	    res = Sp->r1/sqrt(Sp->sr1);
	    hf1_ ( &id4, &res, &one );
	  }
	  else{
	    hf1_ ( id_err, &bad_other, &one );
	  }
	} /* End of chained if to select device type.            */

      }   /* End of check on error status for smoother info.     */
    }     /* End if to select nodes with hits and smoother info. */
  }       /* End loop over nodes.                                */

}
