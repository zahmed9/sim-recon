#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "calorBoxPrint.hh"

char *printCalorBoxInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << " XY Calorimeter " << endl
    << "Name = " << calorbox[which-1].name << endl << endl
    << "The z position = " << calorbox[which-1].z0 << " cm." << endl
    << "The z length = " << calorbox[which-1].zlen << " cm." << endl
    << "The x dimensions = ("
    << calorbox[which-1].xlimit[0] << ", " << calorbox[which-1].xlimit[1]
    << ") cm." << endl
    << "The y dimensions = ("
    << calorbox[which-1].ylimit[0] << ", " << calorbox[which-1].ylimit[1]
    << ") cm." << endl;
    
    out << '\000';
    return output; 
    
}
