#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "muonPrint.hh"

char *printMuonInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Muon Detector" << endl
    << "Name = " << muon[which-1].name << endl << endl
    << "The detector has a " << muon[which-1].shape << " shape."
    << endl
    << "The type = " << muon[which-1].type << "." << endl
    << "There are " << muon[which-1].nlayer << "layer(s)." << endl
    << "The radii = (" << muon[which-1].rmin[0] << ", " 
    << muon[which-1].rmin[1] << ", " << muon[which-1].rmax[0] << ", "
    << muon[which-1].rmax[1] << ") cm." << endl
    << "The z position = " << muon[which-1].z0 << " cm." << endl
    << "The z length = " 
    << muon[which-1].zlen << " cm." << endl
    << "The material is " << muon[which-1].material << endl;  
     
    out << '\000';
    return output; 
  
}
