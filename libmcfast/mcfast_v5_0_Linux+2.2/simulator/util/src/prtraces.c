#include "new_trace.h"
#include <stdio.h>

void prtraces(FILE* fl);
void prtraces_(FILE* fl);

void prtraces_(FILE* fl) {  prtraces(stdout); }  /* Unix */
void PRTRACES(FILE* fl)  {  prtraces(stdout); }  /* Cray */

void prtraces(FILE* fl)
{
    int i;
    fprintf(fl,"Traces info   Ntraces = %d\n",*n_obj_trace_par);
    for (i=0;i<*n_obj_trace_par;i++) {
        fprintf(fl,"  Trc%3d ID%2d Typ%3d Pl%2d Ht%3d Mat %2d Pos %5.3G %5.3G %5.3G\n",
                i,
                trace_par[i].hep,
                trace_par[i].type,
                trace_par[i].plane,
                trace_par[i].hit,
                trace_par[i].material,
                trace_par[i].w.x,
                trace_par[i].w.y,
                trace_par[i].w.z);
    }
}
