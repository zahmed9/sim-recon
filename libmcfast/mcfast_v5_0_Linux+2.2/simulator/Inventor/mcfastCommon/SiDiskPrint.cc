#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "SiDiskPrint.hh"

char *printDiskInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << "Silicon Disk Detector"  <<endl
    << "Name = " <<  sidisk[which-1].name << endl << endl
    << "There are " <<  sidisk[which-1].nlyr << " layers."  << endl
    << "The global z position = " << sidisk[which-1].zpos << " cm." <<endl;
    
    out << '\000';
    return output; 
}
char *printDLyrInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << "Silicon Disk Detector" << endl
    << "Layer Definition" << endl
    << "Detector Index = " <<  layersidi[which-1].det << endl 
    << " Layer Index = " << layersidi[which-1].lyr << "." << endl << endl
    << "The material = " <<  layersidi[which-1].mat << "." << endl
    << "There are " <<  layersidi[which-1].nwed << " wafers." << endl
    << "The local z position = " <<  layersidi[which-1].z_local << 
    " cm." << endl
    << "The min and max radii = " <<  layersidi[which-1].rmin << ", "
    <<  layersidi[which-1].rmax << " cm." << endl
    << "The phi coverage = " <<  layersidi[which-1].phi[0] << ", "
    <<  layersidi[which-1].phi[1] << "." << endl
    << "The measurement type = " <<  layersidi[which-1].type << "." << endl;
    
    
    out << '\000';
    return output; 
}
char *printWedgeInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
 
    out << "Silicon Disk Detector"  << endl
        <<"Wedge Definition" << endl 
    << "Detector Index = " << wedge[which-1].det << endl
    << "Layer Index = " << wedge[which-1].lyr << endl
    << "Wedge Index = "
    << wedge[which-1].nwed << "." << endl << endl
    << "The number of strips = " << wedge[which-1].nstrip << endl
    << "The pitch = " << wedge[which-1].pitch << "." << endl
    << "c0_r = " << wedge[which-1].c0_r << " and C0phi = " 
    << wedge[which-1].c0_phi << "." << endl
    << "The stereo angle = " << wedge[which-1].stereo << "." << endl
    << "The hit efficiency = " << wedge[which-1].eff_hit << "." << endl
    << "The resolutions are " << wedge[which-1].siga << ", " 
    << wedge[which-1].sigb << ", " << wedge[which-1].sigc << "." << endl; 
    
    out << '\000';
    return output; 
}
