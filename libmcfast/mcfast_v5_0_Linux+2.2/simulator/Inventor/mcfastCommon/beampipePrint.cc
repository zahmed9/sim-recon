#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "beampipePrint.hh"

char *printBeampipeInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Beampipe Device" << endl 
    << "Name =" << bpipe[which-1].name << endl << endl
    << "The min and max radii = (" << bpipe[which-1].rmin << ", " 
    << bpipe[which-1].rmax << ") cm." << endl
    << "The z position, length = " << bpipe[which-1].z0 << ", " 
    << bpipe[which-1].zlen << " cm." << endl
    << "The material is " << bpipe[which-1].mat_fill << endl
        << "The boundary thickness are " 
    << bpipe[which-1].bndrthk[0] << ", "
    << bpipe[which-1].bndrthk[1] << ", "
    << bpipe[which-1].bndrthk[2] << ", "
    << bpipe[which-1].bndrthk[3] << " cm. " <<endl
    << "The materials at the boundaries are " << endl 
    << bpipe[which-1].matrbnd[0] << ", "
    << bpipe[which-1].matrbnd[1] << ", "
    << bpipe[which-1].matrbnd[2] << ", "
    << bpipe[which-1].matrbnd[3] << "." <<endl;
 
     
    out << '\000';
    return output; 
  
}
