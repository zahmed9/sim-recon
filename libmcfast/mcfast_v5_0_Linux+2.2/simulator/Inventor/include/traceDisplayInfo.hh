#include "displayTypes.hh"
#ifndef TRACEDISPLAYINFO
#define TRACEDISPLAYINFO
enum {TRACE, TRACK, NEUTR, PARENT, ALL};

//This structure contains the information necessary to control a trace display

struct traceDispInfo
{
  int PlotTrace;
  int PlotTrack;
  int PlotNeutr;
  double EtaMin; 
  double EtaMax;
  momType MomType;
  double MomMin;
  int itrack;       //identifier for track
  int trackAction;  // what to do to track (turn it off, turn on hits)
};
void traceDispInfoInitialize( traceDispInfo *temp);
void traceDispInfoSet( traceDispInfo set, traceDispInfo *temp);
#endif
