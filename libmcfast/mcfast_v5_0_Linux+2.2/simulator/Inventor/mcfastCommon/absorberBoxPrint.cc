#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "absorberBoxPrint.hh"

char *printAbsorberBoxInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "Absorber Box Device " << endl
    << "Name =" << absorberbox[which-1].name << endl << endl
    << "The z position = " << absorberbox[which-1].z0 << " cm." << endl
    << "The z length = "
    << absorberbox[which-1].zlen << " cm." << endl
    << "The x dimensions = ("
    << absorberbox[which-1].xlimit[0] << ", " << absorberbox[which-1].xlimit[1]
    << ") cm." << endl
    << "The y dimensions = ("
    << absorberbox[which-1].ylimit[0] << ", " << absorberbox[which-1].ylimit[1]
    << ") cm." << endl;
    
     
    out << '\000';
    return output; 
  
}
