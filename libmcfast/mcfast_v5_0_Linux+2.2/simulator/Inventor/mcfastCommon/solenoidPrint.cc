#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "solenoidPrint.hh"

char *printSolenoidInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Solenoid Device" << endl
    << "Name = " << solenoid[which-1].name << endl << endl
    << "The magnitude of the B field is " << solenoid[which-1].bfield
    << " Tesla." << endl
    << "The min and max radii = (" << solenoid[which-1].rmin << ", " 
    << solenoid[which-1].rmax << ")cm." << endl
    << "The z position, length = " << solenoid[which-1].z0 << ", " 
    << solenoid[which-1].zlen << " cm." << endl
    << "The fill material is " << solenoid[which-1].mat_fill << endl
    << "The boundary thickness are " 
    << solenoid[which-1].thick_boun[0] << ", "
    << solenoid[which-1].thick_boun[1] << ", "
    << solenoid[which-1].thick_boun[2] << ", "
    << solenoid[which-1].thick_boun[3] << " cm. " <<endl
    << "The materials at the boundaries are " << endl 
    << solenoid[which-1].mat_boun[0] << ", "
    << solenoid[which-1].mat_boun[1] << ", "
    << solenoid[which-1].mat_boun[2] << ", "
    << solenoid[which-1].mat_boun[3] << "." <<endl;
     
    out << '\000';
    return output; 
  
}
