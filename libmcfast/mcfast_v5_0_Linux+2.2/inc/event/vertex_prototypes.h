#ifndef VERTEX_PROTOTYPES_H
#define VERTEX_PROTOTYPES_H

/* 
 * Prototypes for some of the  functions in $MCFAST_DIR/simulator/vertex/src.
 *
*/
int kfit_build_vtx_(int      *ntrk,
                    int      *itrk,          
                    int      *ivopt, 
                    int      *update,
                    double   *vtx, 
                    double   vz[][3], 
                    int      *lcovar, 
                    double   *chisq,
		    wtrack_s *w, 
                    double   wcov[][7], 
                    int      *dim_cov); 

int ksub_insert_w_(wtrack_s *w, 
                   double   wcov[][7], 
                   int      *idtyp, 
                   int      *pos_info,
                   int      *fixed_mass, 
                   int      *origin, 
                   int      *use_mass, 
                   double   *mass,
		   int      *class, 
                   int      *ik ); 

void ksub_set_bfld_(bFieldStruct *bf, 
                    int          *true);

void ksub_init_(void);		   
		   		    
#endif

/*
 *  $Id$
 *
 *  $Log$
 *  Revision 1.1  2000/06/19 19:58:38  eugenio
 *  Initial revision
 *
 *  Revision 1.1  1998/09/15 04:22:11  kutschke
 *  New file.
 *
 *
 */
