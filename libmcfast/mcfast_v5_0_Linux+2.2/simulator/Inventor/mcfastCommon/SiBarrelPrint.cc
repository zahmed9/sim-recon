#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "SiBarrelPrint.hh"
char *printBarrelInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Silicon Barrel Detector" << endl
    << "Name = " << sibarrel[which-1].name << endl << endl
    << "There are " << sibarrel[which-1].nlyr << " layers." <<endl
    << "The global Z position is " << sibarrel[which-1].z0_global 
    << " cm" << endl;
    
    out << '\000';
    return output;
}
char *printLayerInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << "Silicon Barrel Detector" << endl
        << "Layer Definition"  << endl << endl 
	<< "Detector Index = "  
        << layersib[which-1].det << endl << "Layer Index = " 
        << layersib[which-1].lyr << endl << endl
        << "Material = " << layersib[which-1].mat << endl
        << "There are "  << layersib[which-1].nwaf << " wafers on this layer"
        << endl
        << "Z length = " << layersib[which-1].zlen << " cm." << endl
        << "phi angle (beta) = " << layersib[which-1].beta << endl
        << "radial distance (delta) = " << layersib[which-1].delta 
        << " cm." << endl
        << "thickness and width = " << layersib[which-1].thick << ", "
        << layersib[which-1].width << " cm." << endl
        << "measurement type = " << layersib[which-1].type << "." << endl;
    
    out << '\000';
    return output;
}
char *printWaferInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
 
    out << "Silicon Barrel Detector" << endl
    << "Wafer Definition" << endl << endl
    << "Detector Index = " 
    << wafer[which-1].det << endl 
    << "Layer Index = " << wafer[which-1].lyr << endl 
    << "Wafer = " << wafer[which-1].nwaf << endl << endl
    << "The wafer type = " << wafer[which-1].speci << "." << endl
    << "The tilt = " << wafer[which-1].tilt << " cm" << endl
    << "C0x and c0y = " << wafer[which-1].c0x << ", " << wafer[which-1].c0y
    << " cm." << endl
    << "The number of strips = " << wafer[which-1].nstrip << endl
    << "The pitch = "
    << wafer[which-1].pitch << "." << endl
    << "The stereo angle = " << wafer[which-1].stereo << "." << endl
    << "The hit efficiency  = " << wafer[which-1].eff_hit << "." <<endl
    << "The resolutions = " << wafer[which-1].siga << ", " 
                            << wafer[which-1].sigb << ", "
                            << wafer[which-1].sigc << "." << endl; 
    
    out << '\000';
    return output; 
}
