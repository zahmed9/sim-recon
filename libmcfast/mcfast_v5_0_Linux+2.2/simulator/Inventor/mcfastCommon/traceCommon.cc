#ifndef MCFASTDST
#define MCFASTDST
#include "mcfdat_dst.h"
#endif
typedef double DFLOAT;
#include "traceDisplayTypes.hh"
#include "traceCommon.hh"
#include "traceData.hh"
#include "pointsStruct.hh"
#include "stdhep.h"
#include "McfUtilities.hh"
#include <ctype.h>
#include <string.h>
#include <strstream.h>
#include <iostream.h>
#include <math.h>

extern "C" {
//struct hepevt hepevt_;
//struct hepev2 hepev2_;
int hepchg_ (int *id);
void hepnam_(int *id, char *chaup, int flen);
}
const int MAXNAME = 40;
const int MAXSTRING = 1000;
double Eta(double px, double py, double pz ); 
double d_sign(double arg);
int NumHepTrace(void)
{
    return *n_obj_hep_trace;
}
int NumGoodTrace(void)
{
   int ntrace = 0;
   for(int i = 0; i < *n_obj_hep_trace; i++)
   {
      if(hep_trace_c_.hep_trace[i].ntrace > 0) ntrace++;
   }
   return ntrace;
}
int getTraceData(int ihep, traceData *data)
{
   int hep = ihep + 1;
   if(hep_trace[ihep].ntrace <= 0) return 0;
   data->charge = hepchg_(&hepevt_.idhep[ihep]);
   if(data->charge == 0)
   {
     data->traceType = NEUTR;
   }
   else
   {
     data->traceType = TRACE;
     for(int ntrack = 0;
	 ntrack < *n_obj_trk_off;
	 ntrack++)
     {
	 if(hep == trk_off_c_.trk_off[ntrack].hep)
	 {
             data->traceType = TRACK;
	 }  
     }
   }

  data->hep             = ihep;
  data->id	       = hepevt_.idhep[ihep];
  data->displayTrace    = 1;
  data->eta	       = Eta(hepevt_.phep[ihep][0],
                         hepevt_.phep[ihep][1],
                         hepevt_.phep[ihep][2] );
  data->p 	       = sqrt(
                         hepevt_.phep[ihep][0]*hepevt_.phep[ihep][0]+
                         hepevt_.phep[ihep][1]*hepevt_.phep[ihep][1]+
                         hepevt_.phep[ihep][2]*hepevt_.phep[ihep][2]);
  data->pt	       = sqrt(
                         hepevt_.phep[ihep][0]*hepevt_.phep[ihep][0]+
                         hepevt_.phep[ihep][1]*hepevt_.phep[ihep][1]);
  return 1;
     
}

//the following information comes from the trace common

int NumTracePoints(int ihep)
{
  return hep_trace[ihep].ntrace;
}
int FirstTracePoint(int ihep)
{
  return hep_trace[ihep].first_trace;
}
void GetTracePoint(int ihep, Points *trPoints)
{
  int ihit = 0;
  for(int i = hep_trace[ihep].first_trace; 
          i < hep_trace[ihep].first_trace + hep_trace[ihep].ntrace;
          i++)
  {

     trPoints[ihit].x = trace_par[i-1].w.x;
     trPoints[ihit].y = trace_par[i-1].w.y;
     trPoints[ihit].z = trace_par[i-1].w.z; 
     ihit++; 

  }

}

char *traceMessage(int itrace)
{
    static char output[1000];
    int ihep = itrace;
    char fstring[MAXNAME];
    char pstring[MAXNAME];
    char p2string[MAXNAME];
    int flen=MAXNAME;
    
    ostrstream out(output, MAXSTRING);
    
    hepnam_(&(hepevt_.idhep[ihep]),fstring,flen);            
    addNull(fstring);
    
    hepnam_(&(hepevt_.idhep[hepevt_.jmohep[ihep][0]-1]),pstring,flen);          
     
    addNull(pstring);   

    hepnam_(&(hepevt_.idhep[hepevt_.jmohep[ihep][1]-1]),p2string,flen);         
      
    addNull(p2string);   
    
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

   for(int ntrack = 0; ntrack < *n_obj_trk_off; ntrack++)
   {
       if( (ihep + 1) == trk_off_c_.trk_off[ntrack].hep)
       {
        out 
        << " Offline Px  = " << trk_off_c_.trk_off[ntrack].w.px << " GeV"
                             << endl
        << " Offline Py  = " << trk_off_c_.trk_off[ntrack].w.py << " GeV"
                             << endl
        << " Offline Pz  = " << trk_off_c_.trk_off[ntrack].w.pz << " GeV"
                             << endl;
        break;
          
       }  
   }
   out << "There are " << hep_trace[ihep].nhit 
        << " hits on this trace\n";
   out << '\000';
    return output;
}
double Eta( double px, double py, double pz){
double pt;
double p;
double eta;
     pt = sqrt(px*px + py*py);
     if(pt == 0.0){
        eta = 100.; 
     }else{
       p = sqrt(pt*pt + pz*pz);
       eta = - log (pt / ( p + fabs(pz) ) );
     }
     eta = eta * d_sign(pz);
     return eta;
}
double d_sign(double arg){
double dummy;
       dummy = 1.;
       if(arg < 0){
         dummy = -1.;
       }
       return dummy;
}
void addNull(char* string){
int i;
             for(i=0; i<MAXNAME; i++){
               if(isspace(string[i])){
                 string[i] = '\0';
                 break;
               }
             }
}
