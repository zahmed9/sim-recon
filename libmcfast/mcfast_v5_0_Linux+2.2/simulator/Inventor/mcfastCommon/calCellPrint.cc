#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include "stringMax.hh"
#include "calInc.hh"
#include "calCellPrint.hh"
#include "stdhep.h"
extern "C" {
//struct hepevt hepevt_;
//struct hepev2 hepev2_;
int hepchg_ (int *id);
void hepnam_(int *id, char *chaup, int flen);
}
void addNull(char* string);
char *calCellPrint( int ical, int ieta, int iphi)
{
    int dum1, dum2;
    int dumICal, dumIEta, dumIPhi;
    float eta, phi;
    float eMip, eHad, eEm;
    int ihit, nTracks;
    int ihep;
    float percent;
    char fstring[40];
    char pstring[40];
    char p2string[40];
    int flen=40;

    static char output[MAXSTRING];
    ostrstream out(output, MAXSTRING);

    dumICal = ical + 1; dumIEta = ieta + 1; dumIPhi = iphi + 1;
//    get_ceta_cphi_(&dumICal, &dumIEta, &dumIPhi, &eta, &phi);
    ihit = hit_cal_addr_(ical, iphi, ieta);
    info_cal_hit_(ical, ihit, &dum1, &dum2, &eMip, &eEm, &eHad, &nTracks);

    out << "Hit Calorimeter Cell "  << endl;
    out << "ical = " << ical << endl;
    out << endl;
//    out << "( eta, phi ) = ( " << eta << "," << phi << " )\n";
    out << "( icr1, icr2 ) = ( " << iphi << "," << ieta << " )\n";
    if(ihit == NOHIT)
    {
      out << endl;
      out << "No energy information for this cell at this time\n";
      out << '\000';
      return output;
    }
    out << "Energy: \n";
    out << "E mip = " << eMip << endl;
    out << "E Had = " << eHad << endl;
    out << "E Em = " << eEm << endl;
    out << "E    = " << eMip + eHad + eEm << endl;
    out << endl;
    out << nTracks << " particle(s) contributed energy to this tower\n";
    out << endl;
   
    for( int jj = 0; jj < nTracks; jj++)
    {
        info_track_cal_hit_(ical, iphi, ieta, jj, &ihep, &percent);
	ihep--;
	hepnam_(&(hepevt_.idhep[ihep]),fstring,flen);            
	addNull(fstring);

	hepnam_(&(hepevt_.idhep[hepevt_.jmohep[ihep][0]-1]),pstring,flen);          

	addNull(pstring);   

	hepnam_(&(hepevt_.idhep[hepevt_.jmohep[ihep][1]-1]),p2string,flen);         

	addNull(p2string);   
	out << "Particle " << jj + 1 << endl;
        out << " Hep Number  = " << ihep << endl 
        << "     Hep id  = " << hepevt_.idhep[ihep] << endl
        << "       Type  = " << fstring << endl
        //<< "       Mass  = " << hepevt_.phep[ihep][5] << " GeV" << endl
        << "Parent Type  = " << pstring << endl
        << "Ancester Type  = " << p2string << endl
        << "   x origin  = " << hepevt_.vhep[ihep][0] << " mm" << endl
        << "   y origin  = " << hepevt_.vhep[ihep][1] << " mm" << endl
        << "   z origin  = " << hepevt_.vhep[ihep][2] << " mm" << endl
        << "         Px  = " << hepevt_.phep[ihep][0] << " GeV" << endl
        << "         Py  = " << hepevt_.phep[ihep][1] << " GeV" << endl
        << "         Pz  = " << hepevt_.phep[ihep][2] << " GeV" << endl;
	out << endl;
   }	
   out << '\000';
     
    return output; 
}
