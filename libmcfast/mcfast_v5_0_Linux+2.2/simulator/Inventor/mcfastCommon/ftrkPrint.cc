#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "ftrkPrint.hh"

char *printFtrkInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "Foward Tracking Device " << endl 
    << "Name = " << ftrk[which-1].name << endl << endl
    << "detector = " << ftrk[which-1].det << "." << endl
    << "The number of layer = " << ftrk[which-1].nlyr << "." << endl
    << "Xmin, Xmax, Ymin, Ymax = (" << ftrk[which-1].xmin << ", " 
    << ftrk[which-1].xmax << ", " << ftrk[which-1].ymin << ", " 
    << ftrk[which-1].ymax << ") cm." << endl
    << "The z location = " << ftrk[which-1].z0 << ". cm" << endl
    << "The z length = "
    << ftrk[which-1].zlen << " cm." << endl
    << "The material = " << ftrk[which-1].mat_fill << "." << endl
    << "The boundary thickness = "<< endl
    << "(" << ftrk[which-1].thick_boun[0] << ", "
    << ftrk[which-1].thick_boun[1] << ", "
    << ftrk[which-1].thick_boun[2] << ", "
    << ftrk[which-1].thick_boun[3] << ", " 
    << ftrk[which-1].thick_boun[4] << ", "
    << ftrk[which-1].thick_boun[5] << ") cm." << endl	
    << "The material at boundary ="  << endl
    << "(" << ftrk[which-1].mat_boun[0] << ", "
    << ftrk[which-1].mat_boun[1] << ", "
    << ftrk[which-1].mat_boun[2] << ", "
    << ftrk[which-1].mat_boun[3] << ", " 
    << ftrk[which-1].mat_boun[4] << ", "
    << ftrk[which-1].mat_boun[5] << ")." << endl
    << "The resolutions = " << ftrk[which-1].siga << ", " 
    << ftrk[which-1].sigb << ", " 
    << ftrk[which-1].sigc << "." << endl;    
    out << '\000';
    return output; 
}
char *printFtrkLayerInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "Forward Tracking Device" << endl
    << "Layer Definition" << endl
    << "Detector Index = " << layerftrk[which-1].det << endl
    << "Layer Index = " << layerftrk[which-1].lyr << endl << endl
    << "The local z position = " << layerftrk[which-1].z_local << " cm." <<endl
    << "The layer is " << layerftrk[which-1].thick << " cm thick." << endl
    << "xmin, xmax, ymin, ymax of the detector plane = "<< endl << "(" 
    << layerftrk[which-1].xmin << ", "
    << layerftrk[which-1].xmax << ", "
    << layerftrk[which-1].ymin << ", "
    << layerftrk[which-1].ymax << ")cm." << endl
    << "gaps in the detector plane = " << endl << "(" 
    << layerftrk[which-1].xmin_gap << ", "
    << layerftrk[which-1].xmax_gap << ", "
    << layerftrk[which-1].ymin_gap << ", "
    << layerftrk[which-1].ymax_gap << ")cm." << endl
    << "The stereo angle = " << layerftrk[which-1].stereo  << "." <<endl
    << "The number of cells = " << layerftrk[which-1].ncell << "." << endl
    << "The (x,y) coordinates of the first cell = " << endl
    << layerftrk[which-1].coord0_x << ", " << layerftrk[which-1].coord0_y
    << " cm." << endl
    << "The hit efficiency = " << layerftrk[which-1].eff_hit << "." << endl
    << "The resolutions are " << layerftrk[which-1].siga << ", " 
    << layerftrk[which-1].sigb << ", " << layerftrk[which-1].sigc << "."
    << endl;
    
    out << '\000';
    return output; 
}
