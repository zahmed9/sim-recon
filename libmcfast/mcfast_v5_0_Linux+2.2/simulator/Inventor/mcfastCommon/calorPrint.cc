#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "calorPrint.hh"

char *printCalorInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Projective Calorimeter Device" << endl
    << "Name = " << emcal[which-1].name << endl << endl
    << "The shape = " << emcal[which-1].shape << "." << endl 
    << "The type = " << emcal[which-1].type << "." << endl
    << "The material is " << emcal[which-1].material << "." << endl
    << "The active material is " << emcal[which-1].active << "." << endl
    << "The number of segments in phi = " << emcal[which-1].nphi << "." << endl
    << "The number of segments in eta = " << emcal[which-1].neta << "." << endl 
    << "The z position, length = " << emcal[which-1].z0 << ", " 
    << emcal[which-1].zlen << "." << endl
    << "The radii = " << emcal[which-1].rmin[0] << ", " 
    << emcal[which-1].rmin[1] << ", " 
    << emcal[which-1].rmax[0] << ", " 
    << emcal[which-1].rmax[1] << " cm." << endl
    << "em resolutions= " 
    << emcal[which-1].siga_em << ", " 
    << emcal[which-1].sigb_em << endl
    << "Hadronic resolutions = " << endl
    << emcal[which-1].siga_had << ", " 
    << emcal[which-1].sigb_had << "." << endl
    << "The e/pi ratio = " << emcal[which-1].em_had_ratio << "." << endl;
    
    out << '\000';
    return output; 
}
