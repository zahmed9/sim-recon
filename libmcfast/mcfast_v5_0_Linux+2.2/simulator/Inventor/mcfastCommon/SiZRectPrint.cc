#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include "mcfast_db.h"
#endif
#include "SiZRectPrint.hh"
char *printSilZRectInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Silicon rectangular Z plane detector " << endl
    << "Name = " << sizrect[which-1].name 
    << endl << endl
    << "There are " <<  sizrect[which-1].nlayer << " layers." <<endl
    << "The (x,y,z) position is ( " <<  sizrect[which-1].xpos << ", "
    << sizrect[which-1].ypos << ", " << sizrect[which-1].zpos <<" ) cm" 
    << endl;
    
    out << '\000';
    return output;
}
char *printSilZRectLayerInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    out << "Silicon rectangular Z plane"<< endl
        << "Layer definition" << endl
        << "Detector Index = "  
        << layersizrect[which-1].det << endl << "layer Index = " 
        << layersizrect[which-1].lyr << endl << endl
        << "There are ("  << layersizrect[which-1].nwaferx
        << ", " << layersizrect[which-1].nwafery 
        << ") (x,y) wafers on this layer."
        << endl
        << "The local z position of the layer = "
        << layersizrect[which-1].zlayerlocal << " cm." << endl
        << "The rotation about the z axis = "
        << layersizrect[which-1].rotation << " radians." <<endl
        << "The x length of the layer = " 
        << layersizrect[which-1].xlen << " cm with a " 
        << layersizrect[which-1].gapxlen << " cm gap." << endl 
        << "The y length of the layer = " 
        << layersizrect[which-1].ylen << " cm with a " 
        << layersizrect[which-1].gapylen << "cm gap." << endl
        << "The staggering pattern is "
        << layersizrect[which-1].staggeringpattern << "."
        << endl;
    
    out << '\000';
    return output;
}
char *printSilZRectWaferInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
 
    out << "Silicon rectangular Z plane" << endl
    <<  "Wafer definition" << endl 
    << "Detector Index = " 
    << wfrsizrect[which-1].det << endl
    << "Layer Index = " << wfrsizrect[which-1].lyr << endl
    << "Wafer Index in (x,y) = (" << wfrsizrect[which-1].waferx
    << ", " << wfrsizrect[which-1].wafery << ")." << endl
    << "The measurement type = " << wfrsizrect[which-1].type << "." << endl
    << "The material is " << wfrsizrect[which-1].mat << "." << endl
    << "The hit efficency = " << wfrsizrect[which-1].eff_hit << "." <<endl
    << "The stereo angle with respect to the wafer's x axis = " 
    << wfrsizrect[which-1].stereo << " radians." << endl
    << "The (x, y, z) lengths of the wafer = (" 
    << wfrsizrect[which-1].xlen << ", " << wfrsizrect[which-1].ylen << ", "
    << wfrsizrect[which-1].zlen << ") cm." << endl
    << "The z offset from the center of the layer = " 
    << wfrsizrect[which-1].zoffset << " cm." << endl
    << "The number of segments in x, y = (" << wfrsizrect[which-1].nsegm_x 
    << ", " << wfrsizrect[which-1].nsegm_y << ")." <<endl
    << "The pitch in x, y = (" << wfrsizrect[which-1].pitch_x << ", "
    << wfrsizrect[which-1].pitch_y << ")." << endl
    << "The start of the first measurement in x = " 
    << wfrsizrect[which-1].coord0_x << "." << endl
    << "The start of the first measurement in y ="
    << wfrsizrect[which-1].coord0_y << "."
    << endl; 
    
    out << '\000';
    return output; 
}
