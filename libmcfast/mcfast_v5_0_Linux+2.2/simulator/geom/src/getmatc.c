#include "mcfast_db.h"
#include <stdio.h>

void getmat(char* name, int* indx)
{
    int i;
    *indx = -1;
    for (i=0;i<*n_obj_material;i++) {
        if ( !strcmp(name,material[i].name) ) {
            *indx = i;
            return;
        }
    }
    fprintf(stdout,"Material %s not found.\n",name);
}
