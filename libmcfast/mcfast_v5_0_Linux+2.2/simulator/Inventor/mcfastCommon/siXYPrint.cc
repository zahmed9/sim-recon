#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
char *printSiXYGlobal(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Silicon X-Y Detector"  << endl
        << "Name = " << sixy[which-1].name << endl << endl
        << "It has " << sixy[which-1].nly << " layers" << endl
        << "Detector Global Z position = " << sixy[which-1].zpos 
        << " cm." << endl;
    out << '\000';
    return output;
}

char *printSiXYPlane(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Silicon X-Y Detector" << endl
        << "Plane definition" << endl
	<< "Detector Index = " << layersixy[which-1].det << endl
	<< "Plane Index = " << layersixy[which-1].lyr << endl
	<< endl << endl
        << "material = " << layersixy[which-1].mat << endl
        << "Local z position = " << layersixy[which-1].z_local  << " cm." << endl
        << "xmin, xmax, ymin, ymax =" << endl
	<< "(" << layersixy[which-1].xmin << ","
        << layersixy[which-1].xmax << "," << layersixy[which-1].ymin << ","
        << layersixy[which-1].ymax << ") cm" << endl
        << "(x, y) gaps =" << endl
	<< "(" << layersixy[which-1].xmin_gap << ", "
                              << layersixy[which-1].xmax_gap << ", "
                              << layersixy[which-1].ymin_gap << ", "
                              << layersixy[which-1].ymax_gap << ") cm" <<endl
        << "Coord0_x,_y = " << layersixy[which-1].coord0_x << ", "
                            << layersixy[which-1].coord0_y << " cm." << endl
        << "Layer thickness = "<< layersixy[which-1].thick << " cm." << endl
        << "stereo angle = "<< layersixy[which-1].stereo << endl
        << "x pitch and number of segments = " << layersixy[which-1].pitch_x
        << ", " << layersixy[which-1].nsegm_x << "cm" << endl
        << "y pitch = " << layersixy[which-1].pitch_y << endl
	<< "Number of segments = " 
        << layersixy[which-1].nsegm_y << endl;
    out << '\000';
    return output;

         
}
