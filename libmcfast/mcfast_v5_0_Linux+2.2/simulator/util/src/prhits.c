#include "new_hit_trk.h"
#include <stdio.h>

void prhits(FILE* fl);
void prhits_(FILE* fl);

void prhits_(FILE* fl) {  prhits(stdout); }  /* Unix */
void PRHITS(FILE* fl)  {  prhits(stdout); }  /* Cray */

void prhits(FILE* fl)
{
    int i;
    fprintf(fl,"Hits info   Nhits = %d\n",*n_obj_hit_trk);
    for (i=0;i<*n_obj_hit_trk;i++) {
        fprintf(fl,"  Ht%3d ID%2d Tr%3d Det%2d DetN %2d Ly %2d Pos %5.3G %5.3G %5.3G",
                i,
                hit_trk[i].hep,
                hit_trk[i].trace,
                hit_trk[i].chan.devtype,
                hit_trk[i].chan.devnum,
                hit_trk[i].chan.devlayer,
                hit_trk[i].pos[0],
                hit_trk[i].pos[1],
                hit_trk[i].pos[2]);
        fprintf(fl," Sig %7.2G Cov %7.2G %7.2g %7.2g %7.2g\n",
                hit_trk[i].dmeas_sigma,
                hit_trk[i].dpix_cov[1][1],
                hit_trk[i].dpix_cov[1][2],
                hit_trk[i].dpix_cov[2][1],
                hit_trk[i].dpix_cov[1][2]);
    }
}
