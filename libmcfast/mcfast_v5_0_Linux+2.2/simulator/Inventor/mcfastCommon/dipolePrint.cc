#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "dipolePrint.hh"

char *printDipoleInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << "Dipole Device" << endl
    << "Name = " << dipole[which-1].name << endl << endl
    << "The B field magnitude  = " << dipole[which-1].bfield
    << " tesla." << endl
    << "The direction cosines = (" << dipole[which-1].dircos[0] << ", "
    << dipole[which-1].dircos[1] << ", " << dipole[which-1].dircos[2] 
    << ")." << endl
    << "The z position= "<< dipole[which-1].z0 << " cm."<< endl
    << "The  z length = "  ", "
    << dipole[which-1].zlen << " cm." << endl
    << "x and y =(" << dipole[which-1].xmin << ", " << dipole[which-1].xmax
    << ", " << dipole[which-1].ymin << ", " << dipole[which-1].ymax << ") cm."
    << endl << endl
    << "The fill material is " << dipole[which-1].mat_fill << "." << endl
    << "The yoke thickness at the boundaries = " << endl << "(" 
    << dipole[which-1].thick_boun[0] << ", "
    << dipole[which-1].thick_boun[1] << ", "
    << dipole[which-1].thick_boun[2] << ", "
    << dipole[which-1].thick_boun[3] << ", "
    << dipole[which-1].thick_boun[4] << ", "
    << dipole[which-1].thick_boun[5] << ") cm. " << endl
    << "The yoke material  at the boundaries = " << endl <<  "(" 
    << dipole[which-1].mat_boun[0] << ", "
    << dipole[which-1].mat_boun[1] << ", "
    << dipole[which-1].mat_boun[2] << ", "
    << dipole[which-1].mat_boun[3] << ", "
    << dipole[which-1].mat_boun[4] << ", "
    << dipole[which-1].mat_boun[5] << "). " << endl;
      
    
    out << '\000';
    return output; 
}
