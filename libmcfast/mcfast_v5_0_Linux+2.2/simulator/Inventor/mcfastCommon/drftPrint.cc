#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#ifndef MCFAST
#define MCFAST
#include <math.h>
#include "mcfast_db.h"
#endif
#include "drftPrint.hh"

char *printDriftInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    out << "Cylindrical Drift Chamber " << drift[which-1].name << endl
    << "Name = " << drift[which-1].name 
    <<endl << endl
    << "The number of anode layers = " << drift[which-1].num_anode
    << "." << endl
    << "The number of cathode layers = " << drift[which-1].num_cathode
    << "." << endl
    << "The min and max radii = " << drift[which-1].rmin << ", " 
    << drift[which-1].rmax << " cm." << endl
    << "The z position and length = " << drift[which-1].z0 << ", "
    << drift[which-1].zlen << "cm." << endl
    << "The fill material is " << drift[which-1].material << "." << endl
    << "The boundary thickness = "
    << drift[which-1].thick_boun[0] << ", "
    << drift[which-1].thick_boun[1] << ", "
    << drift[which-1].thick_boun[2] << ", "
    << drift[which-1].thick_boun[3] << "cm." << endl
    << "The materials at the boundary are " << endl
    << drift[which-1].mat_boun[0] << ", "
    << drift[which-1].mat_boun[1] << ", "
    << drift[which-1].mat_boun[2] << ", "
    << drift[which-1].mat_boun[3] << "." << endl;
    
    out << '\000';
    return output; 
}
char *printDriftAnodeInfo(int which)
{

    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    
    out << "Cylindrical Drift Chamber Device" << endl
    << "Anode Layer Definition" << endl
    << "Detector Index = " << layerdrfano[which-1].det << endl 
    << "Layer Index = " << layerdrfano[which-1].lyr << endl << endl
    << "The radius = " << layerdrfano[which-1].radius << " cm." << endl
    << "The length = " << layerdrfano[which-1].zlen << " cm." << endl
    << "The cell height = " << layerdrfano[which-1].cell_height << " cm." <<endl
    << "The number of wires = " << layerdrfano[which-1].nwires << "." << endl
    << "The readout side = " << layerdrfano[which-1].id_readout
    << "." << endl
    << "The cathode associated with this anode is " 
    << layerdrfano[which-1].id_cathode << "." << endl
    << "The phi of wire 0 = " << layerdrfano[which-1].phi0 << "." << endl
    << "The stereo angle = " << layerdrfano[which-1].stereo_tau << "." 
    << endl
    << "The stereo offset = " << layerdrfano[which-1].stereo_offset <<"."
    << endl
    << "The hit efficiency = " << layerdrfano[which-1].eff_hit << "."
    << endl
    << "The de/dx efficiency = " << layerdrfano[which-1].eff_dedx << "."
    << endl
    << "The resolution coefficients are " << layerdrfano[which-1].siga
    << ", " << layerdrfano[which-1].sigb << ", " << layerdrfano[which-1].sigc
    << "." << endl;
    
    if(layerdrfano[which-1].lyr != offsetdrfano[which-1].lyr)
    {
      out << endl << "There is no offset layer for this anode" << endl;
    }
    else
    {
       out << endl << "Offset information" << endl
       << "The cell offset = " << offsetdrfano[which-1].cell_offset
       << "." << endl
       << "The sag = " << offsetdrfano[which-1].sag << "." << endl
       << "The offset = (" << offsetdrfano[which-1].offset[0] << ", "
       << offsetdrfano[which-1].offset[1] << ", " 
       << offsetdrfano[which-1].offset[2] << ")." << endl
       << "The direction cosines = (" << offsetdrfano[which-1].dircos[0]
       << ", " << offsetdrfano[which-1].dircos[1] << ", " 
       << offsetdrfano[which-1].dircos[2] << "." << endl;
    }
    
    
    out << '\000';
    return output; 
}
char *printDriftCathodeInfo(int which)
{
    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);
    
    out << "Cylinderical Drift Chamber Device " << endl
    << "Cathode Layer Definition" << endl
    << "Detector Index = " << layerdrfcatho[which-1].det << endl
    << " Layer Index = "
    <<layerdrfcatho[which-1].lyr << "." << endl << endl
    << "Delta R = " << layerdrfcatho[which-1].delta_r << " cm" << endl
    << "The z location = " << layerdrfcatho[which-1].zlen << " cm" <<endl
    << "The number of strips in z = " << layerdrfcatho[which-1].nstrips
    << "." << endl
    << "The number of phi segments = " << layerdrfcatho[which-1].n_phi_segm
    << "." << endl
    << "The corresponding anode layer is " << layerdrfcatho[which-1].id_anode
    << "." << endl
    << "The cell offset is " << layerdrfcatho[which-1].cell_offset << "."
    << endl
    << "The hit efficiency = " << layerdrfcatho[which-1].eff_hit << "."
    << endl
    << "The resolution coefficients are " 
    << layerdrfcatho[which-1].resa << ", " 
    << layerdrfcatho[which-1].resb << ", " 
    << layerdrfcatho[which-1].resc << "." << endl; 
     
    out << '\000';
    return output; 
}
