#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "absorberPrint.hh"

char *printAbsorberInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Absorber Device"<< endl
    << "Name = " << absorber[which-1].name << endl << endl
    << "The absorber has a " << absorber[which-1].shape << " shape."
    << endl
    << "The radii = (" << absorber[which-1].rmin[0] << ", " 
    << absorber[which-1].rmin[1] << ", " << absorber[which-1].rmax[0] << ", "
    << absorber[which-1].rmax[1] << ")cm." << endl
    << "The z position = "  << absorber[which-1].z0 << " cm."
    << "The z length = "  
    << absorber[which-1].zlen << " cm." << endl
    << "The material is " << absorber[which-1].material << endl;  
     
    out << '\000';
    return output; 
  
}
